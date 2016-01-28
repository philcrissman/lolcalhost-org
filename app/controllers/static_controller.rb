class StaticController < ApplicationController

  skip_before_action :authenticate_person!

  def show
    @page = params[:page]
  end
end
