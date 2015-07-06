class Run < ActiveRecord::Base
  has_one :log_output

  belongs_to :run_group

  validates :narrow_params, :general_params, presence: true

  before_save :check_and_save_new_score

  default_scope { where(created_at: Date.parse('2015-06-29')..Time.now) } unless Rails.env.test?

  scope :pending, -> { where(started_at: nil) }
  scope :started, -> { where.not(started_at: nil).where(ended_at: nil) }
  scope :ended, -> { where.not(started_at: nil, ended_at: nil) }
  scope :best, -> { ended.where.not(score: nil) }
  scope :min_created_at, ->(min_created_at) { where(created_at: min_created_at..Time.now) }

  def output
    log_output.try(:output)
  end

  def check_and_save_new_score
    return unless output
    score = log_output.extract_score
    self.score = score if score
  end

  def algo_params
    general_params.merge(narrow_params)
  end
end
