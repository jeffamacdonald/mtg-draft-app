class DraftsController < ApplicationController
  def index
  end

  def show
    @draft = Draft.find params[:id]
  end

  def new

  end

  def create

  end
end
