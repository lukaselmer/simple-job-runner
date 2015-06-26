require 'rails_helper'

RSpec.describe VisualizationService, type: :service do
  let(:visualization_service) do
    VisualizationService.new
  end

  describe '#charts' do
    it 'should get the epochs vs scores grouped by the other parameters' do
      runs = []
      runs << double(id: 1, score: 50, algo_parameters: { epochs: 10, a: 23, b: 44 })
      runs << double(id: 3, score: 20, algo_parameters: { epochs: 1, a: 23, b: 44 })
      runs << double(id: 2, score: 46, algo_parameters: { epochs: 5, a: 23, b: 44 })
      runs << double(id: 4, score: 45, algo_parameters: { epochs: 5, a: 777 })
      allow(visualization_service).to receive(:all_runs).and_return(runs)
      res = visualization_service.charts(:epochs)
      expect(res).to eq([[{ a: 23, b: 44 }, [[1, 20], [5, 46], [10, 50]]],
                         [{ a: 777 }, [[5, 45]]]])
    end

    it 'should ignore results without a score' do
      runs = []
      runs << double(id: 1, score: nil, algo_parameters: { epochs: 10, a: 23, b: 44 })
      expect(visualization_service.charts(:epochs)).to eq([])
    end
  end
end
