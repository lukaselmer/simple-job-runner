require 'rails_helper'

RSpec.describe 'runs/possible_pending', type: :view do
  before(:each) do
    r1 = build_stubbed(:pending_run, general_params: { x: 2000 }, narrow_params: { a: 890 })
    r2 = build_stubbed(:pending_run, general_params: { x: 2000 }, narrow_params: { a: 1234 })
    r3 = build_stubbed(:pending_run, general_params: { x: 2000 }, narrow_params: { c: 333, b: 567 })
    assign(:possible_pending_runs_by_host_name, 'any' => [r1], 'host2.com' => [r2, r3])
  end

  it 'renders the pending runs' do
    render

    expect(rendered).to include('Host: any')
    expect(rendered).to include('Host: host2.com')
    expect(rendered).to include('a=890')
    expect(rendered).to include('a=1234')
    expect(rendered).to include('b=567 c=333')
    expect(rendered).to include('x=2000')
  end
end
