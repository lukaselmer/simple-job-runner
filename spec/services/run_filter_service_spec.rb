require 'rails_helper'

RSpec.describe RunFilterService, type: :service do
  let(:run_filter_service) do
    RunFilterService.new
  end

  describe '#filterable_attributes' do
    it 'should get the filterable attributes' do
      create(:ended_run, general_params: { a: 10, b: 77 }, narrow_params: { z: 10 })
      create(:ended_run, general_params: { c: 20, b: 77 }, narrow_params: { xxx: 123 })
      expect(run_filter_service.filterable_attributes).to eq(%w(a b c xxx z))
    end
  end
end
