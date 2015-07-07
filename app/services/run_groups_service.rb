class RunGroupsService
  def pending_run_groups(host_name)
    groups = RunGroup.where(host_name: host_name, running: false, finished: false)
    groups.joins(:runs).where(runs: { started_at: nil, ended_at: nil })
  end
end
