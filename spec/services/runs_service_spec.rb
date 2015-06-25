require 'rails_helper'

def find_run_by_params(runs, param1, param2, param3)
  runs.find do |run|
    algo_parameters = run.algo_parameters
    algo_parameters['param1'] == param1 &&
      algo_parameters['param2'] == param2 &&
      algo_parameters['param3'] == param3
  end
end

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

  describe 'report results of started run' do
    it 'should finish a started run' do
      create(:started_run)
      started_run_2 = create(:started_run, algo_parameters: { xxx: 123 })
      expect(started_run_2.ended_at).to be_nil
      run_service.report_results started_run_2, "Bla\nScore: 85.32%\nXxxx"
      started_run_2.reload
      expect(started_run_2.output).to eq("Bla\nScore: 85.32%\nXxxx")
      expect(started_run_2.ended_at).not_to be_nil
      expect(started_run_2.score).to be_within(0.0001).of(85.32)
    end
  end

  describe 'schedule new runs' do
    it 'should schedule new runs (3*3*2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs(param1: [5, 7, 9], param2: [1, 5], param3: [10, 20, 30])
      expect(Run.count).to eq(3 * 3 * 2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 7, 1, 30)).not_to be_nil
      expect(find_run_by_params(runs, 7, 5, 30)).not_to be_nil
      expect(find_run_by_params(runs, 5, 5, 30)).not_to be_nil
      expect(find_run_by_params(runs, 9, 5, 10)).not_to be_nil
    end

    it 'should schedule new runs (1*1*1)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs(param1: [5], param2: [1], param3: [15])
      expect(Run.count).to eq(1)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, 15)).not_to be_nil
    end

    it 'should schedule new runs (1*2*1)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs(param1: [5], param2: [1, 2], param3: [15])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, 15)).not_to be_nil
      expect(find_run_by_params(runs, 5, 2, 15)).not_to be_nil
    end

    it 'should schedule new runs (1*2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs(param1: [5], param2: [1, 2])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, nil)).not_to be_nil
      expect(find_run_by_params(runs, 5, 2, nil)).not_to be_nil
    end

    it 'should schedule new runs (2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs(param1: [7, 10])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 7, nil, nil)).not_to be_nil
      expect(find_run_by_params(runs, 10, nil, nil)).not_to be_nil
    end
  end

  describe 'end all the runs' do
    it 'should end all the pending runs' do
      create(:pending_run)
      expect(Run.pending.count).to eq(1)

      run_service.end_all

      expect(Run.pending.count).to eq(0)
    end

    it 'should end all the started runs' do
      started_at = 2.days.ago
      started_run = create(:started_run, started_at: started_at)
      expect(Run.started.count).to eq(1)

      run_service.end_all

      expect(Run.started.count).to eq(0)
      started_run.reload
      expect(started_run.started_at.to_i).to eq(started_at.to_i)
    end

    it 'should not change the ended runs' do
      started_at = 5.days.ago
      ended_at = 3.days.ago
      ended_run = create(:ended_run, started_at: started_at, ended_at: ended_at)

      run_service.end_all

      ended_run.reload
      expect(ended_run.started_at.to_i).to eq(started_at.to_i)
      expect(ended_run.ended_at.to_i).to eq(ended_at.to_i)
    end
  end

  describe '#restart a run' do
    it 'should restart a started run' do
      run = create(:started_run)
      run_service.restart(run)
      run.reload
      expect(run.started_at).to be_nil
    end

    it 'should restart a ended run' do
      run = create(:ended_run)
      run_service.restart(run)
      run.reload
      expect(run.started_at).to be_nil
      expect(run.ended_at).to be_nil
    end
  end
end
