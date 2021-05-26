module ApplicationHelper
  def auth_token
    "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{form_authenticity_token}\">".html_safe
  end

  def band_selector(album, band)
    if album.persisted?
      selected = album.band_id == band.id ? "selected" : ""
    else
      selected = current_band.id == band.id ? "selected" : ""
    end

    selected
  end

  def album_selector(track, album)
    if track.persisted?
      selected = track.album_id == album.id ? "selected" : ""
    else
      selected = current_album.id == album.id ? "selected" : ""
    end

    selected
  end

  def is_author?(note)
    note.user_id == current_user.id 
  end
end
