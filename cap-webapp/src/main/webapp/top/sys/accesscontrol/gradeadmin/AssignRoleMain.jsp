
<%
	/**********************************************************************
	 * �ּ�������Դ�����ɫ�б�ҳ��
	 * 2014-7-15  ������ �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>��ɫ������ͼ</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
	
	<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
	
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>

<style type="text/css">
img {
	margin-left: 5px;
}

#addRoleButton {
	margin-right: 5px;
}

.grid_container input {
	margin-left: -3px;
}
</style>
</head>
<body onload="window.status='Finished';">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- ���ģ���� -->
		<div uitype="bpanel" style="overflow:hidden" id="leftMain" position="left" width="288"
			show_expand_icon="true">
			<div style="padding-top:40px;width:100%;position:relative;">
		          <div style="position:absolute;top:0;left:0;height:55px;width:100%;">
		          	
					<div style = "padding-left:5px;padding-top:5px;">
						<span uitype="ClickInput" id="keywordModule" name="keywordModule"
								emptytext="������ϵͳӦ�����ƹؼ��ֲ�ѯ" on_iconclick="fastModuleQuery"
								icon="search"
								enterable="true" editable="true" width="260px"
								on_keydown="keyDownModuleQuery"></span>
					</div>
					<div id="associateDiv" style="padding-left:5px;text-align: left;width:186px;font:12px/25px Arial;margin-bottom: 1px;" >
						<input type="checkbox" id="associateQuery" align="middle"  title="������ѯ" onclick="setAssociate(0)" style="cursor:pointer;"/>
						<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">������ѯ��ɫ</font></label>
					</div>
				  </div>
				  
				  <div style="height:15px;width:100%"></div>
	               <div  id="treeDivHight" style="overflow:auto;height:100%;">
							<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
							<div id="moduleTree" uitype="Tree" children="initDataModule"
								on_lazy_read="loadNode" on_click="treeClick"
								click_folder_mode="1"></div>
				   </div>
			</div>

		</div>
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="��ɫ�б�" height="500" style="margin-left: 10px">
			<div class="list_header_wrap">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="�������ɫ���ƻ������ؼ��ֲ�ѯ" on_keydown="keyDowngGridQuery"
						width="271px" on_iconclick="iconclick" icon="search"></span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="����"
						on_click="saveRole"></span>
				</div>
			</div>
			<div id="grid_wrap">
				<table uitype="grid" id="roleGrid" sorttype="1" 
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					
					<th><input type="checkbox"/></th>
					<th bindName="roleName" sort="true">��ɫ����</th>
					<th bindName="description" sort="true">����</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">������</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
					<th bindName="strRoleType" sort="true"
						renderStyle="text-align: center">��ɫ����</th>
					
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	    var subjectId="<c:out value='${param.subjectId}'/>";
		var activeRoleClassifyId = "";
		var roleClassifyType = "";
		var resourceTypeCode="ROLE";
		var subjectClassifyCode="ADMIN";
		queryCondition = {};
		var oldResourceIds="";
		var roleWin;
		//��ǰѡ�е����ڵ�
		var curNodeId = '-1';
		$(document).ready(function() {
			comtop.UI.scan();
			 $("#treeDivHight").height($("#leftMain").height()-55);
		});

		window.onresize= function(){
			setTimeout(function(){
				$("#treeDivHight").height($("#leftMain").height()-55);
			},300);
		}
		//���ٲ�ѯ
		function fastQuery() {
			var keyword = cui('#keyword').getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			if (keyword == '') {
				switchTreeListStyle("tree");
				//TODO ����ѡ��ڵ㣬��ˢ���Ҳ�iframe
				var node = cui('#roleClassifyTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				switchTreeListStyle("list");
				listBoxData(cui('#fastQueryList'), keyword);
			}
		}
		//˫���б��¼
		function selectMultiNavClick(roleClassifyId, roleClassifyName,
				fatherClassifyId) {
			tempMultiNavClickId = roleClassifyId;
			tempMultiNavClickFatherId = fatherClassifyId;
			tempMultiNavClickName = roleClassifyName;
			var selectedRoleClassifyId;
			if (roleClassifyId == null) {
				selectedRoleClassifyId = '';
			} else {
				selectedRoleClassifyId = roleClassifyId;
			}
			activeRoleClassifyId = selectedRoleClassifyId;
			cui("#roleGrid").loadData();
		}
		
		//-----------------------------------------------------------------------------------�����༭�򵯳�ǰԤ��������-----------------------------------		
		//----------------------------------------------------------------------------------------------------------------------------------------------
		//�����ѡ�нڵ㣬ˢ���Ҳ�
		function refreshRoleList() {
			var activeNode = cui("#roleClassifyTree").getActiveNode();
			if (!activeNode) {
				cui.alert("��ѡ��ڵ㡣");
				cui('#body').setContentURL("center", "");
				return;
			}
			activeRoleClassifyId = activeNode.getData().key;
			cui("#roleGrid").loadData();
		}

		
		//��Ⱦ�б�����
		function initGridData(grid, query) {
			oldResourceIds = "";
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.roleClassifyId = activeRoleClassifyId;
			queryCondition.fastQueryValue = gridKeyword;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			if(query.associateType!=null && query.associateType!=''){
				queryCondition.cascadeQuery = query.associateType;
			}else{
				queryCondition.cascadeQuery='';
			}
			queryCondition.creatorId=globalUserId;
			
			if (globalUserId == "SuperAdmin") {
				 dwr.TOPEngine.setAsync(false);
				   GradeAdminAction.querySuperAdminRoleList(queryCondition,subjectId, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
				 dwr.TOPEngine.setAsync(true);
			}
			 else {
				 dwr.TOPEngine.setAsync(false);
				 GradeAdminAction.queryGradeAdminRoleList(queryCondition,subjectId,function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					
					grid.setDatasource(dataList, totalSize);
				});
				 dwr.TOPEngine.setAsync(true);
			}
			var resourceIdArray=[];
			var resourceIds = oldResourceIds.substring(0, oldResourceIds.length - 1);
			resourceIdArray = resourceIds.split(",");
			if(resourceIdArray.length>0){
				grid.selectRowsByPK(resourceIdArray);
			}
		}

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return $('body').width() - 305;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		

		//����Ⱦ
		function columnRenderer(data, field) {
			var isSelect=data["isSelect"];
			var resourceId=data["roleId"];
			if(field=='roleName'&&isSelect==1){
				oldResourceIds+=resourceId+",";
			}
		}
		
		//�����ɫ
		function saveRole(){
			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();
			var oldResourceIdArray=[];
			oldResourceIds = oldResourceIds.substring(0, oldResourceIds.length - 1);
			oldResourceIdArray = oldResourceIds.split(",");
			dwr.TOPEngine.setAsync(false);
			GradeAdminAction.saveRoleSubjectResource(oldResourceIdArray,selectIds,subjectId,resourceTypeCode,subjectClassifyCode,globalUserId,function() {
				//cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
				 cui.message("��ɫ��Ȩ�ɹ���","success");
				 setTimeout('cui("#roleGrid").loadData()',500);
			});
			dwr.TOPEngine.setAsync(true);
		}
		//������ͼƬ����¼�
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			
			cui("#roleGrid").setQuery({
				pageNo : 1,
				associateType:$('#associateQuery')[0].checked==true?1:0
			});
			cui("#roleGrid").loadData();
		}

		//���̻س������ٲ�ѯ 
		function keyDowngGridQuery(event) {
			if (event.keyCode == 13) {
				iconclick();
			}
		}

		//���ü���  1Ϊ ������ѯ��0ΪĬ��
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		//ִ�в�ѯ
// 	     	var activeNode = cui("#roleClassifyTree").getActiveNode();
    		fastModuleQuery();
            
        }
		//---------------------------------------------------------------	
		//��ʼ������ 
		function initDataModule(obj) {
			$('#fastQueryList').hide();

			var moduleObj = {
				"parentModuleId" : "-1"
			};
			ModuleAction.queryChildrenModule(moduleObj, function(data) {
				if (data == null || data == "") {
					//��Ϊ��ʱ�����и��ڵ���������
					return;
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					obj.setDatasource(treeData);
					nodeData = treeData;
					var node = cui('#moduleTree').getNode(treeData.key);
					treeClick(node);
				}
			});
		}

		// �������¼�
		function treeClick(node) {
			var data = node.getData();
			curNodeId = data.key;
			node.select();
			activeRoleClassifyId = data.key;
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			var query = cui("#roleGrid").getQuery();
			query.pageNo = 1;
			query.associateType = associateType;
			//��ղ�ѯ�����������ͷ��������
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery(query)
			cui("#roleGrid").loadData();
		}

		function showTree() {
			cui('#keyword').setValue('');
			cui('#fastQueryList').hide();
			cui('#moduleTree').show();
			cui.addType = '';
		}

		//���click�¼����ؽڵ㷽��
		function loadNode(node) {
			curNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var moduleObj = {
				"parentModuleId" : node.getData().key
			};
			ModuleAction.queryChildrenModule(moduleObj, function(data) {
				var treeData = jQuery.parseJSON(data);
				treeData.activate = true;
				node.addChild(treeData.children);
				node.setLazyNodeStatus(node.ok);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//���ٲ�ѯ�б�����Դ
		function listBoxData(obj){
			initBoxData = [];
			var keyword = cui("#keywordModule").getValue().replace(new RegExp("/","gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
			dwr.TOPEngine.setAsync(false);
			ModuleAction.fastQueryModule(keyword,function(data){
				var len = data.length ;
				if(len != 0) {
					$.each(data,function(i,cData){
						if(cData.moduleName.length > 31) {
							path=cData.moduleName.substring(0,31)+"..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
					});
				} else {
					initBoxData.push({href:"#",name:"û������",title:"",onclick:""});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}
		
		function fastModuleQuery(){
			var keyword = cui('#keywordModule').getValue();
			if(keyword==''){
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node=cui('#moduleTree').getNode(curNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//���̻س������ٲ�ѯ 
		function keyDownModuleQuery() {
		
			if ( event.keyCode ==13) {
				fastModuleQuery();
			}
		}

		function clickRecord(moduleId, modulePath){
			var selectedModuleId = moduleId;
			var moduleName = "";
			var moduleType = "";
			var parentModuleId = "";
			var parentModuleName = "";
			var parentModuleType = "";
			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(selectedModuleId,function(data){
				var moduleVO = data;
				moduleName = moduleVO.moduleName;
				moduleType = moduleVO.moduleType;
				parentModuleId = moduleVO.parentModuleId;
			});	
			dwr.TOPEngine.setAsync(true);

			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(parentModuleId,function(data){
				var parentModuleVO = data;
				if(data == null) {
					parentModuleName = '';
				} else {
					parentModuleName = parentModuleVO.moduleName;
					parentModuleType = parentModuleVO.moduleType;
				}
			});	
			dwr.TOPEngine.setAsync(true);

			//curNodeId = moduleId
// 			var node = cui('#moduleTree').getNode(curNodeId);
// 			node.select();
			activeRoleClassifyId = moduleId;
			var query = cui("#roleGrid").getQuery();
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			query.pageNo = 1;
			query.associateType = associateType;
			
			//��ղ�ѯ�����������ͷ��������
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery(query)
			cui("#roleGrid").loadData();
		}
	</script>
  </body>
</html>
