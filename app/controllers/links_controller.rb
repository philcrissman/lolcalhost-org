class LinksController < ApplicationController

  skip_before_action :authenticate_person!, :only => [:index, :show]

  def index
    @links = if link_person
               link_person.links.all.page(1)
             else
               Link.all.page(1)
             end
    @links = if params[:tag]
               @links.tagged_with(params[:tag]).page(1)
             else
               @links
             end
  end

  def new
    @link = Link.new
    @link.link_ownerships.build(person: link_person)
  end

  def create
    @link = Link.find_or_initialize_by(:url => link_params[:url])
    current_person.links << @link
    @link.update_attributes(link_params)
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
    params[:link].permit(:url, :link_ownerships_attributes => [:title, :description])
  end

  def link_person
    @link_person ||= if params[:username]
                     Person.find_by_username params[:username]
                   else
                     current_person
                   end
  end
end
