# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params, :user

  def initialize(url:, filter_params:, user:)
    @url = url
    @filter_params = filter_params
    @user = user
  end

  def switch_view_label
    if text_only?
      "Large Image View"
    else
      "Text View"
    end
  end

  def image_view_size
    if user.default_image_size == "sm"
      "lg"
    else
      "sm"
    end
  end

  def image_view_label
    if user.default_image_size == "sm"
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
    user.default_display == "text"
  end
end
