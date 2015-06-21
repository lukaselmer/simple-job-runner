require 'rails_helper'

RSpec.describe RunsService, type: :service do
  let(:run_service) do
    RunsService.new
  end

  describe 'start random pending run' do
    it 'should get no run if no runs exist' do
      expect(run_service.start_random_pending_run).to be_nil
    end

    it 'should get the first run if one pending run exists' do
      pending_run = create(:pending_run)
      expect(run_service.start_random_pending_run).to eq(pending_run)
    end

    it 'should get no run if no pending run exists' do
      create(:started_run)
      create(:ended_run)
      expect(run_service.start_random_pending_run).to eq(nil)
    end

    it 'should get a random pending run' do
      # there must be a better way for this...?
      create(:pending_run)
      create(:pending_run)
      pending_run_3 = create(:pending_run)
      pending_run_4 = create(:pending_run)
      create(:pending_run)
      pending_run_6 = create(:pending_run)
      Kernel.srand(42)
      expect(run_service.start_random_pending_run).to eq(pending_run_4)
      expect(run_service.start_random_pending_run).to eq(pending_run_6)
      expect(run_service.start_random_pending_run).to eq(pending_run_3)
    end

    it 'should set the run to started' do
      create(:pending_run)
      create(:pending_run)
      started_run_1 = run_service.start_random_pending_run
      expect(started_run_1.started_at).not_to be_nil
      started_run_2 = run_service.start_random_pending_run
      expect(started_run_2.started_at).not_to be_nil
      expect(run_service.start_random_pending_run).to be_nil
      expect(run_service.start_random_pending_run).to be_nil
    end
  end
end
