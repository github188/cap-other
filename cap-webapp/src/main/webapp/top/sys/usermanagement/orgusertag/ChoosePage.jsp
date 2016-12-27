<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ѡ��ҳ��</title>
    <top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/deptfavorite.css"/>
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
      .bottom_left_a {
       	font-size:13px;
		margin:5px 5px 7px 5px ;
		*margin:23px 5px 5px 5px ;
		float:left;
	  }
    </style>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
</head>
<body>
	<div uitype="Tab" tabs="tabs"  id="tab"></div>
	<div id="choose_page_box" class="choose_page_box">
		<div class="choose_page_top">
			<div class="choose_page_left">
				<div class="choose_page_left_top">
					<div class="left_top">
						<label style="font-size: 12px;">��֯�ṹ��</label>
						<span uitype="SinglePullDown" name="" id="orgStructure" select="0" editable="false" width="218" datasource="pullDownData" value_field="orgStructureId" label_field="orgStructureName" on_select_data="changeOrgStructure"></span>
					</div>
					<div class="left_top">
						<input type="hidden" id="queryDeptId"/>
						<span class="query" onclick="fastQuery();"></span>
						<span uitype="Input" name="" id="keyword" width="285" emptytext="�������ơ�ȫƴ����ƴ��ѯ"  on_keyup="fastQuery"></span>
						<div id="searchDiv"  class="search_div" >
						   	 	<div id="queryDataArea" class="queryList"></div>
						    <div id="moreData" class="more_data"><a href="#" hidefocus="true" onclick="showMoreData();return false;">��������...</a></div>
				     	</div>
					</div>
				</div>
				
				<div id="choose_page_left_bottom" class="choose_page_left_bottom main_tree">
					<div id="div_tree" class="main_tree_box">
						<div id="higherUp" class="higerUp" >
						    <span id="higherUpOrg" class="choose_higherUp" uitype="Button" label="�ϼ���֯" on_click="higherUpOrg" icon="images/higerUp.gif"></span>
						    <span id="backDefaultOrg" class="choose_higherUp" uitype="Button" label="Ĭ����֯" on_click="backDefaultOrg" icon="images/backDown.gif"></span>
			    		</div>
			    		<c:choose> 
			    			<c:when test="${param.chooseMode==1}">
								<div uitype="Tree" id="tree" children="[]" on_dbl_click="dbclickNode" on_expand="onExpand" on_lazy_read="lazyData" click_folder_mode="3" min_expand_level="2"></div>
			    			</c:when>
			    			<c:otherwise>
			    				<div uitype="Tree" id="tree" children="[]" select_mode="2" checkbox="true" on_activate="selectNode" on_dbl_click="dbclickNode" on_expand="onExpand" on_lazy_read="lazyData" click_folder_mode="3" min_expand_level="2"></div>
			    			</c:otherwise>
			    		</c:choose>
					</div>
					<div id="div_none" style="display: none; font-size: 12px;">û������</div>
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
				<div class="choose_page_right_top main_right_top">
					<c:choose>
						<c:when test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
							<div id="selectCountDiv">��ѡ��Ա��0 ��</div>
						</c:when>
						<c:otherwise>
							<div id="selectCountDiv">��ѡ��֯��0 ��</div>
						</c:otherwise>
					</c:choose>
					<div id="sortDIV" class="selectedSot">
		    			<img src="images/arrow_up.png" alt="����" title="����" onmouseup="arrowUp();">
		    			<img src="images/arrow_down.png" alt="����" title="����" onmouseup="arrowDown();">
	    			</div>
				</div>
				<div id="div_selected" class="choose_page_right_bottom"></div>
			</div>
		</div>
		<div class="choose_page_bottom">
			<c:if test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
				<a id="batchImportUser" class="bottom_left_a" href="#" onclick="importUser();return false;">��������</a>
			</c:if>
			<span uitype="Button" id="ok" label="ȷ��" on_click="submit"></span>
			<span uitype="Button" id="clear" label="���" on_click="clearSelected"></span>
			<span uitype="Button" id="close" label="�ر�" on_click="winClose"></span>
			<c:choose>
				<c:when test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
					<span uitype="Button" id="joinFavorite" label="���볣����ϵ��" on_click="joinFavorite"></span>
				</c:when>
				<c:otherwise>
					<span uitype="Button" id="joinFavorite" label="���볣����֯" on_click="joinFavorite"></span>
				</c:otherwise>
			</c:choose>
				<div id="favoriteSelectWin" style="display: none;">
					<table>
						<tr>
							<td style="text-align: right;font-size: 12px; line-height: 20px; height:20px;">���飺</td>
							<td>
							<span uitype="PullDown" id="favoriteGroupSelect" mode="Single" select='0' width="150" value_field="favoriteGroupId" label_field="favoriteGroupName" datasource="[]" must_exist="false"></span>
							</td>
						</tr>
					</table>
				</div>
		</div> 
	</div>
	<!-- ������֯start //-->
	<div id="favorite" class="choose_page_box">
		<div class="choose_page_top">
			<div class="choose_page_left">
				<div class="choose_page_left_top">
					<div class="left_top">
						<label style="font-size: 12px;">��֯�ṹ��</label>
						<span uitype="SinglePullDown" name="" select="0" id="orgStructure_favorite" editable="false" width="218" datasource="pullDownData" value_field="orgStructureId" label_field="orgStructureName" on_select_data="changeOrgStructureFavorite"></span>
					</div>
					<div class="left_top">
						<input type="hidden" id="queryDeptIdOfFavorite"/>
						<span class="query" onclick="fastFavoriteQuery();"></span>
						<span uitype="Input" name="" id="keyword_favorite" width="285" emptytext="�������ơ�ȫƴ����ƴ��ѯ" on_keyup="fastFavoriteQuery"></span>
					    <div id="searchDivOfFavorite" class="search_div" >
						    	<div id="queryDataAreaOfFavorite" class="queryList"></div>
						    <div id="moreDataOfFavorite" class="more_data"><a href="#" hidefocus="true" onclick="showMoreDataOfFavorite();return false;">��������...</a></div>
					    </div>
					</div>
				</div>
				
				<div class="choose_page_left_bottom">
					<div id="div_tree_favorite" style="position:relative;overflow: auto;height:100%;width:100%;">
						<ul class="favoriteTree">
