FactoryGirl.define do
  factory :pending_run, class: Run do
    narrow_params({ a: 20, b: 63 }.to_json)
    general_params({ a: 20, b: 63 }.to_json)
    score nil
    association :run_group, general_params: { a: 20, b: 63 }.to_json, host_name: ''
  end

  factory :started_run, class: Run do
    narrow_params({ epochs: 10, a: 20, b: 63 }.to_json)
    general_params({ epochs: 10, a: 20, b: 63 }.to_json)
    score nil
    started_at Time.now
    host_name 'myhost1.com'
    association :run_group, general_params: { a: 20, b: 63 }.to_json, running: true
  end

  factory :ended_run, class: Run do
    narrow_params({ epochs: 10, a: 20, b: 63 }.to_json)
    general_params({ epochs: 10, a: 20, b: 63 }.to_json)
    score 12.254
    log_output
    started_at Time.now
    host_name 'myhost1.com'
    ended_at Time.now
    association :run_group, general_params: { a: 20, b: 63 }.to_json
  end
end
