window.comtop = window.comtop || {};
window.comtop.cap = window.comtop.cap || {};
var ChartUtils = window.comtop.cap.charts = window.comtop.cap.charts || {};

/**
 * 建立chart option 数据结构
 */
var OptionBuilder = ChartUtils.OptionBuilder = function(chartConfigId){
	var chartConfig = uiConfig[chartConfigId];
	var constants = ChartUtils.Constants;
	/** 转换器 */
	var convert = getConvert(chartConfig);
	
	this.build = function(data){
		var chartData = convertDataStruct(data);
		console.log(chartData);
		var option = convert.setData(chartData);
		console.log(option);
		return option;
	}
		
	function convertDataStruct(data){
		var chartData = {};
		chartData.data=data;
		chartData.properties=[];
		if(data && data.length && data.length > 1){
			var dataItem = data[0];
			for(var param in dataItem){
				chartData.properties.push(param);
			}
		}
		return chartData;
	}
	
	function getConvert(chartConfig){
		var type = chartConfig[constants.TYPE];
		if(type == "bar" || type == "line"){
			return new ChartUtils.BaseAxisConvert(chartConfig);
		}else if(type == "pie"){
			return new ChartUtils.BasePieConvert(chartConfig);
		}
	}
	
	return this;
};

/**
 * 转换器基础类
 */
ChartUtils.Convert = function(chartConfig){

	var current = ChartUtils.Convert.prototype;
	
	var constants = ChartUtils.Constants;
	/** 不需要转换到属性的配置 */
	var notConvertConfig = ChartUtils.NotConvertConfig;
	
	/** 通过配置生成option对象*/
	var option = this.option = {};
	loadConfig(chartConfig);
	
	current.validate = function(chartData){
		if(!chartData){
			return false;
		}
		if(chartData.properties === undefined){
			console.error("图表数据的properties属性必须设置");
			return false;
		}
		if(chartData.data === undefined){
			console.error("图表数据的data属性必须设置");
			return false;
		}
		return true;
	}
	
	function loadConfig (chartConfig){
		initOption(chartConfig);
		//共同的option设置
		setDefaultToolBox();
	}
	
	function setDefaultToolBox(){
		if(option.toolbox === undefined || option.toolbox.feature === undefined){//配置未设置toolbox
			option.toolbox = {
				show : true,
			    feature : {
			        dataView : {show: true, readOnly: false},
			        saveAsImage : {show: true}
			    }	
			};
		}
	}
	
	function initOption(chartConfig){
		for(name in chartConfig){
			if(notConvertConfig[name] === undefined){
				ChartUtils.convertProperty(option, name, chartConfig[name])
			}
		}
	}
	
}

ChartUtils.BaseAxisConvert = function(chartConfig){
	ChartUtils.Convert.call(this, chartConfig);
	var parent = ChartUtils.Convert.prototype;
	var current = ChartUtils.BaseAxisConvert.prototype;
	
	var constants = ChartUtils.Constants;
	var option = this.option;
	
	loadConfig (chartConfig);
	
	function loadConfig (chartConfig){
		setDefaultToolTip();
	}

	function setDefaultToolTip(){
		if(option.tooltip !== undefined){
			return;
		}
		option.tooltip = {
		    trigger: 'axis',
		    axisPointer : { 
		        type : 'shadow'//默认为直线，可选为：'line'|'shadow'
		    }
		}
	}
	
	current.setData = function(chartData){
		var valid = this.validate(chartData);
		if(!valid){
			console.error("参数值不合法chartData:");
			console.error(chartData);
			return null;
		}
		this.setLegend(chartData);
		this.setAxis(chartData);
		this.setSeries(chartData);
		return option;
	}
	
	/**
	 * 设置图例
	 */
	current.setLegend = function(chartData){
		var legendData = [];
		var axisName = chartConfig[constants.ASSOCIATED_NAME];
		for (var i = 0; i < chartData.properties.length; i++) {
			var pro = chartData.properties[i];
			if(pro != axisName){
				legendData.push(pro);
			}
		}
		option.legend = {
			data:legendData
		};
	}
	
	current.setAxis = function(chartData){
		var axisName = chartConfig[constants.ASSOCIATED_NAME];
		var axisData = [];
		
		for (var i = 0; i < chartData.data.length; i++) {
			var dataItem = chartData.data[i];
			axisData.push(dataItem[axisName]);
		}
		var categoryAxis = getAxis('category');
		var valueAxis = getAxis('value');
		valueAxis.max = 300;
		categoryAxis.data = axisData;
		option.yAxis = [];
		option.xAxis = [];
		if(chartConfig[constants.ORIENT] === false){
			option.xAxis.push(categoryAxis);
			option.yAxis.push(valueAxis);
		}else{
			option.xAxis.push(valueAxis);
			option.yAxis.push(categoryAxis);
		}
	}
	
	function getAxis(type){
		var axis = {type : type};
		for(name in chartConfig){
			if(!name.startWith('axis')){
				continue;
			}
			if(type === 'category' && (name === 'axis_max' 
				|| name === 'axis_interval' || name === 'axis_min')){
				continue;
			}
			
			var tmpName = name.substring(5);
			if(name === 'axis_max' || name === 'axis_interval' || name === 'axis_min'){
				ChartUtils.convertProperty(axis, tmpName, chartConfig[name], function(value){
					return parseInt(value);
				});
			}else{
				ChartUtils.convertProperty(axis, tmpName, chartConfig[name]);
			}
		}
		return axis;
	}
	
	current.setSeries = function(chartData){
		var series = [];
		for (var i = 0; i < option.legend.data.length; i++) {
			var legendName = option.legend.data[i];
			var sery = {};
			sery.name=legendName;
			sery.type=chartConfig[constants.TYPE];
			sery.data=[];
			
			for (var j = 0; j < chartData.data.length; j++) {
				var dataItem = chartData.data[j];
				sery.data.push(dataItem[legendName]);
			}
			series.push(sery);
		}
		option.series = series;
	}
	
	current.validate = function(chartData){
		var flag = parent.validate.call(this, chartData);
		
		if(!flag){
			return flag;
		}
		var xname = chartConfig[constants.XNAME];
		var yname = chartConfig[constants.YNAME];
		if(ChartUtils.isBlank(xname) && ChartUtils.isBlank(yname)){
			console.error("必须配置x轴名称(" + constants.XNAME + ")或y轴名称（" + constants.YNAME + ").");
			return false;
		}
		return true;
	}
}

