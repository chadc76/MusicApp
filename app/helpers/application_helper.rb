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
end
