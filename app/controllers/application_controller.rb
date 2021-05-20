class ApplicationController < ActionController::Base
  def login!(user)
    session[:session_token] = user.session_token
  end
end
