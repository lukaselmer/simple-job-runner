class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.json :algo_parameters, null: false
      t.datetime :started_at
      t.datetime :ended_at
      t.text :output, null: false, default: ''
      t.float :score

      t.timestamps null: false
    end
  end
end
