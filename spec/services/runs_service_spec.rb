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

  let(:host_name_1) do
    'myhost1.com'
  end

  let(:host_name_2) do
    'myhost2.com'
  end

  let(:algo_parameters_with_10_epochs) do
    { epochs: 10, x: 10, y: 20 }
  end

  let(:algo_parameters_with_20_epochs) do
    { epochs: 20, x: 10, y: 20 }
  end

  let(:different_algo_parameters) do
    { epochs: 20, a: 33, b: 44 }
  end

  describe '#start_random_pending_run' do
    it 'should get no run if no runs exist' do
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
    end

    it 'should get the first run if one pending run exists' do
      pending_run = create(:pending_run)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run)
    end

    it 'should get a random pending run' do
      # there must be a better way for this...?
      create(:pending_run, algo_parameters: { epochs: 5, a: 10 })
      create(:pending_run, algo_parameters: { epochs: 5, a: 20 })
      pending_run_3 = create(:pending_run, algo_parameters: { epochs: 5, a: 30 })
      pending_run_4 = create(:pending_run, algo_parameters: { epochs: 5, a: 40 })
      create(:pending_run, algo_parameters: { epochs: 5, a: 50 })
      pending_run_6 = create(:pending_run, algo_parameters: { epochs: 5, a: 60 })
      Kernel.srand(42)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_4)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_6)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_3)
    end

    it 'should set the run to started' do
      create(:pending_run, algo_parameters: { epochs: 5, a: 10 })
      create(:pending_run, algo_parameters: { epochs: 5, a: 20 })
      started_run_1 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_1.started_at).not_to be_nil
      started_run_2 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_2.started_at).not_to be_nil
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
    end

    it 'should set the host name when a run is started' do
      run = create(:pending_run, algo_parameters: algo_parameters_with_20_epochs)
      started_run = run_service.start_random_pending_run(host_name_2)
      expect(started_run.host_name).to eq(host_name_2)
      run.reload
      expect(run.host_name).to eq(host_name_2)
      expect(started_run.host_name).to eq(host_name_2)
    end

    it 'should get no run if no pending run exists' do
      create(:started_run)
      create(:ended_run)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(nil)
    end
  end

  describe '#possible_pending_runs_by_host_name' do
    it 'should get a hash with any if no runs exist' do
      allow(run_service).to receive(:find_run_groups).and_return(:xxx)
      expect(run_service).to receive(:possible_pending_runs_with).with('any', :xxx).and_return([:a, :b])
      result = run_service.possible_pending_runs_by_host_name
      expect(result).to eq('any' => [:a, :b])
    end

    it 'should get a hash with every host and the possible runs' do
      create(:pending_run, algo_parameters: { a: 30 })
      create(:started_run, algo_parameters: { a: 10 }, host_name: 'x')
      create(:started_run, algo_parameters: { a: 12 }, host_name: 'x')
      create(:started_run, algo_parameters: { a: 20 }, host_name: 'z')
      allow(run_service).to receive(:find_run_groups).and_return(:xxx)
      expect(run_service).to receive(:possible_pending_runs_with).with(/any|x|z/, :xxx).and_return([:a], [:b], [:c])
      result = run_service.possible_pending_runs_by_host_name
      expect(result).to eq('any' => [:a], 'x' => [:b], 'z' => [:c])
    end
  end

  describe '#possible_pending_runs' do
    it 'should get an empty array if no runs exist' do
      expect(run_service.send(:possible_pending_runs, host_name_1)).to be_empty
    end

    it 'should get an array with one run if one pending run exists' do
      pending_run = create(:pending_run)
      expect(run_service.send(:possible_pending_runs, host_name_1)).to eq([pending_run])
    end

    it 'should not get the run with different epochs and same parameters to a different host' do
      create(:ended_run, algo_parameters: algo_parameters_with_10_epochs, host_name: host_name_1)
      create(:pending_run, algo_parameters: algo_parameters_with_20_epochs)
      expect(run_service.send(:possible_pending_runs, host_name_2)).to be_empty
    end

    it 'should get the run with different epochs and same parameters to the same host' do
      create(:ended_run, algo_parameters: algo_parameters_with_10_epochs, host_name: host_name_1)
      run = create(:pending_run, algo_parameters: algo_parameters_with_20_epochs)
      expect(run_service.send(:possible_pending_runs, host_name_1)).to eq([run])
    end

    it 'should not get the run with different epochs and same parameters while one is running' do
      create(:pending_run, algo_parameters: algo_parameters_with_10_epochs)
      create(:started_run, algo_parameters: algo_parameters_with_20_epochs)
      expect(run_service.send(:possible_pending_runs, host_name_1)).to be_empty
    end

    it 'should get an empty array no pending run exists' do
      create(:started_run)
      create(:ended_run)
      expect(run_service.send(:possible_pending_runs, host_name_1)).to eq([])
    end
  end

  describe '#report_results' do
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

    describe 'machine algo parameters' do
      it 'should set the machine algo parameters' do
        run_service.schedule_runs(param1: [10], param2: [55])
        expect(Run.first.algo_parameters).to eq('param1' => 10, 'param2' => 55)
        expect(Run.first.machine_algo_parameters).to eq('param1' => 10, 'param2' => 55)
      end

      it 'should remove the machine dependent parameters' do
        run_service.schedule_runs(param1: [10], param2: [55], epochs: [30])
        expect(Run.first.algo_parameters).to eq('param1' => 10, 'param2' => 55, 'epochs' => 30)
        expect(Run.first.machine_algo_parameters).to eq('param1' => 10, 'param2' => 55)
        # x.match(/^\d+\.\d*$/)
      end
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
