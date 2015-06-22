class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]

  def index
    @runs = Run.all
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
