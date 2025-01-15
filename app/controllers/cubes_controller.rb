class CubesController < ApplicationController
  before_action :set_display_defaults, only: [:show]

  def index
    @user_cubes = current_user.cubes
  end

  def show
    @cube = Cube.find(params[:id])
    @cube_cards = @cube.cube_cards
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
    @text_only = current_user.default_display == "text" 
    @image_size = current_user.default_image_size
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
        error_messages = invalid_records.map { |record| "#{record.name}: #{record.error_message}"}.join(", ").truncate_bytes(3000)
        raise "Failed to import cube: #{error_messages}"
      else
        importer = Import::DckFile.new(import_cards, cube)
        if importer.import
          redirect_to cubes_path
        else
          raise importer.errors.join(" ")
        end
      end
    end
  rescue => ex
    flash[:error] = ex.message
    redirect_to new_cube_path
  end

  private

  helper_method def filter_params
    return {} unless params[:filters].present?

    params.require(:filters).permit(:cmc, :color, :card_text, :card_type, :text_only, :image_size)
  end

  def create_params
    params.require(:cube).permit(
      :name,
      :import_file
    ).merge(owner: current_user)
  end

  def set_display_defaults
    if filter_params[:text_only].present? || filter_params[:image_size].present?
      default_display = filter_params[:text_only] == "1" ? "text" : "image"
      image_size = filter_params[:image_size] || current_user.default_image_size
      current_user.update!(default_display: default_display, default_image_size: image_size, secret_key: ENV.fetch("REGISTRATION_SECRET"))
    end
  end
end
