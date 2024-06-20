# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params

  def initialize(url:, filter_params:)
    @url = url
    @filter_params = filter_params
  end

  def switch_view_label
    if text_only?
      "Large Image View"
    else
      "Text View"
    end
  end

  def image_view_size
    if filter_params[:image_size] == "sm"
      "lg"
    else
      "sm"
    end
  end

  def image_view_label
    if filter_params[:image_size] == "sm"
      "Large Image View"
    else
      "Small Image View"
    end
  end

  def switch_view_value
    if text_only?
      0
    else
      1
    end
  end

  private

  def text_only?
    filter_params[:text_only] == "1"
  end
end
