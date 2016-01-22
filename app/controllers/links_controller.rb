class LinksController < ApplicationController

  def index
    @links = if params[:tag]
               link_user.links.tagged_with(params[:tag])
             else
               link_user.links.all
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

  def link_user
    if params[:username]
      Person.find_by_username params[:username]
    else
      current_person
    end
  end
end
