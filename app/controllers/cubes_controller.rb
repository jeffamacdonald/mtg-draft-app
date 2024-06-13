class CubesController < ApplicationController
  def index
    @user_cubes = current_user.cubes
  end

  def show
    @cube = Cube.find(params[:id])
    @cube_cards = @cube.cube_cards.active.sorted
      .with_cmc(filter_params[:cmc])
      .with_color(filter_params[:color])
      .with_card_text_matching(filter_params[:card_text])
      .with_card_type_matching(filter_params[:card_type])
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      cube = Cube.create(create_params)
      file = create_params[:import_file]
      cube.import_file.attachment.blob.upload(file.tempfile.open)
      import_cards, invalid_records = DckParser.new(cube.import_file).call
      if invalid_records.present?
        error_messages = invalid_records.map { |record| "#{record.name}: #{record.error_message}"}.join(", ")
        flash[:error] = "Failed to import cube: #{error_messages.truncate_bytes(3000)}"
        redirect_to new_cube_path
      else
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

  helper_method def filter_params
    return {} unless params[:filters].present?

    params.require(:filters).permit(:cmc, :color, :card_text, :card_type)
  end

  def create_params
    params.require(:cube).permit(
      :name,
      :import_file
    ).merge(owner: current_user)
  end
end
