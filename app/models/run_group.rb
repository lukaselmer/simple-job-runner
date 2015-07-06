class RunGroup < ActiveRecord::Base
  has_many :runs

  scope :running, -> { where(running: true) }
  scope :finished, -> { where(finished: true) }
end
