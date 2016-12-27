//��֤������Ч��
function validationData(types,data){
	//if(types=="1"||types=="����"){
	if(types=="1"||types=="\u6574\u578B"){
		var re=/^-?[0-9]\d*$/;
		if(!data.match(re)){
			//return "����Ϊ���͵�����ֵ������������<br>";
			return "\u7C7B\u578B\u4E3A\u6574\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u6574\u6570\u3002<br>";
		}
	//}else if(types=="2"||types=="������"){
	}else if(types=="2"||types=="\u6D6E\u70B9\u578B"){
		var reg1=/^-?([0-9]\d*|0(?!\.0+$))\.\d+?$/;
		var reg2=/^-?[0-9]\d*$/;
		if(!(reg1.test(data) || reg2.test(data))){
			//return "����Ϊ�����͵�����ֵ�����Ǹ����͡�<br>";
			return "\u7C7B\u578B\u4E3A\u6D6E\u70B9\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u6D6E\u70B9\u578B\u3002<br>";
		}
	//}else if(types=="3"||types=="������"){
	}else if(types=="3"||types=="\u65E5\u671F\u578B"){
		
		var re = /^\d[19|20]\d{2}\-\d{1,2}\-\d{1,2}$/;
		if(!data.match(re)){
			//return "����Ϊ�����͵�����ֵ�������������͡��� 2010-1-2/2010-01-02<br>";
			return "\u7C7B\u578B\u4E3A\u65E5\u671F\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u662F\u65E5\u671F\u7C7B\u578B\u3002\u5982 2010-1-2/2010-01-02<br>";
		}else{
			var dateArray = data.split("-");
			if(parseInt(dateArray[1],10)>12){
				//return "ֵΪ'"+data+"'���������������·ݲ��ܳ���12���¡�<br>";
				return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u6708\u4EFD\u4E0D\u80FD\u8D85\u8FC7\u0031\u0032\u4E2A\u6708\u3002<br>";
			}
			//����
			if(parseInt(dateArray[0],10)%4==0){
				if(parseInt(dateArray[1],10)==2){
					if(parseInt(dateArray[2],10)>29){
						//return "ֵΪ'"+data+"'������������������2�·��������ܳ���29�졣<br>";
						return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u95F0\u5E74\u0032\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0032\u0039\u5929\u3002<br>";
					}
				}
			}else{
				if(parseInt(dateArray[1],10)==2){
					if(parseInt(dateArray[2],10)>28){
						//return "ֵΪ'"+data+"'��������������ƽ��2�·��������ܳ���28�졣<br>";
						return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E\u5E73\u5E74\u0032\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0032\u0038\u5929\u3002<br>";
					}
				}
			}
			var dateMonth = "1,3,5,7,8,10,12";
			var index = dateMonth.indexOf(parseInt(dateArray[1],10));
			if(index==-1){
				if(parseInt(dateArray[2],10)>30){
					//return "ֵΪ'"+data+"'��������������"+parseInt(dateArray[1],10)+"�·��������ܳ���30�졣<br>";
					return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0033\u0030\u5929\u3002<br>";
				}
			}else{
				if(parseInt(dateArray[2],10)>31){
					//return "ֵΪ'"+data+"'��������������"+parseInt(dateArray[1],10)+"�·��������ܳ���31�졣<br>";
					return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u8D85\u8FC7\u0033\u0031\u5929\u3002<br>";
				}
			}
			if(parseInt(dateArray[2],10)==0){
				//return "ֵΪ'"+data+"'��������������"+parseInt(dateArray[1],10)+"�·���������Ϊ0�졣<br>";
				return "\u503C\u4E3A'"+data+"'\u7684\u65E5\u671F\u7C7B\u578B\u6570\u636E"+parseInt(dateArray[1],10)+"\u6708\u4EFD\u5929\u6570\u4E0D\u80FD\u4E3A\u0030\u5929\u3002<br>";
			}
		}
	//}else if(types=="4"||types=="������"){
	}else if(types=="4"||types=="\u5E03\u5C14\u578B"){
		if(data!="true" && data!="false" && data!="TRUE" && data!="FALSE"){
			//return "����Ϊ�����͵�����ֵ����Ϊ�����͡��� true/false<br>";
			return "\u7C7B\u578B\u4E3A\u5E03\u5C14\u578B\u7684\u6570\u636E\u503C\u5FC5\u987B\u4E3A\u5E03\u5C14\u578B\u3002\u5982 true/false<br>";
		}
	}
	return "";
}

/*
*ȡֵ
*/
function getValue(){
	var jsonHead = [];
	//��ȡtabl����
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
				//��ȡ����ֵ������
				var creatorIdInputElement = td.getElementsByTagName("INPUT")[1];
				var creatorId = "";
				if(creatorIdInputElement!=""){
					creatorId = creatorIdInputElement.value;
					if(!creatorId){
						creatorId = globalUserId;
					}
				}
				var objValue = {configItemValue:tValue,isDefaultValue:defs,rowNumber:i,creatorId:creatorId};
				//����json������
				jsonHead[j-1].lstConfigValueVO.push(objValue);
			}
		}
	}
	return JSON.stringify(jsonHead);
}

