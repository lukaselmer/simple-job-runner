class Run < ActiveRecord::Base
  has_one :log_output

  validates :algo_parameters, presence: true

  before_save :check_and_save_new_score

  scope :pending, -> { where(started_at: nil) }
  scope :started, -> { where.not(started_at: nil).where(ended_at: nil) }
  scope :ended, -> { where.not(started_at: nil, ended_at: nil) }
  scope :best, -> { ended.where.not(score: nil) }

  def output
    log_output.try(:output)
  end

  def check_and_save_new_score
    return unless output
    score = log_output.extract_score
    self.score = score if score
  end
end
