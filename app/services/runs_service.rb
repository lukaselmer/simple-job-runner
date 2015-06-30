class RunsService
  def start_random_pending_run(host_name)
    Run.transaction do
      # avoid concurrency problems
      run_to_start = possible_pending_runs(host_name).sample

      return unless run_to_start

      run_to_start.reload
      return nil if run_to_start.started_at

      run_to_start.host_name = host_name
      run_to_start.started_at = Time.now
      run_to_start.save!

      run_to_start
    end
  end

  def report_results(run, output)
    run.log_output ||= LogOutput.new
    run.log_output.output = output
    run.log_output.save!

    run.ended_at = Time.now
    run.save!
  end

  def schedule_runs(general_params, narrow_params)
    merged_params = general_params.merge(narrow_params)
    all = [nil].product(*merged_params.values).map(&:compact).map do |v|
      all_params = merged_params.keys.zip(v).to_h
      { general_params: select_keys(all_params, general_params), narrow_params: select_keys(all_params, narrow_params) }
    end
    Run.create!(all)
  end

  def select_keys(algo_parameters, general_params)
    algo_parameters.select { |k, _| general_params.keys.include?(k) }
  end

  def end_all
    Run.pending.update_all(started_at: Time.now, ended_at: Time.now)
    Run.started.update_all(ended_at: Time.now)
  end

  def restart(run)
    run.update!(started_at: nil, ended_at: nil)
  end

  def possible_pending_runs_by_host_name
    host_names = ['any'] + find_host_names
    run_groups = find_run_groups
    host_names.map do |host_name|
      [host_name, possible_pending_runs_with(host_name, run_groups)]
    end.to_h
  end

  private

  def find_host_names
    Run.all.select('host_name').map(&:host_name).reject(&:blank?).uniq
  end

  def possible_pending_runs(host_name)
    possible_pending_runs_with(host_name, find_run_groups)
  end

  def possible_pending_runs_with(host_name, run_groups)
    pending_runs, started_runs, ended_runs = run_groups
    pending_runs.select do |pending_run|
      started_runs.none? do |started_run|
        need_to_run_on_same_machine?(pending_run, started_run)
      end && ended_runs.none? do |ended_run|
        need_to_run_on_same_machine?(pending_run, ended_run) && host_name != ended_run.host_name
      end
    end
  end

  def find_run_groups
    [Run.pending, Run.started, Run.ended].map(&:to_a)
  end

  def need_to_run_on_same_machine?(pending_run, started_or_ended_run)
    pending_run.general_params == started_or_ended_run.general_params
  end
end
