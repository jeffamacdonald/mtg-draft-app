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

  def initialize(cube:, draft:, draft_participant:, text_only:, image_size:)
    @cube = cube
    @draft = draft
    @draft_participant = draft_participant
    @text_only = text_only
    @image_size = image_size
  end

  def picked?(cube_card)
    return false unless draft.present?

    draft.participant_picks.map(&:cube_card).include? cube_card
  end

  def active_participant
    @_active_participant ||= draft.active_participant
  end

  def text_only?
    !!@text_only
  end
end
