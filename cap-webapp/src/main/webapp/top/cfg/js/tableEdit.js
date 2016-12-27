// �����
function addRow() {
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var countRow = rows;
	var columns = table.rows[0].cells.length;
	var oTR = table.insertRow(rows);
	
	oTD = oTR.insertCell(0);
	oTD.style.textAlign = "center";
	oTD.style.border="1px";
	oTD.style.borderColor="#94ADCA";
	oTD.style.borderStyle="solid";
	oTD.innerHTML = '<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteRow(' + countRow + ')" class="imgStyle" title="\u5220\u9664\u884c"/>'+
					'<img src="'+webPath+'/top/cfg/images/undefault.png" onclick="setDefault(this)" id="default" class="imgStyle" title="\u5207\u6362\u662F\u5426\u9ED8\u8BA4\u503C" />';
	oTR.id = countRow;
	
	for ( var i = 1; i < columns; i++) {
		oTD = oTR.insertCell(i);
		oTD.style.textAlign = "center";
		oTD.style.border="1px";
		oTD.style.borderColor="#94ADCA";
		oTD.style.borderStyle="solid";
		oTD.innerHTML = '<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text" name="value" value="" maxlength="100"/>';
		oTD.innerHTML+='<input type="hidden" id="creatorId_'+countRow+'_'+i+'" value='+ globalUserId +' />';
	}
	countRow++;
}

// �����
function addColumn() {
	var table = document.getElementById("tdList");
	var columns = table.rows[0].cells.length;
	var rows = table.rows.length;
	count++;
	for ( var i = 0; i < rows; i++) {
		var td = table.rows[i].insertCell(columns);
		td.align="center";
		if (i == 0) {
			td.className = "td_title0";
			td.id = "content" + count;
			td.innerHTML = '<div class="td0_div_style"><a id="span'+count+'" href="javascript:;" onclick="showDiv(' + count +',event)" title="\u540d\u79f0,\u7f16\u7801,\u7c7b\u578b">\u5217'+count+'</a><input type="hidden" id="hiddenValue'+count+'" />'
					+ '<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteColumn('
					+ count + ')" class="deleteColumnImgStyle" title="\u5220\u9664\u5217"/></div>';
		} else {
			td.style.border="1px";
			td.style.borderColor="#94ADCA";
			td.style.borderStyle="solid";
			td.innerHTML = '<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text" name="value" value=""/>';
			td.innerHTML+='<input type="hidden" id="creatorId_'+i+'_'+count+'" value='+ globalUserId +' />';
		}
	}
}


// ɾ����
function deleteRow(rowId) {
	
	var index;
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	for ( var i = 1; i < rows; i++) {
		if (table.rows[i].id == rowId) {
			index = i;
			break;
		}
	}
	if(rows>2){
		cui.confirm("\u786e\u5b9a\u8981\u5220\u9664\u8fd9\u884c\u5417?",{
			onYes:function(){
			table.deleteRow(index);
			}
		});
	}else{
		cui.alert("\u81f3\u5c11\u4fdd\u7559\u53ef\u8f93\u5165\u503c\u7684\u6709\u6548\u884c\u3002");
	}
}

function setDefault(obj){
	if(obj.src.search("undefault")==-1){
		obj.src = webPath+"/top/cfg/images/undefault.png";
		return;
	}
	 var defaultField = document.getElementsByTagName("IMG");
	 for(var i=0;i<defaultField.length;i++){
		if(defaultField[i].id=="default"){
			if(defaultField[i].src.search("undefault")=="-1"){
				defaultField[i].src = webPath+"/top/cfg/images/undefault.png";
			}
		}
	}
	 obj.src = webPath+"/top/cfg/images/default.png";
}

// ɾ����
function deleteColumn(columnId) {
	var index;
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	if(table.rows[0].cells.length>2){
		cui.confirm("\u786e\u5b9a\u8981\u5220\u9664\u8fd9\u5217\u5417?",{
			onYes:function(){
				for ( var i = 0; i < table.rows[0].cells.length; i++) {
					// ��ȡid������֣����бȽ�
					var con = table.rows[0].cells[i].id;
					if (con.substr(7, con.length) == columnId) {
						index = i;
						break;
					}
				}
				for ( var i = 0; i < rows; i++) {
					table.rows[i].deleteCell(index);
				}
			}
		});
	}else{
		cui.alert("\u81f3\u5c11\u4fdd\u7559\u53ef\u8f93\u5165\u503c\u7684\u6709\u6548\u5217\u3002");
	}
}

