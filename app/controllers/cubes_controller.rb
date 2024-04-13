class CubesController < ApplicationController
  def index
    @user_cubes = current_user.cubes
  end

  def show
    @cube = Cube.find(params[:id])
  end

  def edit
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @cube = Cube.create(name: create_params[:name], user: current_user)
      cube_list, errors = DckParser.new(create_params[:import_file]).get_parsed_list
      if errors.present?
        # show errors and redirect to new
      else
        @cube.setup_cube_from_list(cube_list)
        redirect_to cubes_path
      end
    end
  end

  private

  def create_params
    params.require(:cube).permit(
      :name,
      :import_file
    )
  end
end
