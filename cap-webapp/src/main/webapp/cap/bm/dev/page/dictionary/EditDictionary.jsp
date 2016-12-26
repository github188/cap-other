<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<html>
<head>
<title>配置项</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/cfg/css/top_cfg.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigItemAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/tableEdit.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/configfunction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/config.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/json2.js'></script>
 <style type="text/css">
        html{
            padding-top:35px;  /*上部设置为50px*/
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            overflow:hidden;
        }
        html,body{
            margin:0;
            height: 100%;
            width:100%;
        }
      .top{
            width:100%;
            height:38px;  /*高度和padding设置一样*/
            margin-top: -35px; /*值和padding设置一样*/                     
            overflow: auto;
            position:relative;
      }
     .main{
          height: 100%;
            width:100%;
            overflow: auto;
     }
     .td0_div_style{
      width:100%;
     }
    </style>
</head>
<body>
<div class="top">
<div class="top_header_wrap">
  <div class="thw_operate" style = "padding-right:20px;">
    <span uitype="button" label="保存" on_click="save"></span>
    <span uitype="button" label="关闭" on_click="close"></span>
  </div>
</div>
</div>
<div class="main">
<div style="position:relative;overflow-y:auto;overflow-x:hidden; " id="contentDiv">
  <table class="form_table" style="table-layout:fixed;width: 100%;">
  	 <colgroup>
	     	<col width="15%"/>
	     	<col width="35%"/>
	     	<col width="15%"/>
	     	<col width="35%"/>
	 </colgroup>
    <tr>
      <td class="td_label"><span class="top_required">*</span>名称</td>
      <td>
      	<span uitype="input" id="configItemName" name="configItemName" databind="data.configItemName"  
	             validate="名称不能为空" maxlength="80"></span>
	  </td>
	  <td class="td_label"><span class="top_required">*</span>类型</td>
      <td >
      	<span uitype="SinglePullDown" height="170" databind="data.configItemType" id="configItemType"
			value_field="value" label_field="text" datasource="typeData" validate="分类不能为空"	on_select_data="itemTypeChange">
		</span> 
	  </td>
    </tr>
    <tr>
      <td class="td_label"><span class="top_required">*</span>全编码 </td>
      <td colspan="3"  width="100%">
      	<span uitype="input" id="configItemFullCode" name="configItemFullCode" databind="data.configItemFullCode" 
      		 width="92%" title="请输入正确的全编码" maxlength="100" validate="全编码不能为空"></span>
	  </td>
    </tr>

    <tr id="showValue">
      <td class="td_label"><span class="top_required">*</span>数据值<br /></td>
      <td colspan="3" style="line-height:3px;">
	      <span uitype="textarea" id="configItemValue" maxlength="1000" databind="data.configItemValue" height="80"
		  		name="configItemValue" validate="数据值不能为空" class="hide" width="90%"></span>
		  		
		  <span uitype="Calender" id="calender" databind="data.dateConfigValue" validate="数据值不能为空" ></span>
		  
		  <span id="booleanConfigValue" uitype="RadioGroup" value="true" name="booleanConfigValue" databind="data.booleanConfigValue" class="hide">
		        <input type="radio" name="booleanConfigValue" value="true" />
		        true
		        <input type="radio" name="booleanConfigValue" value="false" />
		        false 
		   </span>
        </td>
    </tr>
    
    <tr id="userTable" style="display:none;" >
		<td class="td_label" ><font color="red">*</font>数据值
			<br>
			<img alt="添加行" src="${pageScope.cuiWebRoot}/top/cfg/images/addRow.gif" onclick="addRow();" style="cursor:hand" title="添加行">&nbsp;
			<img alt="添加列" src="${pageScope.cuiWebRoot}/top/cfg/images/addCell.gif" onclick="addColumn();" style="cursor:hand" title="添加列">&nbsp;
		</td>
		<td class="td_content" valign="top" width="100%" colspan="3" style="overflow:hidden;">
			<div id="first" style="width:561px;overflow-y:hidden;overflow-x:auto;" ></div>
		</td>
	</tr>
	<tr>
	  <td class="td_label" >描述<br></td>	
      <td colspan="3">
      <font id="applyRemarkLengthFont" >（您还能输入<label id="defect1" style="color:red;"></label> 字符）</font>
      	<span uitype="textarea" id="configItemDescription" maxlength="250" databind="data.configItemDescription" 
      		width="90%"	name="configItemDescription"  relation="defect1" ></span>
      </td>
	</tr>
  </table> 
  </div>
	<div id="attr" style="display:none;padding:5px;width:190px;height:130px;border: 2px solid;border-color: darkgray;">
		<div uitype="input" name="attrName" id="attrName" maxlength="50" width="95%" emptytext="请输入名称" style="padding-bottom: 5px;" validate="[{'type':'required', 'rule':{'m': '属性名称不能为空。'}}]"></div>
		<div uitype="input" name="attrCode" maxlength="100" id="attrCode" width="95%" emptytext="请输入编码" style="padding-bottom: 5px;"  validate="[{'type':'required', 'rule':{'m': '属性编码不能为空。'}},{'type':'custom','rule':{'against':'isAttrCodeContainSpecialChar','m':'属性编码只能为中英文、数字以及下划线。'}}]"></div>
		<div uitype="PullDown" id="attrType" datasource="attrTypeDataSource" mode="Single"  width="95%" editable="false" empty_text="请选择类型"></div>
		<input type="hidden" id="temp" value=""/>
		<div align="center" style="padding-top: 5px;">
			<span uitype="button" on_click="confirmEvent" label="确定" button_type="green-button"></span>
			<span uitype="button" on_click="hideDiv" label="关闭" button_type="blue-button"></span>
		</div>
	</div>
