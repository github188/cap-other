<%
/**********************************************************************
* ��Ա����:��Ա��չ���Ա༭����
* 2014-7-14 �¼�ɽ   �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>��Ա��չ���Ա༭����</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ExtendAttrAction.js"></script>
	<style type="text/css">
			.thw_title{
			font-family:"΢���ź�";
	  		font-weight:bold;
	        font-size:medium;    		
	  		color:#0099FF;
		}
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
   <div class="thw_title" style="font-size:15px;">��Ա��չ���Ա༭</div>
   <div class="thw_operate" style = "padding-right:20px;">
	  <span uitype="button" label="����" on_click="saveUserExpandDefine"></span>
	  <span uitype="button" label="�������" on_click="saveUserAndContinue" id="saveAndContinue"></span>
	  <span uitype="button" label="ȡ��" on_click="closeSelf"></span>
   </div>
</div>
</div>
<div class="main">
    <table class="form_table" id="attributeTable">
       <tbody>
       <tr id="tr_01">         
		<td class="td_label" width="30%">
			<span  class="top_required">*</span>�������� ��
		</td>
		<td class="td_content">
			<span uitype="input" id="attriName" name="attriName" databind="data.attriName" maxlength="15" width="200" 
		 		validate="[{'type':'required', 'rule':{'m': '�������Ʋ���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isContainSpecialChar','m':'��������ֻ��Ϊ��Ӣ�ġ����֡�'}},{'type':'custom','rule':{'against':'isExistRename','m':'�Ѵ��ڸ����ԡ�'}}]"></span>
		</td>
		<div uitype="input" id="sortNo" name="sortNo" databind="data.sortNo" style="display: none;"></div>
	 </tr> 
	 <tr id="tr_02">  
	    <td class="td_label" width="30%">
	    	 <span  class="top_required">*</span>���Ա��� ��
	    </td>
		<td class="td_content">
			<span uitype="input" id="attriCode" name="attriCode" databind="data.attriCode" maxlength="15" width="200" validate="[{'type':'required', 'rule':{'m': '���Ա��벻��Ϊ�ա�'}},{'type':'custom','rule':{'against':'isCodeContainSpecialChar','m':'���Ա���ֻ��ΪӢ�ġ������Լ��»��ߡ�'}},{'type':'custom','rule':{'against':'isAttributeCodeUnique','m':'���Ա����Ѵ��ڡ�'}}]"></span>
		</td>
		</td>
	 </tr>
	 <tr id="tr_03">         
		<td class="td_label" width="30%">
			 <span  class="top_required">*</span>�Ƿ���� ��
		</td>
		<td class="td_content">
			<span uitype="radioGroup" name="isRequired" id="isRequired" value="1" databind="data.isRequired">
                <input type="radio" value="1" text="��" />
            	<input type="radio" value="2" text="��" />
		    </span>
	    </td>
	</tr>
	 <tr id="tr_04">         
		<td class="td_label" width="30%">
			 <span  class="top_required">*</span>�������� ��
		</td>
		<td class="td_content">
			<span uitype="radioGroup" name="attriType" id="attriType" value="1" databind="data.attriType" on_change="changeAttrType">
                <input type="radio" value="1" text="�ı���"/>
            	<input type="radio" value="2" text="������ѡ"/>
            	<input type="radio" value="3" text="������ѡ"/>
		    </span>
	    </td>
	</tr>
	<tr id="info" style="display: none;">         
		<td class="td_label" width="30%">
			����ֵ<font color='red'> KEY&nbsp;</font>
		</td>
		<td class="td_content">
			 ����ֵ<font color='red'> VALUE&nbsp;</font>
	    </td>
	</tr>
	<tr id="attribute_1" style="display: none;">         
		<td class="td_label" width="30%">
			 <span uitype="input" id="key_1" maxlength="20" width="80" value="1" validate="[{'type':'required', 'rule':{'m': '����ֵKey����Ϊ�ա�'}},{'type':'custom','rule':{'against':'isKeyContainSpecial','m':'����ֵKeyֻ��ΪӢ�ġ����ֻ��»��ߡ�'}},{'type':'custom','rule':{'against':'isKeyExsit','m':'ͬһ�����¸�����ֵKey�Ѵ��ڡ�'}}]"></span>
		</td>
		<td class="td_content">
			<span uitype="input" id="value_1" maxlength="20" width="200" validate="����ֵValue����Ϊ�ա�"></span>
			<img src="${pageScope.cuiWebRoot}/top/sys/images/add.png" onclick="addValue();" style="cursor:pointer;" title="�������ֵ">
	    </td>
	</tr>
	
	
	</tbody>
  </table>
</div>
<script language="javascript">

var totalSize = "<c:out value='${param.totalSize}'/>";
var defineId = "<c:out value='${param.defineId}'/>";
var orgStrucId="<c:out value='${param.orgStrucId}'/>";

var oldAttriName='';
//��Աmark
var mark =1;
totalSize++;
var data = {};
//ɨ�裬�൱����Ⱦ
window.onload=function(){
	initPage();
	comtop.UI.scan();
	  
	 
	if(defineId){
		//�༭ҳ���ʱ�򣬽����沢�����İ�ť���ε�
		cui('#saveAndContinue').hide();
		//�༭ҳ���ʱ�򣬱��벻�ɸ���
		cui('#attriCode').setReadOnly(true);
		//�༭ҳ���ʱ����Ҫ�ж��������ͣ�����ֵ��չ��
		changeAttrType();
	}
}
//��ʼ��ҳ��
function initPage(){
	if(defineId){
		//�༭
		dwr.TOPEngine.setAsync(false);
		ExtendAttrAction.getExpandDefine(defineId,function(expandDefineData){
		    //�������
		    data = expandDefineData;
		    oldAttriName=data.attriName;
		});
		dwr.TOPEngine.setAsync(true);
	}else{
		//����--��ȡ�����õ�atti_id
		var newAttriField = "attribute_"+totalSize;
		dwr.TOPEngine.setAsync(false);
		ExtendAttrAction.getExpandField(orgStrucId,mark,function(data){
		   newAttriField = data;
		});
		dwr.TOPEngine.setAsync(true);
		data.attriField= newAttriField;
		data.sortNo = totalSize;
	}
}
var flag = true;//����һ��flag��ʶֵ����ʶ���л��������͵�ʱ���Ƿ���Ҫ����addValue();
//�л���������
function changeAttrType(){
	if(cui("#attriType").getValue()=='2' || cui("#attriType").getValue()=='3'){
		$('tr[id^=attribute_]').show();
		$('#info').show();
		//�༭ҳ��ʱ�����Ĭ��ֵ��ҳ��
		if(defineId){
			var attriDefaultValue = data.attriDefaultValue;
			if(attriDefaultValue!=null&&attriDefaultValue!=''){
				var attrValues = attriDefaultValue.split(';');
				var attrValue;
				for(var i=0;i<attrValues.length;i++){
					//��Ҫ�Ƚ��������ӽ�ȥ��Ȼ���ٸ�ֵ
					if(flag && i!=0){
						addValue();
					}
					attrValue = attrValues[i];
					var arrays = attrValue.split('-');
					var index = i + 1;
					cui('#key_'+index).setValue(arrays[0]);
					cui('#value_'+index).setValue(arrays[1]);
					//�༭ʱ��keyֵ�����Ա༭
					cui('#key_'+index).setReadonly(true);
				}
			}
			flag = false;
		}
		//��̬�����֤
		window.validater.add("value_1",'required',{m:'ֵ����Ϊ�ա�'});
	}else{
		$('tr[id^=attribute_]').hide();
		$('#info').hide();
	}
}
//�������
function addValue(){
	//�����б����100������ ����ǰ��4�У�һ��105��
	var totalRowsLength = 100;
	var table = document.getElementById('attributeTable');
	var rows = table.rows.length;
	if(rows>totalRowsLength+4){
		cui.alert('�����б�������������100������ֵ��');
		return;
	}
	//��ȡ����ӵ�����ֵ�������Ա���ȷ�ϼ�����ӵ�����ֵ��id�Լ�label
	var lastRowId = $('table>tbody>tr:last>td:last>span')[0].id;
	var lastRowIndex = lastRowId.substring(6);
	var thisRowIdex = parseInt(lastRowIndex)+1;
	var oTr = table.insertRow(rows)
	var oTd = oTr.insertCell(0);
	oTd.className = "td_label";
	oTd.innerHTML = '<span uitype="input" id="key_'+thisRowIdex+'" maxlength="20" width="80" value="'+thisRowIdex+'" validate="[{\'type\':\'required\', \'rule\':{\'m\': \'����ֵKey����Ϊ�ա�\'}},{\'type\':\'custom\',\'rule\':{\'against\':\'isKeyContainSpecial\',\'m\':\'����ֵKeyֻ��ΪӢ�ġ����ֻ��»��ߡ�\'}},{\'type\':\'custom\',\'rule\':{\'against\':\'isKeyExsit\',\'m\':\'ͬһ�����¸�����ֵKey�Ѵ��ڡ�\'}}]"></span>';
	
	oTd = oTr.insertCell(1);
	oTd.className = "td_content";
	//���һ������ֵ����Ҫ���ͼ��
	if(thisRowIdex!=totalRowsLength){
		oTd.innerHTML ='<span uitype="Input" id="value_'+thisRowIdex +'" maxlength="20" width="200" validate="����Ϊ�ա�"></span><img  src="${pageScope.cuiWebRoot}/top/sys/images/add.png" onclick="addValue();" style="cursor:pointer" title="�������ֵ">&nbsp;<img   src="${pageScope.cuiWebRoot}/top/sys/images/remove.png" onclick="deleteValue('+thisRowIdex+');" style="cursor:pointer" title="ɾ������ֵ">';
	}else{
		oTd.innerHTML ='<span uitype="Input" id="value_'+thisRowIdex +'" maxlength="20" width="200"  validate="����Ϊ�ա�"></span><img   src="${pageScope.cuiWebRoot}/top/sys/images/remove.png" onclick="deleteValue('+thisRowIdex+');" style="cursor:pointer" title="ɾ������ֵ">';
	}
	oTr.id = "attribute_"+thisRowIdex;
	
	//ָ����Χɨ��
	comtop.UI.scan($('#attributeTable'));
	 
	//�Ƴ�����һ�е����ͼ��
	$('#attribute_'+lastRowIndex+'>td:last>img').hide();
	
}
//ɾ������
function deleteValue(index){
	var table = document.getElementById('attributeTable');
	if(index>1){
		//ȡ��ɾ��������key��֤
        window.validater.disValid('key_'+index, true);
        window.validater.disValid('value_'+index, true);
        //ɾ��Ԫ��
		table.deleteRow(index+4);
		//���һ��ɾ������һ����ʾͼ��
		$('#attribute_'+(index-1)+'>td:last>img').show();
	}else{
		cui.alert("���ٱ���һ������ֵ");
	}
}
//��ȡ����ֵ
function getAttrDefaultValue(){
	var selectedRows = $('tr[id^=attribute_]');
	var attrDefaultValue='';
	var defaultValue='';
	var defaultKey='';
	for(var i=1;i<=selectedRows.length;i++){
		defaultValue = cui('#value_'+i).getValue(); 
		defaultKey = cui('#key_'+i).getValue();
		attrDefaultValue += i+"-"+defaultValue+';'
	}
	attrDefaultValue = attrDefaultValue.substring(0,attrDefaultValue.length-1);
	return attrDefaultValue;
}
//�رմ���
function closeSelf(){
	window.parent.dialog.hide();
}
//�������
function saveUserAndContinue(){
	saveUserExpandDefine('continue');
}
//У��keyֵ�Ƿ��������ַ�
function isKeyContainSpecial(key){
	var reg = new RegExp("^[A-Za-z0-9_]+$");
	return (reg.test(key));
}
// У��keyֵ�Ƿ��Ѿ�����
function isKeyExsit(key){
	var vCount = 0;
	var defaultKey;
	var selectedRows = $('tr[id^=attribute_]');
	for(var i=1;i<=selectedRows.length;i++){
		defaultKey = cui('#key_'+i).getValue();
		if(key == defaultKey){
			vCount++;
		}
	}
	if(vCount >= 2){
		return false;
	}
	return true;
}
//����
function saveUserExpandDefine(flag){
		 //������֤��ȡ��Ϣ
	     if(cui("#attriType").getValue()=='1'){//ָ������֤
	       var map = window.validater.validElement('CUSTOM',['attriName', 'attriCode', 'isRequired', 'attriType']);
	     }else{
	       var map = window.validater.validAllElement();
	     }
	   	 var inValid = map[0];//���ô�����Ϣ
	   	 var valid = map[1]; //���óɹ���Ϣ
         if (inValid.length > 0) {
            var str = "";
            for (var i = 0; i < inValid.length; i++) {
				str +=  inValid[i].message + "<br />";
			}
         }else {
        	 //��ȡ����Ϣ
         	 var vo = cui(data).databind().getValue();
         	 vo.attributeClassify=orgStrucId;
         	 vo.mark = mark;
         	 //�˴���֪Ϊ�Σ�databindȡ��ֵ��ȫ�������趨
         	 vo.attriType = cui('#attriType').getValue();
         	 vo.isRequired = cui('#isRequired').getValue();
         	 if(cui("#attriType").getValue()=='2' || cui("#attriType").getValue()=='3'){
         	 vo.attriDefaultValue = getAttrDefaultValue();
         	 }else{
         		vo.attriDefaultValue='';
         	 }
         	if(defineId){//�༭
		         	if(oldAttriName!=vo.attriName){
		         		dwr.TOPEngine.setAsync(false);
						var message = "������Ա��<font color='red'>&quot;"+oldAttriName+"&quot;</font>���Զ���Ϊ<font color='red'>&quot;"+vo.attriName+"&quot;</font>���ԣ�����ֵ���������Ƿ�ȷ���޸ģ�";
						cui.confirm(message,{
							onYes:function(){
								ExtendAttrAction.updateExpandDefine(vo,function(){
					                //ˢ���б�
				            	    window.parent.editCallBack(vo.defineId);
				            	    window.parent.cui.message('�޸���չ���Գɹ���','success');
				            	    closeSelf();
						    	});
						  	}
						});
						dwr.TOPEngine.setAsync(true);
			         }else{
		         		dwr.TOPEngine.setAsync(false);
		         		ExtendAttrAction.updateExpandDefine(vo,function(){
				                //ˢ���б�
			            	    window.parent.editCallBack(vo.defineId);
				            	window.parent.cui.message('�޸���չ���Գɹ���','success');
				            	closeSelf();
				    		});
				         dwr.TOPEngine.setAsync(true);
				      }
         	}else{
         		ExtendAttrAction.queryExtendDefineList(orgStrucId,mark,function(datalist){
			    	if(datalist.count>=20){
			    		cui.alert('���ֻ������20����չ���ԡ�');
				    }else{
			        	 dwr.TOPEngine.setAsync(false);
			        	 ExtendAttrAction.insertExpandDefine(vo,function(id){
				            //ˢ���б�
			            	window.parent.editCallBack(id);
				            window.parent.cui.message('������չ���Գɹ���','success');
				            if(typeof(flag)=='string'){
				            	cui(data).databind().setEmpty();
				            	clearAttrValue();
				            	cui('#isRequired').setValue('1');
				            	cui('#attriType').setValue('1');
				            	initPage();
				            }else{
				            	closeSelf();
				            }
				    	});
				        dwr.TOPEngine.setAsync(true);
					}
				});
         	}
         }
}

//���������ʱ����������б������ֵ
function clearAttrValue(){
	var selectedRows = $('tr[id^=attribute_]');
	for(var i=1;i<=selectedRows.length;i++){
		cui('#key_'+i).setValue(i,true); 
		cui('#value_'+i).setValue('',true); 
	}
}

/*
* �ж���չ�������Ƿ���������ַ�
*/
function isContainSpecialChar(){
	var attriName = arguments[0];
	var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9]+$");
	return (reg.test(attriName));
}

