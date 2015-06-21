require 'rails_helper'

RSpec.describe 'runs/show', type: :view do
  before(:each) do
    @run = assign(:run, Run.create!(
                          algo_parameters: { a: 10 },
                          output: 'MyText',
                          score: 20
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
