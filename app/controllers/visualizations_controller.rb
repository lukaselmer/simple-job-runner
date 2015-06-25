class VisualizationsController < ApplicationController
  def x_vs_y
    @charts = visualization_service.charts(params[:x].to_sym, params[:y].to_sym)
  end

  private

  def visualization_service
    VisualizationService.new
  end
end
