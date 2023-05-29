class DraftsController < ApplicationController
  def index
  end

  def show
    @draft = Draft.find params[:id]
  end

  def edit
    @draft = Draft.find params[:id]
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
      # redirect to index
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
end
