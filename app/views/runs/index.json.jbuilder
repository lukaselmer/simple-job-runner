json.array!(@runs) do |run|
  json.extract! run, :id, :algo_parameters, :started_at, :ended_at, :output, :score
  json.url run_url(run, format: :json)
end
