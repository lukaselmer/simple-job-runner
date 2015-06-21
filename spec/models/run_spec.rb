require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:valid_run) do
    Run.new(algo_parameters: { a: 20, b: 63 }.to_json, score: 12.254, output: "Blablabla\nScore: 12.254%\nBlabla")
  end

  it 'should check the validations' do
    r = valid_run
    expect(r.valid?).to be_truthy
    r.algo_parameters = nil
    expect(r.valid?).to be_falsey
  end

  it 'should extract the correct score' do
    r = valid_run
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
    r = valid_run
    r.save!
    expect(r.score).to be_within(0.00001).of(12.254)
    r.update_attributes!(output: 'awefScore: 98.254%awef')
    expect(r.score).to be_within(0.00001).of(98.254)
  end

  it 'should not update the score when the score cannot be parsed' do
    r = valid_run
    r.save!
    expect(r.score).to be_within(0.00001).of(12.254)
    r.update_attributes!(output: 'awefScore: NAN%awef')
    expect(r.score).to be_within(0.00001).of(12.254)
  end
end
