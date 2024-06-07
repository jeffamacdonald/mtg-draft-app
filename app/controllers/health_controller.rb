class HealthController < ApplicationController
  def up
    head :ok
  end
end
