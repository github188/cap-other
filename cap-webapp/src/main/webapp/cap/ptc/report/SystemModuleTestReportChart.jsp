<%
  /**********************************************************************
	* 系统模块测试报表页面
	* 2016-9-7 诸焕辉 
	* fusioncharts参考文档目录：CAP\BM\07_Training\技术类\图形化报表\FusionCharts_XT_Enterprise\（starTeam）
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>系统模块测试报表</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="x-ua-compatible" content="IE=edge">
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:script src="/top/js/jquery.js" />
		<top:script src="/cap/bm/test/js/jct.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/bm/common/fusioncharts/Charts/FusionCharts.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/interface/TestResultAnalyseAction.js" />
	</head>
	<style type="text/css">
		body {
			overflow-y: hidden;
		}
		.statistical-report {
			text-align: center;
		}
		.detail-report {
			display: none;
		}
		.repository-lang-stats-graph {
			display: table;
			width: 100%;
			height: 20px;
			overflow: hidden;
			white-space: nowrap;
			cursor: pointer;
			-webkit-user-select: none;
			-moz-user-select: none;
			-ms-user-select: none;
			user-select: none;
			border: 1px solid #ddd;
			border-top: 0;
		}
		.repository-lang-stats-graph .language-color {
			display: table-cell;
			line-height: 20px; 
			text-indent: -9999px;
			text-align: center;
			font-size: 10px;
			text-indent: -9999px;
		}
		.color-state {
			display: inline;
			color: #39c;
		}
		.detail-report .top-area {
			margin: 10px 0 8px 0;
		    border-left: solid 6px #f0f0f0;
			font-size: 15px;
			font-family: Verdana;
			padding: 0 20px 0 2px;
			font-weight: bold;
			color: #555;
			text-align: left;
		}
		/* 表头固定内容滚动的表格  */
		.scroll {max-height:483px;overflow-y:auto;border-bottom:1px solid #ddd;}
		.grid{
			width: 100%;
			table-layout: fixed;
			border-collapse: collapse;
			color: #333;
			font-size: 12px;
			text-align: center;
		}
		.grid th,.scroll .grid td{width:180px;padding:10px;border:1px solid #ddd;}
		.grid th{font-weight:bold; background:#eee;}
		.grid thead th:last-child,.scroll tbody td:last-child{width:auto;}
		.scroll .grid tbody tr:first-child td{border-top:0;}
	</style>
	<body>
		<div class="statistical-report">
			<div id="seachCondition" style="padding: 0 0 8px 0;">
				<span>
					<div id="queryType" uitype="RadioGroup" name="queryType" value="0" databind="reportCondition.queryType">
						<input type="radio" name="queryType" value="0"/>周
						<input type="radio" name="queryType" value="1"/>月份
					</div>
				</span>
				<span uitype="Calender" id="startTime" width="120px" name="startTime" mindate="-3M" maxdate="#endTime" databind="reportCondition.startTime"></span> 
				- <span uitype="Calender" id="endTime" name="endTime" width="120px" databind="reportCondition.endTime" mindate="#startTime" maxdate="-0d"></span>
				<span uitype="Button" label="确定" button_type="blue-button" icon="" on_click="querySatisticalReport"></span>
			</div>
			<div id="lineChart" class="system-module"></div>
			<div id="stackedBar2DChart" class="application-module"></div>
		</div>
	    <div class="detail-report">
	    	<div class="top-area"><span id="title"></span><span class="cui-icon" title="返回" style="position:absolute;top:10px;right:4px;font-size:12pt;color:#545454;cursor:pointer;padding-right:5px;" onclick="switchReportChart('statistical')">&#xf112;</span></div>
			<div class="func-module">
				<table class="grid">
					<thead>
						<tr>
							<th>元数据</th>
							<th>功能</th>
							<th>测试结果
								<div class="color-state">
									（<span class="cui-icon" style="color: #32cd32;font-size:6px;">&#xf0c8;</span>成功
									&nbsp;<span class="cui-icon" style="color: #ff0000;font-size:6px;">&#xf0c8;</span>失败）
								</div>
							</th>
						</tr>
					</thead>
				</table>
				<div class="scroll">
					<table class="grid">
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--模板-->
		<script id="detailReportTemplate" type="text/template">
		<!---
			for(var i=0, len = this.detailRepDatasource.length; i<len; i++){
				var _data = this.detailRepDatasource[i];
				for(var j=0, len2 = _data.dataList.length; j<len2; j++){
				var funcModuleData = _data.dataList[j];
		-->
			<tr>
				<!---
					if(j == 0){
				-->
				<td rowspan="+-len2-+">+-_data.metaName-+</td>
				<!---
					}
				-->
				<td>+-funcModuleData.funcName-+</td>
				<td align="center" style="padding:5px;">
					<div class="repository-lang-stats-graph js-toggle-lang-stats">
						<span class="language-color" style="width: 100%; background-color: #<!--- if(funcModuleData.pass){ -->32cd32<!--- } else { -->ff0000<!--- }  -->;" title="成功"></span>
					</div>
				</td>
			</tr>
    	<!---
				}	
			} 
		-->
		</script>
		
		<script type="text/javascript">
			var reportCondition, systemModuleReport = [], modulesReport = {};
			//初始化数据
			function init(){
				var weekIndex = getWeekIndex(new Date());
				var startTime = "", diffNum = weekIndex - 3;
				if(diffNum >= 0 ){
					startTime = getBeginDateOfWeek(new Date().getFullYear(), weekIndex - 3);
				} else {
					var oldYear = new Date().getFullYear() - 1;
					startTime = getBeginDateOfWeek(oldYear, getCycleNum(oldYear) + diffNum);
				}
				reportCondition = {queryType: "0", startTime: startTime, endTime: formatDate(new Date())};
		    }
			
			//获取统计报表数据
			function querySatisticalReport(){
				queryPhasedReport(reportCondition);
				if(systemModuleReport.length > 0){
					queryModuleReport(systemModuleReport[systemModuleReport.length-1].id);
				}
			}
			
			//切换报表图
			function switchReportChart(type){
				if(type == "statistical"){
					$(".statistical-report").show();
					$(".detail-report").hide();
				} else {
					$(".detail-report").show();
					$(".statistical-report").hide();
				}
			}
			
			$(document).ready(function($) {
				init();
				querySatisticalReport();
				comtop.UI.scan("#seachCondition");
				$(window).resize(function(){
	    			resizeTableCellWidth();
	    		});
			});
			
			/**
			 * 获取系统总体模块阶段性的统计数据
			 * @param condition 查询条件
			 */
			function queryPhasedReport(condition){
				var startAry = condition.startTime.split(/-/);
				var endAry = condition.endTime.split(/-/);
				var startYear = parseInt(startAry[0]);
				var endYear = parseInt(endAry[0]);
				var startMonth = parseInt(startAry[1]);
				var endMonth = parseInt(endAry[1]);
				var diffYearNum = endYear - startYear;
				if(condition.queryType === "1"){
					systemModuleReport = queryTestResultStatisticsByMonth(condition);
					var axisNameVOs = genAxisNameVOs(startYear, endYear, startMonth, endMonth, '{"year": {year}, "month": {startMonthOrWeek}, "axisName": "{year}年{startMonthOrWeek}月"}', 12);
					var sysRoperts = [];
					$.each(axisNameVOs, function(key, axisNameVO) {
						var startTime = axisNameVO.year + '-' + axisNameVO.month + '-' + (axisNameVO.year == startYear && startMonth == axisNameVO.month ? startAry[2] : "1");
					    var endTime = axisNameVO.year + '-' + axisNameVO.month + '-' + (axisNameVO.year == endYear && endMonth == axisNameVO.month ? endAry[2] : getMonthEndDate(axisNameVO.year, axisNameVO.month));					
						var report = {id: key, startTime: startTime, endTime: endTime, axisName: axisNameVO.axisName, passCount: 0, failCount: 0};
						var obj = find(systemModuleReport, 'axisName', axisNameVO.axisName);
						if(obj){
							report.passCount = obj.passCount;
							report.failCount = obj.failCount;
						}
						sysRoperts.push(report);
					});
					systemModuleReport = sysRoperts;
				} else {
					systemModuleReport = queryTestResultStatisticsByWeek(condition);
					var startWeekIndex = getWeekIndex(new Date(Date.parse(condition.startTime.replace(/-/g, "/"))));
					var endWeekIndex = getWeekIndex(new Date(Date.parse(condition.endTime.replace(/-/g, "/"))));
					var axisNameVOs = genAxisNameVOs(startYear, endYear, startWeekIndex, endWeekIndex, '{"year": {year}, "weekIndex": {startMonthOrWeek}, "axisName": "第{startMonthOrWeek}周"}', getCycleNum(startYear));
					var sysRoperts = [];
					$.each(axisNameVOs, function(key, axisNameVO) {
						var startTime = key == 0 ? reportCondition.startTime : getBeginDateOfWeek(axisNameVO.year, axisNameVO.weekIndex);
						var endTime = key == axisNameVOs.length - 1 ? reportCondition.endTime : getEndDateOfWeek(axisNameVO.year, axisNameVO.weekIndex);
						var report = {id: key, startTime: startTime, endTime: endTime, axisName: axisNameVO.axisName, passCount: 0, failCount: 0};
						var obj = find(systemModuleReport, 'axisName', axisNameVO.weekIndex + "");
						if(obj){
							report.passCount = obj.passCount;
							report.failCount = obj.failCount;
						}
						sysRoperts.push(report);
					});
					systemModuleReport = sysRoperts;
				}
				showPhasedLineChart(builderLineChartJSONData({}, systemModuleReport));
			}
			
			function find(ary, key, val){
				var ret;
				for(var i=0, len=ary.length; i<len; i++){
					if(ary[i][key] === val){
						ret = ary[i];
					}
				}
				return ret;
			}
			
			function genAxisNameVOs(startYear, endYear, startMonthOrWeek, endMonthOrWeek, strJsonExpr, cycleNum) {
				var diffYearNum = endYear - startYear;
				var axisNameVOs = [JSON.parse(strJsonExpr.format({year: startYear, startMonthOrWeek: startMonthOrWeek}))];
				if(diffYearNum == 0 && startMonthOrWeek < endMonthOrWeek){ //当前年，且跨周
					var diffNum = endMonthOrWeek - startMonthOrWeek;
					var i = 1;
					while(diffNum){
						axisNameVOs.push(JSON.parse(strJsonExpr.format({year: startYear, startMonthOrWeek: startMonthOrWeek + i})));
						diffNum--;
						i++;
					}
				} else if(diffYearNum > 0){ //跨年
					//前一年
					var diffNum = cycleNum - startMonthOrWeek, i = 1;
					while(diffNum){
						axisNameVOs.push(JSON.parse(strJsonExpr.format({year: startYear, startMonthOrWeek: startMonthOrWeek + i})));
						diffNum--;
						i++;
					}
					//当前年
					i = 1;
					diffNum = endMonthOrWeek;
					while(diffNum){
						axisNameVOs.push(JSON.parse(strJsonExpr.format({year: endYear, startMonthOrWeek: i})));
						diffNum--;
						i++;
					}
				}
				return axisNameVOs;
			}
			
			//按周查询
			function queryTestResultStatisticsByWeek(condition){
				var ret = null;
				dwr.TOPEngine.setAsync(false);
				TestResultAnalyseAction.queryTestResultStatisticsByWeek(condition, function (data) {
					ret = data;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
			}
			
			//按月查询
			function queryTestResultStatisticsByMonth(condition){
				var ret = null;
				dwr.TOPEngine.setAsync(false);
				TestResultAnalyseAction.queryTestResultStatisticsByMonth(condition, function (data) {
					ret = data;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
			}
			
			/**
			 * 获取某个时间点的系统模块测试报表
			 * @param id 
			 * @param 
			 */
			function queryModuleReport(id){
				var condition = {}, axisName = "";
				for(var i=0, len=systemModuleReport.length; i<len; i++){
					if(systemModuleReport[i].id == id){
						condition = {startTime: systemModuleReport[i].startTime, endTime: systemModuleReport[i].endTime, top: 10};
						axisName = systemModuleReport[i].axisName;
						break;
					}
				}
				dwr.TOPEngine.setAsync(false);
				TestResultAnalyseAction.queryTopTestResultStatistics(condition, function (data) {
					modulesReport = {startTime: condition.startTime, endTime: condition.endTime, dataList: data};
				});
				dwr.TOPEngine.setAsync(true);
				if(modulesReport.dataList.length > 0){
					showModuleStackedBar2DChart(builderStackedBar2DChartJSONData({caption: "【" + axisName + "】系统模块质量排名{BR}（质量最差的TOP10）"}, modulesReport));
				} else {
					var myChart = FusionCharts("module");
					if(myChart) {
						myChart.dispose();
					}
					parent.$("#testChart").height(295);
				}
			}
			
		   	//更改浏览器大小时，重新渲染表格单元格宽度   
		   	function resizeTableCellWidth(){
		   		$(".scroll").css("max-height", 490 - (10 - modulesReport.dataList.length)*20 + "px");
		   		$.each($(".grid th,.scroll .grid tr:first-child td").not("th:last-child,td:last-child"), function(index, tdObj) {
    				$(tdObj).width($("body").width()/4);
    			});
		   	}
			
			/**
			 * 根据系统模块Id，显示当前系统下的应用模块测试用例报表（明细报表）
			 * @param appNameIndex
			 */
			function showDetailReportChart(appNameIndex){
				var detailRepDatasource = [];
				var condition = {startTime: modulesReport.startTime, endTime: modulesReport.endTime, appFullName: modulesReport.dataList[appNameIndex].appFullName};
				$.each(groupBy(queryDetailReport(condition), 'metaName'), function(key, data) {
					if(key != 'null'){
						detailRepDatasource.push({metaName: key, dataList: data});
					}
				});
				$(".detail-report #title").html("【" + modulesReport.dataList[appNameIndex].appName + "】<font size='2' color='#aaa'>（统计时间段：" + condition.startTime + "~" + condition.endTime + "）</font>");
				var jct = new jCT($('#detailReportTemplate').html());
				jct.detailRepDatasource = detailRepDatasource;
	        	$(".grid tbody").html(jct.Build().GetView());
	        	switchReportChart("detail");
				//更改浏览器大小时，重新渲染表格结构是数据表格宽度未重新渲染bug
				setTimeout(resizeTableCellWidth, 0);
			}
			
			/**
			 * 数组对象分组函数
			 * @param ary 数组对象
			 * @param key 分组字段名称
			 */
			function groupBy(ary, key){
				var groupObj = {};
				$.each(ary, function(index, obj) {
					if(groupObj[obj[key]]){
						groupObj[obj[key]].push(obj);
					} else {
						groupObj[obj[key]] = [obj]
					}
				});
				return groupObj;
			}
			
			/**
			 * 根据系统模块Id，获取当前系统下的应用模块测试用例报表信息
			 * @param conditon 查询条件
			 */
			function queryDetailReport(condition){
				var datasource = [];
				dwr.TOPEngine.setAsync(false);
				TestResultAnalyseAction.queryTestResultStatisticsByModule(condition, function (data) {
					datasource = data;
				});
				dwr.TOPEngine.setAsync(true);
				return datasource;
			}
			
			/**
			 * 构建图表数据
			 * @param chartSetting chart属性设置
			 * @param lstReportVO 需要展示的数据
			 * @return chart报表属性以及数据对象
			 */
			function builderLineChartJSONData(chartSetting, lstReportVO) {
				var dataset = [];
				$.each(lstReportVO, function(index, reportVO) {
					var totalCount = reportVO.passCount+reportVO.failCount;
					var value = reportVO.passCount != 0 ? toDecimal(reportVO.passCount/(totalCount)*100) : 0;
					var toolText = reportVO.axisName + (totalCount == 0 ? "未执行测试" : "（总测试："+totalCount+"次，成功："+reportVO.passCount+"次，失败："+reportVO.failCount+"次，通过率："+value+"%）");
					dataset.push({label: reportVO.axisName, value: value, link: "javascript:queryModuleReport(" + reportVO.id + ")", toolText: toolText});
				});
				//默认的chart setting
				var defaulSetting = {
						"caption": "质量趋势图统计",
				    	"bgcolor": "FFFFFF,FFFFFF",
					    "baseFontSize":"12",
					    "useroundedges": "0",
					    "yaxismaxvalue": "100",
					    "decimals": "2",
					    "numbersuffix": "%",
				    	"canvaspadding": "25",
				        "showlabels": "1",
				        "showcolumnshadow": "1",
				        "showalternatehgridcolor": "1",
				        "divlinecolor": "ff5904",
				        "divlinealpha": "20",
				        "linecolor": "FF5904",
				        "lineThickness": "2",
				        //"rotatevalues": "1",
				        "showvalues": "1"
				};
				return {
					  	"chart": $.extend(defaulSetting, chartSetting),
					  	"data": dataset
					};
				
			}
		
			/**
			 * 构建图表数据
			 * @param chartSetting chart属性设置
			 * @param reportVO 需要展示的数据
			 * @return chart报表属性以及数据对象
			 */
			function builderStackedBar2DChartJSONData(chartSetting, reportVO) {
				var category = [];
				var passData = [], failData = [];
				//构建chartData数据
				$.each(reportVO.dataList, function(index, data) {
					var pass = toDecimal(data.passCount/(data.passCount+data.failCount)*100);
					var toolText = data.appName+"（总测试："+(data.passCount+data.failCount)+"次，成功："+data.passCount+"次，失败："+data.failCount+"次，通过率："+pass+"%）";
					var link = "javascript:showDetailReportChart(" + index + ")";
					category.push({label: data.appName});
					passData.push({value: pass, toolText: toolText, link: link});
					failData.push({value: 100-pass, toolText: toolText, link: link});
				});
				var defaulSetting = {
						"bgcolor": "FFFFFF,FFFFFF",
						"yaxismaxvalue": "100",
					    "numbersuffix": "%",
				        "showsum": "0",
				        "showValues":"0",
				        "showyaxisvalues": "0",
				        "divlinealpha": "0",
				        "plotGradientColor":"",
				        "baseFontSize":"12",
				        "showborder": "1",
				        "canvasborderalpha": "0",
				        "paletteColors": "#32cd32,#ff0000",
				        "showPlotBorder": "0",
				        "alternateVGridColor": "FFFFFF"
				};
				return {
					"chart": $.extend(defaulSetting, chartSetting),
					"categories": [{"category": category}],
				  	"dataset": [
					    {
					      "seriesname": "成功",
					      "data": passData
					    },
					    {
					      "seriesname": "失败",
					      "data": failData
					    }
				  	]
				};
			}
			
			/**
			 * 阶段性统计系统总体应用模块测试通过率
			 * @param  myChartData chart报表属性数据
			 * @return FusionCharts Object chart对象
			 */
			function showPhasedLineChart(myChartData) {
				var myChart = FusionCharts("test");
				if(myChart) {
					myChart.setJSONData(myChartData);	//更新报表
				}else {
					createFusionCharts({chartSWF: webPath+"/cap/bm/common/fusioncharts/Charts/Line.swf", chartDOMId: "test", width: "100%", height: "206", debugMode: "0", registerWithJS: "1", bgColor:""}, myChartData, "lineChart");
				}
				return myChart;
			}
			
			/**
			 * 阶段性统计系统总体应用模块测试通过率
			 * @param  myChartData chart报表属性数据
			 * @return FusionCharts Object chart对象
			 */
			function showModuleStackedBar2DChart(myChartData) {
				var height = 300 - (10 - modulesReport.dataList.length)*20;
				var myChart = FusionCharts("module");
				if(myChart) {
					if(myChart && myChart.len != modulesReport.dataList.length){
						myChart.dispose();
						myChart = createFusionCharts({chartSWF: webPath+"/cap/bm/common/fusioncharts/Charts/StackedBar2D.swf", chartDOMId: "module", width: "100%", height: height + "", debugMode: "0", registerWithJS: "1", bgColor:""}, myChartData, "stackedBar2DChart");
						myChart.len = modulesReport.dataList.length;
						parent.$("#testChart").height(300 + height);
					} else {
						//myChart.resizeTo("100%", customHeight(modulesReport.dataList.length));有问题
						myChart.setJSONData(myChartData);	//更新报表
					}
				}else {
					myChart = createFusionCharts({chartSWF: webPath+"/cap/bm/common/fusioncharts/Charts/StackedBar2D.swf", chartDOMId: "module", width: "100%", height: height + "", debugMode: "0", registerWithJS: "1", bgColor:""}, myChartData, "stackedBar2DChart");
					myChart.len = modulesReport.dataList.length;
					parent.$("#testChart").height(300 + height);
				}
				return myChart;
			}
			
			/**
			 * 创建FusionCharts对象
			 * @param chartParams 构造函数入参值
			 * @param myChartData 图表数据对象
			 * @param renderId 模版id
			 * @return 图表对象
			 */
			function createFusionCharts(chartParams, myChartData, renderId){
				var myChart = new FusionCharts(chartParams.chartSWF, chartParams.chartDOMId, chartParams.width, chartParams.height, chartParams.debugMode, chartParams.registerWithJS, chartParams.bgColor);
				myChart.setJSONData(myChartData);
				myChart.configure("ChartNoDataText", "暂时没有数据显示.");
				myChart.render(renderId);
				return myChart;
			}
			
		    /**
			 * 保留两位小数(功能：将浮点数四舍五入，取小数点后2位 )
			 * @param x 数字值
			 */
		    function toDecimal(x) { 
				var f = parseFloat(x); 
				if (isNaN(f)) return; 
			    f = Math.round(x*100)/100; 
			    return f; 
		    }
		    
		    //格式化日期：yyyy-MM-dd      
			function formatDate(date) {       
			    var myyear = date.getFullYear();      
			    var mymonth = date.getMonth()+1;      
			    var myweekday = date.getDate();       
			    if(mymonth < 10){      
			        mymonth = "0" + mymonth;      
			    }       
			    if(myweekday < 10){      
			        myweekday = "0" + myweekday;      
			    }      
			    return (myyear+"-"+mymonth + "-" + myweekday);       
			}  
		    
			//获得某月的最后一天  
			function getMonthEndDate(year, month) {         
	            var new_year = year;    //取当前的年份          
	            var new_month = month++;//取下一个月的第一天，方便计算（最后一天不固定）          
	            if(month>12) {         
	              	new_month -=12;        //月份减          
	              	new_year++;            //年份增          
	            }         
	            var new_date = new Date(new_year,new_month, 1);                //取当年当月中的第一天          
	            return (new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月最后一天日期          
	        } 
			
			//获取某年某周的开始日期
			function getBeginDateOfWeek(paraYear, weekIndex){
				if(weekIndex == 1){
			    	return paraYear + "-1-1";
			    }
			    var firstDay = getFirstWeekBegDay(paraYear);
			    //7*24*3600000 是一星期的时间毫秒数,(JS中的日期精确到毫秒)
			    var time=(weekIndex-1)*7*24*3600000;
			    var beginDay = firstDay;
			    //为日期对象 date 重新设置成时间 time
			    beginDay.setTime(firstDay.valueOf()+time);
			    return formatDate(beginDay);
			}
			
			//获取某年某周的结束日期
			function getEndDateOfWeek(paraYear, weekIndex){
				if(weekIndex == getCycleNum(paraYear)){
			    	return paraYear + "-12-31";
			    }
			    var firstDay = getFirstWeekBegDay(paraYear);
			    //7*24*3600000 是一星期的时间毫秒数,(JS中的日期精确到毫秒)
			    var time=(weekIndex-1)*7*24*3600000;
			    var weekTime = 6*24*3600000;
			    var endDay = firstDay;
			    //为日期对象 date 重新设置成时间 time
			    endDay.setTime(firstDay.valueOf()+weekTime+time);
			    return formatDate(endDay);
			}
			 
			//获取日期为某年的第几周
			function getWeekIndex(dateobj) {
			    var firstDay = getFirstWeekBegDay(dateobj.getFullYear());
			    if (dateobj < firstDay) {
			      	firstDay = getFirstWeekBegDay(dateobj.getFullYear() - 1);
			    }
			    d = Math.floor((dateobj.valueOf() - firstDay.valueOf()) / 86400000);
			    return Math.floor(d / 7) + 1;  
			}
			
			//获取某年的第一天
			function getFirstWeekBegDay(year) {
			    var tempdate = new Date(year, 0, 1);
			    var temp = tempdate.getDay();
			    if (temp == 1){
			       return tempdate;
			    }
			    temp = temp == 0 ? 7 : temp;
			    tempdate = tempdate.setDate(tempdate.getDate() + (8 - temp));
			    return new Date(tempdate);   
			}
			
			//获取一年有几周
			function getCycleNum(year) {
				var totalDay = isLeapYear(year) ? 366 : 365;
				var firstWeekBegDay = getFirstWeekBegDay(year).getDate();
				return Math.ceil((totalDay-(firstWeekBegDay-1))/7);
			}
			
			//是否是闰年
			function isLeapYear(year){  
				return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);  
			}
			
			String.prototype.format = function(args) {
			    var result = this;
			    if (arguments.length > 0) {    
			        if (arguments.length == 1 && typeof (args) == "object") {
			            for (var key in args) {
			                if(args[key]!=undefined){
			                    var reg = new RegExp("({" + key + "})", "g");
			                    result = result.replace(reg, args[key]);
			                }
			            }
			        }
			        else {
			            for (var i = 0; i < arguments.length; i++) {
			                if (arguments[i] != undefined) {
			                    var reg = new RegExp("({[" + i + "]})", "g");
			                    result = result.replace(reg, arguments[i]);
			                }
			            }
			        }
			    }
			    return result;
			}
		</script>
	</body>
</html>