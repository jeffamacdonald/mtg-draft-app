class DraftsController < ApplicationController
  before_action :find_draft, only: [:show, :edit, :update, :start, :pick_list_size]
  before_action :set_context, only: [:show, :pick_list_size]
  before_action :set_display_defaults, only: [:show]
  def index
  end

  def show
    @cube_cards = @draft.cube.cube_cards
      .includes(:card)
      .select(
        "cube_cards.*",
        "cards.name",
        "cards.type_line",
        "cards.card_text"
      )
      .active.sorted
      .with_cmc(filter_params[:cmc])
      .with_color(filter_params[:color])
      .with_card_text_matching(filter_params[:card_text])
      .with_card_type_matching(filter_params[:card_type])
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
      @draft.set_participant_positions!
      @draft.setup_picks!
      @draft.update!(status: "active")
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
        status: DraftStatus.pending,
        transfers_allowed: create_params[:transfers_allowed]
      )
      @draft.draft_participants.create(user: current_user, display_name: current_user.username)
      redirect_to drafts_path
    end
  end

  def pick_list_size
    current_user.update!(pick_list_size: params[:text_size], secret_key: ENV.fetch("REGISTRATION_SECRET"))
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "draft_#{@draft.id}_pick_list",
          render_to_string(PickListComponent.new(draft: @draft, context: @context))
        )
      end
      format.html { redirect_to draft_path(@draft) }
    end
  end

  private

  helper_method def filter_params
    return {} unless params[:filters].present?

    params.require(:filters).permit(:cmc, :color, :card_text, :card_type, :text_only, :image_size)
  end

  def create_params
    params.require(:draft).permit(
      :name,
      :rounds,
      :cube_id,
      :timer_minutes,
      :transfers_allowed
    )
  end

  def update_params
    params.require(:draft).permit(
      :status
    )
  end

  def find_draft
    @draft = Draft.includes(
      :cube,
      draft_participants: :user,
      participant_picks: [:draft_participant, :cube_card]
    ).find(params[:id])
  end

  def set_display_defaults
    if filter_params[:text_only].present? || filter_params[:image_size].present?
      current_user.default_display = filter_params[:text_only] == "1" ? "text" : "image"
      current_user.default_image_size = filter_params[:image_size] || current_user.default_image_size
      current_user.save!(validate: false)
    end
  end

  def set_context
    @draft_participant = @draft.draft_participants.find { |p| p.user_id == current_user.id }

    @context = MagicCardContext.for_active_draft(
      draft: @draft, 
      draft_participant: @draft_participant,
      text_only: current_user.default_display == "text", 
      image_size: current_user.default_image_size)
  end
end
