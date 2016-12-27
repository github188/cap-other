var countRow = 3;
// 添加行
function addRow() {
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	var columns = table.rows[0].cells.length;
	var oTR = table.insertRow(rows);
	var oTD = oTR.insertCell(0);
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
		oTD.innerHTML+='<input type="hidden" id="creatorId_'+(countRow-1)+'_'+i+'" value='+ globalUserId +' />';
	}
	countRow++;
}

// 添加列
function addColumn() {
	count++;
	var table = document.getElementById("tdList");
	var columns = table.rows[0].cells.length;
	var rows = table.rows.length;
	for ( var i = 0; i < rows; i++) {
		var td = table.rows[i].insertCell(columns);
		td.align="center";
		if (i == 0) {
			td.className = "td_title0";
			td.id = "content" + count;
			td.innerHTML = '<div class="td0_div_style"> <a id="span'+count+'" href="javascript:;" onclick="showDiv(' + count+',event)" title="\u540d\u79f0,\u7f16\u7801,\u7c7b\u578b">\u5217'+count+'</a><input type="hidden" id="hiddenValue'+count+'" />'
					+ '<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteColumn('
					+ count + ')" class="deleteColumnImgStyle"  title="\u5220\u9664\u5217"/></div>';
		} else {
			td.style.border="1px";
			td.style.borderColor="#94ADCA";
			td.style.borderStyle="solid";
			td.innerHTML = '<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text" name="value" value=""/>';
			td.innerHTML+='<input type="hidden" id="creatorId_'+i+'_'+count+'" value='+ globalUserId +' />';
		}
	}
}

// 删除行
function deleteRow(rowId) {
	var index;
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	for ( var i = 1; i <= rows; i++) {
		if (table.rows[i].id == rowId) {
			index = i;
			break;
		}
	}
	if(rows>2){
		//确定要删除这行吗?
		cui.confirm("\u786e\u5b9a\u8981\u5220\u9664\u8fd9\u884c\u5417?",{
			onYes:function(){
			table.deleteRow(index);
			}
		});
	}else{
		//至少保留可输入值的有效行。
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

// 删除列
function deleteColumn(columnId) {
	
	var index;
	var table = document.getElementById("tdList");
	var rows = table.rows.length;
	if(table.rows[0].cells.length>2){
		cui.confirm("\u786e\u5b9a\u8981\u5220\u9664\u8fd9\u5217\u5417?",{
			onYes:function(){
				for ( var i = 0; i < table.rows[0].cells.length; i++) {
					// 截取id后的数字，进行比较
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

//判断某字符中是否包含指定字符
function isContainSymbol(value,symbol){

	var index = value.indexOf(symbol);
	if(index!=-1){
		return true;
	}else{
		return false;
	}
}

//去除空格
function trimSpace(value){
	return value.replace(/[ ]/g,"");
}
//设置题头
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

