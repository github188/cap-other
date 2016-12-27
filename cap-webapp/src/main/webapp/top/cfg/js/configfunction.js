//验证数据有效性
function validationData(types,data){
	//if(types=="1"||types=="整型"){
	if(types=="1"||types=="\u6574\u578B"){
		var re=/^-?[0-9]\d*$/;
		if(!data.match(re)){
			//return "类型为整型的数据值必须是整数。<br>";
			return "\u7C7B\u578B\u4E3A\u6574\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u6574\u6570\u3002<br>";
		}
	//}else if(types=="2"||types=="浮点型"){
	}else if(types=="2"||types=="\u6D6E\u70B9\u578B"){
		var reg1=/^-?([0-9]\d*|0(?!\.0+$))\.\d+?$/;
		var reg2=/^-?[0-9]\d*$/;
		if(!(reg1.test(data) || reg2.test(data))){
			//return "类型为浮点型的数据值必须是浮点型。<br>";
			return "\u7C7B\u578B\u4E3A\u6D6E\u70B9\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u6D6E\u70B9\u578B\u3002<br>";
		}
	//}else if(types=="3"||types=="日期型"){
	}else if(types=="3"||types=="\u65E5\u671F\u578B"){
		
		var re = /^\d[19|20]\d{2}\-\d{1,2}\-\d{1,2}$/;
		if(!data.match(re)){
			//return "类型为日期型的数据值必须是日期类型。如 2010-1-2/2010-01-02<br>";
			return "\u7C7B\u578B\u4E3A\u65E5\u671F\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u65E5\u671F\u7C7B\u578B\u3002\u5982 2010-1-2/2010-01-02<br>";
		}else{
			var dateArray = data.split("-");
			if(parseInt(dateArray[1],10)>12){
				//return "值为'"+data+"'的日期类型数据月份不能超过12个月。<br>";
				return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u6708\u4EFD\u4E0D\u80FD\u8D85\u8FC7\u0031\u0032\u4E2A\u6708\u3002<br>";
			}
			//闰年
			if(parseInt(dateArray[0],10)%4==0){
				if(parseInt(dateArray[1],10)==2){
					if(parseInt(dateArray[2],10)>29){
						//return "值为'"+data+"'的日期类型数据闰年2月份天数不能超过29天。<br>";
						return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u95F0\u5E74\u0032\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0032\u0039\u5929\u3002<br>";
					}
				}
			}else{
				if(parseInt(dateArray[1],10)==2){
					if(parseInt(dateArray[2],10)>28){
						//return "值为'"+data+"'的日期类型数据平年2月份天数不能超过28天。<br>";
						return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u5E73\u5E74\u0032\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0032\u0038\u5929\u3002<br>";
					}
				}
			}
			var dateMonth = "1,3,5,7,8,10,12";
			var index = dateMonth.indexOf(parseInt(dateArray[1],10));
			if(index==-1){
				if(parseInt(dateArray[2],10)>30){
					//return "值为'"+data+"'的日期类型数据"+parseInt(dateArray[1],10)+"月份天数不能超过30天。<br>";
					return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0033\u0030\u5929\u3002<br>";
				}
			}else{
				if(parseInt(dateArray[2],10)>31){
					//return "值为'"+data+"'的日期类型数据"+parseInt(dateArray[1],10)+"月份天数不能超过31天。<br>";
					return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0033\u0031\u5929\u3002<br>";
				}
			}
			if(parseInt(dateArray[2],10)==0){
				//return "值为'"+data+"'的日期类型数据"+parseInt(dateArray[1],10)+"月份天数不能为0天。<br>";
				return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u4E3A\u0030\u5929\u3002<br>";
			}
		}
	//}else if(types=="4"||types=="布尔型"){
	}else if(types=="4"||types=="\u5E03\u5C14\u578B"){
		if(data!="true" && data!="false" && data!="TRUE" && data!="FALSE"){
			//return "类型为布尔型的数据值必须为布尔型。如 true/false<br>";
			return "\u7C7B\u578B\u4E3A\u5E03\u5C14\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u4E3A\u5E03\u5C14\u578B\u3002\u5982 true/false<br>";
		}
	}
	return "";
}

/*
*取值
*/
function getValue(){
	var jsonHead = [];
	//获取tabl对象
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var columns = table.rows[0].cells.length;
	
	for(var i=1;i<=count;i++){
		var hiddenObj = document.getElementById('hiddenValue'+i);
		if(hiddenObj){
			var innerText = hiddenObj.value;
			var texts = innerText.replace(new RegExp("<br>|\n|\r","gm"),"").split(",");
			var obj={attributeName:texts[0].split(":")[1],attributeCode:texts[1].split(":")[1],attributeType:texts[2].split(":")[1],columnNumber:i,lstConfigValueVO:[]};
			jsonHead.push(obj);
		}
	}
	for(var i=1;i<rows;i++){
		var defs;
		var def = table.rows[i].cells[0].getElementsByTagName("IMG")[1];
		if(def.src.search("undefault")=="-1"){
			defs ="1";
		}else{
			defs ="2";
		}
		var flag = true;
		for(var j=1;j<columns;j++){
			var td = table.rows[i].cells[j];
			if(td){
				var values = td.getElementsByTagName("INPUT")[0];
				var tValue = "";
				if(values!=""){
					tValue = values.value;
				}
				//获取属性值创建人
				var creatorIdInputElement = td.getElementsByTagName("INPUT")[1];
				var creatorId = "";
				if(creatorIdInputElement!=""){
					creatorId = creatorIdInputElement.value;
					if(!creatorId){
						creatorId = globalUserId;
					}
				}
				var objValue = {configItemValue:tValue,isDefaultValue:defs,rowNumber:i,creatorId:creatorId};
				//放入json对象中
				jsonHead[j-1].lstConfigValueVO.push(objValue);
			}
		}
	}
	return JSON.stringify(jsonHead);
}

