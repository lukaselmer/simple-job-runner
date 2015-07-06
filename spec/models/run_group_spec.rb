require 'rails_helper'

RSpec.describe RunGroup, type: :model do
  describe 'default values' do
    it 'should set running to false by default' do
      expect(RunGroup.new.running).to eq(false)
    end

    it 'should set finished to false by default' do
      expect(RunGroup.new.finished).to eq(false)
    end

    it 'should set host_name to "" by default' do
      expect(RunGroup.new.host_name).to eq('')
    end
  end
end
