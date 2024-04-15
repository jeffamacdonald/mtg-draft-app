class CubeCardsController < ApplicationController
  def edit
    @cube_card = CubeCard.find params[:id]
  end

  def update
    @cube_card = CubeCard.find params[:id]
    @cube_card.attributes = update_params.merge(custom_color_identity)
    if @cube_card.save
      redirect_to cube_path(@cube_card.cube), flash: {success: "Cube card changes saved"}
    else
      render :edit, flash: {error: "Cube card changes failed: #{@cube_card.errors.full_messages.join(" ")}"}
    end
  end

  private

  def update_params
    params.require(:cube_card).permit(
      :count,
      :custom_set,
      :custom_image,
      :custom_cmc,
      custom_color_identity: []
    )
  end

  def custom_color_identity
    {
      custom_color_identity: update_params[:custom_color_identity].reject(&:blank?)
    }
  end
end
