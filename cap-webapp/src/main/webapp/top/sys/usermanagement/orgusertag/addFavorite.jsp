<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ѡ��ҳ��</title>
    <top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/deptfavorite.css"/>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
    <style type="text/css">
    html,body{
		margin:0;
		width:100%; 
	  	overflow:hidden;
	  }
      .listbox{
         overflow-x:auto; 
      }
      .listbox .tr{
         
        width:auto;
      }
      .listbox .tr .td{
        overflow:visible;
        text-overflow: inherit;
         width:auto;
      }
    </style>
</head>
<body>
	<div id="choose_page_box" class="choose_page_box">
		<div class="choose_page_top">
			<div class="choose_page_left">
				<div class="choose_page_left_top">
					<div class="left_top">
						<label style="font-size: 12px;">��֯�ṹ��<span id="orgStructure"></span></label>
					</div>
					<div class="left_top">
						<input type="hidden" id="queryDeptId"/>
						<span class="query" onclick="fastQuery();"></span>
						<span uitype="Input" name="" id="keyword" width="285" emptytext="�������ơ�ȫƴ����ƴ��ѯ" on_keyup="fastQuery"></span>
						<div id="searchDiv"  class="search_div" >
					   	 	<div id="queryDataArea" class="queryList"></div>
						    <div id="moreData" class="more_data"><a href="#" hidefocus="true" onclick="_showMoreData();return false;">��������...</a></div>
				     	</div>
					</div>
				</div>
				<div class="choose_page_left_bottom">
					<div id="div_tree" style="overflow: auto;height:100%;width:100%;">
						<div uitype="Tree" id="tree" children="[]" select_mode="2" checkbox="true" on_activate="selectNode" on_dbl_click="dbclickNode" on_expand="onExpand" on_lazy_read="lazyData" click_folder_mode="3" min_expand_level="2"></div>
					</div>
				</div>
			</div>

			<div class="choose_page_center" id="chooseCenterDiv">
				<div class="center_btns">
					<a class="btns_group addBtn" href="javascript:;" title="���" onclick="addData();return false;"></a>
   		 			<a class="btns_group addChildBtn" href="javascript:;" title="����ӽڵ�" onclick="addDataChild();return false;"></a>
   		 			<a class="btns_group deleteBtn" href="javascript:;" title="ɾ��ѡ�нڵ�" onclick="deleteSelectedData();return false;"></a>
				</div>
			</div>
			
			<div id="choose_page_right" class="choose_page_right">
				<div class="choose_page_right_top">
					<c:choose>
						<c:when test="${param.chooseType=='user' }">
							<div id="selectCountDiv">��ѡ��Ա��0 ��</div>
						</c:when>
						<c:otherwise>
							<div id="selectCountDiv">��ѡ��֯��0 ��</div>
						</c:otherwise>
					</c:choose>
				</div>
				<div id="div_selected" class="choose_page_right_bottom"></div>
			</div>
		</div>
		<div class="choose_page_bottom">
			<span uitype="Button" id="ok" label="ȷ��" on_click="submitClick"></span>
			<span uitype="Button" id="clear" label="���" on_click="clearSelected"></span>
			<span uitype="Button" id="close" label="�ر�" on_click="winClose"></span>
		</div>
	</div>

