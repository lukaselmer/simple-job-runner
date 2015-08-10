class RunsViewModel
  attr_reader :pending, :started, :ended, :best, :pending_total, :ended_total, :ended_failed

  def initialize(raw_created_at, min_created_at)
    runs = load_runs(raw_created_at, min_created_at)

    @pending = find_pending(runs)
    @started = find_started(runs)
    @ended = find_ended(runs)
    @best = find_best(runs)

    init_totals(runs)
  end

  private

  def find_best(runs)
    runs.best.limit(20).order(score: :desc)
  end

  def find_ended(runs)
    runs.ended.limit(20).order(ended_at: :desc)
  end

  def find_started(runs)
    runs.started.order(:started_at)
  end

  def find_pending(runs)
    runs.pending.limit(20)
  end

  def init_totals(runs)
    @pending_total = runs.pending.count
    @ended_total = runs.ended.count
    @ended_failed = runs.failed.count
  end

  def load_runs(raw_created_at, min_created_at)
    runs = Run.all
    runs = runs.min_created_at(min_created_at) if min_created_at
    return runs unless raw_created_at

    created_at = raw_created_at.to_datetime
    runs.where(created_at: (created_at - 15.seconds)..(created_at + 15.seconds))
  end
end
