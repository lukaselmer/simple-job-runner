$ ->
  $('.chart').each (i, chart) ->
    chart_data = $(chart).data('chart')

    $(chart).highcharts
      line:
        dataLabels:
          enabled: true
      xAxis:
        type: 'numeric'
        tickInterval: 5
      yAxis:
        min: 70
        max: 100
        type: 'numeric'
        minorTickInterval: 1
        tickInterval: 5
      tooltip:
        # headerFormat: '<b>{series.name}</b><br />',
        pointFormat: 'epoch = {point.x}, score = {point.y}'
      series: [{
        data: chart_data
        pointStart: 1
      }]


