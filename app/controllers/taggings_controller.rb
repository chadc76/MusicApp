class TaggingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @tagging = Tagging.create(tagging_params)
    tag = Tag.find_by(tag: params[:tagging][:tag])
    if tag
      @tagging.tag_id = tag.id
    else 
      tag = Tag.new(tag: params[:tagging][:tag])
      if tag.save
        @tagging.tag_id = tag.id
      else
        flash.now[:errors] = tag.errors.full_messages
        redirect_to request.referer[0..-10]
        return
      end
    end

    if @tagging.save
      url = params[:tagging]
      fail
      redirect_to request.referer[0..-10]
    else
      flash.now[:errors] = @tagging.errors.full_messages
      redirect_to request.referer[0..-10]
    end
  end

  def destroy
    @tagging = Tagging.includes(:tag).find_by(id: params[:id])
    @tagging.destroy
    flash[:notice] = ["#{@tagging.tag.tag} was removed"]
    redirect_to request.referer[0..-14]
  end

  private

  def tagging_params
    params.require(:tagging).permit(:taggable_id, :taggable_type)
  end
end