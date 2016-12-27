<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>������</title>
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
            padding-top:35px;  /*�ϲ�����Ϊ50px*/
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
            height:38px;  /*�߶Ⱥ�padding����һ��*/
            margin-top: -35px; /*ֵ��padding����һ��*/                     
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
    <span uitype="button" label="����" on_click="save"></span>
    <span uitype="button" label="�ر�" on_click="close"></span>
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
      <td class="td_label"><span class="top_required">*</span>����</td>
      <td>
      	<span uitype="input" id="configItemName" name="configItemName" databind="data.configItemName"  
	             validate="���Ʋ���Ϊ��" maxlength="80"></span>
	  </td>
	  <td class="td_label"><span class="top_required">*</span>����</td>
      <td >
      	<span uitype="SinglePullDown" height="170" databind="data.configItemType" id="configItemType"
			value_field="value" label_field="text" datasource="typeData" validate="���಻��Ϊ��"	on_select_data="itemTypeChange">
		</span> 
	  </td>
    </tr>
    <tr>
      <td class="td_label"><span class="top_required">*</span>ȫ���� </td>
      <td colspan="3"  width="100%">
      	<span uitype="input" id="configItemFullCode" name="configItemFullCode" databind="data.configItemFullCode" 
      		 width="92%" title="��������ȷ��ȫ����" maxlength="100" validate="ȫ���벻��Ϊ��"></span>
	  </td>
    </tr>

    <tr id="showValue">
      <td class="td_label"><span class="top_required">*</span>����ֵ<br /></td>
      <td colspan="3" style="line-height:3px;">
	      <span uitype="textarea" id="configItemValue" maxlength="1000" databind="data.configItemValue" height="80"
		  		name="configItemValue" validate="����ֵ����Ϊ��" class="hide" width="90%"></span>
		  		
		  <span uitype="Calender" id="calender" databind="data.dateConfigValue" validate="����ֵ����Ϊ��" ></span>
		  
		  <span id="booleanConfigValue" uitype="RadioGroup" value="true" name="booleanConfigValue" databind="data.booleanConfigValue" class="hide">
		        <input type="radio" name="booleanConfigValue" value="true" />
		        true
		        <input type="radio" name="booleanConfigValue" value="false" />
		        false 
		   </span>
        </td>
    </tr>
    
    <tr id="userTable" style="display:none;" >
		<td class="td_label" ><font color="red">*</font>����ֵ
			<br>
			<img alt="�����" src="${pageScope.cuiWebRoot}/top/cfg/images/addRow.gif" onclick="addRow();" style="cursor:hand" title="�����">&nbsp;
			<img alt="�����" src="${pageScope.cuiWebRoot}/top/cfg/images/addCell.gif" onclick="addColumn();" style="cursor:hand" title="�����">&nbsp;
		</td>
		<td class="td_content" valign="top" width="100%" colspan="3" style="overflow:hidden;">
			<div id="first" style="width:561px;overflow-y:hidden;overflow-x:auto;" ></div>
		</td>
	</tr>
	<tr>
	  <td class="td_label" >����<br></td>	
      <td colspan="3">
      <font id="applyRemarkLengthFont" >������������<label id="defect1" style="color:red;"></label> �ַ���</font>
      	<span uitype="textarea" id="configItemDescription" maxlength="250" databind="data.configItemDescription" 
      		width="90%"	name="configItemDescription"  relation="defect1" ></span>
      </td>
	</tr>
  </table> 
  </div>
	<div id="attr" style="display:none;padding:5px;width:190px;height:130px;border: 2px solid;border-color: darkgray;">
		<div uitype="input" name="attrName" id="attrName" maxlength="50" width="95%" emptytext="����������" style="padding-bottom: 5px;" validate="[{'type':'required', 'rule':{'m': '�������Ʋ���Ϊ�ա�'}}]"></div>
		<div uitype="input" name="attrCode" maxlength="100" id="attrCode" width="95%" emptytext="���������" style="padding-bottom: 5px;"  validate="[{'type':'required', 'rule':{'m': '���Ա��벻��Ϊ�ա�'}},{'type':'custom','rule':{'against':'isAttrCodeContainSpecialChar','m':'���Ա���ֻ��Ϊ��Ӣ�ġ������Լ��»��ߡ�'}}]"></div>
		<div uitype="PullDown" id="attrType" datasource="attrTypeDataSource" mode="Single"  width="95%" editable="false" empty_text="��ѡ������"></div>
		<input type="hidden" id="temp" value=""/>
		<div align="center" style="padding-top: 5px;">
			<span uitype="button" on_click="confirmEvent" label="ȷ��" button_type="green-button"></span>
			<span uitype="button" on_click="hideDiv" label="�ر�" button_type="blue-button"></span>
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
	typeData = [{"value":"0","text":"�ַ���"},
	        	{"value":"1","text":"����"},
	        	{"value":"2","text":"������"},
	        	{"value":"3","text":"������"},
	        	{"value":"4","text":"������"},
	        	{"value":"5","text":"����"}],	
	data={configItemType:dataType};
	var attrTypeDataSource = [{id:'0',text:'�ַ���'},{id:'1',text:'����'},{id:'2',text:'������'},{id:'3',text:'������'},{id:'4',text:'������'}]
	//��������ֻ������
	var count = 1;
	//�����������������������ɾ��֮���кžͲ�̫һ�����й涨�ģ�������Ҫȷ������к�����չ�֣��������Щ���ݳ�����
	var maxRowNum = 1;
	var typeArray=[];
	for(var i=0;i<typeData.length-1;i++){
	    typeArray.push(typeData[i].text);
	}
	$(function(){ 
		init();
	});
	//��ʼ��
	function init(){	
		comtop.UI.scan();	
		addValid(); 
		showFormFiled(cui("#configItemType").getValue(),'edit');
	 	initFormData(); 
	}
	//����ʼ��
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
	            	jointTable(da.lstAttributeValueVO);
	            	//���г���ֵ
	            	count = da.lstAttributeValueVO.length;
	    			//��ʼ����������������
	    			initCollection();
	            	dwr.TOPEngine.setAsync(true);
	            }
	        });
	    } 
	}
	//������䶯
	function itemTypeChange(item) {	
	    showFormFiled(item.value,'edit');
	}
	//����
	function save() {
		var formdata = cui(data).databind().getValue();
    	formdata.configClassifyId = classifyId;
		//ָ��������֤
	    var map = window.validater.validElement("AREA","#contentDiv");
	    var inValid = map[0];
	    var msg = "";
	    //����������֤����֤ͨ��
	    if (inValid.length == 0) {
	    	//��֤��������
	        if (formdata.configItemType == "5") { 
	        	//��֤��������ֵ
	    		msg = validateValueField();
	    		//����������֤��ͨ��������ִ�б������
	    		var msgShow = msg.split(":")[0];
	    		var msgConfirm = msg.split(":")[1];
	    		if(msgShow.length>0){
	    			cui.alert(msgShow);
	    			return;
	    		}else{
	        		if(msgConfirm.length>0){
						cui.confirm(msgConfirm+'ȷ��Ҫ������',{
						    onYes:function(){
								//����������֤ͨ��
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
		 ConfigItemAction.saveConfigItem(obj, "edit", function() {
				window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
				window.top.cuiEMDialog.wins['ConfigItemListDialog'].cui.message("�������޸ĳɹ�",'success');
				window.top.cuiEMDialog.wins['ConfigItemListDialog'].refreshList();
				
	     });
	}
	//�ر�
	function close(){
		window.top.cuiEMDialog.dialogs['ConfigItemListDialog'].hide();
	}
</script>
</body>
</html>