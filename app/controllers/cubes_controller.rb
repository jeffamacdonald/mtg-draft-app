class CubesController < ApplicationController
  def index
    @user_cubes = current_user.cubes
  end

  def show
    @cube = Cube.find(params[:id])
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      import_cards, invalid_records = DckParser.new(create_params[:import_file]).call
      if invalid_records.present?
        error_messages = invalid_records.map { |record| "#{record.name}: #{record.error_message}"}.join(", ")
        flash[:error] = "Failed to import cube: #{error_messages}"
        redirect_to new_cube_path
      else
        cube = Cube.new(name: create_params[:name], owner: current_user)
        importer = Import::DckFile.new(import_cards, cube)
        if importer.import
          redirect_to cubes_path
        else
          flash[:error] = importer.errors.join(" ")
          redirect_to new_cube_path
        end
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