<c:choose>
	<c:when  test="${param.chooseType=='ChooseUser'||param.chooseType=='user' }">
	<script type="text/template" id="template">
	<!---// data-->
    <!---
        for(var i=0;i<data.length;i++){
    -->
	<li name="groupLi" favoriteGourpId="+-data[i].favoriteGroupId-+">
		<span class="favorite_floder" count="+-data[i].children.length-+" style="cursor: pointer" groupName="+-data[i].favoriteGroupName-+"  id="div_+-data[i].favoriteGroupId-+">
		  <span class="showFavoriteGroupName">
				<span class="favoriteGroupName" id="span_favoriteGroupName_+-data[i].favoriteGroupId-+">+-data[i].favoriteGroupName-+&nbsp;</span>(<span id="span_favoriteGroup_+-data[i].favoriteGroupId-+">+-data[i].children.length-+</span>)
				<div style="display:none">
					<a href="#" onmousedown="updateFavoriteGroup('div_+-data[i].favoriteGroupId-+');return false;">&nbsp;�޸�</a>
					<a href="#" onclick="deleteFavoriteGroup('+-data[i].favoriteGroupId-+');return false;">&nbsp;ɾ��</a>
				</div>
		  </span>
		   <span class="editFavoriteGroupName"></span>
		</span>
        <ul class="deptName">
			<!---
				for(var j=0;j<data[i].children.length;j++){
					var id=data[i].children[j].objectId;
			  		var name=data[i].children[j].objectName;
					var belongDeptName=data[i].children[j].objectFullName;
					var sex=data[i].children[j].sex;
					var favoriteId= data[i].children[j].favoriteId;
     		-->
			<li id="li_+-favoriteId-+" objectid="+-id-+" favoriteId="+-favoriteId-+" name="+-name-+" fullName="+-belongDeptName-+">
				<!---
					if(sex == 2){
				-->
						<img class="user_img" src="images/girl.gif" ondblclick="dbClickFavorite('li_+-favoriteId-+');"/>
				<!---
					}else{
				-->
						<img class="user_img" src="images/boy.gif" ondblclick="dbClickFavorite('li_+-favoriteId-+');"/>
				<!---
					}
				-->
				<span class="group_delete" favoriteGourpId="+-data[i].favoriteGroupId-+"></span>
				<a href="#" class="favorite_treenode" ondblclick="dbClickFavorite('li_+-favoriteId-+');return false;" hidefocus="true" title="+-belongDeptName-+" id="a_+-id-+" userid="a_+-id-+">+-name-+</a>
			</li>
      	 	<!--- }-->
			<li id="addFavorite_li" class="addFavoriteUser">
				<img class="addFavorite" src="images/add.gif"/>
	    		<a class="addFavoriteUser" hidefocus="true" onclick="addFavoriteUserWithRootId('+-data[i].favoriteGroupId-+');return false;"  href="#">��ӳ�����ϵ��</a>
	    	</li>
        </ul>
    <!---
       }
    -->
		<li id="addFavoriteGroup_li">
	    	<div class="addFavoriteGroup" hidefocus="true" id="addFavoriteGroup">
			<div onclick="addFavoriteGroup();" class="addFavoriteGroup_click" id="addFavoriteDiv"><img  class="addFavorite" src="images/add.gif"/>&nbsp;����Զ�����</div>
			<div class="editFavoriteGroupName"><img class="addFavorite" src="images/add.gif"/>&nbsp;<span uitype="Input" maxLength="20" validate="[{'type':'required', 'rule':{'m': '�������Ʊ���'}},{ 'type':'custom','rule':{'against':'checkGroupName', 'm':'���Ʋ����ظ�'}}]" id="groupName" name="input" width="100px"></span><a class="submit" hidefocus="true" onclick="saveGroup();return false;" href="#">&nbsp;&nbsp;ȷ��</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="calcelGroup();return false;" href="#">ȡ��</a></div>
			</div>
	    </li>
    </li>
