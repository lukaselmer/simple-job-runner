class MigrateRunDataToRunGroups < ActiveRecord::Migration
  def change
    add_reference :runs, :run_group
    run_groups = {}

    Run.all.to_a.each do |run|
      general_params = run.general_params.sort_by { |k, _| k.to_s }.to_h

      unless run_groups.key? general_params
        attributes = { general_params: general_params, host_name: run.host_name, finished: true }
        run_groups[general_params] = RunGroup.create! attributes
      end

      run.general_params = general_params
      run.run_group = run_groups[general_params]
      run.save!
    end
  end
end
