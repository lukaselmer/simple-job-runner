require 'rails_helper'

RSpec.describe LogOutput, type: :model do
  describe '#extract_score' do
    it 'should extract the correct score' do
      log_output = build(:log_output)
      expect(log_output.extract_score).to be_within(0.00001).of(12.254)
      log_output.output = 'score: 12.254%'
      expect(log_output.extract_score).to be_within(0.00001).of(12.254)
      log_output.output = 'awefScore: 98.254%awef'
      expect(log_output.extract_score).to be_within(0.00001).of(98.254)
      log_output.output = 'Unknown score - exception trace!?'
      expect(log_output.extract_score).to be_nil
      log_output.output = 'Score: NaN%'
      expect(log_output.extract_score).to be_nil
    end
  end
end
