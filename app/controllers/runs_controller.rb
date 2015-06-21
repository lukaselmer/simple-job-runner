class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]

  def index
    @runs = Run.all
  end

  def show
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

  private

  def set_run
    @run = Run.find(params[:id])
  end

  def run_params
    params.require(:run).permit(:algo_parameters, :started_at, :ended_at, :output, :score)
  end
end
