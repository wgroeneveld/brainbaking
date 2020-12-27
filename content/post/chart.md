---
title: amchart renderer
draft: true
---

this is a chart:

<script src="https://www.amcharts.com/lib/4/core.js"></script>
<script src="https://www.amcharts.com/lib/4/charts.js"></script>
<script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>


<div id="chartdiv" style="width: 100%; height: 500px"></div>


done. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac neque ac justo bibendum condimentum. Ut ac erat non urna elementum cursus. Phasellus vestibulum elementum diam eu accumsan. In justo lectus, lobortis ut mattis ut, iaculis vel massa. Ut dapibus, arcu ut dapibus bibendum, augue massa fringilla velit, nec lobortis felis elit et velit. Aliquam erat volutpat. Mauris non arcu velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec odio purus, feugiat sit amet tristique in, tristique sit amet odio. In nisi quam, mollis quis mollis mattis, mattis eu enim. Pellentesque pellentesque eros ut eleifend ultrices. Suspendisse maximus magna vel ipsum consequat porta. Integer mattis sem ut semper condimentum.

Proin gravida vitae tortor eu posuere. Nunc quis pellentesque mauris, ac ultrices turpis. Nulla iaculis, risus nec posuere euismod, risus est efficitur purus, in rutrum nulla est id sapien. Nam venenatis ipsum gravida, feugiat tortor suscipit, tincidunt metus. Phasellus purus nisl, pulvinar tristique tellus id, eleifend fringilla dui. Cras porta pharetra ligula quis tincidunt. Praesent condimentum auctor dolor, nec aliquam enim accumsan non. Nullam congue gravida libero sit amet hendrerit.

<script>
am4core.ready(function() {

am4core.useTheme(am4themes_animated);

function createChart(divid, data) {
    var chart = am4core.create(divid, am4charts.XYChart);
      chart.exporting.menu = new am4core.ExportMenu();

    chart.data = data;

    chart.padding(40, 40, 40, 40);

    var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
    categoryAxis.renderer.grid.template.location = 0;
    categoryAxis.dataFields.category = "config";
    categoryAxis.renderer.inversed = true;
    categoryAxis.renderer.grid.template.disabled = true;
    //categoryAxis.renderer.minGridDistance = 100;
    categoryAxis.renderer.minWidth = 120;

    var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
    valueAxis.min = 0;

    var series = chart.series.push(new am4charts.ColumnSeries());
    series.dataFields.categoryY = "config";
    series.dataFields.valueX = "val";
    series.tooltipText = "{valueX.value}"
    series.columns.template.strokeOpacity = 0;
    series.columns.template.column.cornerRadiusBottomRight = 5;
    series.columns.template.column.cornerRadiusTopRight = 5;

    var labelBullet = series.bullets.push(new am4charts.LabelBullet())
    labelBullet.label.horizontalCenter = "left";
    labelBullet.fontSize = 20;
    labelBullet.label.dx = 5;
    labelBullet.label.fill = am4core.color("white");
    labelBullet.label.text = "{values.valueX.workingValue}";
    labelBullet.locationX = 1;

    categoryAxis.sortBySeries = series;

    var columnTemplate = series.columns.template;
    columnTemplate.adapter.add("fill", function(fill, target) {
      return am4core.color("#018660")
    })
}

createChart("chartdiv", [{
      "config": "2020 ARM64",
      "val": 1378
    }, {
      "config": "2020 x86_64",
      "val": 2459
    }, {
      "config": "2012 x86_64",
      "val": 3200
    }]
    );

}); // end am4core.ready()
</script>