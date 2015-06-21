require 'rails_helper'

RSpec.describe 'runs/new', type: :view do
  before(:each) do
    assign(:run, build(:ended_run))
  end

  it 'renders new run form' do
    render

    assert_select 'form[action=?][method=?]', runs_path, 'post' do
      assert_select 'input#run_algo_parameters[name=?]', 'run[algo_parameters]'
      assert_select 'textarea#run_output[name=?]', 'run[output]'
      assert_select 'input#run_score[name=?]', 'run[score]'
    end
  end
end
