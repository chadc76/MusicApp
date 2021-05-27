class AlbumsController < ApplicationController
  before_action :must_be_logged_in
  before_action :current_user_admin?, except: [:show]
  
  def show
    @album = Album.find_by(id: params[:id])
    render :show
  end

  def new
    @album = Album.new
    render :new
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def edit
    @album = Album.find_by(id: params[:id])
    render :edit
  end

  def update
    @album = Album.find_by(id: params[:id])
    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def destroy
    @album = Album.find_by(id: params[:id])
    @album.destroy
    flash[:notice] = "#{@album.title} has been deleted!"
    redirect_to band_url(@album.band_id)
  end

  def new_tag
    @tagging = Tagging.new
    @album = Album.find_by(id: params[:id])
    render :tag
  end

  def tag
    @album = Album.find_by(id: params[:id])
    @tagging = Tagging.new(taggable_id: params[:id], taggable_type: "Album")
    tag = Tag.find_by(tag: params[:tagging][:tag].downcase)
    if tag
      @tagging.tag_id = tag.id
    else 
      tag = Tag.new(tag: params[:tagging][:tag].downcase)
      if tag.save
        @tagging.tag_id = tag.id
      else
        flash.now[:errors] = tag.errors.full_messages
        redirect_to album_url(params[:id])
        return
      end
    end

    if @tagging.save
      url = params[:tagging]
      redirect_to album_url(params[:id])
    else
      flash.now[:errors] = @tagging.errors.full_messages
      render :tag
    end
  end

  def edit_tags
    @album = Album.includes(:tags).find_by(id: params[:id])
    @taggings = @album.tags
    render :untag
  end

  def untag
    @album = Album.find_by(id: params[:id])
    tag = Tagging.find_by(taggable_id: params[:id], taggable_type: "Album", tag_id: params[:tag_id])
    if tag
      tag.destroy
      flash[:notice] = ["The Tag has been removed"]
      redirect_to album_url(params[:id])
    else
      redirect_to album_url(params[:id])
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :year, :band_id, :live)
  end
end