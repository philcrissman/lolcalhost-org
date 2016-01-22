class TagsController < ApplicationController
  def show
    @links = Link.tagged_with(params[:tag])
  end
end
