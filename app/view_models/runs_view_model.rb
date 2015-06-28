class RunsViewModel
  attr_reader :pending, :started, :ended, :best, :pending_total, :ended_total

  def initialize(raw_created_at)
    runs = load_runs(raw_created_at)

    @pending = select_fields(find_pending(runs))
    @started = select_fields(find_started(runs))
    @ended = select_fields(find_ended(runs))
    @best = select_fields(find_best(runs))

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

  def select_fields(runs)
    runs.select(:id, :score, :algo_parameters, :started_at, :ended_at, :host_name, :created_at)
  end

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
