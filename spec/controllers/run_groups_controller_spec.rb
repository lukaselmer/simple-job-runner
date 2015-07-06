require 'rails_helper'

RSpec.describe RunGroupsController, type: :controller do
  let(:valid_session) { { api_key: ENV['API_KEY'] } }

  describe 'GET #index' do
    it 'assigns all run_groups as @run_groups' do
      run_group = create(:run_group)
      get :index, {}, valid_session
      expect(assigns(:run_groups)).to eq([run_group])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested run_group as @run_group' do
      run_group = create(:run_group)
      get :show, { id: run_group.to_param }, valid_session
      expect(assigns(:run_group)).to eq(run_group)
    end
  end
end
