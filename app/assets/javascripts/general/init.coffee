$ ->
  $('.chart').each (i, chart) ->
    chart_data = $(chart).data('chart')

    $(chart).highcharts
      line:
        dataLabels:
          enabled: true
      title:
        text: 'Logarithmic axis demo'
      xAxis:
        type: 'numeric'
        tickInterval: 5
      yAxis:
        min: 0
        max: 100
        type: 'numeric'
        minorTickInterval: 10
        tickInterval: 20
      tooltip:
        # headerFormat: '<b>{series.name}</b><br />',
        pointFormat: 'epoch = {point.x}, score = {point.y}'
      series: [{
        data: chart_data
        pointStart: 1
      }]


