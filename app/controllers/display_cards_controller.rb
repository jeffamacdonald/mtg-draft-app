class DisplayCardsController < ApplicationController
  def route
    cube_card = CubeCard.find(params[:cube_card_id])
    draft = Draft.find_by(id: params[:draft_id])
    if draft.present?
      current_participant = draft.draft_participants.find_by(user: current_user)
      picking_participant = if current_participant.skipped?
        current_participant
      elsif current_participant.can_pick_for?(draft.active_participant)
        draft.active_participant
      end

      if draft.participant_picks.map(&:cube_card).include?(cube_card)
        render_cube_card_path(cube_card)
      else
        if picking_participant.present?
          render_new_participant_pick_path(cube_card, picking_participant)
        else
          render_new_queued_pick_path(cube_card, current_participant)
        end
      end
    elsif cube_card.cube.owner == current_user
      render_edit_cube_card_path(cube_card)
    else
      render_cube_card_path(cube_card)
    end
  end

  private

  def render_cube_card_path(cube_card)
    respond_to do |format|
      format.html { redirect_to cube_card_path(cube_card) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal", template: "cube_cards/show")
      end
    end
  end

  def render_new_participant_pick_path(cube_card, draft_participant)
    respond_to do |format|
      format.html { redirect_to new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: draft_participant.id) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal", template: "participant_picks/new")
      end
    end
  end

  def render_new_queued_pick_path(cube_card, draft_participant)
    respond_to do |format|
      format.html { redirect_to new_queued_pick_path(cube_card_id: cube_card.id, draft_participant_id: draft_participant.id) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal", template: "queued_picks/new")
      end
    end
  end

  def render_edit_cube_card_path(cube_card)
    respond_to do |format|
      format.html { redirect_to edit_cube_card_path(cube_card) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("modal", template: "cube_cards/edit")
      end
    end
  end
end