//��ȡ�������͵�jsonֵ
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
	//��ȡtabl����
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var columns = table.rows[0].cells.length;
	//���ٱ���һ��������
	if(columns<=1){
		//msg+="����ֵ��������Ӧ����һ���������Ե��С�<br>";
		msg+="\u6570\u636E\u503C\u533A\u57DF\u81F3\u5C11\u5E94\u4FDD\u7559\u4E00\u4E2A\u53EF\u586B\u5C5E\u6027\u7684\u5217\u3002<br>";
	}
	if(rows<=1){
		//msg+="����ֵ��������Ӧ����һ������ֵ���С�<br>";
		msg+="\u6570\u636E\u503C\u533A\u57DF\u81F3\u5C11\u5E94\u4FDD\u7559\u4E00\u4E2A\u53EF\u586B\u503C\u7684\u884C\u3002<br>";
	}
	for(var i=1;i<=count;i++){
		var hiddenObj = document.getElementById('hiddenValue'+i);
		if(hiddenObj){
			var innerText = hiddenObj.value;
			if(innerText){
				var texts = innerText.split(",");
				if(texts[0].split(":").length==1){
					//msg+="����ֵ�����"+(i+1)+"����ͷֵ����Ϊ�ա�<br>";
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
			//ȡֵ
			var td = table.rows[i].cells[j];
			if(td){
				var tempValues = td.getElementsByTagName("INPUT")[0].value;
				if(trimSpace(tempValues)!=""){
					//У������ֵ�Ƿ��в�����������ַ�
					var validateDataRegexInfo = validateDataRegex(trimSpace(tempValues));
					if(validateDataRegexInfo){
						msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217"+validateDataRegexInfo;
					}
					flag = false;
					//ֻ��ֵ��Ϊ��ʱ�Ž�����֤
					//��֤�����ֵ�Ƿ�Ϸ�
					var attributeType = trimSpace(jsonHead[j-1].attributeType);
					var vInfo = validationData(attributeType,trimSpace(tempValues));
					if(vInfo!=""){
						//msg += "����ֵ�����"+i+"��,��"+(j+1)+"��"+vInfo;
						msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217"+vInfo;
					}
				}else{
					//msg += "����ֵ�����"+i+"��,��"+(j+1)+"��ֵΪ�ա�<br>";
					msgRowsValidate += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+(j+1)+"\u5217\u503C\u4E3A\u7A7A\u3002<br>";
				}
				var objValue = {configItemValue:trimSpace(tempValues),isDefaultValue:defs,rowNumber:i};
				jsonHead[j-1].lstConfigValueVO.push(objValue);
			}
		}
	}
	//�жϱ����Ƿ��ظ�
	msg+=attributeUnique(jsonHead);
	msg = msg + ":" + msgRowsValidate;
	return msg;
}
//��֤��Ԫ������������ַ�����
function validateDataRegex(data){
	var re=/\"/;
	if(data.match(re)){
		//return "����ֵ���ܰ���"��<br>";
		return "\u6570\u636E\u503C\u4E0D\u80FD\u5305\u542B\u0022\u3002<br>";
	}
}
//divȷ����ť�¼�
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
		//msg+="�������Ʋ���Ϊ��<br>";
		msg+="\u5C5E\u6027\u540D\u79F0\u4E0D\u80FD\u4E3A\u7A7A<br>";
	}
	if(trimSpace(attrCode).length==0){
		//msg+="���Ա��벻��Ϊ��<br>";
		msg+="\u5C5E\u6027\u7F16\u7801\u4E0D\u80FD\u4E3A\u7A7A<br>";
	}else{
		msg += isRepeat(attrCode,temp);
	}
	if(msg.length>0){
		cui.alert(msg);
		return;
	}
	//var info = "����:"+trimSpace(attrName)+",����:"+trimSpace(attrCode)+",����:"+type;
	var info = "\u540D\u79F0:"+trimSpace(attrName)+",\u7F16\u7801:"+trimSpace(attrCode)+",\u7C7B\u578B:"+type;
	document.getElementById("hiddenValue"+temp).value = info;
	document.getElementById("span"+temp).innerText=cutOutSide(trimSpace(attrName),9);
	document.getElementById("span"+temp).title=trimSpace(attrCode);
	document.getElementById("attr").style.display='none';
}

//���div�ϵ�ȷ��ʱ�жϱ����Ƿ��ظ�
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
							//return "����͵�"+(i+1)+"���ظ���";
							return "\u7F16\u7801\u548C\u7B2C"+(i+1)+"\u5217\u91CD\u590D\u4E86";
						}
					}
				}
			}
		}
	}
	return "";
}
//��ʾdiv
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

//����div
function hideDiv(){
	document.getElementById("attr").style.display = "none";
}
//�������Ա����Ψһ��
function attributeUnique(jsonValue){
	for(var i=0;i<jsonValue.length;i++){
		for(var j=0;j<jsonValue.length;j++){
			if(i!=j){
				if(jsonValue[i].attributeCode==jsonValue[j].attributeCode){
					//return "��"+(i+3)+"�е����Ա���͵�"+(j+3)+"�е����Ա����ظ���<br>";
					return "\u7B2C"+(i+3)+"\u5217\u7684\u5C5E\u6027\u7F16\u7801\u548C\u7B2C"+(j+3)+"\u5217\u7684\u5C5E\u6027\u7F16\u7801\u91CD\u590D\u4E86<br>";
				}
			}
		}
	}
	return "";
}

/**
 * ��ֵת����json
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