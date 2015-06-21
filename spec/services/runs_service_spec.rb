require 'rails_helper'

RSpec.describe RunService, type: :service do
  let(:run_ready_to_start) do
    Run.new(algo_parameters: { a: 20, b: 63 }.to_json, score: nil, output: '')
  end

  let(:run_service) do
    RunService.new
  end

  describe 'start random pending run' do
    it 'should get no run if no runs exist' do
      expect(run_service.start_random_pending_run).to be_nil
    end

    it 'should get the first run if one run exists' do
      run_ready_to_start.save!
      expect(run_service.start_random_pending_run).to eq(run_ready_to_start)
    end
  end
end
