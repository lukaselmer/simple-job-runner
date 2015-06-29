class Run < ActiveRecord::Base
  has_one :log_output

  validates :algo_parameters, presence: true

  before_save :check_and_save_new_score, :cleanup_output

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

  def cleanup_output
    return unless output

    cleanup_output_with(/.*gensim.*INFO.*PROGRESS: at.*\n/)
    cleanup_output_with(/.*gensim.*INFO.*storing numpy array.*\n/)
    cleanup_output_with(/.*gensim.*INFO.*reached.*input.*outstanding jobs.*\n/)
    log_output.save!
  end

  private

  def cleanup_output_with(pattern)
    log_output.output = output.gsub(pattern, '')
  end
end