</div>	
<script type="text/javascript"> 
	var classifyId="<c:out value='${param.classifyId}'/>",  
	dataType = "<c:out value='${param.dataType}'/>";	 
	dataType = dataType==""?"0":dataType;
	var dataV=parseInt(dataType);	
	dataType = isNaN(dataV)?"0":(dataV>5||dataV<0?"0":dataV.toString()); 	
	var	configItemId = "<c:out value='${param.configItemId}'/>",
	typeData = [//{"value":"0","text":"字符串"},
	        	//{"value":"1","text":"整型"},
	        	//{"value":"2","text":"浮点型"},
	        	//{"value":"3","text":"日期型"},
	        	//{"value":"4","text":"布尔型"},
	        	{"value":"5","text":"集合"}],	
	data={configItemType:dataType};
	var attrTypeDataSource = [{id:'0',text:'字符串'},{id:'1',text:'整型'},{id:'2',text:'浮点型'},{id:'3',text:'日期型'},{id:'4',text:'布尔型'}]
	//总列数，只增不减
	var count = 1;
	//最大行数，经过了生产的增删改之后，行号就不太一定是有规定的，所以需要确定最大行号来做展现，否则会有些数据出不来
	var maxRowNum = 1;
	var typeArray=[];
	for(var i=0;i<typeData.length-1;i++){
	    typeArray.push(typeData[i].text);
	}
	$(function(){ 
		init();
	});
	//初始化
	function init(){	
		comtop.UI.scan();	
		addValid(); 
		showFormFiled(cui("#configItemType").getValue(),'edit');
	 	initFormData(); 
	}
	//表单初始化
	function initFormData() {
	    if (configItemId != "") {
	        ConfigItemAction.showConfigItemEdit(configItemId, dataType, function(da) {          
	            cui(data).databind().setValue(da);
	            if(da.configItemType=="5"){
	            	$("#showValue").hide(); 
	            	dwr.TOPEngine.setAsync(false);
	            	ConfigItemAction.getMaxRowNum(da.configItemFullCode,function(maxRow){
	            		if(maxRow == 0){
	            			maxRow = 1;
	            		}
	            		maxRowNum = maxRow;
	            	});
	            	jointTableX(da.lstAttributeValueVO);
	            	//给列长赋值
	            	count = da.lstAttributeValueVO.length;
	    			//初始化集合类型配置项
	    			initCollectionX();
	            	dwr.TOPEngine.setAsync(true);
	            }
	        });
	    } 
	}
	//下拉框变动
	function itemTypeChange(item) {	
	    showFormFiled(item.value,'edit');
	}
	//保存
	function save() {
		var formdata = cui(data).databind().getValue();
    	formdata.configClassifyId = classifyId;
		//指定区域验证
	    var map = window.validater.validElement("AREA","#contentDiv");
	    var inValid = map[0];
	    var msg = "";
	    //基本属性验证，验证通过
	    if (inValid.length == 0) {
	    	//验证集合类型
	        if (formdata.configItemType == "5") { 
	        	//验证数据区域值
	    		msg = validateValueField();
	    		//集合类型验证不通过，不能执行保存操作
	    		var msgShow = msg.split(":")[0];
	    		var msgConfirm = msg.split(":")[1];
	    		if(msgShow.length>0){
	    			cui.alert(msgShow);
	    			return;
	    		}else{
	        		if(msgConfirm.length>0){
						cui.confirm(msgConfirm+'确定要保存吗？',{
						    onYes:function(){
								//集合类型验证通过
					        	formdata.collectionJson = getValue();
					        	formdata.collectionJson = setIdFromValue(formdata.collectionJson);
					        	doSave(formdata); 
						    }
						});
					}else{
						formdata.collectionJson = getValue();
						formdata.collectionJson = setIdFromValue(formdata.collectionJson);
			        	doSave(formdata); 
					}
	    		}
	        }else{
	        	formdata.collectionJson = getBaseValue(formdata);
	        	doSave(formdata); 
		    }
	    } 
	}
	//doSave
	function doSave(obj){
		dwr.TOPEngine.setAsync(false);
		ConfigItemAction.saveConfigItem(obj, "edit", function() {
				
	    });
		dwr.TOPEngine.setAsync(true);
		close();
		if(window.top.cuiEMDialog){
			window.top.cuiEMDialog.wins['ConfigItemListDialog'].cui.message("配置项修改成功",'success');
			window.top.cuiEMDialog.wins['ConfigItemListDialog'].refreshList();
		}else{
			window.parent.cui.message("新增数据成功",'success');
			setTimeout("window.parent.refresh()",600);
		}
	}
	
	/**
	 * 把集合类配置项的id值设置为value的值
	 *
	 * @param 当前集合配置项表格中数据的json字符串
	 */
	function setIdFromValue(str){
		var obj = JSON.parse(str);
		$.each(obj[0].lstConfigValueVO,function(index,item) {
			item.configItemValue = obj[1].lstConfigValueVO[index].configItemValue;
		});
		return JSON.stringify(obj);
	}
	
	//关闭
	function close(){
		//window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
		if(window.top.cuiEMDialog){
			window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
		}else{
			window.parent.ConfigItemListDialog.hide();
		}
	}
	
	/**
	 * function:初始化集合\u7c7b\u578b数据
	 * @param data
	 * @return
	 */
	function initCollectionX(){
		document.getElementById("userTable").style.display="";
		//此方法在configFunction.js中,将所有值转换成json,包含行号，列号，值，默认值
		var json = transValueToJson();
		//循环次数maxRowNum
		for(var i=0;i<maxRowNum;i++){
			var valueObj = new Array();
			for(var k=0;k<json.length;k++){
				//将行相等的数据放在一起,方便生成对应的一行数据
				if((i+1) == parseInt(json[k].rowNumber)){
					valueObj.push(json[k]);
				}
			}
			if(valueObj[0]){
				//生成行列数据
				initRowFromJson(valueObj,i);
			} 
		}
	}
	
	//集合类型生成的题头
	function jointTableX(data){
		var innerHtml = '<table id="tdList" width="95%" border="1" cellspacing="1" cellpadding="5"	bordercolor="#b0c4de" style="border-collapse: collapse;width:100%;">';
		innerHtml+='<tr id="addColspan">';
		//删除/默认值
		innerHtml+='<td class="td_title" align="center" width="90px;"><div class="td0_div_style">\u5220\u9664\u002f\u9ed8\u8ba4\u503c</div></td>'; 
		for(var i=0;i<data.length;i++){
			var value = data[i].lstConfigValueVO;
			if(i == 0){
				innerHtml+='<td align="center" class="td_title"  style="display:none;" id="content'+(i+1)+'">';
			}else{
				innerHtml+='<td align="center" class="td_title" id="content'+(i+1)+'">';
			}
			innerHtml+='<input type="hidden" name="attrId"  value="'+data[i].attributeId+'"/>';
			if(i>=3){
				innerHtml+='<div class="td0_div_style" width="100%"><a id="span'+(i+1)+'" href="javascript:;" onclick="showDiv('+(i+1)+',event)" title="'+data[i].attributeCode+'">'+cutOutSide(trimSpace(data[i].attributeName),11)+'</a>';
			}else{
				innerHtml+='<div class="td0_div_style" width="100%"><a id="span'+(i+1)+'">'+cutOutSide(trimSpace(data[i].attributeName),11)+'</a>';
			}
			innerHtml+='<input type="hidden" id="hiddenValue'+(i+1)+'" value="\u540d\u79f0:'+data[i].attributeName+',\u7f16\u7801:'+data[i].attributeCode+',\u7c7b\u578b:'+data[i].attributeType+'" />';
			if(i>=3){
				innerHtml+='<img src="'+webPath+'/top/cfg/images/delete1.png" onclick="deleteColumn('+(i+1)+')" class="deleteColumnImgStyle" title="\u5220\u9664\u5217"/>';
			}
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
	
	/**
	 * 重写tableEdit.js里的addRow()方法
	 */
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
			oTD.innerHTML = '<input onmouseover="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout"  type="text" name="value" value="" maxlength="100" id="colum_'+countRow+'_'+i +'" onchange="changeIdColumValue(this,'+countRow+')"/>';
			oTD.innerHTML+='<input type="hidden" id="creatorId_'+countRow+'_'+i+'" value='+ globalUserId +' />';
			//这个方法addRow()是重写到table.js里的addRow()方法。
			//就重写了这里一点点，加了这个if判断。
			if(i == 1){
				oTD.style.display="none";
			}
		}
		countRow++;
	}
	
	/**
	 * 页面初始化时,根据后台返回的数据添加行
	 * (重写的tableEdit.js中的initRowFromJson方法)
	 */
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
					//第 1 行  第 2 列【题头和行头不算】
					oTD.innerHTML+='<input type="hidden" id="creatorId_'+(columnNo+1)+'_'+i+'" value='+ json[j].creatorId +' />';
				}
			}
			//重写的内容：添加了这个if
			if(i == 1){
				oTD.style.display="none";
			}
		}
		countRow++;
	}
	
	/**
	 * 重写configfunction.js里的validateValueField()方法
	 */
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
						//msg+="数据值区域有题头未设置名称。<br>";
						msg+="\u6570\u636e\u503c\u533a\u57df\u6709\u9898\u5934\u672a\u8bbe\u7f6e\u540d\u79f0\u3002<br>";
					}else{
						var obj={attributeName:texts[0].split(":")[1],attributeCode:texts[1].split(":")[1],attributeType:texts[2].split(":")[1],lstConfigValueVO:[]};
						jsonHead.push(obj);
					}
				}else{
					//msg+="数据值区域有题头未设置名称。<br>";
					msg+="\u6570\u636e\u503c\u533a\u57df\u6709\u9898\u5934\u672a\u8bbe\u7f6e\u540d\u79f0\u3002<br>";
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
							msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+j+"\u5217"+validateDataRegexInfo;
						}
						flag = false;
						//只有值不为空时才进行验证
						//验证输入的值是否合法
						var attributeType = trimSpace(jsonHead[j-1].attributeType);
						var vInfo = validationData(attributeType,trimSpace(tempValues));
						if(vInfo!=""){
							//msg += "数据值区域第"+i+"行,第"+j+"列"+vInfo;
							msg += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+j+"\u5217"+vInfo;
						}
					}else{
						//重写的内容：当是j==1时不校验.
						if(j != 1){
							//msg += "数据值区域第"+i+"行,第"+j+"列值为空。<br>";
							msgRowsValidate += "\u6570\u636E\u503C\u533A\u57DF\u7B2C"+i+"\u884C\u002C\u7B2C"+j+"\u5217\u503C\u4E3A\u7A7A\u3002<br>";
						}
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
</script>
</body>
</html>
