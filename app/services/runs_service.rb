class RunsService
  def start_random_pending_run(host_name)
    run_to_start = possible_pending_runs(host_name).sample

    return unless run_to_start

    run_to_start.with_lock do
      # avoid concurrency problems
      run_to_start.reload
      return nil if run_to_start.started_at

      run_to_start.started_at = Time.now
      run_to_start.save!
    end

    run_to_start
  end

  def report_results(run, output)
    run.output = output
    run.ended_at = Time.now
    run.save!
  end

  def schedule_runs(parameters)
    all = [nil].product(*parameters.values).map(&:compact).map { |v| { algo_parameters: parameters.keys.zip(v).to_h } }
    Run.create!(all)
  end

  def end_all
    Run.pending.update_all(started_at: Time.now, ended_at: Time.now)
    Run.started.update_all(ended_at: Time.now)
  end

  def restart(run)
    run.update!(started_at: nil, ended_at: nil)
  end

  private

  def possible_pending_runs(host_name)
    pending_runs = Run.pending.to_a
    started_runs = Run.started.to_a
    ended_runs = Run.ended.to_a
    pending_runs.select do |pending_run|
      started_runs.none? do |started_run|
        similar_algo_parameters?(pending_run, started_run)
      end && ended_runs.none? do |ended_run|
        similar_algo_parameters?(pending_run, ended_run) && host_name != ended_run.host_name
      end
    end
  end

  def similar_algo_parameters?(pending_run, started_run)
    pending_algo_parameters = pending_run.algo_parameters
    started_algo_parameters = started_run.algo_parameters.dup
    started_algo_parameters['epochs'] = pending_algo_parameters['epochs']
    started_algo_parameters == pending_algo_parameters
  end
end
