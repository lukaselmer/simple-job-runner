require 'rails_helper'

RSpec.describe 'runs/show', type: :view do
  before(:each) do
    @run = assign(:run, build_stubbed(:ended_run, score: 27.5, algo_parameters: { a: 20, b: 63 }))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/27.5/)
    expect(rendered).to match(/Blablabla/)
    expect(rendered).to match(/Score: 12.254%/)
    expect(rendered).to include(::ERB::Util.html_escape('{"a":20,"b":63}'))
  end
end
