window.onload = function() {
  let arr_evaluation_fidgets = document.getElementById("js_evaluation_fidgets").value
  var evaluation_fidgets = JSON.parse(arr_evaluation_fidgets)
  evaluation_fidgets["dayofweek"] = dayofweek(evaluation_fidgets.evaluate_days)
  evaluation_fidgets.evaluate_days.unshift("x")
  js_weekly_fidget_times_chart(evaluation_fidgets)
  js_weekly_fidget_calories_chart(evaluation_fidgets)
  js_weekly_fidget_levels_chart(evaluation_fidgets)
}

function dayofweek(days){
  var dayofweek = ["x"]
  days.forEach((day) => {
    var date = new Date (day)
    dayofweek.push([ "日", "月", "火", "水", "木", "金", "土" ][date.getDay()])
  });
  return dayofweek
}

function js_weekly_fidget_times_chart(data){
  var chart_data = {}
  chart_data["columns"] = [data.dayofweek,["time"].concat(data.fidget_times)]
  chart_data["y_tick_values"] = [0, Math.max(...data.fidget_times)]
  chart_data["bindto"] = "#js_weekly_fidget_times_chart"
  chart_data["y_label_text"] = "累計時間"
  js_weekly_chart(chart_data)
}

function js_weekly_fidget_calories_chart(data){
  var chart_data = {}
  chart_data["columns"] = [data.dayofweek,["calorie"].concat(data.fidget_calories)]
  chart_data["y_tick_values"] = [0, Math.round(Math.max(...data.fidget_calories))]
  chart_data["bindto"] = "#js_weekly_fidget_calories_chart"
  chart_data["y_label_text"] = "カロリー"
  js_weekly_chart(chart_data)
}

function js_weekly_fidget_levels_chart(data){
  var chart_data = {}
  chart_data["columns"] = [data.dayofweek,["fidget_level"].concat(data.fidget_level_maximums)]
  chart_data["y_tick_values"] = [0, Math.max(...data.fidget_level_maximums)]
  chart_data["bindto"] = "#js_weekly_fidget_levels_chart"
  chart_data["y_label_text"] = "最大自震度"
  js_weekly_chart(chart_data)
}

function js_weekly_chart(chart_data){
  var chart = c3.generate({
    bindto: chart_data["bindto"],
    data: {
      type: "bar",
      columns: chart_data["columns"],
      x: "x"
    },
    bar: {
      width: {
          ratio: 0.5,
      }
    },
    axis: {
      x: {
        type: "category"
      },
      y: {
        label: {
          text: chart_data["y_label_text"],
          position: "outer-top",
        },
        tick: {
          values: chart_data["y_tick_values"]
        }
      }
    },
    legend: {
      show: false
    }
  })
}
