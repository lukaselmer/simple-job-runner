require 'rails_helper'

RSpec.describe 'visualizations/x_vs_y.html.slim', type: :view do
  #  before(:each) do
  #   @ended_run_1 = build_stubbed(:ended_run, host_name: 'ended_host1', score: 99, ended_at: 25.days.ago)
  #   @ended_run_2 = build_stubbed(:ended_run, host_name: 'ended_host2', score: 34.5, ended_at: 23.days.ago)
  #   runs_view_model_mock = double('Runs View Model Mock')
  #   allow(runs_view_model_mock).to receive(:pending).and_return([@pending_run_1])
  #   allow(runs_view_model_mock).to receive(:pending_total).and_return(777)
  #   allow(runs_view_model_mock).to receive(:started).and_return([@started_run_1])
  #   allow(runs_view_model_mock).to receive(:ended).and_return([@ended_run_1, @ended_run_2])
  #   allow(runs_view_model_mock).to receive(:ended_total).and_return(999)
  #   allow(runs_view_model_mock).to receive(:best).and_return([@best_ended_run])
  #   assign(:runs, runs_view_model_mock)
  # end
  #
  # it 'renders the pending runs' do
  #   render
  #
  #   expect(rendered).to include(ERB::Util.html_escape(@pending_run_1.algo_parameters.to_json))
  #   expect(rendered).to include('10 days ago')
  #   expect(rendered).to include('Pending (777 total)')
  # end
end
