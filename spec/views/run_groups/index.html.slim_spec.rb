require 'rails_helper'

RSpec.describe 'run_groups/index', type: :view do
  before(:each) do
    assign(:run_groups, [build_stubbed(:run_group), build_stubbed(:run_group)])
  end

  it 'renders a list of run_groups' do
    render
    assert_select 'tr>td', text: 'myhost1.com', count: 2
  end
end
