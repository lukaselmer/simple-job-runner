require 'rails_helper'

RSpec.describe 'runs/edit', type: :view do
  before(:each) do
    @run = assign(:run, Run.create!(
                          algo_parameters: { a: 10 },
                          output: 'MyText',
                          score: 20
    ))
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
