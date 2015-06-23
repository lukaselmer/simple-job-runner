class RunsService
  def start_random_pending_run
    run_to_start = Run.pending.to_a.sample

    return unless run_to_start

    run_to_start.with_lock do
      # avoid concurrency problems
      run_to_start.reload
      return start_random_pending_run if run_to_start.started_at

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
end
