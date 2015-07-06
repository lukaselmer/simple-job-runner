require 'ostruct'

class VisualizationService
  def initialize(minimum_points_per_chart, date_filter = nil)
    @minimum_points_per_chart = minimum_points_per_chart
    @date_filter = date_filter
  end

  def multi_charts(x1, x2)
    charts_with_x2 = charts(x1).select { |params, _| params.key?(x2) }
    grouped_charts = charts_with_x2.group_by { |params, _| params.reject { |k, _| k == x2 } }
    grouped_charts.map do |new_params, series|
      multi_series = series.map do |params, data|
        [params[x2], data]
      end.to_h
      [new_params, multi_series]
    end
  end

  def charts(x)
    structured_runs = structured_runs(x)
    grouped_runs = grouped_runs(structured_runs)
    ordered_grouped_values = ordered_grouped_values(grouped_runs)
    filter_groups_without_enough_data(ordered_grouped_values)
  end

  private

  def filter_groups_without_enough_data(ordered_grouped_values)
    ordered_grouped_values.select { |_, elements| elements.count > @minimum_points_per_chart }
  end

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
    all_runs.select { |run| run.algo_params.key?(x) && run.score }.map do |run|
      params_without_x = run.algo_params.dup
      x_value = params_without_x.delete(x)
      OpenStruct.new(params_without_x: params_without_x, x_value: x_value, score: run.score)
    end
  end

  def all_runs
    runs = Run.all
    runs = runs.min_created_at(@date_filter) if @date_filter
    runs.to_a
  end
end
