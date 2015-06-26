class VisualizationsController < ApplicationController
  def x_vs_score
    @charts = visualization_service.charts(params[:x])
  end

  private

  def visualization_service
    VisualizationService.new
  end
end
