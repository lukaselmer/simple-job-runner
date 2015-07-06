class MigrateRunDataToRunGroups < ActiveRecord::Migration
  def change
    add_reference :runs, :run_group
    run_groups = {}

    Run.all.to_a.each do |run|
      unless run_groups.key? run.general_params
        attributes = { general_params: run.general_params, host_name: run.host_name, finished: true }
        run_groups[run.general_params] = RunGroup.create! attributes
      end
      
      run.run_group = run_groups[run.general_params]
      run.save!
    end
  end
end
