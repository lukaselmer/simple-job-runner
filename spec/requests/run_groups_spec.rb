require 'rails_helper'

RSpec.describe 'RunGroups', type: :request do
  describe 'GET /run_groups' do
    it 'works!' do
      get run_groups_path(api_key: ENV['API_KEY'])
      expect(response).to have_http_status(200)
    end
  end
end
