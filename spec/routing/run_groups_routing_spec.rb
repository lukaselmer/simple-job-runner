require 'rails_helper'

RSpec.describe RunGroupsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/run_groups').to route_to('run_groups#index')
    end

    it 'routes to #show' do
      expect(get: '/run_groups/1').to route_to('run_groups#show', id: '1')
    end
  end
end
