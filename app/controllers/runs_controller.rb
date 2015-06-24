class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy, :report_results, :restart]
  skip_before_action :verify_authenticity_token, only: [:report_results, :schedule_runs]

  def index
    @runs = RunsViewModel.new(params[:created_at])
  end

  def show
    render format: :json
  end

  def new
    @run = Run.new
  end

  def edit
  end

  def create
    @run = Run.new(run_params)

    if @run.save
      redirect_to @run, notice: 'Run was successfully created.'
    else
      render :new
    end
  end

  def update
    if @run.update(run_params)
      redirect_to @run, notice: 'Run was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @run.destroy
    redirect_to runs_url, notice: 'Run was successfully destroyed.'
  end

  def start_random_pending_run
    @run = runs_service.start_random_pending_run
    result = @run ? { result: :start, id: @run.id, algo_parameters: @run.algo_parameters } : { result: :nothing }
    render json: result
  end

  def end_all
    runs_service.end_all
    render nothing: true
  end

  def schedule_runs
    runs_service.schedule_runs(params[:algo_parameters].map { |k, v| [k.to_sym, v.map(&:to_i)] }.to_h)
    render nothing: true
  end

  def report_results
    runs_service.report_results(@run, run_params[:output])
    render nothing: true
  end

  def restart
    runs_service.restart(@run)
    redirect_to runs_path
  end

  private

  def runs_service
    RunsService.new
  end

  def set_run
    @run = Run.find(params[:id])
  end

  def run_params
    params.require(:run).permit(:algo_parameters, :started_at, :ended_at, :output, :score)
  end
end
