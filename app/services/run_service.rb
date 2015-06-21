class RunService
  def start_random_pending_run
    pending_runs = Run.pending
    pending_runs.first
  end
end