//ҳ���ʼ��ʱ,���ݺ�̨���ص����������
function initRowFromJson(json,columnNo) {
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var countRow = rows;
	var columns = table.rows[0].cells.length;
	var oTR = table.insertRow(rows);
	
	oTD = oTR.insertCell(0);
	oTD.style.textAlign = "center";
	oTD.style.border="1px";
	oTD.style.borderColor="#94ADCA";
	oTD.style.borderStyle="solid";
	oTD.innerHTML = '<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteRow(' + countRow + ')" class="imgStyle"  title="\u5220\u9664\u884c"/>';
	if(json[0].defaultValue=="1"){
		oTD.innerHTML += '<img src="'+webPath+'/top/cfg/images/default.png" onclick="setDefault(this)" id="default" class="imgStyle" title="\u5207\u6362\u662F\u5426\u9ED8\u8BA4\u503C" />';
	}else{
		oTD.innerHTML += '<img src="'+webPath+'/top/cfg/images/undefault.png" onclick="setDefault(this)" id="default" class="imgStyle" title="\u5207\u6362\u662F\u5426\u9ED8\u8BA4\u503C"  />';
	}
	
	oTR.id = countRow;
	
	for (var i = 1; i < columns; i++) {
		for(var j=0;j<json.length;j++){
			if(json[j].columnNum==i){
				oTD = oTR.insertCell(i);
				oTD.style.textAlign = "center";
				oTD.style.border="1px";
				oTD.style.borderColor="#94ADCA";
				oTD.style.borderStyle="solid";
				oTD.innerHTML = '<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text"  name="value" maxlength="100" value="'+json[j].values+'"/>';
				//�� 1 ��  �� 2 �С���ͷ����ͷ���㡿
				oTD.innerHTML+='<input type="hidden" id="creatorId_'+(columnNo+1)+'_'+i+'" value='+ json[j].creatorId +' />';
			}
		}
	}
	countRow++;
}

//ȥ���ո�
function trimSpace(value){
	return value.replace(/[ ]/g,"");
}

function setSelectColumnValue(index){
	var hiddenValue = document.getElementById("hiddenValue"+index).value;
	if(hiddenValue){
		var data = hiddenValue.split(",");
		cui('#attrName').setValue(typeof(data[0].split(":")[1])=='undefined'?"":data[0].split(":")[1]);
		cui('#attrCode').setValue(typeof(data[1].split(":")[1])=='undefined'?"":data[1].split(":")[1]);
		if(typeof(data[2].split(":")[1])=='undefined'){
			cui('#attrType').setValue('0');
			return;
		}
		var types = attrTypeDataSource;
		
			for(var i=0;i<types.length;i++){
				if(types[i].text==trimSpace(data[2].split(":")[1])){
					cui('#attrType').setValue(i.toString());
					return;
				}
			}
	}else{
		cui('#attrName').setValue('',true);
		cui('#attrCode').setValue('',true);
		cui('#attrType').setValue('0');
	}
}

/**
 * function:��ʼ������\u7c7b\u578b����
 * @param data
 * @return
 */
function initCollection(){
	document.getElementById("userTable").style.display="";
	//�˷�����configFunction.js��,������ֵת����json,�����кţ��кţ�ֵ��Ĭ��ֵ
	var json = transValueToJson();
	//ѭ������maxRowNum
	for(var i=0;i<maxRowNum;i++){
		var valueObj = new Array();
		for(var k=0;k<json.length;k++){
			//������ȵ����ݷ���һ��,�������ɶ�Ӧ��һ������
			if((i+1) == parseInt(json[k].rowNumber)){
				valueObj.push(json[k]);
			}
		}
		if(valueObj[0]){
			//������������
			initRowFromJson(valueObj,i);
		} 
	}
}

