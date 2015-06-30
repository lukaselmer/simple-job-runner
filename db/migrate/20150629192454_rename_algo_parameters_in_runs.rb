class RenameAlgoParametersInRuns < ActiveRecord::Migration
  def change
    rename_column :runs, :algo_parameters, :narrow_params
    rename_column :runs, :machine_algo_parameters, :general_params

    Run.all.each do |run|
      tmp = run.narrow_params
      run.narrow_params = { epochs: tmp[:epochs] }
      run.save!
    end
  end
end
