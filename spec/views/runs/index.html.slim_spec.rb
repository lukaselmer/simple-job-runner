require 'rails_helper'

RSpec.describe 'runs/index', type: :view do
  before(:each) do
    assign(:runs, [
      build_stubbed(:ended_run, score: 99),
      build_stubbed(:ended_run, score: 34.5)
    ])
  end

  it 'renders a list of runs' do
    render
    assert_select 'tr>td', text: '{"a":20,"b":63}', count: 2
    assert_select 'tr>td', text: "Blablabla\nScore: 12.254%\nBlabla", count: 2
    assert_select 'tr>td', text: '99.0', count: 1
    assert_select 'tr>td', text: '34.5', count: 1
  end
end
