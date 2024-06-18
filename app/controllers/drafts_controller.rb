class DraftsController < ApplicationController
  before_action :find_draft, only: [:show, :edit, :update, :start]
  def index
  end

  def show
    @cube_cards = @draft.cube.cube_cards.active.sorted
      .with_cmc(filter_params[:cmc])
      .with_color(filter_params[:color])
      .with_card_text_matching(filter_params[:card_text])
      .with_card_type_matching(filter_params[:card_type])
    @context = MagicCardContext.for_active_draft(draft_participant: @draft.draft_participants.find_by(user: current_user), text_only: filter_params[:text_only] == "1")
  end

  def edit
    if @draft.status != DraftStatus.pending
      redirect_to draft_path(@draft)
    end
  end

  def update
    @draft.update(update_params)
    redirect_to draft_path(@draft)
  end

  def start
    if @draft.status == "pending"
      @draft.update!(status: "active", active_round: 1)
      @draft.set_participant_positions
      redirect_to draft_path(@draft)
    else
      flash[:error] = "Can only start a pending draft."
      redirect_to draft_path(@draft)
    end
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @draft = Draft.create(
        name: create_params[:name],
        rounds: create_params[:rounds],
        timer_minutes: create_params[:timer_minutes],
        cube: Cube.find(create_params[:cube_id]),
        owner: current_user,
        status: DraftStatus.pending
      )
      @draft.draft_participants.create(user: current_user, display_name: current_user.username)
      redirect_to drafts_path
    end
  end

  private

  helper_method def filter_params
    return {} unless params[:filters].present?

    params.require(:filters).permit(:cmc, :color, :card_text, :card_type, :text_only)
  end

  def create_params
    params.require(:draft).permit(
      :name,
      :rounds,
      :cube_id,
      :timer_minutes
    )
  end

  def update_params
    params.require(:draft).permit(
      :status
    )
  end

  def find_draft
    @draft = Draft.find params[:id]
  end
end
