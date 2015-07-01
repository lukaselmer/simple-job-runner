class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy, :report_results, :restart]
  skip_before_action :verify_authenticity_token, only: [:report_results, :schedule_runs]

  def index
    @runs = RunsViewModel.new(params[:created_at], @date_filter)
  end

  def possible_pending
    @possible_pending_runs_by_host_name = runs_service.possible_pending_runs_by_host_name
  end

  def show
    render format: :json
  end

  def start_random_pending_run
    @run = runs_service.start_random_pending_run params[:host_name]
    result = @run ? { result: :start, id: @run.id, algo_params: @run.algo_params } : { result: :nothing }
    render json: result
  end

  def end_all
    runs_service.end_all
    render nothing: true
  end

  def schedule_runs
    runs_service.schedule_runs(convert_json(params[:general_params]), convert_json(params[:narrow_params]))
    render nothing: true
  end

  def report_results
    runs_service.report_results(@run, params[:run][:output])
    render nothing: true
  end

  def restart
    runs_service.restart(@run)
    redirect_to runs_path
  end

  private

  def convert_json(value)
    return value.map { |k, v| [k.to_sym, convert_json(v)] }.to_h if value.is_a?(Hash)
    return value.map { |v| convert_json(v) } if value.is_a?(Array)
    value
  end

  def runs_service
    RunsService.new
  end

  def set_run
    @run = Run.find(params[:id])
  end
end
