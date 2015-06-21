require 'rails_helper'

RSpec.describe 'runs/edit', type: :view do
  before(:each) do
    @run = assign(:run, build_stubbed(:ended_run))
  end

  it 'renders the edit run form' do
    render

    assert_select 'form[action=?][method=?]', run_path(@run), 'post' do
      assert_select 'input#run_algo_parameters[name=?]', 'run[algo_parameters]'
      assert_select 'textarea#run_output[name=?]', 'run[output]'
      assert_select 'input#run_score[name=?]', 'run[score]'
    end
  end
end
