require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:ended_run) do
    build(:ended_run)
  end

  it 'should check the narrow params validations' do
    expect(ended_run.valid?).to be_truthy
    ended_run.narrow_params = nil
    expect(ended_run.valid?).to be_falsey
  end

  it 'should check the general params validations' do
    expect(ended_run.valid?).to be_truthy
    ended_run.general_params = nil
    expect(ended_run.valid?).to be_falsey
  end

  it 'should update the score when the output has changed' do
    expect(ended_run.score).to be_within(0.00001).of(12.254)
    ended_run.log_output.update!(output: 'awefScore: 98.254%awef')
    expect(ended_run.score).to be_within(0.00001).of(98.254)
  end

  it 'should not update the score when the score cannot be parsed' do
    expect(ended_run.score).to be_within(0.00001).of(12.254)
    ended_run.log_output.update!(output: 'awefScore: NAN%awef')
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

  it 'returns the algo params' do
    run = build(:started_run, general_params: { a: 44 }, narrow_params: { c: 55, d: 'test' })
    expect(run.algo_params).to eq('a' => 44, 'c' => 55, 'd' => 'test')
  end
end
