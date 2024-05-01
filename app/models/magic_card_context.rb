class MagicCardContext
  include Rails.application.routes.url_helpers

  attr_reader :cube, :draft_participant
  delegate :draft, to: :draft_participant

  def self.for_cube(cube)
    new(cube:, draft_participant: nil)
  end

  def self.for_active_draft(draft_participant)
    new(cube: nil, draft_participant:)
  end

  def initialize(cube:, draft_participant:)
    @cube = cube
    @draft_participant = draft_participant
  end

  def link_url(cube_card)
    if cube.present?
      edit_cube_card_path(cube_card)
    elsif draft_participant.skipped? || draft.active_participant == draft_participant
      new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: draft_participant.id)
    end
  end
end
