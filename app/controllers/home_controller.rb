class HomeController < ApplicationController
  def index
    redirect_to drafts_path
  end
end
