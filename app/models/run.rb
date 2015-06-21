class Run < ActiveRecord::Base
  validates :algo_parameters, presence: true

  before_save :check_and_save_new_score

  def extract_score
    result = output.scan(/Score: (\d+[,.]\d+)/i).first
    result.first.to_f if result
  end

  def check_and_save_new_score
    score = extract_score
    self.score = score if score
  end
end
