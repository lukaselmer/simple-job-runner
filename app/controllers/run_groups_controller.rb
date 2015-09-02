class RunGroupsController < ApplicationController
  def index
    @run_groups = RunGroup.order(:created_at)
  end

  def show
    @run_group = RunGroup.find(params[:id])
  end
end
