module VisualizationsHelper
  def convert_chart_data(chart)
    [
      {
        data: chart,
        pointStart: 1
      }
    ].to_json
  end

  def convert_multi_chart_data(multi_chart, z_name)
    multi_chart.map do |z_value, chart|
      {
        name: "#{z_name} #{z_value}",
        data: chart,
        pointStart: 1
      }
    end.to_json
  end
end
