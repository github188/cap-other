<%
  /**********************************************************************
	* CAP业务事项编辑
	* 2015-11-12 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>CAP业务事项编辑</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"/>
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js"/>
		<top:script src="/cap/dwr/util.js"/>
		<top:script src="/cap/bm/common/top/js/jquery.js"/>
		<top:script src="/cap/bm/common/js/capCommon.js"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
		<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/base/js/cap_ui_attachment.js'></script>
</head>
<style>
.top_header_wrap{
				margin-right:28px;
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body class="top_body">
		<div class="top_header_wrap">
			<div class="thw_operate">
				<span uitype="button" id="btnSave" label="保  存" button_type="blue-button" on_click="saveInfo"></span>
				<span uitype="button" id="btnContinu" label="保 存并继续" button_type="blue-button" on_click="saveContinu"></span> 
				<span uitype="button" id="btnClose" label="返 回" button_type="blue-button" on_click="close"></span>
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout: fixed;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr id="code_tr">
					<td class="td_label">编码：</td>
					<td>
						<span uitype="Input" id="code" width="85%" databind="itemInfo.code" type="text" readonly="true"></span>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td class="td_label">所属业务域：</td>
					<td><span uitype="ClickInput" id="belongDomain" name="belongDomain" databind="itemInfo.belongDomain" width="85%" readonly="true"></span></td>
					<td class="td_label">名称<span class="top_required">*</span>：</td>
					<td><span uitype="input" id="name" name="name" databind="itemInfo.name" maxlength="200" width="85%" validate="checkName"></span></td>
				</tr>
<!-- 				<tr> -->
<!-- 					<td class="td_label">管控策略：</td> -->
<!-- 					<td><span uitype="PullDown" id="managePolicy" name="managePolicy" databind="itemInfo.managePolicy" width="85%" datasource="managePolicyData"></span></td> -->
<!-- 					<td class="td_label">统一规范策略：</td> -->
<!-- 					<td><span uitype="PullDown" id="normPolicy" name="normPolicy" databind="itemInfo.normPolicy" width="85%" datasource="normPolicyData"></span></td> -->
<!-- 				</tr> -->
				<tr>
					<td class="td_label">业务说明：</td>
					<td colspan="3"><span  uitype="Editor" id="bizDesc"  toolbars="toolbars" width="93%" min_frame_height="110" databind="itemInfo.bizDesc" maximum_words="4000"></span></td>
				</tr>
				<tr>
					<td class="td_label">引用文件：</td>
					<td colspan="3"><span  uitype="Editor" id="referenceFile" toolbars="toolbars" width="93%" min_frame_height="110" databind="itemInfo.referenceFile" maximum_words="4000"></span></td>
				</tr>
				<tr>
					<td class="td_label">管理要点：</td>
					<td colspan="3"><span  uitype="Editor"  id="managePoints" toolbars="toolbars" width="93%" min_frame_height="110" databind="itemInfo.managePoints" maximum_words="4000"></span></td>
				</tr>
				<tr>
					<td class="td_label">关联角色：</td>
					<td colspan="3">
						<span uitype="ClickInput" id="roleNames" databind="itemInfo.roleNames" width="90%" on_iconclick="btnChooseRole"></span>
						<span uitype="button" on_click="btnClean" id="btnClean" hide="false" button_type="blue-button" label="清空"></span>
					</td>
				</tr>
			</table>
		</div>
	<top:script src="/cap/dwr/interface/BizItemsAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script type="text/javascript">
	var selectDomainId = "${param.selectDomainId}";
	var ItemInfoVO={};
	var selectItemId="${param.selectItemId}";
	var saveContinued=false;
	var itemsRoleList=[];
	var checkName=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}},
	               {'type':'custom','rule':{'against':'checkItemName', 'm':'名称已存在，请使用其他名称'}}
	               ]
	window.onload = function(){
		init();
		if(cui("#roleNames").getValue()){
			cui("#btnClean").show();
		}
		else{
			cui("#btnClean").hide();
		}
	}
	
	//界面加载前数据处理 
	function init(){
		if(selectItemId){
			dwr.TOPEngine.setAsync(false);
			BizItemsAction.queryBizItemsById(selectItemId,function(data){
   				if(data){
   					itemInfo=data;
   					if(itemInfo.bizItemsRoleList){
   						itemsRoleList=data.bizItemsRoleList;
   					}
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
   			comtop.UI.scan();
   			cui("#btnContinu").hide();
		}
		else{
			comtop.UI.scan();
			cui("#btnContinu").show();
   			$("#code_tr").hide();
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(selectDomainId,function(data){
   				if(data){
   					cui("#belongDomain").setValue(data.name);
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
	}

	//关闭窗口
	function close(){
		if(selectItemId=="" || selectItemId ==null){
			var vUrl = "BizItemList.jsp?selectDomainId="+selectDomainId+"&selectItemId="+selectItemId;	
			window.location.href = vUrl;
		}
		else{
			var vUrl = "BizItemList.jsp?selectDomainId="+selectDomainId;	
			window.location.href = vUrl;
		}
	}
	
	//保存
	function save(){
		var str = "";
		if(window.validater){
			window.validater.notValidReadOnly = true;
			var map = window.validater.validAllElement();
			var inValid = map[0];
			var valid = map[1];
			//验证消息
			if(inValid.length > 0) { //验证失败
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
			}
			if(str != ""){
				return false;
			}
		}
		ItemInfoVO=cui(itemInfo).databind().getValue();
		ItemInfoVO.domainId=selectDomainId;
		ItemInfoVO.dataFrom=0;
		if(itemsRoleList){
			ItemInfoVO.bizItemsRoleList=itemsRoleList;
			for(var i=0;i<itemsRoleList.length;i++){
				ItemInfoVO.bizItemsRoleList[i].id=null;
			}
		}
		else{
			ItemInfoVO.bizItemsRoleList=null;
		}
		if(saveContinued){
			ItemInfoVO.id=null;
		}
		dwr.TOPEngine.setAsync(false);
		BizItemsAction.saveBizItems(ItemInfoVO,function(data){
 			if(data) {
 				window.parent.cui.message('保存成功。','success');
 				ItemInfoVO.id=data;
 				selectItemId=data;
 			}else{
 				window.parent.cui.message('保存失败。','error');
 			}
		});
		dwr.TOPEngine.setAsync(true);
		return true;
	}
	
	//去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
 	
 	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
 	
	//保存按钮
	function saveInfo(){
		if(save()){
			close();
		}
		else{
			return;
		}
	}
	
	//保存继续按钮
	function saveContinu(){
		if(save()){
			cui(itemInfo).databind().setEmpty();
			saveContinued=true;
			cui("#bizDesc").setHtml("");
			cui("#referenceFile").setHtml("");
			cui("#managePoints").setHtml("");
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(selectDomainId,function(data){
					if(data){
						cui("#belongDomain").setValue(data.name);
					}
				});
			dwr.TOPEngine.setAsync(true);
		}
		else{
			return;
		}
	}
	
	function notCn(data){
		if (/[\u4E00-\u9FA5]/i.test(data)){
			return false;
		  }
		return true;
	}
	
	function btnChooseRole(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/role/chooseMulRole.jsp?domainId="+selectDomainId;
		var title="角色选择";
		var height = 550; //600
		var width =  700; // 680;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//导入回调方法 
	function chooseRole(selectRole){
		getArray(selectRole);
		cui("#btnClean").show();
	}
	
	//判断是否重复
	function getArray(selects){
		var roleNames="";
		var roleVO={};
		if(itemsRoleList.length>0){
			roleNames=itemInfo.roleNames;
			for(var i=0;i<selects.length;i++){
				var flag=true;
				for(var j=0;j<itemsRoleList.length;j++){
					if(selects[i].id==itemsRoleList[j].roleId){
						flag=false;
					}
				}
				if(flag){
					roleVO={'roleId':selects[i].id};
					itemsRoleList.push(roleVO);
					roleNames+=selects[i].roleName+";";
				}
			}
			cui("#roleNames").setValue(roleNames);
		}
		else{
			for(var i=0;i<selects.length;i++){
				roleVO={'roleId':selects[i].id};
				itemsRoleList.push(roleVO);
				roleNames+=selects[i].roleName+";";
			}
			cui("#roleNames").setValue(roleNames);
		}
	}
	
	function btnClean(){
		cui("#roleNames").setValue("");
		itemsRoleList=[];
		itemInfo.roleNames="";
		cui("#btnClean").hide();
	}
	
	//名称查重
	function checkItemName(data){
		data=trim(data);
		var strResult=false;
		var itemVO={};
		if(selectItemId){
			itemVO=itemInfo
		}
		else{
			itemVO.domainId=selectDomainId;
		}
		itemVO.name=data;
		dwr.TOPEngine.setAsync(false);
		BizItemsAction.checkItemName(itemVO,function(data){
			strResult=data;
		});
		dwr.TOPEngine.setAsync(true);
		return strResult;
	}
	
	toolbars=[[
	           'undo', //撤销
	           'redo', //重做
	           'bold', //加粗
	           'indent', //首行缩进
	           'italic', //斜体
	           'underline', //下划线
	           'strikethrough', //删除线
	           'time', //时间
	           'date', //日期
	           'fontfamily', //字体
	           'fontsize', //字号
	           'paragraph', //段落格式
	           'edittable', //表格属性
	           'edittd', //单元格属性
	           'spechars', //特殊字符
	           'justifyleft', //居左对齐
	           'justifyright', //居右对齐
	           'justifycenter', //居中对齐
	           'justifyjustify', //两端对齐
	           'forecolor', //字体颜色
	           'insertimage',//多图上传 
	           'rowspacingtop', //段前距
	           'rowspacingbottom', //段后距
	           'pagebreak', //分页
	           'imagecenter', //居中
	           ]];
</script>
</body>
</html>