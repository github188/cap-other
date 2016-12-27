<%
/**********************************************************************
* 人员管理:人员扩展属性编辑界面
* 2014-7-14 陈佳山   新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>人员扩展属性编辑界面</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ExtendAttrAction.js"></script>
	<style type="text/css">
			.thw_title{
			font-family:"微软雅黑";
	  		font-weight:bold;
	        font-size:medium;    		
	  		color:#0099FF;
		}
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
   <div class="thw_title" style="font-size:15px;">人员扩展属性编辑</div>
   <div class="thw_operate" style = "padding-right:20px;">
	  <span uitype="button" label="保存" on_click="saveUserExpandDefine"></span>
	  <span uitype="button" label="保存继续" on_click="saveUserAndContinue" id="saveAndContinue"></span>
	  <span uitype="button" label="取消" on_click="closeSelf"></span>
   </div>
</div>
</div>
<div class="main">
    <table class="form_table" id="attributeTable">
       <tbody>
       <tr id="tr_01">         
		<td class="td_label" width="30%">
			<span  class="top_required">*</span>属性名称 ：
		</td>
		<td class="td_content">
			<span uitype="input" id="attriName" name="attriName" databind="data.attriName" maxlength="15" width="200" 
		 		validate="[{'type':'required', 'rule':{'m': '属性名称不能为空。'}},{'type':'custom','rule':{'against':'isContainSpecialChar','m':'属性名称只能为中英文、数字。'}},{'type':'custom','rule':{'against':'isExistRename','m':'已存在该属性。'}}]"></span>
		</td>
		<div uitype="input" id="sortNo" name="sortNo" databind="data.sortNo" style="display: none;"></div>
	 </tr> 
	 <tr id="tr_02">  
	    <td class="td_label" width="30%">
	    	 <span  class="top_required">*</span>属性编码 ：
	    </td>
		<td class="td_content">
			<span uitype="input" id="attriCode" name="attriCode" databind="data.attriCode" maxlength="15" width="200" validate="[{'type':'required', 'rule':{'m': '属性编码不能为空。'}},{'type':'custom','rule':{'against':'isCodeContainSpecialChar','m':'属性编码只能为英文、数字以及下划线。'}},{'type':'custom','rule':{'against':'isAttributeCodeUnique','m':'属性编码已存在。'}}]"></span>
		</td>
		</td>
	 </tr>
	 <tr id="tr_03">         
		<td class="td_label" width="30%">
			 <span  class="top_required">*</span>是否必填 ：
		</td>
		<td class="td_content">
			<span uitype="radioGroup" name="isRequired" id="isRequired" value="1" databind="data.isRequired">
                <input type="radio" value="1" text="是" />
            	<input type="radio" value="2" text="否" />
		    </span>
	    </td>
	</tr>
	 <tr id="tr_04">         
		<td class="td_label" width="30%">
			 <span  class="top_required">*</span>属性类型 ：
		</td>
		<td class="td_content">
			<span uitype="radioGroup" name="attriType" id="attriType" value="1" databind="data.attriType" on_change="changeAttrType">
                <input type="radio" value="1" text="文本框"/>
            	<input type="radio" value="2" text="下拉单选"/>
            	<input type="radio" value="3" text="下拉多选"/>
		    </span>
	    </td>
	</tr>
	<tr id="info" style="display: none;">         
		<td class="td_label" width="30%">
			属性值<font color='red'> KEY&nbsp;</font>
		</td>
		<td class="td_content">
			 属性值<font color='red'> VALUE&nbsp;</font>
	    </td>
	</tr>
	<tr id="attribute_1" style="display: none;">         
		<td class="td_label" width="30%">
			 <span uitype="input" id="key_1" maxlength="20" width="80" value="1" validate="[{'type':'required', 'rule':{'m': '属性值Key不能为空。'}},{'type':'custom','rule':{'against':'isKeyContainSpecial','m':'属性值Key只能为英文、数字或下划线。'}},{'type':'custom','rule':{'against':'isKeyExsit','m':'同一属性下该属性值Key已存在。'}}]"></span>
		</td>
		<td class="td_content">
			<span uitype="input" id="value_1" maxlength="20" width="200" validate="属性值Value不能为空。"></span>
			<img src="${pageScope.cuiWebRoot}/top/sys/images/add.png" onclick="addValue();" style="cursor:pointer;" title="添加属性值">
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
//人员mark
var mark =1;
totalSize++;
var data = {};
//扫描，相当于渲染
window.onload=function(){
	initPage();
	comtop.UI.scan();
	  
	 
	if(defineId){
		//编辑页面的时候，将保存并继续的按钮屏蔽掉
		cui('#saveAndContinue').hide();
		//编辑页面的时候，编码不可更改
		cui('#attriCode').setReadOnly(true);
		//编辑页面的时候，需要判断属性类型，下面值的展现
		changeAttrType();
	}
}
//初始化页面
function initPage(){
	if(defineId){
		//编辑
		dwr.TOPEngine.setAsync(false);
		ExtendAttrAction.getExpandDefine(defineId,function(expandDefineData){
		    //填充数据
		    data = expandDefineData;
		    oldAttriName=data.attriName;
		});
		dwr.TOPEngine.setAsync(true);
	}else{
		//新增--获取可以用的atti_id
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
var flag = true;//创建一个flag标识值，标识在切换属性类型的时候是否需要进行addValue();
//切换属性类型
function changeAttrType(){
	if(cui("#attriType").getValue()=='2' || cui("#attriType").getValue()=='3'){
		$('tr[id^=attribute_]').show();
		$('#info').show();
		//编辑页的时候解析默认值到页面
		if(defineId){
			var attriDefaultValue = data.attriDefaultValue;
			if(attriDefaultValue!=null&&attriDefaultValue!=''){
				var attrValues = attriDefaultValue.split(';');
				var attrValue;
				for(var i=0;i<attrValues.length;i++){
					//需要先将输入框添加进去，然后再赋值
					if(flag && i!=0){
						addValue();
					}
					attrValue = attrValues[i];
					var arrays = attrValue.split('-');
					var index = i + 1;
					cui('#key_'+index).setValue(arrays[0]);
					cui('#value_'+index).setValue(arrays[1]);
					//编辑时候，key值不可以编辑
					cui('#key_'+index).setReadonly(true);
				}
			}
			flag = false;
		}
		//动态添加验证
		window.validater.add("value_1",'required',{m:'值不能为空。'});
	}else{
		$('tr[id^=attribute_]').hide();
		$('#info').hide();
	}
}
//添加属性
function addValue(){
	//下拉列表最多100个属性 加上前面4行，一共105行
	var totalRowsLength = 100;
	var table = document.getElementById('attributeTable');
	var rows = table.rows.length;
	if(rows>totalRowsLength+4){
		cui.alert('下拉列表型数据最多添加100个数据值。');
		return;
	}
	//获取已添加的数据值个数，以便于确认即将添加的数据值的id以及label
	var lastRowId = $('table>tbody>tr:last>td:last>span')[0].id;
	var lastRowIndex = lastRowId.substring(6);
	var thisRowIdex = parseInt(lastRowIndex)+1;
	var oTr = table.insertRow(rows)
	var oTd = oTr.insertCell(0);
	oTd.className = "td_label";
	oTd.innerHTML = '<span uitype="input" id="key_'+thisRowIdex+'" maxlength="20" width="80" value="'+thisRowIdex+'" validate="[{\'type\':\'required\', \'rule\':{\'m\': \'属性值Key不能为空。\'}},{\'type\':\'custom\',\'rule\':{\'against\':\'isKeyContainSpecial\',\'m\':\'属性值Key只能为英文、数字或下划线。\'}},{\'type\':\'custom\',\'rule\':{\'against\':\'isKeyExsit\',\'m\':\'同一属性下该属性值Key已存在。\'}}]"></span>';
	
	oTd = oTr.insertCell(1);
	oTd.className = "td_content";
	//最后一个属性值不需要添加图标
	if(thisRowIdex!=totalRowsLength){
		oTd.innerHTML ='<span uitype="Input" id="value_'+thisRowIdex +'" maxlength="20" width="200" validate="不能为空。"></span><img  src="${pageScope.cuiWebRoot}/top/sys/images/add.png" onclick="addValue();" style="cursor:pointer" title="添加属性值">&nbsp;<img   src="${pageScope.cuiWebRoot}/top/sys/images/remove.png" onclick="deleteValue('+thisRowIdex+');" style="cursor:pointer" title="删除属性值">';
	}else{
		oTd.innerHTML ='<span uitype="Input" id="value_'+thisRowIdex +'" maxlength="20" width="200"  validate="不能为空。"></span><img   src="${pageScope.cuiWebRoot}/top/sys/images/remove.png" onclick="deleteValue('+thisRowIdex+');" style="cursor:pointer" title="删除属性值">';
	}
	oTr.id = "attribute_"+thisRowIdex;
	
	//指定范围扫描
	comtop.UI.scan($('#attributeTable'));
	 
	//移除掉上一行的添加图标
	$('#attribute_'+lastRowIndex+'>td:last>img').hide();
	
}
//删除属性
function deleteValue(index){
	var table = document.getElementById('attributeTable');
	if(index>1){
		//取消删除的属性key验证
        window.validater.disValid('key_'+index, true);
        window.validater.disValid('value_'+index, true);
        //删除元素
		table.deleteRow(index+4);
		//最后一行删除，上一行显示图标
		$('#attribute_'+(index-1)+'>td:last>img').show();
	}else{
		cui.alert("至少保留一行输入值");
	}
}
//获取属性值
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
//关闭窗口
function closeSelf(){
	window.parent.dialog.hide();
}
//保存继续
function saveUserAndContinue(){
	saveUserExpandDefine('continue');
}
//校验key值是否含有特殊字符
function isKeyContainSpecial(key){
	var reg = new RegExp("^[A-Za-z0-9_]+$");
	return (reg.test(key));
}
// 校验key值是否已经存在
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
//保存
function saveUserExpandDefine(flag){
		 //设置验证获取信息
	     if(cui("#attriType").getValue()=='1'){//指定表单验证
	       var map = window.validater.validElement('CUSTOM',['attriName', 'attriCode', 'isRequired', 'attriType']);
	     }else{
	       var map = window.validater.validAllElement();
	     }
	   	 var inValid = map[0];//放置错误信息
	   	 var valid = map[1]; //放置成功信息
         if (inValid.length > 0) {
            var str = "";
            for (var i = 0; i < inValid.length; i++) {
				str +=  inValid[i].message + "<br />";
			}
         }else {
        	 //获取表单信息
         	 var vo = cui(data).databind().getValue();
         	 vo.attributeClassify=orgStrucId;
         	 vo.mark = mark;
         	 //此处不知为何，databind取的值不全，重新设定
         	 vo.attriType = cui('#attriType').getValue();
         	 vo.isRequired = cui('#isRequired').getValue();
         	 if(cui("#attriType").getValue()=='2' || cui("#attriType").getValue()=='3'){
         	 vo.attriDefaultValue = getAttrDefaultValue();
         	 }else{
         		vo.attriDefaultValue='';
         	 }
         	if(defineId){//编辑
		         	if(oldAttriName!=vo.attriName){
		         		dwr.TOPEngine.setAsync(false);
						var message = "所有人员的<font color='red'>&quot;"+oldAttriName+"&quot;</font>属性都变为<font color='red'>&quot;"+vo.attriName+"&quot;</font>属性，所有值都保留，是否确认修改？";
						cui.confirm(message,{
							onYes:function(){
								ExtendAttrAction.updateExpandDefine(vo,function(){
					                //刷新列表
				            	    window.parent.editCallBack(vo.defineId);
				            	    window.parent.cui.message('修改扩展属性成功。','success');
				            	    closeSelf();
						    	});
						  	}
						});
						dwr.TOPEngine.setAsync(true);
			         }else{
		         		dwr.TOPEngine.setAsync(false);
		         		ExtendAttrAction.updateExpandDefine(vo,function(){
				                //刷新列表
			            	    window.parent.editCallBack(vo.defineId);
				            	window.parent.cui.message('修改扩展属性成功。','success');
				            	closeSelf();
				    		});
				         dwr.TOPEngine.setAsync(true);
				      }
         	}else{
         		ExtendAttrAction.queryExtendDefineList(orgStrucId,mark,function(datalist){
			    	if(datalist.count>=20){
			    		cui.alert('最多只能新增20个扩展属性。');
				    }else{
			        	 dwr.TOPEngine.setAsync(false);
			        	 ExtendAttrAction.insertExpandDefine(vo,function(id){
				            //刷新列表
			            	window.parent.editCallBack(id);
				            window.parent.cui.message('新增扩展属性成功。','success');
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

//保存继续的时候清空下拉列表里面的值
function clearAttrValue(){
	var selectedRows = $('tr[id^=attribute_]');
	for(var i=1;i<=selectedRows.length;i++){
		cui('#key_'+i).setValue(i,true); 
		cui('#value_'+i).setValue('',true); 
	}
}

/*
* 判断扩展属性名是否包含特殊字符
*/
function isContainSpecialChar(){
	var attriName = arguments[0];
	var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9]+$");
	return (reg.test(attriName));
}

/**
 * 属性编码只能为中英文及下划线
 */
function isCodeContainSpecialChar(){
	var attrubuteCode = cui('#attriCode').getValue();
	var reg = new RegExp("^[A-Za-z0-9_]+$");
	return (reg.test(attrubuteCode));
}

/**
 * 判断该属性编码是否唯一
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
* 判断扩展属性名称是否重复
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