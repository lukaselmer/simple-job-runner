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

  let(:invalid_attributes) do
    { algo_parameters: nil, score: 10, output: "Blablabla\nScore: 10%\nBlabla" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RunsController. Be sure to keep this updated too.
  let(:valid_session) { { api_key: ENV['API_KEY'] } }

  describe 'GET #index' do
    it 'assigns all runs as @runs' do
      run = create(:ended_run)
      get :index, {}, valid_session
      expect(assigns(:runs)).to eq([run])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested run as @run' do
      run = create(:ended_run)
      get :show, { id: run.to_param }, valid_session
      expect(assigns(:run)).to eq(run)
    end
  end

  describe 'GET #new' do
    it 'assigns a new run as @run' do
      get :new, {}, valid_session
      expect(assigns(:run)).to be_a_new(Run)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested run as @run' do
      run = create(:ended_run)
      get :edit, { id: run.to_param }, valid_session
      expect(assigns(:run)).to eq(run)
    end
  end

  describe 'GET #start_random_pending_run' do
    render_views

    it 'assigns a @run which it gets from the service' do
      run_mock = build_stubbed(:pending_run)
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:start_random_pending_run).with(no_args).and_return(run_mock)
      get :start_random_pending_run, valid_session
      expect(assigns(:run)).to eq(run_mock)
      id = run_mock.id.to_s
      json = run_mock.algo_parameters.to_json
      expect(response.body).to eq('{"result":"start","id":' + id + ',"algo_parameters":' + json + '}')
    end

    it 'renders nothing when there are no pending runs' do
      runs_service_mock = mock_controller_with_run_service(controller)
      expect(runs_service_mock).to receive(:start_random_pending_run).with(no_args).and_return(nil)
      get :start_random_pending_run, valid_session
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
      algo_parameters = { param1: [10, 15], param2: [5] }
      expect(runs_service_mock).to receive(:schedule_runs).with(algo_parameters)
      get :schedule_runs, { algo_parameters: algo_parameters }, valid_session
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
      get :report_results, { id: run.to_param, run: {output: output} }, valid_session
      expect(assigns(:run)).to eq(run)
      expect(response.body).to eq('')
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Run' do
        expect do
          post :create, { run: valid_attributes }, valid_session
        end.to change(Run, :count).by(1)
      end

      it 'assigns a newly created run as @run' do
        post :create, { run: valid_attributes }, valid_session
        expect(assigns(:run)).to be_a(Run)
        expect(assigns(:run)).to be_persisted
      end

      it 'redirects to the created run' do
        post :create, { run: valid_attributes }, valid_session
        expect(response).to redirect_to(Run.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved run as @run' do
        post :create, { run: invalid_attributes }, valid_session
        expect(assigns(:run)).to be_a_new(Run)
      end

      it "re-renders the 'new' template" do
        post :create, { run: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { algo_parameters: { a: 50, b: 22 }.to_json, output: "Blablabla\nScore: 33.5%\nBlabla" }
      end

      it 'updates the requested run' do
        run = create(:ended_run)
        put :update, { id: run.to_param, run: new_attributes }, valid_session
        run.reload
        expect(run.algo_parameters).to eq('a' => 50, 'b' => 22)
        expect(run.score).to eq(33.5)
        expect(run.output).to eq("Blablabla\nScore: 33.5%\nBlabla")
      end

      it 'assigns the requested run as @run' do
        run = create(:ended_run)
        put :update, { id: run.to_param, run: valid_attributes }, valid_session
        expect(assigns(:run)).to eq(run)
      end

      it 'redirects to the run' do
        run = create(:ended_run)
        put :update, { id: run.to_param, run: valid_attributes }, valid_session
        expect(response).to redirect_to(run)
      end
    end

    context 'with invalid params' do
      it 'assigns the run as @run' do
        run = create(:ended_run)
        put :update, { id: run.to_param, run: invalid_attributes }, valid_session
        expect(assigns(:run)).to eq(run)
      end

      it "re-renders the 'edit' template" do
        run = create(:ended_run)
        put :update, { id: run.to_param, run: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested run' do
      run = create(:ended_run)
      expect do
        delete :destroy, { id: run.to_param }, valid_session
      end.to change(Run, :count).by(-1)
    end

    it 'redirects to the runs list' do
      run = create(:ended_run)
      delete :destroy, { id: run.to_param }, valid_session
      expect(response).to redirect_to(runs_url)
    end
  end
end
