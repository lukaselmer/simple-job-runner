class RunsService
  def start_random_pending_run(host_name)
    assigned_ready_run_group = RunGroup.where(running: false, finished: false, host_name: host_name)
    return start_run_group(assigned_ready_run_group.sample, host_name) if assigned_ready_run_group.any?

    unassigned_ready_run_group = RunGroup.where(running: false, finished: false, host_name: '')
    return start_run_group(unassigned_ready_run_group.sample, host_name) if unassigned_ready_run_group.any?

    nil
  end

  def report_results(run, output)
    run.log_output ||= LogOutput.new
    run.log_output.output = output
    run.log_output.save!

    run.run_group.running = false
    run.run_group.save!

    run.ended_at = Time.now
    run.save!
  end

  def schedule_runs(general_params, narrow_params)
    all_runs = build_run_combinations(general_params, narrow_params)

    fail RangeError, 'too many runs' if all_runs.length >= 800

    run_groups = create_run_groups(all_runs)
    create_runs(all_runs, run_groups)
  end

  def end_all
    Run.pending.update_all(started_at: Time.now, ended_at: Time.now)
    Run.started.update_all(ended_at: Time.now)
    RunGroup.running.update_all(running: false)
  end

  def restart(run)
    run.update!(started_at: nil, ended_at: nil)
  end

  def possible_pending_runs_by_host_name
    pending_runs_by_host_name = {}

    RunGroup.where(running: false, finished: false).includes(:runs).each do |run_group|
      host_name = run_group.host_name.blank? ? 'any' : run_group.host_name

      pending_runs_by_host_name[host_name] ||= []
      pending_runs_by_host_name[host_name] += run_group.runs.to_a.select { |run| !run.started_at }
    end

    pending_runs_by_host_name
  end

  private

  def create_runs(all_runs, run_groups)
    runs_attributes = all_runs.map do |run|
      run[:run_group_id] = run_groups[run[:general_params].to_json].id
      run
    end

    Run.create! runs_attributes
  end

  def start_run_group(run_group, host_name)
    run_group.transaction do
      run_group.running = true
      run_group.host_name = host_name
      run_group.save!

      run_to_start = run_group.runs.pending.to_a.sample
      return nil unless run_to_start

      start_run(host_name, run_to_start)
    end
  end

  def start_run(host_name, run_to_start)
    run_to_start.transaction do
      run_to_start.reload
      return nil if run_to_start.started_at

      run_to_start.host_name = host_name
      run_to_start.started_at = Time.now
      run_to_start.save!
      run_to_start
    end
  end

  def build_run_combinations(general_params, narrow_params)
    merged_params = general_params.merge(narrow_params)
    [nil].product(*merged_params.values).map(&:compact).map do |v|
      all_params = merged_params.keys.zip(v).to_h
      { general_params: select_keys(all_params, general_params), narrow_params: select_keys(all_params, narrow_params) }
    end
  end

  def create_run_groups(all_runs)
    run_groups = all_runs.map { |run_attr| run_attr[:general_params].to_json }.uniq

    # This will result in n queries. Is there a better way to do this?
    run_groups.map { |params| [params, RunGroup.find_or_create_by(general_params: params)] }.to_h
  end

  def select_keys(algo_params, general_params)
    unsorted = algo_params.select { |k, _| general_params.keys.include?(k) }
    unsorted.sort_by { |k, _| k.to_s }.to_h
  end
end
