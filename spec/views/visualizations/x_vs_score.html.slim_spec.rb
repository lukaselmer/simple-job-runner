require 'rails_helper'

RSpec.describe 'visualizations/x_vs_score.html.slim', type: :view do
  it 'renders the titles' do
    charts = [[{ a: 23, b: 44 }, [[1, 20], [5, 46], [10, 50]]],
              [{ a: 777 }, [[5, 45]]]]
    assign(:charts, charts)
    render
    expect(rendered).to include('Results for a=23 b=44')
  end

  it 'sorts the title' do
    charts = [[{ b: 333, a: 553 }, [[1, 20]]]]
    assign(:charts, charts)
    render
    expect(rendered).to include('Results for a=553 b=333')
  end
end
