require 'rails_helper'

RSpec.describe 'run_groups/show', type: :view do
  before(:each) do
    @run_group = assign(:run_group, build_stubbed(:run_group))
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/myhost1\.com/)
  end
end
