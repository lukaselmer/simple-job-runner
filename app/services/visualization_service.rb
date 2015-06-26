require 'ostruct'

class VisualizationService
  def graphs(x)
    structured_runs = structured_runs(x)
    grouped_runs = grouped_runs(structured_runs)
    ordered_grouped_values(grouped_runs)
  end

  private

  def ordered_grouped_values(grouped_runs)
    grouped_runs.reverse.map do |params_without_x, hsh_group|
      [params_without_x, hsh_group.sort_by(&:x_value).map { |obj| [obj.x_value, obj.score] }]
    end
  end

  def grouped_runs(structured_runs)
    structured_runs.group_by { |hsh| hsh[:params_without_x] }.sort_by do |_, hsh_group|
      hsh_group.max_by(&:score).score
    end
  end

  def structured_runs(x)
    all_runs.select { |run| run.algo_parameters.key?(x) }.map do |run|
      params_without_x = run.algo_parameters.dup
      x_value = params_without_x.delete(x)
      OpenStruct.new(params_without_x: params_without_x, x_value: x_value, score: run.score)
    end
  end

  def all_runs
    Run.all.select(:id, :score, :algo_parameters).to_a
  end
end
