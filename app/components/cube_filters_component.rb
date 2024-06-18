# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params

  def initialize(url:, filter_params:)
    @url = url
    @filter_params = filter_params
  end

  def switch_view_label
    if text_only?
      "Image View"
    else
      "Text View"
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
