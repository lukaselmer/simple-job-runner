require 'rails_helper'

RSpec.describe RunService, type: :service do
  let(:run_service) do
    RunService.new
  end

  describe 'start random pending run' do
    it 'should get no run if no runs exist' do
      expect(run_service.start_random_pending_run).to be_nil
    end

    it 'should get the first run if one run exists' do
      pending_run = create(:pending_run)
      expect(run_service.start_random_pending_run).to eq(pending_run)
    end
  end
end
