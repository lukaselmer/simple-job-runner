require 'rails_helper'

def mock_controller_with_run_service(controller)
  runs_service_mock = double('Runs Service')
  allow(controller).to receive(:runs_service).and_return(runs_service_mock)
  runs_service_mock
end

RSpec.describe RunsController, type: :controller do
  let(:valid_attributes) do
    attributes_for(:ended_run)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RunsController. Be sure to keep this updated too.
  let(:valid_session) { { api_key: ENV['API_KEY'] } }

  describe '#runs_service' do
    it 'should return a run service' do
      expect(controller.send(:runs_service)).to be_a(RunsService)
    end
  end

  describe 'GET #index' do
    it 'assigns all runs as @runs' do
      pending_run = create(:pending_run)
      started_run = create(:started_run)
      ended_run = create(:ended_run)

      get :index, {}, valid_session

      expect(assigns(:runs).pending).to eq([pending_run])
      expect(assigns(:runs).started).to eq([started_run])
      expect(assigns(:runs).ended).to eq([ended_run])
    end

    it 'filters the @runs by created_at within +/-15 seconds' do
      filter_time = 10.days.ago
      time1 = filter_time - 10.seconds
      time2 = filter_time + 10.seconds
      time3 = filter_time - 20.seconds
      time4 = filter_time + 20.seconds
      run1 = create(:ended_run, created_at: time1)
      run2 = create(:ended_run, created_at: time2)
      create(:ended_run, created_at: time3)
      create(:ended_run, created_at: time4)
      get :index, { created_at: filter_time }, valid_session
      expect(assigns(:runs).ended).to eq([run1, run2])
    end

    it 'sorts the @runs by ended_at (newest to oldest)' do
      run1 = create(:ended_run, ended_at: 10.seconds.ago)
      run2 = create(:ended_run, ended_at: 20.seconds.ago)
      run3 = create(:ended_run, ended_at: 5.seconds.ago)
      get :index, {}, valid_session
      expect(assigns(:runs).ended).to eq([run3, run1, run2])
    end
  end

  describe 'GET #possible_pending' do
    it 'should get the possible pending runs with a new hostname' do
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:possible_pending_runs_by_host_name).with(no_args).and_return([:x])
      get :possible_pending, { host_name: 'any' }, valid_session
      expect(assigns(:possible_pending_runs_by_host_name)).to eq([:x])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested run as @run' do
      run = create(:ended_run)
      get :show, { id: run.to_param }, valid_session
      expect(assigns(:run)).to eq(run)
    end
  end

  describe 'GET #start_random_pending_run' do
    render_views

    it 'assigns a @run which it gets from the service' do
      run_mock = build_stubbed(:pending_run)
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:start_random_pending_run).with('host1').and_return(run_mock)
      get :start_random_pending_run, { host_name: 'host1' }, valid_session
      expect(assigns(:run)).to eq(run_mock)
      id = run_mock.id.to_s
      json = run_mock.algo_params.to_json
      expect(response.body).to eq('{"result":"start","id":' + id + ',"algo_params":' + json + '}')
    end

    it 'renders nothing when there are no pending runs' do
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:start_random_pending_run).with('host1').and_return(nil)
      get :start_random_pending_run, { host_name: 'host1' }, valid_session
      expect(assigns(:run)).to eq(nil)
      expect(response.body).to eq('{"result":"nothing"}')
    end
  end

  describe 'GET #end_all' do
    render_views

    it 'calls end_all on the service' do
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:end_all).with(no_args)
      get :end_all, valid_session
      expect(response.body).to eq('')
    end
  end

  describe 'GET #schedule_runs' do
    render_views

    it 'calls schedule_runs on the service' do
      runs_service_mock = mock_controller_with_run_service(controller)
      general_params = { param1: [10, 15], param2: [5] }
      narrow_params = { epochs: [40, 50] }
      expect(runs_service_mock).to receive(:schedule_runs).with(general_params, narrow_params)
      post :schedule_runs, { format: :json, general_params: general_params, narrow_params: narrow_params }, valid_session
      expect(response.body).to eq('')
    end

    it 'handles floats' do
      runs_service_mock = mock_controller_with_run_service(controller)
      general_params = { param1: [10.5, 15], param2: [5] }
      narrow_params = { epochs: [40, 50] }
      expect(runs_service_mock).to receive(:schedule_runs).with(general_params, narrow_params)
      post :schedule_runs, { format: :json, general_params: general_params, narrow_params: narrow_params }, valid_session
      expect(response.body).to eq('')
    end

    it 'handles strings' do
      runs_service_mock = mock_controller_with_run_service(controller)
      general_params = { classifier: %w(rbf linear_svc), param2: [5] }
      narrow_params = { epochs: [40, 50] }
      expect(runs_service_mock).to receive(:schedule_runs).with(general_params, narrow_params)
      post :schedule_runs, { format: :json, general_params: general_params, narrow_params: narrow_params }, valid_session
      expect(response.body).to eq('')
    end
  end

  describe 'GET #report_results' do
    render_views

    it 'calls report_results on the service' do
      run = create(:started_run)
      runs_service_mock = mock_controller_with_run_service(controller)
      output = "A very very very long string\nScore: 55%\nSome more output"
      expect(runs_service_mock).to receive(:report_results).with(run, output)
      put :report_results, { id: run.to_param, run: { output: output } }, valid_session
      expect(assigns(:run)).to eq(run)
      expect(response.body).to eq('')
    end
  end

  describe 'GET #restart' do
    render_views

    it 'calls restart on the service' do
      run = create(:started_run)
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:restart).with(run)
      get :restart, { id: run.to_param }, valid_session
      expect(response).to redirect_to(runs_url)
    end
  end
end
