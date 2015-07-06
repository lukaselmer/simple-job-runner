class RunFilterService
  def filterable_attributes
    Run.all.pluck(:general_params, :narrow_params).map { |x| x.map(&:keys) }.flatten.uniq.sort
  end
end
