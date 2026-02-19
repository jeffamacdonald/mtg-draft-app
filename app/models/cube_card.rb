# == Schema Information
#
# Table name: cube_cards
#
#  id                    :uuid             not null, primary key
#  count                 :integer          not null
#  custom_cmc            :integer          not null
#  custom_color_identity :string           not null, is an Array
#  custom_image          :string           not null
#  custom_set            :string           not null
#  soft_delete           :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  card_id               :uuid
#  cube_id               :uuid
#
# Indexes
#
#  index_cube_cards_on_card_id                (card_id)
#  index_cube_cards_on_cube_id                (cube_id)
#  index_cube_cards_on_cube_soft_delete_cmc   (cube_id,soft_delete,custom_cmc)
#  index_cube_cards_on_custom_color_identity  (custom_color_identity)
#  index_cube_cards_on_soft_delete            (soft_delete)
#
# Foreign Keys
#
#  fk_rails_...  (card_id => cards.id)
#  fk_rails_...  (cube_id => cubes.id)
#
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
