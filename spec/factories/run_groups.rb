FactoryGirl.define do
  factory :run_group do
    general_params({ epochs: 10, a: 20, b: 63 }.to_json)
    host_name 'myhost1.com'
    running false
    finished false
  end
end