ChartUtils.BasePieConvert = function(chartConfig){
	ChartUtils.Convert.call(this, chartConfig);
	var parent = ChartUtils.Convert.prototype;
	var current = ChartUtils.BasePieConvert.prototype;
	
	var constants = ChartUtils.Constants;
	var option = this.option;
	
	loadConfig (chartConfig);
	
	function loadConfig (chartConfig){
		console.log("ChartUtils.BaseAxisConvert loadConfig");
		setDefaultStyles();
	}
	
	function setDefaultStyles(){
		//设置默认样式
		var title = option.title || {};
		title.x = 'center';
		option.title = title;
		
		var legend = option.legend || {};
		legend.orient='vertical';
		legend.x='left';
		option.legend = legend;
	}
	
	current.setData = function(chartData){
		var valid = this.validate(chartData);
		if(!valid){
			console.error("参数值不合法chartData:");
			console.error(chartData);
			return null;
		}
		this.setLegend(chartData);
		this.setSeries(chartData);
		return option;
	}
	
	current.setLegend = function(chartData){
		var xname = chartConfig[constants.XNAME];
		var legendData = [];
		for (var i = 0; i < chartData.data.length; i++) {
			var dataItem = chartData.data[i];
			legendData.push(dataItem[xname]);
		}
		option.legend = option.legend || {};
		option.legend.data = legendData;
	}
	
	current.setSeries = function(chartData){
		var series = [];
		var sery = {//TODO
			name : "蒸发量",
			type : chartConfig[constants.TYPE],
			radius : ['45%', '30%'],//半径 可内半径 外半径
			center: ['30%', '40%']//坐标
		};
		sery.data=[];
		var xname = chartConfig[constants.XNAME];
		
		for (var i = 0; i < chartData.data.length; i++) {
			var dataItem = chartData.data[i];
			for(var pro in dataItem){
				if(pro != xname){
					sery.data.push({name: dataItem[xname], value: dataItem[pro]});
					break;
				}
			}
		}
		series.push(sery);
		option.series = series;
	}
	
	current.validate = function(chartData){
		var flag = parent.validate.call(this, chartData);
		
		if(!flag){
			return flag;
		}
		var xname = chartConfig[constants.XNAME];//TODO
		if(ChartUtils.isBlank(xname)){
			console.error("必须配置指标名称(" + constants.XNAME + ").");
			return false;
		}
		return true;
	}
}

ChartUtils.Constants = {
	SPLIT_CHAR : "_",
	
	TYPE : "charts_type",
	TITLE_TEXT : "title_text",
	TITLE_SUBTEXT : "title_subtext",
	ASSOCIATED_NAME : "assoName",
	ORIENT  : "showOrient"
}

ChartUtils.NotConvertConfig = {
	"data_subject" : 1, "assoName" : 1, "axis_axisTick_show" : 1, "axis_min" : 1, "axis_max" : 1, 
	"axis_axisLabel_show" : 1, "axis_splitLine_show": 1, "axis_interval": 1, "axis_axisLine_show":true,
	"width" : 1, "height" : 1, "charts_type" : 1, "axis_boundaryGap": 1, "uitype": 1, "initData_id": 1, 
	"initData": 1, "staticData" : 1, "showOrient" : 1,
}

ChartUtils.isBlank = function(str){
	if(str == "undefined" || str == "null" 
		|| str == ""){
		return true;
	}
	return false;
}

ChartUtils.convertProperty = function(obj, name, value, callback){
	var splitNames = name.split(ChartUtils.Constants.SPLIT_CHAR);
	var tmpObject = obj;
	for (var i = 0; i < splitNames.length; i++) {
		var splitName = splitNames[i];
		if(i < splitNames.length - 1){
			tmpObject[splitName] = tmpObject[splitName] || {};
			tmpObject = tmpObject[splitName];
		}else{
			if(callback !== undefined){
				tmpObject[splitName] = callback(value);
			}else{
				tmpObject[splitName] = value;
			}
		}
	}
}

String.prototype.startWith=function(str){  
    if(str==null||str==""||this.length==0||str.length>this.length)  
      return false;  
    if(this.substr(0,str.length)==str)  
      return true;  
    else  
      return false;  
}  
