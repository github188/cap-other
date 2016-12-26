<%
  /**********************************************************************
	* 首页报表显示页面
	* 2015-9-22 杨赛 
	* fusioncharts参考文档目录：CAP\BM\07_Training\技术类\图形化报表\FusionCharts_XT_Enterprise\（starTeam）
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="x-ua-compatible" content="IE=edge">
<title>项目模块复杂度分析</title>
</head>
<style type="text/css">
	#moduleChart {
		width: 100%;
		height: 300px;
	}
</style>
<body>
<div id="moduleChart">	
</div>

<top:script src="/top/js/jquery.js" />
<top:script src="/cap/bm/common/fusioncharts/Charts/FusionCharts.js" />
<top:script src="/cap/dwr/engine.js" />
<top:script src="/cap/dwr/interface/CAPReportAction.js" />
<script type="text/javascript">
	var moduleChart;
	$(document).ready(function($) {
		//加载系统模块资源报表
		CAPReportAction.queryModuleReportVO(null, function (data) {
			moduleChart = showReport({"caption":"项目模块复杂度分析"}, data, function (myChart) {
				myChart.render("moduleChart");
			});
		});
	
	});
	
	/**
	 * 显示阶段性资源统计报表或者项目模块复杂度分析报表
	 * @param  chartSetting     chart属性设置
	 * @param  lstReportVO 需要展示的数据
	 * @param  renderFn    render回调方法
	 * @return FusionCharts Object chart对象
	 */
	function showReport(chartSetting, lstReportVO, renderFn) {
		var category = [];
		var entityCountArray = [],pageCountArray = [],flowCountArray = [],serviceCountArray = [];
		//构建chartData数据
		//只显示前8个
		$.each(lstReportVO, function(index, reportVO) {
			category.push({"label": reportVO.axisName});
			entityCountArray.push({"value":reportVO.entityCount});
			pageCountArray.push({"value":reportVO.pageCount});
			flowCountArray.push({"value":reportVO.flowCount});
			serviceCountArray.push({"value":reportVO.serviceCount});
		});

		//默认的chart setting
		var defaulSetting = {
			"bgcolor": "FFFFFF,FFFFFF",
	        // "bgAlpha": "100",
	        // "numDivLines": "4",
	        "showsum": "1",
	        "showValues":"0",
	        "canvasBgAlpha": "20",
	        //"canvasBgColor":"2F2F2F",
	        "plotGradientColor":"",
	        "baseFontSize":"12",
	        "showborder": "1",
	        "paletteColors": "#5cacfa,#90d451,#cdd229,#fe9191"
		};
		var myChartData = {
			"chart": $.extend(defaulSetting, chartSetting),
			"categories": [{"category": category}],
		  	"dataset": [
			    {
			      "seriesname": "实体",
				  // "color": "27DC85",
			      "data": entityCountArray
			    },
			    {
			      "seriesname": "界面",
				  // "color": "E9BA2B",
			      "data": pageCountArray
			    },
			    {
			      // "color": "9BC12B",
			      "seriesname": "流程",
			      "data": flowCountArray
			    },
			    {
			      // "color": "F09156",
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
		var myChart = new FusionCharts(webPath+"/cap/bm/common/fusioncharts/Charts/StackedBar2D.swf", "phased", "100%", "100%", "0", "0");
		myChart.setJSONData(myChartData);
		myChart.configure("ChartNoDataText", "暂时没有数据显示.");
		if(renderFn) {
			renderFn(myChart);
		}
		return myChart;
	}
</script>
</body>
</html>