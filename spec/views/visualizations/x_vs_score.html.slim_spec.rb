require 'rails_helper'

RSpec.describe 'visualizations/x_vs_score.html.slim', type: :view do
  it 'renders the titles' do
    charts = [[{ a: 23, b: 44 }, [[1, 20], [5, 46], [10, 50]]],
              [{ a: 777 }, [[5, 45]]]]
    assign(:charts, charts)
    assign(:filterable_attributes, %w(a b c))
    render
    expect(rendered).to include('a=23 b=44')
  end

  it 'sorts the title' do
    charts = [[{ b: 333, a: 553 }, [[1, 20]]]]
    assign(:charts, charts)
    assign(:filterable_attributes, %w(a b c))
    render
    expect(rendered).to include('a=553 b=333')
  end

  it 'renders a table per chart' do
    charts = [[{ a: 23, b: 44 }, [[1, 20], [5, 46]]],
              [{ a: 777 }, [[234_567, 45]]]]
    assign(:charts, charts)
    assign(:filterable_attributes, %w(a b c))
    render
    expect(rendered).to include('Epoch')
    expect(rendered).to include('Score')
    expect(rendered).to include('table')
    expect(rendered).to include('234567')
    expect(rendered).to include('45')
  end
end
