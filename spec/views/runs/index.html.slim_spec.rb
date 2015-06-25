require 'rails_helper'

RSpec.describe 'runs/index', type: :view do
  before(:each) do
    @pending_run_1 = build_stubbed(:pending_run, created_at: 10.days.ago)
    @started_run_1 = build_stubbed(:started_run, host_name: 'started_host', started_at: 17.days.ago)
    @ended_run_1 = build_stubbed(:ended_run, host_name: 'ended_host1', score: 99, ended_at: 25.days.ago)
    @ended_run_2 = build_stubbed(:ended_run, host_name: 'ended_host2', score: 34.5, ended_at: 23.days.ago)
    @best_ended_run = build_stubbed(:ended_run, host_name: 'best_host', score: 99.99, ended_at: 26.days.ago)
    runs_view_model_mock = double('Runs View Model Mock')
    allow(runs_view_model_mock).to receive(:pending).and_return([@pending_run_1])
    allow(runs_view_model_mock).to receive(:pending_total).and_return(777)
    allow(runs_view_model_mock).to receive(:started).and_return([@started_run_1])
    allow(runs_view_model_mock).to receive(:ended).and_return([@ended_run_1, @ended_run_2])
    allow(runs_view_model_mock).to receive(:ended_total).and_return(999)
    allow(runs_view_model_mock).to receive(:best).and_return([@best_ended_run])
    assign(:runs, runs_view_model_mock)
  end

  it 'renders the pending runs' do
    render

    expect(rendered).to include(ERB::Util.html_escape(@pending_run_1.algo_parameters.to_json))
    expect(rendered).to include('10 days ago')
    expect(rendered).to include('Pending (777 total)')
  end

  it 'renders the started runs' do
    render

    expect(rendered).to include(ERB::Util.html_escape(@started_run_1.algo_parameters.to_json))
    expect(rendered).to include('17 days ago')
    expect(rendered).to include('Restart')
    expect(rendered).to include('started_host')
  end

  it 'renders the ended runs' do
    render

    expect(rendered).to include(ERB::Util.html_escape(@ended_run_1.algo_parameters.to_json))
    expect(rendered).not_to include(@ended_run_1.output)
    expect(rendered).to include('99.0')
    expect(rendered).to include('34.5')
    expect(rendered).to include('25 days ago')
    expect(rendered).to include('23 days ago')
    expect(rendered).to include('Ended (999 total)')
    expect(rendered).to include('Restart')
    expect(rendered).to include('ended_host1')
    expect(rendered).to include('ended_host2')
  end

  it 'renders the best runs' do
    render

    expect(rendered).to include(ERB::Util.html_escape(@best_ended_run.algo_parameters.to_json))
    expect(rendered).to include('99.99')
    expect(rendered).to include('26 days ago')
    expect(rendered).to include('best_host')
  end
end
