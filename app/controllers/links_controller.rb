class LinksController < ApplicationController

  def index
    @links = if params[:tag]
      Link.tagged_with(params[:tag])
    else
      Link.all
    end
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    @link.refresh_metadata
    if @link.save
      redirect_to link_path(@link)
    else
      render :new
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  private

  def link_params
    params[:link].permit(:url, :title, :description)
  end
end
