<%
  /**********************************************************************
	* 首页报表显示页面
	* 2015-9-22 杨赛 
	* fusioncharts参考文档目录：CAP/BM/07_Training/技术类/图形化报表/PowerCharts_XT_Enterprise（starTeam）
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="x-ua-compatible" content="IE=edge">
<title>report index</title>
</head>
<style>
	.container {
		height: 500px;
	}
	.report_left {
		float: left;
		width: 30%;
		height: 100%;
		/*border-right: solid 1px #ddd;*/
	}
	.report_right {
		float: right;
		width: 70%;
		height: 100%;
	}
	.report_right .report_top {
		height: 50%;
		/*border-bottom: solid 1px #ddd;*/
	}
	.report_right .report_bottom {
		height: 50%;
	}
	
</style>
<body>
<div class="container">
	<div id="systemIntegralityChart" class="report_left"></div>
	<div class="report_right">
		<div id="phasedChart" class="report_top"></div>
		<div id="moduleChart" class="report_bottom"></div>
	</div>
	
</div>

<top:script src="/top/js/jquery.js" />
<top:script src="/cap/bm/common/fusioncharts/fusioncharts.js" />
<top:script src="/cap/dwr/engine.js" />
<top:script src="/cap/dwr/interface/CAPReportAction.js" />
<script type="text/javascript">
	var systemIntegralityChart;	//系统整体资源报表
	var phasedChart;
	var moduleChart;
	$(document).ready(function($) {
		//加载系统整体资源报表
		CAPReportAction.querySystemIntegralityReportVO(function (data) {
			// console.log(data);
			showSystemIntegralityReprot(data);
		});
		
		//加载系统阶段性报表
		CAPReportAction.queryPhasedReportVO(null,function (data) {
			showReport({"caption":"阶段性资源统计", "xaxisName":"月份"}, data, function (myChart) {
				myChart.render("phasedChart");
				phasedChart = myChart;
			});
		});

		//加载系统模块资源报表
		CAPReportAction.queryModuleReportVO(null,function (data) {
			showReport({"caption":"项目模块复杂度分析"}, data, function (myChart) {
				myChart.render("moduleChart");
				moduleChart = myChart;
			});
		});
	
	});
	
	/**
	 * 显示阶段性资源统计报表或者项目模块复杂度分析报表
	 * @param  chartSetting     chart属性设置
	 * @param  reportVOMap 需要展示的数据
	 * @param  renderFn    render回调方法
	 * @return FusionCharts Object chart对象
	 */
	function showReport(chartSetting, reportVOMap, renderFn) {
		var category = [];
		var entityCountArray = [],pageCountArray = [],flowCountArray = [],serviceCountArray = [];
		//构建chartData数据
		$.each(reportVOMap, function(key, reportVO) {
			category.push({"label": key});
			entityCountArray.push({"value":reportVO.entityCount});
			pageCountArray.push({"value":reportVO.pageCount});
			flowCountArray.push({"value":reportVO.flowCount});
			serviceCountArray.push({"value":reportVO.serviceCountArray});
		});

		//默认的chart setting
		var defaulSetting = {
			"showpercentagevalues": "1",
			// "caption": caption,
			"chartrightmargin": "45",
			"bgcolor": "FFFFFF,B8D288",
			"showshadow": "1",
			"borderalpha": "50",
			"bgalpha": "100,100",
			"showvalues": "1",
			"legendBorderAlpha":"0",
			"useRoundEdges":"1",
			// "xaxisName":"月份",
			"palette":"2"
		};
		var myChartData = {
			"chart": $.extend(defaulSetting, chartSetting),
			"categories": [{"category": category}],
		  	"dataset": [
			    {
			      "seriesname": "实体",
				  "color": "69C6FF",
			      "data": entityCountArray
			    },
			    {
			      "seriesname": "界面",
				  "color": "D46659",
			      "data": pageCountArray
			    },
			    {
			      "color": "ECA538",
			      "seriesname": "流程",
			      "data": flowCountArray
			    },
			    {
			      "color": "ECA538",
			      "seriesname": "服务",
			      "data": serviceCountArray
			    }
		  	],
		  	"styles":{
		    	"definition":[
		    		{
				        "name":"myLabelFont",
				        "type":"font",
				        "size":"12",
				        "font":'Arial',
				        "color":"090909"
			      	},
			      	{
				        "name":"myToolTip",
				        "type":"font",
				        "size":"12",
				        "font":'Arial',
				        "color":"090909",
				        "BgColor":"F4F7E5"
			      	}
		    	],
		    	"application":[
		    		{
			        	"toobject":"DataLabels",
			        	"styles":"myLabelFont"
		      		},
		      		{
			        	"toobject":"ToolTip",
			        	"styles":"myToolTip"
		      		}
		    	]
		    }
		};
		var myChart = new FusionCharts(webPath+"/cap/bm/common/fusioncharts/Charts/ScrollStackedColumn2D.swf", "chart"+Math.random(), "100%", "100%", "0", "0");
		myChart.setJSONData(myChartData);
		if(renderFn) {
			renderFn(myChart);	
		}
		return myChart;		
	}

	/**
	 * 显示系统整体资源图
	 * @param  data 报表数据
	 */
	function showSystemIntegralityReprot(reportVO) {
		var myChartData = {
		    "chart": {
		    "showpercentagevalues": "1",
		    "caption": "系统整体资源情况",
		    "chartrightmargin": "45",
		    "bgcolor": "FFFFFF,B8D288",
		    "chartleftmargin": "50",
		    "charttopmargin": "35",
		    "chartbottommargin": "20",
		    "showplotborder": "0",
		    "showshadow": "1",
		    "showborder": "1",
		    // "bordercolor": "0080FF",
		    "borderalpha": "50",
		    "bgalpha": "100,100",
		    "labelFont": "Arial",
	        "labelFontColor": "0075c2",
	        "labelFontSize": "15",
			"showvalues": "1",
			"paletteColors": "#DA3608,#F2C500,#2C560A,#4C9ED4"
		  },
		  "data": [
		    {
		      "value": reportVO.entityCount,
		      "label": "实体("+reportVO.entityCount+")"
		    },
		    {
		      "value": reportVO.pageCount,
		      "label": "界面("+reportVO.pageCount+")"
		    },
		    {
		      "value": reportVO.serviceCount,
		      "label": "服务("+reportVO.serviceCount+")"
		    },
		    {
		      "value": reportVO.flowCount,
		      "label": "流程("+reportVO.flowCount+")"

		    }
		  ],
		  "styles":{
		    "definition":[{
		        	"name":"myLabelFont",
			        "type":"font",
			        "size":"12",
			        "color":"090909",
		    	},
        		{
		  	        "name":"myToolTip",
		  	        "type":"font",
		  	        "size":"12",
		  	        "font":'Arial',
		  	        "color":"090909",
		  	        "BgColor":"F4F7E5"
        		}
		    ],
		    "application":[{
		        	"toobject":"DataLabels",
		        	"styles":"myLabelFont"
		    	},
	      		{
		        	"toobject":"ToolTip",
		        	"styles":"myToolTip"
	      		}
		    ]
		  }
		};

		systemIntegralityChart = new FusionCharts(webPath+"/cap/bm/common/fusioncharts/Charts/Doughnut2D.swf",
		"systemIntegrality", "100%", "100%", "0");
		systemIntegralityChart.setJSONData(myChartData);
		systemIntegralityChart.render("systemIntegralityChart");
	}
</script>
</body>
</html>