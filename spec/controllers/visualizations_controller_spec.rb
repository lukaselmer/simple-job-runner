require 'rails_helper'

def mock_controller_with_visualization_service(controller)
  visualization_service_mock = double('Visualization Service')
  allow(controller).to receive(:visualization_service).and_return(visualization_service_mock)
  visualization_service_mock
end

RSpec.describe VisualizationsController, type: :controller do
  let(:valid_session) { { api_key: ENV['API_KEY'] } }

  describe 'GET #x_vs_score' do
    it 'returns http success' do
      mocked_service = mock_controller_with_visualization_service(controller)
      expect(mocked_service).to receive(:charts).with('epochs').and_return(:magic)
      get :x_vs_score, { x: :epochs }, valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:charts)).to eq(:magic)
    end
  end
end
