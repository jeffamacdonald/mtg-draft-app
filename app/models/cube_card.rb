# t.references :cube, references: :cubes, foreign_key: { to_table: :cubes}
# t.references :card, references: :cards, foreign_key: { to_table: :cards}
# t.integer :count, null: false
# t.string :custom_set, null: false
# t.string :custom_image, null: false
# t.string :custom_color_identity, array: true
# t.integer :custom_cmc, null: false
# t.boolean :soft_delete, null: false
# t.timestamps null: false

class CubeCard < ApplicationRecord
  class CreationError < StandardError;end
  include PgSearch::Model
  belongs_to :cube
  belongs_to :card

  validates :count, presence: true

  pg_search_scope :search_by_card_text, associated_against: {
    card: [:card_text]
  }, ignoring: :accents

  pg_search_scope :search_by_card_type, associated_against: {
    card: [:type_line]
  }, ignoring: :accents

  scope :active, -> { where(soft_delete: false) }
  scope :sorted, -> { order(:custom_color_identity, :custom_cmc) }
  scope :with_cmc, ->(cmc) { where(custom_cmc: cmc) if cmc.present? }
  scope :with_color, ->(color) { where("? = ANY (custom_color_identity)", color) if color.present? }
  scope :with_card_text_matching, ->(card_text) { search_by_card_text(card_text) if card_text.present? }
  scope :with_card_type_matching, ->(card_type) { search_by_card_type(card_type) if card_type.present? }

  delegate :colorless?, :white?, :blue?, :black?, :red?, :green?, to: :color_identity
  delegate_missing_to :card

  def color_identity
    if custom_color_identity.present?
      Card::ColorIdentity.new(custom_color_identity)
    else
      card.color_identity
    end
  end

  def update_from_hash(card_hash)
    update_params = card_hash.slice(:count, :custom_color_identity, :custom_cmc, :soft_delete)
    if card_hash[:set].present?
      image = if custom_set.upcase != card_hash[:set].upcase
          CubeCard.get_custom_image(card_hash)
        else
          default_image
        end
      update_params.merge!({
        custom_image: image,
        custom_set: card_hash[:set]
      })
    end
    update!(**update_params)
  end
# I have to refactor all of this... ugh
  def self.create_cube_card_from_hash(cube, card_hash)
    image = if card_hash[:set].present? && card_hash[:default_set].upcase != card_hash[:set]&.upcase
        get_custom_image(card_hash)
      else
        card_hash[:default_image]
      end
    CubeCard.create!(
      cube_id: cube.id,
      card_id: card_hash[:id],
      count: card_hash[:count],
      custom_set: card_hash[:set],
      custom_image: image,
      custom_color_identity: card_hash[:custom_color_identity] || card_hash[:color_identity],
      custom_cmc: card_hash[:custom_cmc] || card_hash[:cmc]
    )
  end

  def self.get_custom_image(card_hash)
    cube_card_with_set = CubeCard.find_by(card_id: card_hash[:id], custom_set: card_hash[:set])
    if cube_card_with_set.present?
      cube_card_with_set.custom_image
    else
      scryfall_card = CardEnricher.get_enriched_card(card_hash)
      if scryfall_card[:error].present?
        raise CreationError.new(scryfall_card[:error].to_json)
      else
        scryfall_card[:image_uri]
      end
    end
  end

  def image_url
    custom_image || default_image
  end
end
