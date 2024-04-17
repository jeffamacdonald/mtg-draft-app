class DraftsController < ApplicationController
  before_action :find_draft, only: [:show, :edit, :update]
  def index
  end

  def show
    if @draft.status == "PENDING"
      redirect_to edit_draft_path(@draft)
    end
  end

  def edit
    if @draft.status != "PENDING"
      redirect_to draft_path(@draft)
    end
  end

  def update
    @draft.update(update_params)
    redirect_to draft_path(@draft)
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @draft = Draft.create(
        name: create_params[:name],
        rounds: create_params[:rounds],
        cube: Cube.find(create_params[:cube_id]),
        user: current_user,
        status: "PENDING"
      )
      @draft.draft_participants.create(user: current_user, display_name: current_user.username)
      redirect_to drafts_path
    end
  end

  private

  def create_params
    params.require(:draft).permit(
      :name,
      :rounds,
      :cube_id
    )
  end

  def update_params
    params.permit(
      :id,
      :status
    )
  end

  def find_draft
    @draft = Draft.find params[:id]
  end
end
