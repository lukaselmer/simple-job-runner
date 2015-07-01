class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init_authentication, :init_date_filter, :authenticate!

  private

  def authenticate!
    head :unauthorized, location: home_index_path unless @authentication_valid
  end

  def init_authentication
    session[:api_key] = params[:api_key] if params[:api_key]
    @authentication_valid = session[:api_key] == ENV['API_KEY']
  end

  def init_date_filter
    session[:date_filter] = params[:date_filter] if params[:date_filter]
    @date_filter = Date.parse(session[:date_filter]) if session[:date_filter]
  end
end
