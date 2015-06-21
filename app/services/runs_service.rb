class RunsService
  def start_random_pending_run
    run_to_start = Run.pending.to_a.sample

    return unless run_to_start

    run_to_start.with_lock do
      run_to_start.started_at = Time.now
      run_to_start.save!
    end

    run_to_start
  end
end
