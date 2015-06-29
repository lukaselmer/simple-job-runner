class CreateLogOutputs < ActiveRecord::Migration
  def change
    create_table :log_outputs do |t|
      t.belongs_to :run
      t.text :output
      t.timestamps null: false
    end
  end
end
