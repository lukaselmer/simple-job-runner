getOptions = (series, chart_title, xName) ->
  chart:
    height: 700
  line:
    dataLabels:
      enabled: true
  title:
    text: chart_title
  xAxis:
    title:
      text: xName
    type: 'numeric'
    tickInterval: 5
  yAxis:
    title:
      text: 'Score'
    min: 80
    max: 95
    type: 'numeric'
    minorTickInterval: 1
    tickInterval: 5
  tooltip:
    headerFormat: '<b>{series.name}</b><br />',
    pointFormat: "#{xName} = {point.x}, Score = {point.y}"
  series: series


initTextareaCode = (chart, options) ->
  chartParent = $(chart).parents('.chart-container')
  chartParent.find('.options').val(JSON.stringify(options))
  chartParent.find('.options-submit').click(runTextareaCode)


runTextareaCode = (e) ->
  chartParent = $(e.target).parents('.chart-container')
  options = chartParent.find('.options').val()
  chart = chartParent.find('.chart')
  chart.highcharts JSON.parse(options)


$ ->
  $('.chart').each (i, chart) ->
    series = $(chart).data('series')
    chartTitle = $(chart).data('chart-title')
    xName = $(chart).data('chart-x-name')

    options = getOptions(series, chartTitle, xName)

    initTextareaCode(chart, options)
    $(chart).highcharts options
