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

  describe '#cleanup_output' do
    it 'should call #cleanup_output before save' do
      log_output = build(:log_output)
      expect(log_output).to receive(:cleanup_output).with(no_args)
      log_output.run_callbacks(:save)
    end

    it 'should work if output is nil' do
      log_output = build(:log_output)
      log_output.output = nil
      log_output.cleanup_output
      expect(log_output.output).to be_nil
    end

    it 'should cleanup the gensim progress' do
      bad = 'bbla gensim ff INFO - PROGRESS: at ba'
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      log_output = build(:log_output)
      log_output.output = output
      log_output.cleanup_output
      expect(log_output.output).to eq("blabla\nxxxx\n" * 2)
    end

    it 'should cleanup numpy storing events' do
      bad = "abcgensim.utils - INFO - storing numpy array 'syn1' todef"
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      log_output = build(:log_output)
      log_output.output = output
      log_output.cleanup_output
      expect(log_output.output).to eq("blabla\nxxxx\n" * 2)
    end

    it 'should cleanup reached the end of input events' do
      bad = 'cgensimX INFO Xreached ihu input awefawef outstanding jobs'
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      log_output = build(:log_output)
      log_output.output = output
      log_output.cleanup_output
      expect(log_output.output).to eq("blabla\nxxxx\n" * 2)
    end
  end
end
