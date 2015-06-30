require 'rails_helper'

RSpec.describe 'runs/show', type: :view do
  before(:each) do
    @run = assign(:run, build_stubbed(:ended_run, score: 27.5, general_params: { a: 20, b: 63 }, narrow_params: { x: 44 }))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/27.5/)
    expect(rendered).to match(/Blablabla/)
    expect(rendered).to match(/Score: 12.254%/)
    expect(rendered).to include(::ERB::Util.html_escape('{"a":20,"b":63}'))
    expect(rendered).to include('44')
  end
end
