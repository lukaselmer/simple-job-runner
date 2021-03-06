class Run < ActiveRecord::Base
  has_one :log_output
  belongs_to :run_group

  validates :narrow_params, :general_params, presence: true

  before_save :check_and_save_new_score

  include RunScopes

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
