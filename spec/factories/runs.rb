FactoryGirl.define do
  factory :pending_run, class: Run do
    algo_parameters({ a: 20, b: 63 }.to_json)
    score nil
    output ''
  end

  factory :started_run, class: Run do
    algo_parameters({ a: 20, b: 63 }.to_json)
    score nil
    output ''
    started_at Time.now
  end

  factory :ended_run, class: Run do
    algo_parameters({ a: 20, b: 63 }.to_json)
    score 12.254
    output "Blablabla\nScore: 12.254%\nBlabla"
    started_at Time.now
    ended_at Time.now
  end
end