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
  scope :sorted, -> { joins('LEFT OUTER JOIN cards ON cube_cards.card_id = cards.id').order(:custom_cmc, Arel.sql("cards.type_line LIKE '\%Creature\%' DESC"), "cards.name") }
  scope :with_cmc, ->(cmc) { where(custom_cmc: cmc) if cmc.present? }
  scope :with_color, ->(color) { where("? = ANY (custom_color_identity)", color) if color.present? }
  scope :with_card_text_matching, ->(card_text) { search_by_card_text(card_text) if card_text.present? }
  scope :with_card_type_matching, ->(card_type) { search_by_card_type(card_type) if card_type.present? }
  scope :with_cmc_greater_than, -> (cmc) { where("custom_cmc > ?", cmc) }

  delegate :colorless?, :white?, :blue?, :black?, :red?, :green?, to: :color_identity

  def color_identity
    Card::ColorIdentity.new(custom_color_identity)
  end

  def image_url
    custom_image
  end
end
