class MagicCardContext
  include Rails.application.routes.url_helpers

  attr_reader :cube, :draft_participant, :draft, :image_size

  def self.for_cube(cube:, text_only:, is_owner:, image_size:)
    new(cube:, draft: nil, draft_participant: nil, text_only:, is_owner:, image_size:)
  end

  def self.for_active_draft(draft:, draft_participant:, text_only:, image_size:)
    new(cube: nil, draft:, draft_participant:, text_only:, is_owner: true, image_size:)
  end

  def initialize(cube:, draft:, draft_participant:, text_only:, is_owner:, image_size:)
    @cube = cube
    @draft = draft
    @draft_participant = draft_participant
    @text_only = text_only
    @is_owner = is_owner
    @image_size = image_size || "lg"
  end

  def link_url(cube_card)
    return unless cube.present? || draft_participant.present?

    if cube.present? && is_owner?
      edit_cube_card_path(cube_card)
    elsif draft_participant.present? && (draft_participant.skipped? || active_participant == draft_participant)
      new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: draft_participant.id)
    elsif draft_participant.present? && active_participant.surrogate_participants.include?(draft_participant)
      new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: active_participant.id)
    end
  end

  def picked?(cube_card)
    return false unless draft.present?

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
