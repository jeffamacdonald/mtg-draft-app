class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def up
    head :ok
  end
end