</script> 
	</c:when>
	<c:otherwise>
	<script type="text/template" id="template">
<!---// data-->
    <!---

        for(var i=0;i<data.length;i++){
    -->
       <li name="groupLi" favoriteGourpId="+-data[i].favoriteGroupId-+">
        <span class="favorite_floder" count="+-data[i].children.length-+" style="cursor: pointer" groupName="+-data[i].favoriteGroupName-+"  id="div_+-data[i].favoriteGroupId-+">
		  <span class="showFavoriteGroupName">
				<span class="favoriteGroupName" id="span_favoriteGroupName_+-data[i].favoriteGroupId-+">+-data[i].favoriteGroupName-+&nbsp;</span>(<span id="span_favoriteGroup_+-data[i].favoriteGroupId-+">+-data[i].children.length-+</span>)
				<div style="display:none"><a href="#" onmousedown="updateFavoriteGroup('div_+-data[i].favoriteGroupId-+');return false;">&nbsp;�޸�</a><a href="#" onclick="deleteFavoriteGroup('+-data[i].favoriteGroupId-+');return false;">&nbsp;ɾ��</a></div>
		  </span>
		   <span class="editFavoriteGroupName"></span>
		</span>
        <ul class="deptName">
   		 <!---for(var j=0;j<data[i].children.length;j++){
       		  var id=data[i].children[j].objectId;
			  var name=data[i].children[j].objectName;
			  var showName=data[i].children[j].objectShowName;
			  var fullName = data[i].children[j].objectFullName;
			  var favoriteId = data[i].children[j].favoriteId;

			  if(data[i].children[j].unselectable){
		-->
		<li id="li_+-favoriteId-+" objectid="+-id-+" unselectable="true"  favoriteId="+-favoriteId-+" fullname="+-fullName-+" name="+-name-+">
				<img class="dept_img" src="images/folder_close_readonly.gif"/>
				<span class="group_delete"  favoriteGourpId="+-data[i].favoriteGroupId-+"></span>
				<a  href="#" hidefocus="true" title="+-fullName-+" id="a_+-id-+">
					+-showName-+
				</a>
			 </li>
		<!---
			}else{
		-->
        	 <li id="li_+-favoriteId-+" objectid="+-id-+" favoriteId="+-favoriteId-+" fullname="+-fullName-+" name="+-name-+">
				<img class="dept_img" src="images/folder_close.gif" ondblclick="dbClickFavorite('li_+-favoriteId-+');"/>
				<span class="group_delete"  favoriteGourpId="+-data[i].favoriteGroupId-+"></span>
				<a class="favorite_treenode" ondblclick="dbClickFavorite('li_+-favoriteId-+');return false;" href="#" hidefocus="true" title="+-fullName-+" id="a_+-id-+">
					+-showName-+
				</a>
			 </li>
		<!---
			} 
     	 -->

      	 <!--- }-->
			<li  id="addFavorite_li" class="addFavoriteDept">
				<img class="addFavorite" src="images/add.gif"/>	    		
				<a class="addFavoriteDept" hidefocus="true"  onclick="addFavoriteDept('+-data[i].favoriteGroupId-+');return false;"  href="#">��ӳ�����֯</a>
	    	</li>
        </ul>
    <!---
       }
    -->
		<li id="addFavoriteGroup_li">
	    	<div class="addFavoriteGroup" hidefocus="true" id="addFavoriteGroup">
			<div onclick="addFavoriteGroup();" class="addFavoriteGroup_click" id="addFavoriteDiv"><img  class="addFavorite" src="images/add.gif"/>&nbsp;����Զ�����</div>
			<div class="editFavoriteGroupName"><img class="addFavorite" src="images/add.gif"/>&nbsp;<span uitype="Input" maxLength="20" validate="[{'type':'required', 'rule':{'m': '�������Ʊ���'}},{ 'type':'custom','rule':{'against':'checkGroupName', 'm':'���Ʋ����ظ�'}}]" id="groupName" name="input" width="100px"></span><a class="submit" hidefocus="true" onclick="saveGroup();return false;" href="#">&nbsp;&nbsp;ȷ��</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="calcelGroup();return false;" href="#">ȡ��</a></div>
			</div>
	    </li>
    </li>
