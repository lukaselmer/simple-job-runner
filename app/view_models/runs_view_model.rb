class RunsViewModel
  attr_reader :pending, :started, :ended, :best, :pending_total, :ended_total

  def initialize(raw_created_at)
    runs = load_runs(raw_created_at)

    @pending = runs.pending.limit(20)
    @started = runs.started.order(:started_at)
    @ended = runs.ended.limit(20).order(ended_at: :desc)
    @best = runs.ended.limit(20).order(score: :desc)

    init_totals(runs)
  end

  private

  def init_totals(runs)
    @pending_total = runs.pending.count
    @ended_total = runs.ended.count
  end

  def load_runs(raw_created_at)
    runs = Run.all
    return runs unless raw_created_at

    created_at = raw_created_at.to_datetime
    runs.where(created_at: (created_at - 15.seconds)..(created_at + 15.seconds))
  end
end
