getOptions = (series, chart_title, xName) ->
  chart:
    height: 700
    style:
      fontFamily: 'Computer Modern Sans'
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
      text: 'Accuracy'
    min: 80
    max: 95
    type: 'numeric'
    minorTickInterval: 1
    tickInterval: 5
  tooltip:
    headerFormat: '<b>{series.name}</b><br />',
    pointFormat: "#{xName} = {point.x}, Accuracy = {point.y}"
  series: series

chartTextHpvReplacements =
  0: 'NO-HPV'
  1: 'HPV-PAR-SENT-SUB'
  3: 'HPV-PAR-SENT-SUBNV'
  2: 'HPV-PAR-SENT'
  4: 'HPV-TOP'
  5: 'HPV-TOP-PAR-SENT'
  6: 'HPV-PAR'
  7: 'HPV-TOP-PAR'

chartTextDeletions = ['tfid_features=0 ', 'classifier_c=0.0195 ', 'classifier_penalty=l2 ', '_total',
                      'algorithm_version=10.0 ']

replaceLabels = (text) ->
  for key of chartTextHpvReplacements
    text = text.replace("Hierarchical paragraph vectors #{key}", chartTextHpvReplacements[key])
  for value in chartTextDeletions
    text = text.replace(value, '')
  text


renderChart = (chart, options) ->
  text = JSON.stringify(options)
  text = replaceLabels(text)
  $(chart).highcharts(JSON.parse(text))


initTextareaCode = (chart, options) ->
  chartParent = $(chart).parents('.chart-container')
  chartParent.find('.options').val(JSON.stringify(options))
  chartParent.find('.options-submit').click(runTextareaCode)


runTextareaCode = (e) ->
  chartParent = $(e.target).parents('.chart-container')
  options = chartParent.find('.options').val()
  chart = chartParent.find('.chart')
  renderChart(chart, JSON.parse(options))


$ ->
  $.each chartTextHpvReplacements, (_, hpvText) ->
    $('body').on 'click', "text:contains('#{hpvText}')", (e) ->
      return unless hpvText is $(e.target).text()
      if e.shiftKey
        $("text:contains('#{hpvText}')").each (_, el) ->
          return unless $(el).text() is hpvText
          return if el is e.target
          $(el).click()


$ ->
  $('.chart').each (i, chart) ->
    series = $(chart).data('series')
    chartTitle = $(chart).data('chart-title')
    xName = $(chart).data('chart-x-name')

    options = getOptions(series, chartTitle, xName)

    initTextareaCode(chart, options)
    renderChart(chart, options)
