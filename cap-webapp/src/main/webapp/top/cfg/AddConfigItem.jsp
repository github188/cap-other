<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>配置项</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/cfg/css/top_cfg.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/table.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/configfunction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/js/config.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigItemAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
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
<div style="position:relative;overflow-y: auto;overflow-x: hidden;" id="contentDiv">
  <table class="form_table" style="table-layout:fixed;width: 100%;">
  	 <colgroup>
	     	<col width="15%"/>
	     	<col width="35%"/>
	     	<col width="15%"/>
	     	<col width="35%"/>
	 </colgroup>
    <tr>
      <td class="td_label"><span class="top_required">*</span>名称：</td>
      <td>
      	<span uitype="input" id="configItemName" name="configItemName" databind="data.configItemName"  
	             validate="名称不能为空" maxlength="80"></span>
	  </td>
	  <td class="td_label"><span class="top_required">*</span>类型：</td>
      <td >
      	<span uitype="SinglePullDown" height="170" databind="data.configItemType" id="configItemType"
			value_field="value" label_field="text" datasource="typeData" validate="分类不能为空"	on_select_data="itemTypeChange">
		</span> 
	  </td>
    </tr>
    <tr>
      <td class="td_label"><span class="top_required">*</span>全编码： </td>
      <td  colspan="3" width="100%" style="line-height: 3px;">
      	<span uitype="input" id="configItemFullCode" name="configItemFullCode" databind="data.configItemFullCode" 
      		 width="92%" title="请输入正确的全编码" maxlength="100" validate="全编码不能为空"></span>
	  </td>
    </tr>
    <tr id="showValue">
      <td class="td_label"><span class="top_required">*</span>数据值：</td>
      <td colspan="3" width="100%" style="line-height:3px;">
	      <span uitype="textarea" id="configItemValue" maxlength="1000" databind="data.configItemValue" height="50"
		  		name="configItemValue" validate="数据值不能为空" class="hide" width="90%"></span>
		  		
		  <span uitype="Calender" id="calender" databind="data.dateConfigValue" validate="数据值不能为空" ></span>
		  
		  <span id="booleanConfigValue" uitype="RadioGroup" name="booleanConfigValue" databind="data.booleanConfigValue"
			  value="true" class="hide">
		        <input type="radio" name="booleanConfigValue" value="true" />
		        true
		        <input type="radio" name="booleanConfigValue" value="false" />
		        false </span>
        </td>
    </tr>
    
    <tr id="userTable" style="display:none;" >
		<td class="td_label" ><font color="red">*</font>数据值：
			<br>
			<img alt="添加行" src="${pageScope.cuiWebRoot}/top/cfg/images/addRow.gif" onclick="addRow();" style="cursor:pointer;" title="添加行">&nbsp;
			<img alt="添加列" src="${pageScope.cuiWebRoot}/top/cfg/images/addCell.gif" onclick="addColumn();" style="cursor:pointer;" title="添加列">&nbsp;
		</td>
		<td class="td_content"  valign="top" width="100%" colspan="3" style="overflow:hidden;">
			<div id="autoDiv" style="width:561px;overflow-y:hidden;overflow-x:auto; ">
				<table id="tdList" border="1" cellspacing="1" cellpadding="5"	bordercolor="#b0c4de" style="border-collapse: collapse;width:100%;" >
				<tr id="addColspan" >
					<td class="td_title" align="center" style="width:80px;"><div class="td0_div_style">删除/默认值</div></td>
					<td align="center" class="td_title0" id="content1" >
							<div class="td0_div_style"><a id="span1" href="javascript:;" onclick="showDiv(1,event)" title="名称,编码,类型">列1</a>
							<input type="hidden" id="hiddenValue1" />
							<img src="${pageScope.cuiWebRoot}/top/cfg/images/delete1.png" onclick="deleteColumn(1)" class="deleteColumnImgStyle"  title="删除列"/>
							</div>
					</td>
				</tr>
				<tr id="1">
					<td align="center" class="td_Border">
						<img src="${pageScope.cuiWebRoot}/top/cfg/images/delete1.png" onclick="deleteRow(1)" class="imgStyle" title="删除行"  />
						<img src="${pageScope.cuiWebRoot}/top/cfg/images/undefault.png" onclick="setDefault(this)" id="default" class="imgStyle"  title="切换是否默认值"/>
					</td>
					<td align="center" class="td_Border">
						<input onmousemove="addBorder(this)" onmouseout="removeBorder(this)" class="input_mouseout" type="text" name="value" maxlength="100"/>
						<input type="hidden" id="creatorId_1_1" value="${pageScope.userInfo.userId}" />
					</td>
				</tr>
				</table>
				<br>
			  </div>
			</td>
		</tr>
		<tr>
	      <td class="td_label" >描述：</td>	
	      <td colspan="3">
				<font id="applyRemarkLengthFont" >（您还能输入<label id="defect1" style="color:red;"></label> 字符）</font>
		      	<span uitype="textarea" id="configItemDescription" maxlength="250" databind="data.configItemDescription"  
		      		width="90%"	name="configItemDescription" relation="defect1" ></span>
	      </td>
	    </tr>
  </table> 
