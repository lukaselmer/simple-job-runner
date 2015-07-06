class RunGroupsController < ApplicationController
  def index
    @run_groups = RunGroup.all
  end

  def show
    @run_group = RunGroup.find(params[:id])
  end
end
