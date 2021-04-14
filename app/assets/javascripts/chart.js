window.onload = function() {
  let arr_evaluation_fidgets = document.getElementById("js_evaluation_fidgets").value
  let evaluation_fidgets = JSON.parse(arr_evaluation_fidgets)
  js_today_score_chart(evaluation_fidgets)
}

function js_today_score_chart(data){
  let width = 150, height = 150

  var svg = d3.select("#js_today_score_chart").attr("width", width).attr("height", height).append("g").attr("transform",`translate(${width/2},${height/2})`)

  let fidget_time = data.fidget_times[data.fidget_times.length-1]
  let fidget_level = data.fidget_level_maximums[data.fidget_level_maximums.length-1]
  let comprehensive_evaluation = data.comprehensive_evaluation

  render_fidget_time(svg, fidget_time, width/2-15, width/2-5)
  render_fidget_level(svg, fidget_level, width/2-20, width/2-30)
}

function render_fidget_time(svg, fidget_time, innerRadius, outerRadius){
  let color = "green"
  let font_size = 25

  render_arc(svg, Math.PI*2, innerRadius, outerRadius, "lightgray")
  render_arc(svg, fidget_time/60, innerRadius, outerRadius, color)
  render_text(svg.append("g").attr("transform", `translate(0,${-font_size/3})`), Math.round(fidget_time), font_size, color)
}

function render_fidget_level(svg, fidget_level, innerRadius, outerRadius){
  let color = "lightgreen"
  let font_size = 20

  render_arc(svg, Math.PI*2, innerRadius, outerRadius, "lightgray")
  render_arc(svg, fidget_level/5*Math.PI, innerRadius, outerRadius, color)
  render_text(svg.append("g").attr("transform", `translate(0,${font_size/1.5})`), fidget_level, font_size, color)
}

function render_text(svg, value, font_size, color){
  svg.append("text")
    .attr("class", "text")
    .text(value)
    .attr("text-anchor", "middle")
    .attr("dominant-baseline", "central")
    .attr("font-size", font_size)
    .attr("fill", color)
}

function render_arc(svg, value, innerRadius, outerRadius, color){
  let start_angle = 0
  var arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius)
      .startAngle(start_angle)
      .endAngle(start_angle+value)

  svg.append("path")
    .attr("class", "arc")
    .attr("d", arc)
    .attr("fill", color)
}
