require 'rails_helper'

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
