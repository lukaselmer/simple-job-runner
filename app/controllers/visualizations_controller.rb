class VisualizationsController < ApplicationController
  before_filter :init_filterable_attributes

  def x_vs_score
    @charts = visualization_service.charts(params[:x])
    init_names
  end

  def x_vs_score_by_z
    @charts = visualization_service.multi_charts(params[:x], params[:z])
    init_names
  end

  private

  def init_names
    @x_name = params[:x].humanize
    @z_name = params[:z].humanize if params[:z]
  end

  def init_filterable_attributes
    @filterable_attributes = run_filter_service.filterable_attributes
  end

  def visualization_service
    VisualizationService.new(2, @date_filter)
  end

  def run_filter_service
    RunFilterService.new
  end
end