</script> 
	</c:otherwise>
</c:choose>
	    		</ul>
					</div>
				</div>
			</div>
			<div class="choose_page_center" id="favoriteCenterDiv">
				<div class="center_btns">
					<a class="btns_group addBtn" href="javascript:;" title="���" onclick="addData();return false;"></a>
	   		 		<a class="btns_group addChildBtn" href="javascript:;" title="��ӷ���" onclick="addGroupAll();return false;"></a>
   		 			<a class="btns_group deleteBtn" href="javascript:;" title="ɾ��ѡ�нڵ�" onclick="deleteSelectedData();return false;"></a>
				</div>
			</div>
			<div id="choose_page_right_favorite" class="choose_page_right">
				<div class="choose_page_right_top main_right_top">
					<c:choose>
						<c:when test="${param.chooseType=='ChooseUser' }">
							<div id="selectCountFavoriteDiv">��ѡ��Ա��0 ��</div>
						</c:when>
						<c:otherwise>
							<div id="selectCountFavoriteDiv">��ѡ��֯��0 ��</div>
						</c:otherwise>
					</c:choose>
					<div id="sortFavoriteDIV" class="selectedSot">
		    			<img src="images/arrow_up.png" alt="����" title="����" onmouseup="arrowUp();">
		    			<img src="images/arrow_down.png" alt="����" title="����" onmouseup="arrowDown();">
    				</div>
				</div>
				<div id="div_selected_favorite" class="choose_page_right_bottom"></div>
			</div>
		</div>
		<div class="choose_page_bottom">
			<span uitype="Button" id="ok" label="ȷ��" on_click="submit"></span>
			<span uitype="Button" id="clear_fav" label="���" on_click="clearSelected"></span>
			<span uitype="Button" id="close" label="�ر�" on_click="winClose"></span>
		</div> 
	</div>
	<!-- ������֯end //-->
