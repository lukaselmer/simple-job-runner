require 'rails_helper'

RSpec.describe 'Runs', type: :request do
  describe 'GET /runs' do
    it 'gets the runs' do
      get runs_path(api_key: ENV['API_KEY'])
      expect(response).to have_http_status(200)
    end

    it 'doesnt get the runs when not authenticated' do
      get runs_path
      expect(response).to have_http_status(401)
    end
  end
end
