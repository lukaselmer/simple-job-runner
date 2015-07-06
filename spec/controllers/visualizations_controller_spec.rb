require 'rails_helper'

def mock_controller_with_visualization_service(controller)
  visualization_service_mock = double('Visualization Service')
  allow(controller).to receive(:visualization_service).and_return(visualization_service_mock)
  run_filter_service_mock = double('Run Filter Service')
  allow(controller).to receive(:run_filter_service).and_return(run_filter_service_mock)
  [visualization_service_mock, run_filter_service_mock]
end

RSpec.describe VisualizationsController, type: :controller do
  let(:valid_session) { { api_key: ENV['API_KEY'] } }

  describe 'GET #x_vs_score' do
    it 'returns http success' do
      visualization_service, run_filter_service = mock_controller_with_visualization_service(controller)
      expect(visualization_service).to receive(:charts).with('epochs').and_return(:magic)
      expect(run_filter_service).to receive(:filterable_attributes).with(no_args).and_return(:magic2)
      get :x_vs_score, { x: :epochs }, valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:charts)).to eq(:magic)
      expect(assigns(:filterable_attributes)).to eq(:magic2)
    end
  end

  describe 'GET #x_vs_score_by_z' do
    it 'returns http success' do
      visualization_service, run_filter_service = mock_controller_with_visualization_service(controller)
      expect(visualization_service).to receive(:multi_charts).with('epochs', 'zzz').and_return(:magic)
      expect(run_filter_service).to receive(:filterable_attributes).with(no_args).and_return(:magic2)
      get :x_vs_score_by_z, { x: :epochs, z: :zzz }, valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:charts)).to eq(:magic)
      expect(assigns(:filterable_attributes)).to eq(:magic2)
    end
  end
end
