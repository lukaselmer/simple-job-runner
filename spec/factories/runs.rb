FactoryGirl.define do
  factory :pending_run, class: Run do
    algo_parameters({ a: 20, b: 63 }.to_json)
    score nil
  end

  factory :started_run, class: Run do
    algo_parameters({ epochs: 10, a: 20, b: 63 }.to_json)
    score nil
    started_at Time.now
    host_name 'myhost1.com'
  end

  factory :ended_run, class: Run do
    algo_parameters({ epochs: 10, a: 20, b: 63 }.to_json)
    score 12.254
    log_output
    started_at Time.now
    host_name 'myhost1.com'
    ended_at Time.now
  end
end
