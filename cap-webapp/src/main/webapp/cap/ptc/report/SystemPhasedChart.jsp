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
<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
<title>阶段性资源变化统计</title>
</head>
<style type="text/css">
	#phasedChart {
		width: 100%;
		height: 300px;
	}
	#seachCondition {
		width: 100%;
		/*height: 40px;*/
		margin:0 auto;
		text-align: center;
	}
</style>
<body>
<div id="seachCondition">
	<p></p>
	<span>
		<div id="queryType" uitype="RadioGroup" value="0" name="queryType" on_change="changeQueryType" databind="reportCondition.queryType">
			<input type="radio" value="0" />周
			<input type="radio" value="1" />月份
			<!-- <input type="radio" value="2" />季度 -->
		</div>
	</span>
	<span uitype="PullDown" mode="Single" value_field="id" label_field="employeeName"  width="80px" datasource="getCreateData" id="createrId" name="createrId" databind="reportCondition.createrId"></span>
	<span uitype="Calender" id="startTime" width="120px" name="startTime" maxdate="#endTime" databind="reportCondition.startTime"></span> 
	- <span uitype="Calender" id="endTime" name="endTime" width="120px" databind="reportCondition.endTime" mindate="#startTime"></span>
	<!-- <span id="calender6" uitype="Calender"  width="150px" isrange="true" format="yyyy-MM"></span> -->
	<span uitype="Button" label="确定" button_type="blue-button" icon="" on_click="queryChart"></span>
	<p></p>
</div>
<div id="phasedChart">
</div>
<top:script src="/top/js/jquery.js" />
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
<top:script src="/cap/dwr/engine.js" />
<top:script src="/cap/dwr/interface/CAPReportAction.js" />
<top:script src="/cap/dwr/interface/CapEmployeeAction.js" />
<top:script src="/cap/bm/common/fusioncharts/Charts/FusionCharts.js" />

