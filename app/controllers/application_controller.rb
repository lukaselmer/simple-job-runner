class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_api_key, :authenticate_with_api_key

  private

  def authenticate_with_api_key
    head :unauthorized, location: home_index_path unless @authentication_valid
  end

  def set_api_key
    key = params[:api_key]
    session[:api_key] = key if key
    api_key = ENV['SKIP_AUTHENTICATION'] == 'skip' ? ENV['API_KEY'] : session[:api_key]
    @authentication_valid = api_key == ENV['API_KEY']
  end
end
