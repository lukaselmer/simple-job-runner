class CreateRunGroups < ActiveRecord::Migration
  def change
    create_table :run_groups do |t|
      t.jsonb :general_params
      t.string :host_name, default: '', null: false
      t.boolean :running, default: false
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