/**
 * ���Ա���ֻ��Ϊ��Ӣ�ļ��»���
 */
function isCodeContainSpecialChar(){
	var attrubuteCode = cui('#attriCode').getValue();
	var reg = new RegExp("^[A-Za-z0-9_]+$");
	return (reg.test(attrubuteCode));
}

/**
 * �жϸ����Ա����Ƿ�Ψһ
 */
function isAttributeCodeUnique(){
	var attrubuteCode = cui('#attriCode').getValue();
	var obj = {'defineId':defineId,'mark':1,'attributeClassify':orgStrucId,'attriCode':attrubuteCode};
	var flag = true;
	if(attrubuteCode){
		dwr.TOPEngine.setAsync(false);
		ExtendAttrAction.isAttributeCodeUnique(obj,function(data){
			flag = data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	return flag;
}


/*
* �ж���չ���������Ƿ��ظ�
*/
function isExistRename(){
	var newName = arguments[0];
	var flag = true;
	var objItem={'attriName':newName,'attributeClassify':orgStrucId,'mark':mark};
	if(newName != ""&&newName!=oldAttriName){
		dwr.TOPEngine.setAsync(false);
		ExtendAttrAction.isExistRename(objItem,function(data){
			if(data){
				flag = false;
			}else{
				flag = true;
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	return flag;
}


</script>
</body>
</html>