<top:script src="/top/js/jquery.js"/>
<top:script src="/top/sys/usermanagement/orgusertag/js/comtop.ui.emDialog.js"/>
<top:script src="/top/sys/js/commonUtil.js"/>
<top:script src="/top/sys/dwr/engine.js"/>
<top:script src="/top/js/jct.js"/>
<top:script src="/top/sys/dwr/interface/ChooseAction.js"/>
<top:script src="/top/sys/dwr/interface/FavoriteAction.js"/>
<top:script src="/top/sys/usermanagement/orgusertag/js/deptUserCommon.js"/>
<top:script src="/top/sys/usermanagement/orgusertag/js/favoriteCommon.js"/>
<top:script src="/top/sys/usermanagement/orgusertag/js/cStorage.full.min.js"/>

<script type="text/javascript">	
	//��ǩID
	var cmpID = "<c:out value='${param.id}'/>";
	
	var jsID= "<c:out value='${param.jsId}'/>";
	var winType = "<c:out value='${param.winType}'/>";
	
	//��ȡ��ǩ����
	function getCmpObj(){
		if(cmpID!=""){
			if(winType==="window"){
				return window.opener.cui('#'+cmpID);
			}else{
				return window.top.cuiEMDialog.wins["topdialog_"+cmpID].cui("#"+cmpID);
			}
		}else{
			return {};
		}
	}
	//��ǩ
	var cmp = getCmpObj();
	//ѡ������
	var chooseType = cmpID!=''?(cmp.options.uitype=='ChooseUser'?'user':'org'):"<c:out value='${param.chooseType}'/>";
	//ѡ��ģʽ
	var chooseMode = cmpID!=''?cmp.options.chooseMode:"<c:out value='${param.chooseMode}'/>";
	//�û�����
	var userType = cmpID!=''?cmp.options.userType:"<c:out value='${param.userType}'/>";
	//��֯�ṹID
	var orgStructureId = cmpID!=''?cmp.options.orgStructureId:"<c:out value='${param.orgStructureId}'/>";
	//���ڵ�ID
	var rootId = cmpID!=''?cmp.options.rootId:"<c:out value='${param.rootId}'/>";
	 //��ʼĬ����֯�ڵ�ID ,�����ϼ��õ�
	var defaultOrgId = cmpID!=''?cmp.options.defaultOrgId:"<c:out value='${param.defaultOrgId}'/>";
	//չʾ�㼶
	var showLevel = cmpID!=''?cmp.options.showLevel:"<c:out value='${param.showLevel}'/>";
    //ȫ·����ʾ˳��reverse:����order:����
	var showOrder = cmpID!=''?cmp.options.showOrder:"<c:out value='${param.showOrder}'/>";
	//���ͽṹչʾ���Ĳ㼶
	var levelFilter = cmpID!=''?cmp.options.levelFilter:"<c:out value='${param.levelFilter}'/>";
	//ֻ����֯id		
	var unselectableCode = cmpID!=''?cmp.options.unselectableCode:"<c:out value='${param.unselectableCode}'/>";
	//�ص�����
	var callback = cmpID!=''?cmp.options.callback:"<c:out value='${param.callback}'/>";
	//ѡ������ݶ��󼯺�
	var selected = cmpID!=''?(cmp.getValue()):[];
	//��Ŀ·��
	var webPath = '${pageScope.cuiWebRoot}'; 
	//�������Ϊ1�������س��Ƿ�ѡ�н��
	var singleChoose = cmpID!=''?cmp.options.singleChoose:"<c:out value='${param.singleChoose}'/>";
	//�������ӽڵ㣬�Ƿ���ѡ��ȫ���¼����ţ�Ĭ��Ϊfalse
	var childSelect = cmpID!=''?cmp.options.childSelect:"<c:out value='${param.childSelect}'/>";

	var otherVo=[];//�������飬�����ⲿ����Ķ���
	var favoriteName =chooseType=="org"?"������֯":"������ϵ��";
	
	//����tabҳ����
	var tabs = [
	 	{
	 		title: '��֯�ṹ',
	 		html: $('#choose_page_box')
	 	},
	 	{
	 		title: favoriteName,
	 		html: $('#favorite'),
	 		tab_width:'70px'
	 	}
	];
	
 	// �������������������ʾ��������¼��Ĭ��10��
	var countPerPage = 10;
	var pageNo=1;;
    var pageSize=countPerPage;//���ٲ�ѯÿҳ��ʾ����
	//��ʱ����ĸ��ڵ㣬�����ϼ���֯�õ�
	var tmpRootId=rootId;
	//���洫�ݽ��������������ڴ򿪳�����ϵ�ˡ���֯ѡ��ʱȷ������
    var favoriteRootId = rootId;
	//��ǩ��id
	var thisId = cmpID===''?jsID:cmpID;
    var choose_cst = cst.use('paas_chooseorgoruser_cst', 15),
        chooseCstData = choose_cst.get(thisId);
    jQuery(document).ready(function(){
		comtop.UI.scan();
		init();
    });
    
	//ҳ���ʼ������
	function init(){
		if(orgStructureId){
			cui('#orgStructure').setValue(orgStructureId);
			cui('#orgStructure_favorite').setValue(orgStructureId);
		}
		if(chooseMode==1){//��ѡ
			$('#choose_page_right').hide();
			$("#chooseCenterDiv").hide();
			$('#choose_page_box').attr('class','choose_page_box_one');
			if(chooseType=="user"){
				$('#batchImportUser').hide();
			}
			$('#choose_page_right_favorite').hide();
			$("#favoriteCenterDiv").hide();
			cui('#favorite').attr('class','choose_page_box_one');
		}else{
			//��ʼ����ѡ��¼��
			for(var i=0;i<selected.length;++i){
				putToSelectedBox(selected[i]);
			}
			//��ʼ��tabҳ����¼�
			changeTab();
			selectedClick();
		}
		repaint();
		//ҳ�������Ϻ󣬰��������¼�������tabҳ���󶨡�
		keyboardEvent(false);//���Žṹ
		keyboardEvent(true);//������ϵ��
	    if(chooseCstData){
	    	try{
	    		chooseCstData = Number(chooseCstData);
	    	}catch(e){
	    		chooseCstData = 0;
	    	}
	    	if(chooseCstData==1){
	    		cui("#tab").switchTo(1);
	    	}
	    }
	}
	
	//�л�������֯�µ���֯�ṹ
	function changeOrgStructureFavorite(){
		if(!cui('#orgStructure_favorite').getValue()){
			return ;
		}
		//���³�ʼ����Э��λ����
		initFavoriteDept();
		//�л���֯�ṹ��ʱ�򣬲�ѯ�������
		cui('#keyword_favorite').setValue('');
	}

	//�л���֯�ṹ
	function changeOrgStructure(){
		var orgStructureId =cui('#orgStructure').getValue(); 
		if(!orgStructureId){
			return;
		}
		var bShow = showHigherUpOrNot();
		var vRootId ="";
		if(bShow){
			vRootId = defaultOrgId;
		}else{
			//�ж���Ӧ����ʾrootId������һ����֯�ṹ
			var nodeVo= {};
			nodeVo.orgId = rootId;
			if(!rootId){
				nodeVo.orgId="-1";
			}
			vRootId = getRootId(nodeVo.orgId,orgStructureId);
		}
		//��ʼ����֯�ṹ
		initRoot(vRootId);
		//�л���֯�����ʱ��,��ѯ�������
		cui('#keyword').setValue('');
	}

	//��֯�ṹ�����б�����Դ
	function pullDownData(obj){
		ChooseAction.queryOrgStructList(orgStructureId,function(data){
			obj.setDatasource(data);
		});
	}

	/***
	��ʼ�������ڵ�
	@param treeRootId ���ĸ��ڵ�
	*/
	function initRoot(treeRootId){
		var vo = {};
		vo.chooseType = chooseType;
		vo.orgStructureId = cui('#orgStructure').getValue();
		vo.orgId = treeRootId;
		if(chooseType==="user"){
			vo.userType = userType;
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
		if(chooseMode==1&&selected.length>0){
			//ѡ��ʱ�������Աid��������֯id
			//ѡ��֯ʱ�������֯id��undefined 
			setTimeout(function(){ 
				locationInTree(selected[0].id);				
			},500);
			
		}
	}
	
	//������֯���ٲ�ѯ
	function fastFavoriteQuery(event){
		queryDataOfFavorite(event);
	}

	//���ٲ�ѯ
	function fastQuery(event){
		queryData(event);
	}

	/**
	 * ��ӳ��÷����������֯
	 */
	function addGroupAll(){
		var $AllLi;
		if(globalGroupId !==""){
			$AllLi=$("li[name='groupLi'][favoriteGourpId='"+globalGroupId+"']").find("li[id^=li_]");
			putSelectedFavoriteToBox($AllLi);
		}
	}

	//�رմ���
	function winClose(){
		//�رմ���ǰ��¼��ǰ�Ļtab
 		choose_cst.set(thisId,cui("#tab").index());
		if(winType==="window"){
			window.close();			
		}else{
			if(cmpID!=''){
				window.top.cuiEMDialog.dialogs["topdialog_"+cmpID].hide();
			}else{
				var dialogId = getDialogId();
				window.top.cuiEMDialog.dialogs[dialogId].hide();
			}
		}
	}

	function getDialogId(){
		var dialogId = "topdialogwithjsopen";
		if(jsID){
			dialogId+=jsID;
		}
		return dialogId;
	}
	
	//��ԭ�����õ�ֵ��ȡֵ������set�������ⲿ���ݶ�ʧ�ֶ�
	
	function getValueFromSet(data){
		if(selected&&selected.length){
			for(var i=0;i<selected.length;i++){
				if(data.id===selected[i].id){
					return selected[i];
				}
			}		
		}
		return data;
	}
	
	//���ȷ���󣬽���ȡ��������д�ر�ǩ���󲢵��ûص����رմ���
	function submitSelected(selectedId){
		var result= loadSelectedFromDb(selectedId);
		if(otherVo&&otherVo.length){ //����У�����ӵ�ָ����λ��
			for(var i=0;i<otherVo.length;i++){
				if(otherVo[i]){ //��Ӧ��λ����ֵ�����ʾ���ⲿ�����
					result.splice(i,0,getValueFromSet(otherVo[i]));
				}
			}
		}
		
		if(cmpID!=''){
			cmp.__setValue(result);
			//ȷ������ص�����
			if(typeof cmp.options.callback==="function"){
				callback(result,cmpID);
			}
		}else{
			if(winType==="window"){
				window.opener[callback](result,jsID);
			}else{
				var dialogId = getDialogId();
				window.top.cuiEMDialog.wins[dialogId][callback](result,jsID);
			}
		}
		winClose();
	}

	//�Ӻ�̨����ѡ�еĽڵ����� ������
	function loadSelectedFromDb(selectedId){
		if(!$.isArray(selectedId)){
			selectedId=[selectedId]; 
		}
		if(!selectedId||!selectedId.length){
			return [];
		}
		var dbVo=[];
		//��������id���ɺ�̨��ѯ���ݳ���
		dwr.TOPEngine.setAsync(false);
		ChooseAction.querySelectedDataByIds(selectedId,{"chooseType":chooseType,"showLevel":showLevel||0,"showOrder":showOrder||""},function(result){
			if(!result){
				result = [];
			}
			dbVo= result;
		});
		dwr.TOPEngine.setAsync(true);
		return dbVo;
	}
	
	//���ȷ����ť �ύ
	function submit(){
		var selectedId = [];
		if(chooseMode!=1){  //��ѡ
			var container = getSelectedBox();
			var $SelectData = container.children("div");
			var oneData,oneId;
			for(var i=0;i<$SelectData.length;i++){
				oneData = $SelectData.eq(i);
				oneId =oneData.attr("id").replace("div_","");
				if(oneData.hasClass("block_stand_other")){
					otherVo.push({"id":oneId,"name":oneData.children("span").eq(0).text(),"isOther":true});
				}else{
					otherVo.push(null);
					selectedId.push(oneId);
				}
			}
		}else{ //��ѡʱ��ֱ�ӻ�ȡѡ��Ľڵ�
			selectedId = [];
			if(getTab()) {
				var node = cui('#tree').getActiveNode();
				if(node){
					selectedId.push(node.getData().key);
				}
			}else{
				var selectEle = getAllSelectedFavorite();
				if(selectEle&&selectEle.length){
					selectedId.push(selectEle.eq(0).attr("objectid"));
				}
			}
		}
		submitSelected(selectedId);
	}
    
  //��ѡ������ϵ��ҳ��
	function addFavoriteUserWithRootId(favoriteGroupId){
		var vRootId = "";
		if(rootId == ""){
			vRootId = cui('#tree').getRoot().firstChild().getData().key;
		}else{
			var orgStructId = cui('#orgStructure').getValue();
			var orgFavoriteStructId = cui('#orgStructure_favorite').getValue();
			//�����ߵ���֯�ṹ��һ��
			if(orgFavoriteStructId!=orgStructId){
				vRootId = tmpRootId;
			}else{
				vRootId = rootId;
			}
		}
		addFavoriteUser(favoriteGroupId,vRootId);
	}
	
    //�������봰��
	this.bacthImportDialog;
    /**
	 * �����������û�����
	 */
	function importUser(){
		var width = getImportWindowWidth();
		var height = getImportWindowHeight();
		//��֯�ṹId
		var orgStructureId = cui('#orgStructure').getValue();
		var url = webPath + "/top/sys/usermanagement/orgusertag/userBatchGuide.jsp?rootDepartmentId=" + getRootId(rootId,orgStructureId)+"&userType="+userType+"&orgStructureId="+orgStructureId;
		bacthImportDialog = cui.dialog({
			src: url,
			title: "���������û�",
			width: width,
			height: height
		}).show();
	}
    
    /**��ȡ���봰�ڿ��*/
	function getImportWindowWidth(){
		if($.browser.msie){
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion !== "10.0" && $BrowserVersion !== "9.0"){
        		return 462;
        	}
		}
		return 464;
	}

	/**��ȡ���봰�ڸ߶�*/
	function getImportWindowHeight(){
		if($.browser.msie){
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion !== "10.0" && $BrowserVersion !== "9.0"){
        		return 194;
        	}
		}
		return 202;
	}
	
	//��ӵ�����Ա���ݵ���ѡ��¼,�˷�����addDataToSelected����һ����ֻ�Ƿ���ֵ��һ����Ϊ�˵������Ҫ
	function addImportUserDataToSelected(dataList){
		var count =0;
		var data;
		for(var i=0;i<dataList.length;i++){
			data = dataList[i];
			if(!addDataToSelected(data)){
				break;
			};
			count++;
		}
		return count;
	}
</script>
</body>
</html>
