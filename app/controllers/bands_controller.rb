class BandsController < ApplicationController
  before_action :must_be_logged_in
  before_action :current_user_admin?, except: [:show, :index]
  
  def index
    @bands = Band.all
    render :index
  end

  def show
    @band = Band.includes(:tags).includes(:albums).find_by(id: params[:id])
    render :show
  end

  def new
    @band = Band.new
    render :new
  end

  def create
    @band = Band.new(band_params)
    
    if @band.save 
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :new
    end
  end

  def edit
    @band = Band.find_by(id: params[:id])
    render :edit
  end

  def update
    @band = Band.find_by(id: params[:id])
    
    if @band.update(band_params)
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :edit
    end
  end

  def destroy
    @band = Band.find_by(id: params[:id])
    @band.destroy
    flash[:notice] = "#{@band.name} has been deleted!"
    redirect_to bands_url
  end

  def new_tag
    @tagging = Tagging.new
    @band = Band.find_by(id: params[:id])
    render :tag
  end

  def tag
    @band = Band.find_by(id: params[:id])
    @tagging = Tagging.new(taggable_id: params[:id], taggable_type: "Band")
    tag = Tag.find_by(tag: params[:tagging][:tag])
    if tag
      @tagging.tag_id = tag.id
    else 
      tag = Tag.new(tag: params[:tagging][:tag])
      if tag.save
        @tagging.tag_id = tag.id
      else
        flash.now[:errors] = tag.errors.full_messages
        redirect_to band_url(params[:id])
        return
      end
    end

    if @tagging.save
      url = params[:tagging]
      redirect_to band_url(params[:id])
    else
      flash.now[:errors] = @tagging.errors.full_messages
      render :tag
    end
  end

  def edit_tags
    @band = Band.includes(:tags).find_by(id: params[:id])
    @taggings = @band.tags
    render :untag
  end

  def untag
    @band = Band.find_by(id: params[:id])
    tag = Tagging.find_by(taggable_id: params[:id], taggable_type: "Band", tag_id: params[:tag_id])
    if tag
      tag.destroy
      flash[:notice] = ["The Tag has been removed"]
      redirect_to band_url(params[:id])
    else
      redirect_to band_url(params[:id])
    end
  end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end