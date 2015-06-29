class RemoveAlgoParametersFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :algo_parameters
    rename_column :runs, :algo_parameters_jsonb, :algo_parameters
  end
end
