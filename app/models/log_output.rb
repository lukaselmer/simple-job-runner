class LogOutput < ActiveRecord::Base
  belongs_to :run

  def extract_score
    result = output.scan(/Score: (\d+[,.]\d+)/i).first
    result.first.to_f if result
  end
end
