# frozen_string_literal: true

class CubeListComponent < ViewComponent::Base
  def initialize(cubes:)
    @cubes = cubes
  end

  def render?
    @cubes.present?
  end
end
