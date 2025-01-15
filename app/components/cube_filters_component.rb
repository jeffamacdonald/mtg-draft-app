# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params, :user

  SWITCH_VIEW_VALUES = {
    "Text View" => [1, "lg"],
    "Large Image View" => [0, "lg"],
    "Small Image View" => [0, "sm"]
  }

  def initialize(url:, filter_params:, user:)
    @url = url
    @filter_params = filter_params
    @user = user
  end

  def switch_view_labels
    SWITCH_VIEW_VALUES.keys - [selected_view]
  end

  def text_only_value(switch_view_label)
    SWITCH_VIEW_VALUES[switch_view_label][0]
  end

  def image_size_value(switch_view_label)
    SWITCH_VIEW_VALUES[switch_view_label][1]
  end

  private

  def selected_view
    if user.default_display == "text"
      "Text View"
    elsif user.default_image_size == "lg"
      "Large Image View"
    else
      "Small Image View"
    end
  end
end
