require 'rails_helper'

RSpec.describe 'runs/index', type: :view do
  before(:each) do
    assign(:runs, [
      Run.create!(
        algo_parameters: { a: 10 },
        output: 'MyText',
        score: 99
      ),
      Run.create!(
        algo_parameters: { a: 10 },
        output: 'MyText',
        score: 34.5
      )
    ])
  end

  it 'renders a list of runs' do
    render
    assert_select 'tr>td', text: '{"a":10}'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: '99.0'.to_s, count: 1
    assert_select 'tr>td', text: '34.5'.to_s, count: 1
  end
end
