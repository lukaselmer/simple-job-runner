class AddAlgoParametersJsonbToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :algo_parameters_jsonb, :jsonb
    Run.all.each { |v| v.update(algo_parameters_jsonb: v.algo_parameters) }
  end
end