//获取基本类型的json值
function getBaseValue(formdata){
	var jsonHead = [];
	var obj = {attributeName:formdata.configItemName,attributeCode:formdata.configItemFullCode,attributeType:'0',columnNumber:0,lstConfigValueVO:[]};
	jsonHead.push(obj);
	var configValue = '';
	if(formdata.configItemType == '3'){
		configValue = formdata.dateConfigValue;
	}else if(formdata.configItemType == '4'){
		configValue = formdata.booleanConfigValue;
	}else{
		configValue = formdata.configItemValue;
	}
	var objValue = {configItemValue:configValue,isDefaultValue:2,rowNumber:0};
	jsonHead[0].lstConfigValueVO.push(objValue);
	return JSON.stringify(jsonHead);
}

function validateValueField(){
	var msg = "";
	var jsonHead = [];
	//获取tabl对象
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var columns = table.rows[0].cells.length;
	//至少保留一个属性列
	if(columns<=1){
		//msg+="数据值区域至少应保留一个可填属性的列。<br>";
		msg+="\u6570\u636E\u503C\u533A\u57DF\u81F3\u5C11\u5E94\u4FDD\u7559\u4E00\u4E2A\u53EF\u586B\u5C5E\u6027\u7684\u5217\u3002<br>";
	}
	if(rows<=1){
		//msg+="数据值区域至少应保留一个可填值的行。<br>";
		msg+="\u6570\u636E\u503C\u533A\u57DF\u81F3\u5C11\u5E94\u4FDD\u7559\u4E00\u4E2A\u53EF\u586B\u503C\u7684\u884C\u3002<br>";
	}
	for(var i=1;i<=count;i++){
		var hiddenObj = document.getElementById('hiddenValue'+i);
		if(hiddenObj){
			var innerText = hiddenObj.value;
			if(innerText){
				var texts = innerText.split(",");
				if(texts[0].split(":").length==1){
					//msg+="数据值区域第"+(i+1)+"列题头值不能为空。<br>";
					msg+="\u6570\u636E\u503C\u533A\u57DF\u7B2C"+(i+1)+"\u5217\u9898\u5934\u503C\u4E0D\u80FD\u4E3A\u7A7A\u3002<br>";
				}else{
					var obj={attributeName:texts[0].split(":")[1],attributeCode:texts[1].split(":")[1],attributeType:texts[2].split(":")[1],lstConfigValueVO:[]};
					jsonHead.push(obj);
				}
			}else{
				msg+="\u6570\u636E\u503C\u533A\u57DF\u7B2C"+(i+1)+"\u5217\u9898\u5934\u503C\u4E0D\u80FD\u4E3A\u7A7A\u3002<br>";
			}
		}
	}
	if(msg.length>0){
		return msg;
	}
	var msgRowsValidate = "";
	for(var i=1;i<rows;i++){
		var defs;
		var def = table.rows[i].cells[0].getElementsByTagName("IMG")[1];
		if(def.src.search("undefault")=="-1"){
			defs ="1";
		}else{
			defs ="2";
		}
		var flag = true;
		for(var j=1;j<=count;j++){
			//取值
			var td = table.rows[i].cells[j];
			if(td){
				var tempValues = td.getElementsByTagName("INPUT")[0].value;
				if(trimSpace(tempValues)!=""){
					//校验数据值是否含有不允许的特殊字符
					var validateDataRegexInfo = validateDataRegex(trimSpace(tempValues));
					if(validateDataRegexInfo){
						msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217"+validateDataRegexInfo;
					}
					flag = false;
					//只有值不为空时才进行验证
					//验证输入的值是否合法
					var attributeType = trimSpace(jsonHead[j-1].attributeType);
					var vInfo = validationData(attributeType,trimSpace(tempValues));
					if(vInfo!=""){
						//msg += "数据值区域第"+i+"行,第"+(j+1)+"列"+vInfo;
						msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217"+vInfo;
					}
				}else{
					//msg += "数据值区域第"+i+"行,第"+(j+1)+"列值为空。<br>";
					msgRowsValidate += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217\u503C\u4E3A\u7A7A\u3002<br>";
				}
				var objValue = {configItemValue:trimSpace(tempValues),isDefaultValue:defs,rowNumber:i};
				jsonHead[j-1].lstConfigValueVO.push(objValue);
			}
		}
	}
	//判断编码是否重复
	msg+=attributeUnique(jsonHead);
	msg = msg + ":" + msgRowsValidate;
	return msg;
}
//验证单元格里面的特殊字符问题
function validateDataRegex(data){
	var re=/\"/;
	if(data.match(re)){
		//return "数据值不能包含"。<br>";
		return "\u6570\u636E\u503C\u4E0D\u80FD\u5305\u542B\u0022\u3002<br>";
	}
}
//div确定按钮事件
function confirmEvent(){
	var valid = window.validater.validElement('AREA','#attr');
	if(!valid[2]){
		return ;
	}
	var temp = document.getElementById("temp").value;
	var attrName = cui('#attrName').getValue();
	var attrCode = cui('#attrCode').getValue();
	var attrType = cui('#attrType').getText();
	var type = attrType;
	var msg = '';
	if(trimSpace(attrName).length==0){
		//msg+="属性名称不能为空<br>";
		msg+="\u5C5E\u6027\u540D\u79F0\u4E0D\u80FD\u4E3A\u7A7A<br>";
	}
	if(trimSpace(attrCode).length==0){
		//msg+="属性编码不能为空<br>";
		msg+="\u5C5E\u6027\u7F16\u7801\u4E0D\u80FD\u4E3A\u7A7A<br>";
	}else{
		msg += isRepeat(attrCode,temp);
	}
	if(msg.length>0){
		cui.alert(msg);
		return;
	}
	//var info = "名称:"+trimSpace(attrName)+",编码:"+trimSpace(attrCode)+",类型:"+type;
	var info = "\u540D\u79F0:"+trimSpace(attrName)+",\u7F16\u7801:"+trimSpace(attrCode)+",\u7C7B\u578B:"+type;
	document.getElementById("hiddenValue"+temp).value = info;
	document.getElementById("span"+temp).innerText=cutOutSide(trimSpace(attrName),9);
	document.getElementById("span"+temp).title=trimSpace(attrCode);
	document.getElementById("attr").style.display='none';
}

