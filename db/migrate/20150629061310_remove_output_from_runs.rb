class RemoveOutputFromRuns < ActiveRecord::Migration
  def change
    Run.skip_callback(:save, :before, :before_action)
    Run.skip_callback(:save, :after, :after_action)
    Run.all.each do |run|
      output = run[:output]
      next unless output
      LogOutput.create!(output: output, run_id: run.id)
    end
    remove_column :runs, :output, :text
  end
end