<top:script src="/top/js/jquery.js"/>
<top:script src="/top/sys/js/commonUtil.js"/>
<top:script src="/top/sys/dwr/engine.js"/>
<top:script src="/top/sys/dwr/interface/ChooseAction.js"/>
<top:script  src="/top/sys/usermanagement/orgusertag/js/deptUserCommon.js"/>
<script type="text/javascript">	

	//Ĭ����֯�ṹID
	var orgStructureId ="<c:out value='${param.orgStructureId}'/>";
	var orgStructureName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgStructureName}'/>"));
	var groupId = "<c:out value='${param.groupId}'/>";
	var unselectableCode = "<c:out value='${param.unselectableCode}'/>";
	var levelFilter =Number("<c:out value='${param.levelFilter}'/>");
	var idSuffix = "<c:out value='${param.idSuffix}'/>";
	//ѡ������
	var chooseType = "<c:out value='${param.chooseType}'/>";
	//ѡ��ģʽ ��ѡ ÿ��ѡ��������ѡ30������
	var chooseMode = 30;
	//���ڵ�ID
	var rootId ="<c:out value='${param.rootId}'/>";
	var pageNo=1;;
    var pageSize=10;
 	//�û�����
	var userType = "<c:out value='${param.userType}'/>";
	
	var winType = "<c:out value='${param.winType}'/>";
	jQuery(document).ready(function(){
		comtop.UI.scan();
		init();
	});
	//ҳ���ʼ������
	function init(){
		$('#orgStructure').text(orgStructureName);
		initRoot();
		selectedClick();
		keyboardEvent(false);
	}

	//��ʼ�������ڵ�
	function initRoot(){
		rootId = getRootId(rootId,orgStructureId);
		$('#div_list').hide();
		$('#page').hide();
		var vo = {};
		vo.chooseType = chooseType;
		vo.orgStructureId = orgStructureId;
		if(rootId&&rootId!='-1'){
			vo.orgId = rootId;
		}else{	
			vo.parentOrgId = '-1';
		}
		dwr.TOPEngine.setAsync(false);
		ChooseAction.queryNode(vo,unselectableCode,function(data){
			if(!data){
				$('#div_none').show();
				$('#div_tree').hide();
			}else{
				handleNodeData(data);
				cui('#tree').setDatasource(data);
				if(data.isLazy){
					cui('#tree').getNode(data.key).expand();
				}
				$('#div_none').hide();
				$('#div_tree').show();
				
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//���ٲ�ѯ
	function fastQuery(event){
		//�жϼ����¼����������¼����س���
		if(typeof event == "undefined" || isValidKeyCodeForQueryData(event.keyCode)){
			clearTimeout(tempFunc);
			clearTimeout(tempNoDataFunc);
			pageNo = 1;
			tempFunc = setTimeout(function(){_fastQuery("replace")},300);
		}
	}
	
	function _showMoreData(){
		var moreData = $("#moreData");
		if(moreData.hasClass("more_data")){
			pageNo++;
			moreData.removeClass("more_data");
			moreData.addClass("more_data_disable");
			_fastQuery("add");
		}
	}
	
	/**ִ�п��ٲ�ѯ
	*/
	function _fastQuery(type){
		var keyword = handleStr(cui('#keyword').getValue());
		keyword=$.trim(keyword);
		
		// ����ֶ�Ϊ�գ����û���ղ�ѯ�ֶκ�����div
		if(keyword == ""){
			$("#searchDiv").slideUp("fast");
			return;
		}
		var vo = {};
		vo.keyword = keyword;
		vo.orgStructureId = orgStructureId;
		vo.rootDepartmentId = rootId;
	    vo.pageNo=pageNo;
		vo.pageSize=pageSize;
		vo.levelFilter = levelFilter;
		_doQuery(vo,type);
	}
	
	//�رմ���
	function winClose(){
		if(winType==="window"){
			window.close();			
		}else{
			//�رնԻ���
	        window.top.cuiEMDialog.dialogs[getDialogId()].hide();
		}
	}

	function getDialogId(){
		return chooseType==="org"?"addFavoriteOrgDialog"+idSuffix:"addFavoriteUserDialog"+idSuffix;	
	}
	
	/**
	 * ȷ����ť�¼�
	 */
	function submitClick(){
		var container = getSelectedBox();
		var $SelectData = container.children("div");
		var oneData,selectedId=[];
		for(var i=0;i<$SelectData.length;i++){
			oneData = $SelectData.eq(i)
			selectedId.push(oneData.attr("id").replace("div_",""));
		}
		var deptIds = selectedId.join(";");
		if(deptIds!=""){
			if(winType==="window"){
				window.opener.saveFavoriteToDB(deptIds,groupId);
			}else{
				window.top.cuiEMDialog.wins[getDialogId()].saveFavoriteToDB(deptIds,groupId);
			}
		}
		winClose();
	}
    
</script>
</body>
</html>
