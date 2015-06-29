class LogOutput < ActiveRecord::Base
  belongs_to :run

  before_save :cleanup_output

  def extract_score
    result = output.scan(/Score: (\d+[,.]\d+)/i).first
    result.first.to_f if result
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
