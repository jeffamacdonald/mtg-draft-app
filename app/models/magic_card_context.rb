require 'set'

class MagicCardContext
  include Rails.application.routes.url_helpers

  attr_reader :cube, :draft_participant, :draft, :image_size

  def self.for_cube(cube:, text_only:, image_size:)
    new(cube:, draft: nil, draft_participant: nil, text_only:, image_size:)
  end

  def self.for_active_draft(draft:, draft_participant:, text_only:, image_size:)
    new(cube: nil, draft:, draft_participant:, text_only:, image_size:)
  end

  def self.for_view_only
    new(cube: nil, draft: nil, draft_participant: nil, text_only: nil, image_size: nil)
  end

  attr_reader :active_participant, :picked_cube_card_ids

  def initialize(cube:, draft:, draft_participant:, text_only:, image_size:)
    @cube = cube
    @draft = draft
    @draft_participant = draft_participant
    @text_only = text_only
    @image_size = image_size
    @card_route_template = draft.present? ? DRAFT_CARD_ROUTE_TEMPLATE.sub(DRAFT_ID_PLACEHOLDER, draft.id.to_s) : CARD_ROUTE_TEMPLATE
    # Precompute expensive operations
    precompute_draft_data if draft.present?
  end

  def picked?(cube_card)
    return false unless draft.present?

    picked_cube_card_ids.include?(cube_card.id)
  end

  def text_only?
    !!@text_only
  end

  # Placeholders with no characters that get URL-escaped
  CARD_ID_PLACEHOLDER = "CUBE_CARD_ID".freeze
  DRAFT_ID_PLACEHOLDER = "DRAFT_ID".freeze

  # The card route is generated once, at load, and ids substituted in: the route helper
  # is the most expensive part of rendering a tile.
  CARD_ROUTE_TEMPLATE = Rails.application.routes.url_helpers
    .route_display_card_path(cube_card_id: CARD_ID_PLACEHOLDER).freeze
  DRAFT_CARD_ROUTE_TEMPLATE = Rails.application.routes.url_helpers
    .route_display_card_path(cube_card_id: CARD_ID_PLACEHOLDER, draft_id: DRAFT_ID_PLACEHOLDER).freeze

  def card_route_path(cube_card)
    @card_route_template.sub(CARD_ID_PLACEHOLDER, cube_card.id.to_s)
  end

  private

  def precompute_draft_data
    # Use the already loaded participant_picks from includes
    picks_with_cards = @draft.participant_picks.select { |pick| pick.cube_card_id.present? }
    @picked_cube_card_ids = Set.new(picks_with_cards.map(&:cube_card_id))

    # Calculate active pick without additional queries
    max_pick_number = @draft.participant_picks
      .select { |pick| pick.cube_card_id.present? || pick.skipped? }
      .map(&:pick_number)
      .max || 0

    @active_participant = @draft.participant_picks
      .find { |pick| pick.pick_number == max_pick_number + 1 }
      &.draft_participant
  end
end
