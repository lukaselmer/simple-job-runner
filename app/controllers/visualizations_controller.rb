class VisualizationsController < ApplicationController
  def x_vs_score
    @charts = visualization_service.charts(params[:x])
  end

  def x_vs_score_by_z
    @charts = visualization_service.multi_charts(params[:x], params[:z])
    @x_name = params[:x].humanize
    @z_name = params[:z].humanize
  end

  private

  def visualization_service
    VisualizationService.new(2, @date_filter)
  end
end
