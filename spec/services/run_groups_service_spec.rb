require 'rails_helper'

RSpec.describe RunGroupsService, type: :service do
  let(:run_group_service) do
    RunGroupsService.new
  end

  let(:host_name_1) do
    'myhost1.com'
  end

  let(:host_name_2) do
    'myhost2.com'
  end

  describe '#pending_run_groups_by_host_name' do
    it 'returns an empty array if there are no run groups' do
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([])
    end

    it 'returns the run groups with runs' do
      g1 = create(:run_group_with_pending_run, host_name: host_name_1)
      g2 = create(:run_group_with_pending_run, host_name: host_name_1)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([g1, g2])
    end

    it 'returns the run groups with runs by the correct host name' do
      g1 = create(:run_group_with_pending_run, host_name: host_name_1)
      create(:run_group_with_pending_run, host_name: host_name_2)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([g1])
    end

    it 'returns the run groups which are not running' do
      create(:run_group_with_pending_run, host_name: host_name_1, running: true)
      g1 = create(:run_group_with_pending_run, host_name: host_name_1, running: false)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([g1])
    end

    it 'returns the run groups which are not finished' do
      create(:run_group_with_pending_run, host_name: host_name_1, finished: true)
      g1 = create(:run_group_with_pending_run, host_name: host_name_1, finished: false)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([g1])
    end

    it 'returns an empty array if there are no pending runs' do
      create(:run_group, host_name: host_name_1)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([])
    end

    it 'returns an empty array if there are only ended runs' do
      g1 = create(:run_group, host_name: host_name_1)
      create(:ended_run, run_group: g1)
      expect(run_group_service.pending_run_groups(host_name_1)).to eq([])
    end
  end
end
