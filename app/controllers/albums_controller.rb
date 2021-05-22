class AlbumsController < ApplicationController
  def show
    @album = Album.find(params[:id])
    render :show
  end

  def new

  end

  def create

  end

  def edit

  end

  def update
    
  end

  def destroy

  end

  private

  def albums_params
    params.require(:album).permit(:title, :year, :band_id, :live)
  end
end