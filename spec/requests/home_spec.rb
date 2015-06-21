require 'rails_helper'

RSpec.describe 'Home', type: :request do
  context 'initial test' do
    it 'should check if the app is ok and connected to a database' do
      get home_check_path(api_key: ENV['API_KEY'])
      expect(response).to have_http_status(200)
      expect(response.body).to eq('1+2=3')
    end
  end

  context 'authentication' do
    it 'should set the api key in the session' do
      skip_authentication_value_before = ENV['SKIP_AUTHENTICATION']
      begin
        ENV['SKIP_AUTHENTICATION'] = nil
        get '/home/check'
        expect(response).to have_http_status(401)
        get '/'
        expect(session[:api_key]).to be_nil
        expect(response).to have_http_status(200)
        expect(response.body).to include('authentication is invalid')
        get '/home/check?api_key=somekey'
        expect(response).to have_http_status(401)
        expect(session[:api_key]).to eq('somekey')
        get "/home/check?api_key=#{ENV['API_KEY']}"
        expect(response).to have_http_status(200)
        expect(session[:api_key]).to eq(ENV['API_KEY'])
        get '/'
        expect(session[:api_key]).to eq(ENV['API_KEY'])
        expect(response.body).to include('authentication is valid')
        get '/?api_key='
        expect(session[:api_key]).to eq('')
        expect(response.body).to include('authentication is invalid')
      ensure
        ENV['SKIP_AUTHENTICATION'] = skip_authentication_value_before
      end
    end
  end
end
