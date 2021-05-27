class TracksController < ApplicationController
  before_action :must_be_logged_in
  before_action :current_user_admin?, except: [:show]
  
  def show
    @track = Track.find_by(id: params[:id])
    render :show
  end

  def new
    @track = Track.new
    render :new
  end

  def create
    @track = Track.new(track_params)
    if @track.save
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def edit
    @track = Track.find_by(id: params[:id])
    render :edit
  end

  def update
    @track = Track.find_by(id: params[:id])
    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def destroy
    @track = Track.find_by(id: params[:id])
    @track.destroy
    flash[:notice] = ["#{@track.title} has been deleted!"]
    redirect_to album_url(@track.album_id)
  end
  
  def new_tag
    @tagging = Tagging.new
    @track = Track.find_by(id: params[:id])
    render :tag
  end

  def tag
    @track = Track.find_by(id: params[:id])
    @tagging = Tagging.new(taggable_id: params[:id], taggable_type: "Track")
    tag = Tag.find_by(tag: params[:tagging][:tag])
    if tag
      @tagging.tag_id = tag.id
    else 
      tag = Tag.new(tag: params[:tagging][:tag])
      if tag.save
        @tagging.tag_id = tag.id
      else
        flash.now[:errors] = tag.errors.full_messages
        redirect_to track_url(params[:id])
        return
      end
    end

    if @tagging.save
      url = params[:tagging]
      redirect_to track_url(params[:id])
    else
      flash.now[:errors] = @tagging.errors.full_messages
      render :tag
    end
  end

  def edit_tags
    @track = Track.includes(:tags).find_by(id: params[:id])
    @taggings = @track.tags
    render :untag
  end

  def untag
    @track = Track.find_by(id: params[:id])
    tag = Tagging.find_by(taggable_id: params[:id], taggable_type: "Track", tag_id: params[:tag_id])
    if tag
      tag.destroy
      flash[:notice] = ["The Tag has been removed"]
      redirect_to track_url(params[:id])
    else
      redirect_to track_url(params[:id])
    end
  end

  private

  def track_params
    params.require(:track).permit(:title, :ord, :album_id, :bonus_track, :lyrics)
  end
end