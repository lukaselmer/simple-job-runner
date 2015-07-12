require 'rails_helper'

RSpec.describe 'visualizations/x_vs_score_by_z.html.slim', type: :view do
  it 'renders the titles' do
    charts = [[{ a: 23, b: 44 },
               { 999 => [[1, 20], [5, 46], [10, 50]], 123 => [[1, 87], [3, 82], [10, 88]] }],
              [{ a: 777 },
               { 888 => [[5, 45], [7, 46], [8, 46.5]] }]]
    assign(:charts, charts)
    assign(:filterable_attributes, %w(a b c))
    render
    expect(rendered).to include('a=23 b=44')
  end
end
