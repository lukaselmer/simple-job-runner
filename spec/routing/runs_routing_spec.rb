require 'rails_helper'

RSpec.describe RunsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/runs').to route_to('runs#index')
    end

    it 'routes to #show' do
      expect(get: '/runs/1').to route_to('runs#show', id: '1')
    end
  end
end