//�����������ɵ���ͷ
function jointTable(data){
	var innerHtml = '<table id="tdList" width="90%" border="1" cellspacing="1" cellpadding="5"	bordercolor="#b0c4de" style="border-collapse: collapse;width:100%;">';
	innerHtml+='<tr id="addColspan">';
	//ɾ��/Ĭ��ֵ
	innerHtml+='<td class="td_title" align="center" width="80px;"><div class="td0_div_style">\u5220\u9664\u002f\u9ed8\u8ba4\u503c</div></td>'; 
	for(var i=0;i<data.length;i++){
		var value = data[i].lstConfigValueVO;
		innerHtml+='<td align="center" class="td_title" id="content'+(i+1)+'">';
		innerHtml+='<input type="hidden" name="attrId"  value="'+data[i].attributeId+'"/>';
		innerHtml+='<div class="td0_div_style"><a id="span'+(i+1)+'" href="javascript:;" onclick="showDiv('+(i+1)+',event)" title="'+data[i].attributeCode+'">'+cutOutSide(trimSpace(data[i].attributeName),9)+'</a>';
		innerHtml+='<input type="hidden" id="hiddenValue'+(i+1)+'" value="\u540d\u79f0:'+data[i].attributeName+',\u7f16\u7801:'+data[i].attributeCode+',\u7c7b\u578b:'+data[i].attributeType+'" />';
		innerHtml+='<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteColumn('+(i+1)+')" class="deleteColumnImgStyle" title="\u5220\u9664\u5217"/>';
		innerHtml+='</div>';
		for(var j=0;j<value.length;j++){
			var temp = "";
			if(value[j].configItemValue==null){
				temp = (i+1)+'###'+value[j].isDefaultValue+'###'+value[j].rowNumber+'###'+value[j].creatorId+'###'+"";
			}else{
				temp = (i+1)+'###'+value[j].isDefaultValue+'###'+value[j].rowNumber+'###'+value[j].creatorId+'###'+value[j].configItemValue;
			}
			innerHtml+='<input type="hidden" name="attrValue" value="'+temp+'" />';
		}
		innerHtml+='</td>';
	}
	innerHtml+='</tr>';
	innerHtml+='</table>';
	document.getElementById("first").innerHTML=innerHtml;
}

//�Ǽ�����������
function jointNotTable(){
	var innerHtml = '<table id="tdList" width="90%" border="1" cellspacing="1" cellpadding="5"	bordercolor="#b0c4de" style="border-collapse: collapse;width:100%;">';
	innerHtml+='<tr id="addColspan">';
	innerHtml+='<td class="td_title" align="center" width="80px;"><div class="td0_div_style">\u5220\u9664\u002F\u9ED8\u8BA4\u503C</div></td>';
	innerHtml+='<td align="center" class="td_title0" id="content1">';
	innerHtml+='<div class="td0_div_style"><a id="span1" href="javascript:;" onclick="showDiv(1,event)" title="\u540D\u79F0\u002C\u7F16\u7801\u002C\u7C7B\u578B">\u5217\u0031</a>';
	innerHtml+='<input type="hidden" id="hiddenValue1" />';
	innerHtml+='<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteColumn(1)" class="deleteColumnImgStyle" title="\u5220\u9664\u5217"/>';
	innerHtml+='</div>';
	innerHtml+='</td>';
	innerHtml+='<tr id="1">';
	innerHtml+='<td align="center" class="td_Border">';
	innerHtml+='<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteRow(1)" class="imgStyle" title="\u5220\u9664\u884c"/>';
	innerHtml+='<img src="'+webPath+'/top/cfg/images/undefault.png" onclick="setDefault(this)" id="default" class="imgStyle" title="\u5207\u6362\u662F\u5426\u9ED8\u8BA4\u503C" />';
	innerHtml+='</td>';
	innerHtml+='<td align="center" class="td_Border">';
	innerHtml+='<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text" name="value" maxlength="100"/>';
	//�� 1 ��  �� 2 ��
	innerHtml+='<input type="hidden" id="creatorId_1_1" value='+ globalUserId +' />';
	innerHtml+='</td>';
	innerHtml+='</tr>';
	innerHtml+='</table>';
	document.getElementById("first").innerHTML=innerHtml;
}
