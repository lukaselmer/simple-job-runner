FactoryGirl.define do
  factory :run_group do
    general_params({ epochs: 10, a: 20, b: 63 }.to_json)
    host_name 'myhost1.com'
    running false
    finished false

    factory :run_group_with_pending_run do
      transient do
        runs_count 1
      end
      after(:create) do |run_group, evaluator|
        create_list(:pending_run, evaluator.runs_count, run_group: run_group)
      end
    end
  end
end
