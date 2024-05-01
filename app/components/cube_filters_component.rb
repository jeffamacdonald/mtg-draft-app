# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params

  def initialize(url:, filter_params:)
    @url = url
    @filter_params = filter_params
  end
end
