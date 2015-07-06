require 'rails_helper'

def find_run_by_params(runs, param1, param2, param3)
  runs.find do |run|
    algo_params = run.narrow_params.merge(run.general_params)
    algo_params['param1'] == param1 &&
      algo_params['param2'] == param2 &&
      algo_params['param3'] == param3
  end
end

def find_run_group_by_params(run_groups, param1, param2, param3)
  run_groups.find do |run|
    run.general_params['param1'] == param1 &&
      run.general_params['param2'] == param2 &&
      run.general_params['param3'] == param3
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

  let(:narrow_params_with_10_epochs) do
    { epochs: 10, x: 10, y: 20 }
  end

  let(:narrow_params_with_20_epochs) do
    { epochs: 20, x: 10, y: 20 }
  end

  let(:different_narrow_params) do
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
      create(:pending_run, narrow_params: { epochs: 5, a: 10 }, general_params: { b: 10 })
      create(:pending_run, narrow_params: { epochs: 5, a: 20 }, general_params: { b: 20 })
      pending_run_3 = create(:pending_run, narrow_params: { epochs: 5, a: 30 }, general_params: { b: 30 })
      pending_run_4 = create(:pending_run, narrow_params: { epochs: 5, a: 40 }, general_params: { b: 40 })
      create(:pending_run, narrow_params: { epochs: 5, a: 50 }, general_params: { b: 50 })
      pending_run_6 = create(:pending_run, narrow_params: { epochs: 5, a: 60 }, general_params: { b: 60 })
      Kernel.srand(42)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_4)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_6)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(pending_run_3)
    end

    it 'should set the run to started' do
      create(:pending_run, run_group: create(:run_group, general_params: { b: 10 }),
                           narrow_params: { epochs: 5, a: 10 }, general_params: { b: 10 })
      create(:pending_run, run_group: create(:run_group, general_params: { b: 20 }),
                           narrow_params: { epochs: 5, a: 20 }, general_params: { b: 20 })
      started_run_1 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_1.started_at).not_to be_nil
      started_run_2 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_2.started_at).not_to be_nil
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
    end

    it 'should set the run group to running' do
      create(:pending_run, run_group: create(:run_group, general_params: { b: 10 }),
                           narrow_params: { epochs: 5, a: 10 }, general_params: { b: 10 })
      create(:pending_run, run_group: create(:run_group, general_params: { b: 20 }),
                           narrow_params: { epochs: 5, a: 20 }, general_params: { b: 20 })
      started_run_1 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_1.run_group.running).to eq(true)
      started_run_2 = run_service.start_random_pending_run(host_name_1)
      expect(started_run_2.run_group.running).to eq(true)
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
    end

    it 'should not start a running run group' do
      create(:pending_run, run_group: create(:run_group, general_params: { b: 10 }, running: true),
                           narrow_params: { epochs: 5, a: 10 }, general_params: { b: 10 })
      expect(run_service.start_random_pending_run(host_name_1)).to be_nil
    end

    it 'should set the host name when a run is started' do
      run = create(:pending_run)
      started_run = run_service.start_random_pending_run(host_name_2)
      expect(started_run.host_name).to eq(host_name_2)
      expect(started_run.run_group.host_name).to eq(host_name_2)
      run.reload
      expect(run.host_name).to eq(host_name_2)
      expect(run.run_group.host_name).to eq(host_name_2)
    end

    it 'should get no run if no pending run exists' do
      create(:started_run)
      create(:ended_run)
      expect(run_service.start_random_pending_run(host_name_1)).to eq(nil)
    end
  end

  describe '#possible_pending_runs_by_host_name' do
    it 'should get an array with one run if one pending run exists' do
      pending_run = create(:pending_run)
      expect(run_service.possible_pending_runs_by_host_name).to eq('any' => [pending_run])
    end

    it 'should get an array with one run if one pending run exists' do
      run_group1 = create(:run_group, general_params: { a: 10 }, host_name: '')
      pending_run1 = create(:pending_run, general_params: { a: 10 }, run_group: run_group1)
      run_group2 = create(:run_group, general_params: { b: 10 }, host_name: '')
      pending_run2 = create(:pending_run, general_params: { b: 10 }, run_group: run_group2)
      expect(run_service.possible_pending_runs_by_host_name).to eq('any' => [pending_run1, pending_run2])
    end

    it 'should not get the run with different epochs and same parameters to a different host' do
      create(:ended_run, narrow_params: { epochs: 10 }, general_params: { a: 10 }, host_name: host_name_1)
      create(:pending_run, narrow_params: { epochs: 20 }, general_params: { a: 10 })
      expect(run_service.possible_pending_runs_by_host_name[host_name_2]).to be_nil
    end

    it 'should get the run with different epochs and same parameters to the same host' do
      run_group = create(:run_group, general_params: { a: 10 }, host_name: host_name_1)
      create(:ended_run, narrow_params: { epochs: 10 }, general_params: { a: 10 }, host_name: host_name_1,
                         run_group: run_group)
      run = create(:pending_run, narrow_params: { epochs: 20 }, general_params: { a: 10 }, run_group: run_group)
      expect(run_service.possible_pending_runs_by_host_name[host_name_1]).to eq([run])
    end

    it 'should not get the run with different epochs and same parameters while one is running' do
      run_group = create(:run_group, general_params: { a: 10 }, host_name: host_name_1, running: true)
      create(:pending_run, narrow_params: { epochs: 10 }, general_params: { a: 10 }, run_group: run_group)
      create(:started_run, narrow_params: { epochs: 20 }, general_params: { a: 10 }, run_group: run_group)
      expect(run_service.possible_pending_runs_by_host_name[host_name_1]).to be_nil
    end

    it 'should get an empty array no pending run exists' do
      create(:started_run)
      create(:ended_run)
      expect(run_service.possible_pending_runs_by_host_name[host_name_1]).to eq([])
    end
  end

  describe '#report_results' do
    it 'should finish a started run' do
      create(:started_run)
      started_run_2 = create(:started_run)
      expect(started_run_2.ended_at).to be_nil
      expect(started_run_2.run_group.running).to eq(true)

      run_service.report_results started_run_2, "Bla\nScore: 85.32%\nXxxx"

      started_run_2.reload
      expect(started_run_2.run_group.running).to eq(false)
      expect(started_run_2.output).to eq("Bla\nScore: 85.32%\nXxxx")
      expect(started_run_2.ended_at).not_to be_nil
      expect(started_run_2.score).to be_within(0.0001).of(85.32)
    end
  end

  describe 'schedule new runs' do
    it 'should abort if there are more than 800 runs to be scheduled' do
      a = %w(0 1 2 3 4 5 6 7 8 9)
      z = %w(0 1 2 3 4 5 6 7)
      expect { run_service.schedule_runs({ a: a, b: a }, z: z) }.to raise_error(RangeError)

      expect(Run.count).to eq(0)
    end

    it 'should create new run groups (3) when scheduling new runs' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5, 7, 9] }, param2: [1, 5], param3: [10, 20, 30])
      expect(RunGroup.count).to eq(3)

      run_groups = RunGroup.all.to_a
      expect(find_run_group_by_params(run_groups, 5, nil, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 7, nil, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 9, nil, nil)).not_to be_nil
      expect(run_groups.first.runs.count).to eq(2 * 3)
    end

    it 'should create new run groups (3*2) when scheduling new runs' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5, 7, 9], param2: [1, 5] }, param3: [10, 20, 30])
      expect(RunGroup.count).to eq(3 * 2)

      run_groups = RunGroup.all.to_a
      expect(find_run_group_by_params(run_groups, 5, 1, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 5, 5, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 7, 1, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 7, 5, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 9, 1, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 9, 5, nil)).not_to be_nil
      expect(run_groups.first.runs.count).to eq(3)
    end

    it 'should not create duplicated run groups when scheduling new runs' do
      expect(Run.count).to eq(0)
      RunGroup.create!(general_params: { param1: 5 })
      run_service.schedule_runs({ param1: [5, 7, 9] }, param2: [1, 5], param3: [10, 20, 30])
      expect(RunGroup.count).to eq(3)

      run_groups = RunGroup.all.to_a
      expect(find_run_group_by_params(run_groups, 5, nil, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 7, nil, nil)).not_to be_nil
      expect(find_run_group_by_params(run_groups, 9, nil, nil)).not_to be_nil
    end

    it 'should schedule new runs (3*3*2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5, 7, 9] }, param2: [1, 5], param3: [10, 20, 30])
      expect(Run.count).to eq(3 * 3 * 2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 7, 1, 30)).not_to be_nil
      expect(find_run_by_params(runs, 7, 5, 30)).not_to be_nil
      expect(find_run_by_params(runs, 5, 5, 30)).not_to be_nil
      expect(find_run_by_params(runs, 9, 5, 10)).not_to be_nil
    end

    it 'should schedule new runs (1*1*1)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5], param2: [1] }, param3: [15])
      expect(Run.count).to eq(1)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, 15)).not_to be_nil
    end

    it 'should schedule new runs (1*2*1)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5], param2: [1, 2] }, param3: [15])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, 15)).not_to be_nil
      expect(find_run_by_params(runs, 5, 2, 15)).not_to be_nil
    end

    it 'should schedule new runs (1*2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [5] }, param2: [1, 2])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 5, 1, nil)).not_to be_nil
      expect(find_run_by_params(runs, 5, 2, nil)).not_to be_nil
    end

    it 'should schedule new runs (2)' do
      expect(Run.count).to eq(0)
      run_service.schedule_runs({ param1: [7, 10] }, epochs: [10])
      expect(Run.count).to eq(2)

      runs = Run.all.to_a
      expect(find_run_by_params(runs, 7, nil, nil)).not_to be_nil
      expect(find_run_by_params(runs, 10, nil, nil)).not_to be_nil
    end

    describe 'machine algo parameters' do
      it 'should set the machine algo parameters' do
        run_service.schedule_runs({ param1: [10] }, param2: [55])
        expect(Run.first.algo_params).to eq('param1' => 10, 'param2' => 55)
        expect(Run.first.general_params).to eq('param1' => 10)
        expect(Run.first.narrow_params).to eq('param2' => 55)
      end

      it 'should remove the machine dependent parameters' do
        run_service.schedule_runs({ param1: [10] }, param2: [55], epochs: [30])
        expect(Run.first.algo_params).to eq('param1' => 10, 'param2' => 55, 'epochs' => 30)
        expect(Run.first.general_params).to eq('param1' => 10)
        expect(Run.first.narrow_params).to eq('param2' => 55, 'epochs' => 30)
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
      expect(RunGroup.running.count).to eq(1)

      run_service.end_all

      expect(Run.started.count).to eq(0)
      expect(RunGroup.running.count).to eq(0)
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

    it 'should restart an ended run' do
      run = create(:ended_run)
      run_service.restart(run)
      run.reload
      expect(run.started_at).to be_nil
      expect(run.ended_at).to be_nil
    end
  end
end
