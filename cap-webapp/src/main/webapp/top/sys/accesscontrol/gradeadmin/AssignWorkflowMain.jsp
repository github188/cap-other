<%
  /**********************************************************************
	* ��ɫ������ͼ
	* 2013-3-29  ��С�� �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<title>����������</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>                                                         

	<style type="text/css">
		img{
		  margin-left:5px;
		}
		#addRoleButton{
		margin-right:5px;
		}
		 .grid_container input{margin-left: -3px;} 
	</style>
	</head>
<body onload="window.status='Finished';">

<div uitype="Borderlayout" id="body"  is_root="true">
<!-- ���ģ���� -->
		<div  uitype="bpanel" style="overflow:hidden" id="leftMain" position="left" width="288"  show_expand_icon="true">       
        <div style="padding-top:40px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:40px;width:100%;">
			<div style = "padding-left:15px;padding-top:5px;">
					<span uitype="ClickInput" id="keyword" name="keyword" emptytext="������ϵͳӦ�����ƹؼ��ֲ�ѯ"
					on_iconclick="fastModuleQuery"  icon="search" enterable="true"
					editable="true"	 width="260px" on_keydown="keyDownModuleQuery"></span>
					</div>
				 </div>     
               <div  id="treeDivHight" style="overflow:auto;height:100%;">
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div>
                     <div id="moduleTree" uitype="Tree" children="initDataModule" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
                 </div>
                 </div>
         </div>
		  <div  uitype="bpanel"  position="center" id="centerMain" header_title="��ɫ�б�"    height="500">
			
		</div>
	</div>
	
<script type="text/javascript">
    var activeRoleClassifyId = "";
    var adminId="<c:out value='${param.adminId}'/>";
//     var moduleId="${param.parentFuncId}";
	var parentFuncId = "";
	var currentModuleCode = '';
    var initBoxData=[];
    var dialog;
    queryCondition={};
    var roleWin;
    //��ǰѡ�е����ڵ�
	var curNodeId = '';
	$(document).ready(function (){
		comtop.UI.scan(); 
		$("#treeDivHight").height($("#leftMain").height()-40);
		//cui('#body').setContentURL("left",'${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/SysModuleThree.jsp');
		//expandToNode();
		showFuncList();
		
	});
	
	window.onresize= function(){
		setTimeout(function(){
			$("#treeDivHight").height($("#leftMain").height()-40);
		},300);
	}
	
	 function showFuncList() {
			cui('#body').setContentURL(
					"center",
					'AssignWorkflowList.jsp?moduleCode=' + currentModuleCode+"&adminId="+adminId);
		}
	 //չ��ָ���ڵ�
	 function expandToNode(){
         cui("#moduleTree").getNode("<c:out value='${param.moudleId}'/>").focus();
         showFuncList();
     }
   		
   	//---------------------------------------------------------------	
   		
   	//��ʼ������ 
		function initDataModule(obj) {
			$('#fastQueryList').hide();
			 
			var moduleObj={"parentModuleId":"-1"};
			ModuleAction.queryChildrenModule(moduleObj,function(data){
			
				if(data == null || data == "") {
					//��Ϊ��ʱ�����и��ڵ���������
					return;
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
			    	obj.setDatasource(treeData);
			    	nodeData = treeData;
				}
		     });
		}
   	
		// �������¼�
		function treeClick(node){
			var data=node.getData();
			curNodeId=data.key;
			node.select();
			parentFuncId=curNodeId;
			currentModuleCode = data.data['moduleCode'];
			showFuncList();
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
			var moduleObj={"parentModuleId":node.getData().key};
			ModuleAction.queryChildrenModule(moduleObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	treeData.activate = true;
		    	node.addChild(treeData.children);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}

		//���ٲ�ѯ�б�����Դ
		function listBoxData(obj) {
			initBoxData = [];
			var keyword = cui("#keyword").getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			dwr.TOPEngine.setAsync(false);
			ModuleAction.fastQueryModule(keyword, function(data) {
				var len = data.length;
				if (len != 0) {
					$.each(data, function(i, cData) {
						if (cData.moduleName.length > 31) {
							path = cData.moduleName.substring(0, 31) + "..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({
							href : "#",
							name : path,
							title : cData.moduleName,
							onclick : "clickRecord('" + cData.moduleId + "','"
									+ cData.moduleName + "')"
						});
					});
				} else {
					initBoxData.push({
						href : "#",
						name : "û������",
						title : "",
						onclick : ""
					});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}

		function fastModuleQuery() {
			var keyword = cui('#keyword').getValue();

			if (keyword == '') {
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node = cui('#moduleTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//���̻س������ٲ�ѯ 
		function keyDownModuleQuery() {
			if (event.keyCode == 13) {
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
			parentFuncId=moduleId;
			showFuncList();
		}

    </script>
</body>
</html>
            