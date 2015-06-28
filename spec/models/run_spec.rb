require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:ended_run) do
    build(:ended_run)
  end

  it 'should check the validations' do
    expect(ended_run.valid?).to be_truthy
    ended_run.algo_parameters = nil
    expect(ended_run.valid?).to be_falsey
  end

  it 'should extract the correct score' do
    r = build(:ended_run)
    expect(r.extract_score).to be_within(0.00001).of(12.254)
    r.output = 'score: 12.254%'
    expect(r.extract_score).to be_within(0.00001).of(12.254)
    r.output = 'awefScore: 98.254%awef'
    expect(r.extract_score).to be_within(0.00001).of(98.254)
    r.output = 'Unknown score - exception trace!?'
    expect(r.extract_score).to be_nil
    r.output = 'Score: NaN%'
    expect(r.extract_score).to be_nil
  end

  it 'should update the score when the output has changed' do
    expect(ended_run.score).to be_within(0.00001).of(12.254)
    ended_run.update!(output: 'awefScore: 98.254%awef')
    expect(ended_run.score).to be_within(0.00001).of(98.254)
  end

  it 'should not update the score when the score cannot be parsed' do
    expect(ended_run.score).to be_within(0.00001).of(12.254)
    ended_run.update!(output: 'awefScore: NAN%awef')
    expect(ended_run.score).to be_within(0.00001).of(12.254)
  end

  it 'should return the pending, started, ended runs' do
    create(:pending_run)
    create(:pending_run)
    create(:pending_run)
    create(:pending_run)
    create(:started_run)
    create(:started_run)
    create(:started_run)
    create(:ended_run)
    create(:ended_run)
    expect(Run.pending.count).to eq(4)
    expect(Run.started.count).to eq(3)
    expect(Run.ended.count).to eq(2)
  end

  describe '#cleanup_output' do
    it 'should call #cleanup_output before save' do
      run = build(:ended_run)
      expect(run).to receive(:cleanup_output).with(no_args)
      run.run_callbacks(:save)
    end

    it 'should work if output is nil' do
      run = build(:ended_run, output: nil)
      run.cleanup_output
      expect(run.output).to be_nil
    end

    it 'should cleanup the gensim progress' do
      bad = 'bbla gensim ff INFO - PROGRESS: at ba'
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      run = build(:ended_run, output: output)
      run.cleanup_output
      expect(run.output).to eq("blabla\nxxxx\n" * 2)
    end

    it 'should cleanup numpy storing events' do
      bad = "abcgensim.utils - INFO - storing numpy array 'syn1' todef"
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      run = build(:ended_run, output: output)
      run.cleanup_output
      expect(run.output).to eq("blabla\nxxxx\n" * 2)
    end

    it 'should cleanup reached the end of input events' do
      bad = 'cgensimX INFO Xreached ihu input awefawef outstanding jobs'
      output = "blabla\n#{bad}\n#{bad}\n#{bad}\nxxxx\n" * 2
      run = build(:ended_run, output: output)
      run.cleanup_output
      expect(run.output).to eq("blabla\nxxxx\n" * 2)
    end
  end
end
