<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible"content="IE=Edge">
<%
  /**********************************************************************
	* 首页报表显示页面
	* 2015-9-22 杨赛 
	* fusioncharts参考文档目录：CAP\BM\07_Training\技术类\图形化报表\FusionCharts_XT_Enterprise\（starTeam）
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="x-ua-compatible" content="IE=edge">
<title>系统整体资源情况</title>
</head>
<style type="text/css">
	#systemIntegralityChart {
		width: 100%;
		height: 400px;
	}

</style>
<body>
<div id="systemIntegralityChart">	
</div>

<top:script src="/top/js/jquery.js" />
<top:script src="/cap/bm/common/fusioncharts/Charts/FusionCharts.js" />
<top:script src="/cap/dwr/engine.js" />
<top:script src="/cap/dwr/interface/CAPReportAction.js" />
<script type="text/javascript">
	var systemIntegralityChart;	//系统整体资源报表
	$(document).ready(function($) {
		//加载系统整体资源报表
		CAPReportAction.querySystemIntegralityReportVO(function (data) {
			// console.log(data);
			systemIntegralityChart = showSystemIntegralityReprot(data);
		});
	});
	
	/**
	 * 显示系统整体资源图
	 * @param  data 报表数据
	 */
	function showSystemIntegralityReprot(reportVO) {
		var myChartData = {
			"chart": {
	    	    "showpercentageinlabel": "1",
	    	    "showvalues": "1",
	    	    "showlabels": "0",
	    	    "showlegend": "1",
	    	    "showpercentvalues": "1",
			    "showpercentagevalues": "1",
			    "caption": "系统整体资源情况{BR}模块总数(" + reportVO.moduleCount + ")",
			    "chartrightmargin": "45",
			    "bgcolor": "FFFFFF,FFFFFF",
			    "chartleftmargin": "50",
			    "charttopmargin": "35",
			    "chartbottommargin": "20",
			    "showplotborder": "0",
			    "showshadow": "1",
			    "showborder": "1",
			    // "bordercolor": "0080FF",
			    // "borderalpha": "50",
			    // "bgalpha": "100,100",
			    "labelFont": "Arial",
		        "labelFontColor": "0075c2",
		        "labelFontSize": "15",
		        "baseFontSize":"12",
				// "showvalues": "1"
				"paletteColors": "#5cacfa,#90d451,#cdd229,#fe9191"
			},
		  "data": [
		    {
		      	"value": reportVO.entityCount,
		      	// "color": "5cacfa",
		      	"label": "实体("+reportVO.entityCount+")"
		    },
		    {
		      	"value": reportVO.pageCount,
		      	// "color": "90d451",
		      	"label": "界面("+reportVO.pageCount+")"
		    },
		    {
				// "color": "cdd229",
				"value": reportVO.flowCount,
				"label": "流程("+reportVO.flowCount+")"
			},
		    {
		      	// "color": "fe9191",
		      	"value": reportVO.serviceCount,
		      	"label": "服务("+reportVO.serviceCount+")"
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
		FusionCharts.setCurrentRenderer('javascript');
		var myChart = new FusionCharts(webPath+"/cap/bm/common/fusioncharts/Charts/Pie2D.swf","systemIntegrality", "100%", "100%", "0", '1', '');
		myChart.setJSONData(myChartData);
		myChart.configure({"ChartNoDataText": "暂时没有数据显示.", "LoadingText": "数据加载中..."});
		myChart.render("systemIntegralityChart");
		return myChart;
	}
</script>
</body>
</html>