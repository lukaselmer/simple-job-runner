FactoryGirl.define do
  factory :log_output do
    output "Blablabla\nScore: 12.254%\nBlabla"

    factory :log_output_error do
      output 'Error!'
    end
  end
end
