class SearchResultsController < ApplicationController
  before_action :must_be_logged_in
  skip_before_action :verify_authenticity_token

  def show
    @search = search_input
    @search_type = search_type
    case search_type
    when "All"
      @results = search_all
    when "Album"
      @results = { "Album" => search_albums }
    when "Band"
      @results = { "Band" => search_bands }
    when "Tag"
      @results = search_tags
    when "Track"
      @results = { "Track" => search_tracks }
    else
      flash[:notice] = ["Invalid search type"]
      redirect_to request.referer
      return
    end
    render :results
  end

  private

  def search_all
    hash = { }

    hash["Album"] = search_albums.empty? ? search_tags["Album"] : search_albums + search_tags["Album"]
    hash["Band"] = search_bands.empty? ? search_tags["Band"] : search_bands + search_tags["Band"]
    hash["Track"] = search_tracks.empty? ? search_tags["Track"] : search_tracks + search_tags["Track"]

    hash
  end

  def search_albums
    Album.where("upper (albums.title) LIKE upper (?) OR albums.year = ?", search_input_with_percent, search_input.to_i)
  end

  def search_bands
    Band.where("upper (bands.name) LIKE upper (?)", search_input_with_percent)
  end

  def search_tags
    @tag = Tag.find_by(tag: search_input)
    item_hash = Hash.new { |h, k| h[k] = [] }

    if @tag 
      items = Tagging.includes(:taggable).where("taggings.tag_id = ?", @tag.id)
      items.each do |item|
        item_hash[item.taggable.class.name] << item.taggable
      end
    end

    item_hash
  end

  def search_tracks
    Track.where("upper (tracks.title) LIKE upper (?) OR upper (tracks.lyrics) LIKE upper (?)", search_input_with_percent, search_input_with_percent)
  end

  def search_type
    params[:search][:search_type]
  end

  def search_input
    params[:search][:search_input]
  end

  def search_input_with_percent
    "%" + search_input + "%"
  end
end