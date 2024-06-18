class MagicCardContext
  include Rails.application.routes.url_helpers

  attr_reader :cube, :draft_participant
  delegate :draft, to: :draft_participant

  def self.for_cube(cube:, text_only:, is_owner:)
    new(cube:, draft_participant: nil, text_only:, is_owner:)
  end

  def self.for_active_draft(draft_participant:, text_only:)
    new(cube: nil, draft_participant:, text_only:, is_owner: true)
  end

  def initialize(cube:, draft_participant:, text_only:, is_owner:)
    @cube = cube
    @draft_participant = draft_participant
    @text_only = text_only
    @is_owner = is_owner
  end

  def link_url(cube_card)
    if cube.present? && is_owner?
      edit_cube_card_path(cube_card)
    elsif draft_participant.present? && (draft_participant.skipped? || active_participant == draft_participant)
      new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: draft_participant.id)
    end
  end

  def picked?(cube_card)
    return false unless draft_participant.present?

    draft.participant_picks.map(&:cube_card).include? cube_card
  end

  def active_participant
    @_active_participant ||= draft.active_participant
  end

  def text_only?
    @text_only
  end

  private

  def is_owner?
    @is_owner
  end
end