</div>
<div id="attr" align="center" style="display:none;padding:5px;width:190px;height:130px;border: 2px solid;border-color: darkgray;">
	<div uitype="input" name="attrName" id="attrName" maxlength="50" width="95%" emptytext="请输入名称" style="padding-bottom: 5px;" validate="[{'type':'required', 'rule':{'m': '属性名称不能为空。'}}]"></div>
	<div uitype="input" name="attrCode" maxlength="100" id="attrCode" width="95%" emptytext="请输入编码" style="padding-bottom: 5px;" validate="[{'type':'required', 'rule':{'m': '属性编码不能为空。'}},{'type':'custom','rule':{'against':'isAttrCodeContainSpecialChar','m':'属性编码只能为中英文、数字以及下划线。'}}]"></div>
	<div uitype="PullDown" id="attrType" datasource="attrTypeDataSource" mode="Single"  width="95%" editable="false" empty_text="请选择类型"></div>
	<input type="hidden" id="temp" value=""/>
	<div align="center" style="padding-top: 5px;">
		<span uitype="button" on_click="confirmEvent" label="确定"  button_type="green-button"></span>
		<span uitype="button" on_click="hideDiv" label="关闭" button_type="blue-button"></span>
	</div>
</div>
</div>
<script type="text/javascript"> 
	var classifyId= "<c:out value='${param.classifyId}'/>", 
	dataType = "<c:out value='${param.dataType}'/>";	 
	dataType = dataType==""?"0":dataType;
	var dataV=parseInt(dataType);	
	dataType = isNaN(dataV)?"0":(dataV>5||dataV<0?"0":dataV.toString()); 	
	var	configItemId =  "<c:out value='${param.configItemId}'/>",
	typeData = [{"value":"0","text":"字符串"},
	        	{"value":"1","text":"整型"},
	        	{"value":"2","text":"浮点型"},
	        	{"value":"3","text":"日期型"},
	        	{"value":"4","text":"布尔型"},
	        	{"value":"5","text":"集合"}],	
	data={configItemType:dataType},
	fullCode="";
	var attrTypeDataSource = [{id:'0',text:'字符串'},{id:'1',text:'整型'},{id:'2',text:'浮点型'},{id:'3',text:'日期型'},{id:'4',text:'布尔型'}]
	
	var sysModule = "<c:out value='${param.sysModule}'/>";//标识当前节点是系统模块还是统一分类
	//总列数，只增不减
	var count = 1;
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
		showFormFiled(cui("#configItemType").getValue(),'add');
	 	initFormData(); 
	}
	//表单初始化
	function initFormData() {
	   ConfigItemAction.showAddConfigItemPage(classifyId, sysModule, function (result) {
	       fullCode = result;
	       cui(data).databind().set('configItemFullCode',result);
	   });
	}
	//下拉框变动
	function itemTypeChange(item) {	
	    showFormFiled(item.value,'add');
	}
	//保存
	function save() {
	    var formdata = cui(data).databind().getValue();
	    	formdata.configClassifyId = classifyId;
	    if(sysModule=='Yes'){
	    	formdata.classifyType='SYS_MODULE';
	    }else{
	    	formdata.classifyType='UNI_CLASSIFY';
	    }
	
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
					        	doSave(formdata); 
						    }
						});
					}else{
						formdata.collectionJson = getValue();
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
	     ConfigItemAction.saveConfigItem(obj, "save", function (b) {
				window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
				window.top.cuiEMDialog.wins['ConfigItemListDialog'].cui.message("新增数据成功",'success');
				window.top.cuiEMDialog.wins['ConfigItemListDialog'].refreshList();
				
	     });
	}
	//关闭
	function close(){
		window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
	}
</script>
</body>
</html>