<script type="text/javascript">
	var reportCondition;

	$(document).ready(function($) {
        var timeArray = getWeekRangeDate(4);
        reportCondition = {
			"queryType":0,
			"startTime":timeArray[0],
			"endTime":timeArray[1]
		};
		comtop.UI.scan("#seachCondition");
		
		queryPhasedReportVO(reportCondition);
		parent.resetPanelHeight("phasedChart");
	});

	/**
	 * 点击确定按钮时调用方法
	 */
	function queryChart () {
		var data = cui(reportCondition).databind().getValue();
		data.startTime = cui("#startTime").getValue('date');
		data.endTime = cui("#endTime").getValue('date');
		// console.log(data);
		queryPhasedReportVO(data);
	}

	/**
	 * 查询阶段性报表数据并展示报表
	 * @param condition 查询条件对象
	 */
	function queryPhasedReportVO (condition) {
		// debugger
		//加载系统阶段性报表
		// dwr.TOPEngine.setAsync(true);
		CAPReportAction.queryPhasedReportVO(condition,function (data) {
			// if($.isEmptyObject(data)) {
			// 	$("#phasedChart").css("height","100px");
			// }
			showChart(builderChartJSONData({}, data));
		});
	}


	/**
	 * change query type event
	 */
	function changeQueryType (value) {
		var timeArray;
		if(value === '0') {
			timeArray = getWeekRangeDate(4);
			
		}else {
			timeArray = getMonthRangeDate(4);
		}
		cui("#startTime").setValue(timeArray[0]);
		cui("#endTime").setValue(timeArray[1]);
	}

	/**
	 * 获取从现在开始往前n周的时间
	 * @param  int n 前几周
	 * @return [startDate,endDate]	起止时间
	 */
    function getWeekRangeDate (n) {
        //起止日期数组
        var startStop = new Array();
        //获取当前时间
        var currentDate = new Date();
        //获得当前月份0-11
        var currentMonth = currentDate.getMonth();
        //获得当前年份4位年
        var currentYear = currentDate.getFullYear();
        var currentDay = currentDate.getDate();
        var lastDay = new Date(currentYear, currentMonth, currentDay);

        // 1周的毫秒数
        var millisecond = 1000 * 60 * 60 * 24 * 7;
        var firstDay = new Date(lastDay.getTime() - millisecond * n);
		startStop.push(firstDay);
        startStop.push(lastDay);
        //返回
        return startStop;
    };

	/**
	 * 获取从现在开始往前n个月的时间
	 * @param  int n 前几月
	 * @return [startDate,endDate]	起止时间
	 */
    function getMonthRangeDate (n) {
    	n--;
    	//起止日期数组
        var startStop = new Array();
        //获取当前时间
        var currentDate = new Date();
        //获得当前月份0-11
        var currentMonth = currentDate.getMonth();
        //获得当前年份4位年
        var currentYear = currentDate.getFullYear();
       
        if(currentMonth - n < 0) {	//跨年
        	currentYear --;
        	currentMonth = 12 + currentMonth - n;
        }else {
        	currentMonth = currentMonth - n;
        }
        var firstDay = new Date(currentYear, currentMonth, 1);

        //获得当前月份0-11
        currentMonth = currentDate.getMonth();
        //获得当前年份4位年
        currentYear = currentDate.getFullYear();
        //当为12月的时候年份需要加1
        //月份需要更新为0 也就是下一年的第一个月
        if (currentMonth == 11) {
            currentYear++;
            currentMonth = 0; //就为
        } else {
            //否则只是月份增加,以便求的下一月的第一天
            currentMonth++;
        }
        //下月的第一天
        var millisecond = 1000 * 60 * 60 * 24;

        var nextMonthDayOne = new Date(currentYear, currentMonth, 1);
        //求出上月的最后一天
        var lastDay = new Date(nextMonthDayOne.getTime() - millisecond);

        
        startStop.push(firstDay);
        startStop.push(lastDay);
        //返回
        return startStop;
    }

	/**
	 * 获取create Data
	 */
	function getCreateData (obj) {
		CapEmployeeAction.queryEmployeeListNoPage(null, function (data) {
			// console.log(data);
			obj.setDatasource(data);
		})
	}

	function getCount (reportVO) {
		return reportVO.entityCount + reportVO.pageCount + reportVO.flowCount + reportVO.serviceCount;
	}

	/**
	 * 显示阶段性资源统计报表或者项目模块复杂度分析报表
	 * @param  chartSetting     chart属性设置
	 * @param  reportVOMap 需要展示的数据
	 * @return chart报表属性以及数据对象
	 */
	function builderChartJSONData (chartSetting, lstReportVO) {
		var category = [];
		var entityCountArray = [],pageCountArray = [],flowCountArray = [],serviceCountArray = [];
		var changeIncreaseArray = [];
		//构建chartData数据
		$.each(lstReportVO, function(index, reportVO) {
			category.push({"label": reportVO.axisName});
			entityCountArray.push({"value":reportVO.entityCount});
			pageCountArray.push({"value":reportVO.pageCount});
			flowCountArray.push({"value":reportVO.flowCount});
			serviceCountArray.push({"value":reportVO.serviceCount});
			if(index === 0) {
				changeIncreaseArray.push({"value" : getCount(reportVO)});
			} else {
				changeIncreaseArray.push({"value" : getCount(reportVO) - changeIncreaseArray[(index - 1)].value});
			}
		});

		//默认的chart setting
		var defaulSetting = {
		    // "caption": "Cost Analysis",
		    // "numberprefix": "$",
		    // "xaxisname": "Quarters",
		    // "yaxisname": "Cost",
		    "bgcolor": "FFFFFF,FFFFFF",
			"showvalues": "0",		//柱形图里不显示实体、界面、流程、服务数
		    "showsum": "1",
		    // "decimals": "0",
		    "legendborderalpha": "0",
		    "baseFontSize":"12",
		    "useroundedges": "0",
		    "plotGradientColor":"",
		    "paletteColors": "#5cacfa,#90d451,#cdd229,#fe9191,#008E8F"
		};
		return {
			"chart": $.extend(defaulSetting, chartSetting),
			"categories": [{"category": category}],
		  	"dataset": [
			    {
			      "seriesname": "实体",
				  // "color": "5cacfa",
			      "data": entityCountArray
			    },
			    {
			      "seriesname": "界面",
				  // "color": "90d451",
			      "data": pageCountArray
			    },
			    {
			      // "color": "cdd229",
			      // "renderas": "Line",
			      "seriesname": "流程",
			      "data": flowCountArray
			    },
			    {
			      // "color": "fe9191",
			      "seriesname": "服务",
			      "data": serviceCountArray
			    },
			    {
			    	"renderas": "Line",
			      	"seriesname": "环比增长",
			      	"data": changeIncreaseArray
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
	}


	/**
	 * 根据给定的chart data显示阶段性资源统计报表
	 * @param  myChartData     chart报表属性数据
	 * @return FusionCharts Object chart对象
	 */
	function showChart (myChartData) {
		var myChart = FusionCharts("phased");
		if(myChart) {
			myChart.setJSONData(myChartData);	//更新报表
		}else {
			myChart = new FusionCharts(webPath+"/cap/bm/common/fusioncharts/Charts/StackedColumn2DLine.swf", "phased", "100%", "100%", "0", '1', '');
			myChart.setJSONData(myChartData);
			myChart.configure("ChartNoDataText", "暂时没有数据显示.");
			myChart.render("phasedChart");
		}
		return myChart;
	}
</script>
</body>
</html>