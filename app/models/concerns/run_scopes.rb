module RunScopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> { where(started_at: nil) }
    scope :started, -> { where.not(started_at: nil).where(ended_at: nil) }
    scope :ended, -> { where.not(started_at: nil, ended_at: nil) }
    scope :failed, -> { ended.where(score: nil) }
    scope :best, -> { ended.where.not(score: nil) }
    scope :min_created_at, ->(min_created_at) { where(created_at: min_created_at..Time.now) }
  end
end
