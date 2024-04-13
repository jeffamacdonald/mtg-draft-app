# t.references :user, references: :users, foreign_key: { to_table: :users}
# t.string :name, null: false
# t.timestamps null: false

class Cube < ApplicationRecord
  class CreationError < StandardError;end

  belongs_to :user
  has_many :cube_cards
  has_many :cards, :through => :cube_cards
  include CubeHelper

  def setup_cube_from_list(cube_list)
    @cube_list = cube_list
    errors, enriched_cards = get_new_enriched_cards
    raise CreationError.new(errors.to_json) unless errors.empty?
    create_new_cards(enriched_cards)
    errors = create_cube_cards_and_return_errors(self)
    raise CreationError.new(errors.to_json) unless errors.empty?
  end

  def display_cube
    get_sorted_active_cube_cards.chunk_while { |bef, aft|
      bef.color_identity.display_identity == aft.color_identity.display_identity
    }.each_with_object({}) { |chnk, hsh|
      hsh[chnk.first.color_identity.display_identity] = chnk
    }
  end

  def update_cube(params)
    ActiveRecord::Base.transaction do
      if params[:name]
        self.name = params[:name]
        save!
      end
      params[:cube_list]&.each do |update_hash|
        if update_hash[:id].present?
          CubeCard.find(update_hash[:id]).update_from_hash(update_hash)
        else
          card = Card.find_by(name: update_hash[:name])
          if card.nil?
            enriched_card = CardEnricher.get_enriched_card(update_hash)
            if enriched_card[:error].present?
              raise CreationError.new(enriched_card[:error].to_json)
            end
            card = Card.create_card_from_hash(enriched_card)
          end
          CubeCard.create_cube_card_from_hash(self, update_hash.merge(
            {:id => card.id, :default_set => card.default_set}))
        end
      end
    end
  end

  private

  def get_sorted_active_cube_cards
    cube_cards
      .where(soft_delete: false)
      .order(:custom_color_identity, :custom_cmc)
  end
end