//点击div上的确定时判断编码是否重复
function isRepeat(attrCode,index){
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var columns = table.rows[0].cells.length;
	for(var i=1;i<=count;i++){
		var hiddenObj = document.getElementById('hiddenValue'+i);
		if(hiddenObj){
			var innerText = hiddenObj.value;
			if(innerText){
				var texts = innerText.split(",");
				if(texts[0].split(":").length!=1){
					if(i!=index){
						if(trimSpace(attrCode)==trimSpace(texts[1].split(":")[1])){
							//return "编码和第"+(i+1)+"列重复了";
							return "\u7F16\u7801\u548C\u7B2C"+(i+1)+"\u5217\u91CD\u590D\u4E86";
						}
					}
				}
			}
		}
	}
	return "";
}
//显示div
function showDiv(index,event){
	var scroll = document.body.scrollLeft;
	var scrollY = document.body.scrollTop;
	document.getElementById("temp").value=index;
	var div = document.getElementById("attr");
	div.style.display="block";
	
	if(event.clientX<200){
		div.style.left=(event.clientX+scroll) + 'px';
		if(scrollY>0){
			div.style.top=(event.clientY+scrollY) + 'px';
		}else{
			div.style.top=event.clientY + 'px';
		}
	}else{
		div.style.left=(event.clientX-200+scroll) + 'px';
		if(scrollY>0){
			div.style.top=(event.clientY+scrollY) + 'px';
		}else{
			div.style.top=event.clientY + 'px';
		}
	}
	setSelectColumnValue(index);
}

//隐藏div
function hideDiv(){
	document.getElementById("attr").style.display = "none";
}
//检验属性编码的唯一性
function attributeUnique(jsonValue){
	for(var i=0;i<jsonValue.length;i++){
		for(var j=0;j<jsonValue.length;j++){
			if(i!=j){
				if(jsonValue[i].attributeCode==jsonValue[j].attributeCode){
					//return "第"+(i+3)+"列的属性编码和第"+(j+3)+"列的属性编码重复了<br>";
					return "\u7B2C"+(i+3)+"\u5217\u7684\u5C5E\u6027\u7F16\u7801\u548C\u7B2C"+(j+3)+"\u5217\u7684\u5C5E\u6027\u7F16\u7801\u91CD\u590D\u4E86<br>";
				}
			}
		}
	}
	return "";
}

/**
 * 把值转换成json
 * @return
 */
function transValueToJson(){
	var attrValues = document.getElementsByName("attrValue");
	var json = [];
	for(var i=0,j=attrValues.length;i<j;i++){
		var valuesInfo = attrValues[i].value.split("###");
		var tempJson = {columnNum:valuesInfo[0],defaultValue:valuesInfo[1],rowNumber:valuesInfo[2],creatorId:valuesInfo[3],values:valuesInfo[4]};
		json.push(tempJson);
	}
	return json;
}
function addBorder(obj){
	obj.className = "input_mouseover";
}
function removeBorder(obj){
	obj.className = "input_mouseout";
}