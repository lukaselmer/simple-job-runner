class AddHostNameToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :host_name, :string, default: '', null: false
  end
end
