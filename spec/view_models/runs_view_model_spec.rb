require 'rails_helper'

RSpec.describe RunsViewModel, type: :view_model do
  describe 'pending runs' do
    it 'should limit the pending runs to 20' do
      21.times { create(:pending_run) }
      expect(RunsViewModel.new(nil, nil).pending.count).to eq(20)
      expect(RunsViewModel.new(nil, nil).pending_total).to eq(21)
    end
  end

  describe 'started runs' do
    it 'should order the started runs by started at' do
      r1 = create(:started_run, started_at: 10.days.ago)
      r2 = create(:started_run, started_at: 15.days.ago)
      r3 = create(:started_run, started_at: 7.days.ago)
      expect(RunsViewModel.new(nil, nil).started).to eq([r2, r1, r3])
    end
  end

  describe 'ended runs' do
    it 'should order the ended runs by ended at' do
      r1 = create(:ended_run, ended_at: 10.days.ago)
      r2 = create(:ended_run, ended_at: 15.days.ago)
      r3 = create(:ended_run, ended_at: 7.days.ago)
      expect(RunsViewModel.new(nil, nil).ended).to eq([r3, r1, r2])
    end

    it 'should limit the pending runs to 20' do
      21.times { create(:ended_run) }
      expect(RunsViewModel.new(nil, nil).ended.count).to eq(20)
      expect(RunsViewModel.new(nil, nil).ended_total).to eq(21)
    end
  end

  describe 'best runs' do
    it 'should order the best runs by score' do
      r1 = create(:ended_run, ended_at: 10.days.ago, score: 98, log_output: nil)
      r2 = create(:ended_run, ended_at: 15.days.ago, score: 99, log_output: nil)
      r3 = create(:ended_run, ended_at: 7.days.ago, score: 97, log_output: nil)
      create(:ended_run, ended_at: 7.days.ago, score: nil, log_output: build(:log_output_error))
      expect(RunsViewModel.new(nil, nil).best).to eq([r2, r1, r3])
    end

    it 'should limit the best runs to 20' do
      21.times { create(:ended_run) }
      expect(RunsViewModel.new(nil, nil).best.count).to eq(20)
    end
  end
end
