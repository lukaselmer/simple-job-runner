class Run < ActiveRecord::Base
  validates :algo_parameters, presence: true

  before_save :check_and_save_new_score, :cleanup_output

  scope :pending, -> { where(started_at: nil) }
  scope :started, -> { where.not(started_at: nil).where(ended_at: nil) }
  scope :ended, -> { where.not(started_at: nil, ended_at: nil) }
  scope :best, -> { ended.where.not(score: nil) }

  def extract_score
    result = output.scan(/Score: (\d+[,.]\d+)/i).first
    result.first.to_f if result
  end

  def check_and_save_new_score
    score = extract_score
    self.score = score if score
  end

  def cleanup_output
    return unless output

    cleanup_output_with(/.*gensim.*INFO.*PROGRESS: at.*\n/)
    cleanup_output_with(/.*gensim.*INFO.*storing numpy array.*\n/)
    cleanup_output_with(/.*gensim.*INFO.*reached.*input.*outstanding jobs.*\n/)
  end

  private

  def cleanup_output_with(pattern)
    self.output = output.gsub(pattern, '')
  end
end
