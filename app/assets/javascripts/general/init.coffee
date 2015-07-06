$ ->
  $('.chart').each (i, chart) ->
    series = $(chart).data('series')
    chart_title = $(chart).data('chart-title')
    x_name = $(chart).data('chart-x-name')

    $(chart).highcharts
      line:
        dataLabels:
          enabled: true
      title:
        text: chart_title
      xAxis:
        title:
          text: x_name
        type: 'numeric'
        tickInterval: 5
      yAxis:
        title:
          text: 'Score'
        min: 70
        max: 100
        type: 'numeric'
        minorTickInterval: 1
        tickInterval: 5
      tooltip:
        headerFormat: '<b>{series.name}</b><br />',
        pointFormat: "#{x_name} = {point.x}, Score = {point.y}"
      series: series


