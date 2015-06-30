class AddMachineAlgoParametersToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :machine_algo_parameters, :jsonb

    Run.all.each do |run|
      params = run.algo_parameters
      next unless params

      machine_algo_parameters = params.dup
      machine_algo_parameters.delete(:epochs)
      run.machine_algo_parameters = machine_algo_parameters
      run.save!
    end
  end
end
