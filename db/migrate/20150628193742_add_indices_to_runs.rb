class AddIndicesToRuns < ActiveRecord::Migration
  def change
    add_index :runs, :started_at
    add_index :runs, :ended_at
    add_index :runs, :host_name
    add_index :runs, :created_at
  end
end
