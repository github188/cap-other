<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>选择页面</title>
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
						<label style="font-size: 12px;">组织结构：</label>
						<span uitype="SinglePullDown" name="" id="orgStructure" select="0" editable="false" width="218" datasource="pullDownData" value_field="orgStructureId" label_field="orgStructureName" on_select_data="changeOrgStructure"></span>
					</div>
					<div class="left_top">
						<input type="hidden" id="queryDeptId"/>
						<span class="query" onclick="fastQuery();"></span>
						<span uitype="Input" name="" id="keyword" width="285" emptytext="输入名称、全拼、简拼查询"  on_keyup="fastQuery"></span>
						<div id="searchDiv"  class="search_div" >
						   	 	<div id="queryDataArea" class="queryList"></div>
						    <div id="moreData" class="more_data"><a href="#" hidefocus="true" onclick="showMoreData();return false;">更多数据...</a></div>
				     	</div>
					</div>
				</div>
				
				<div id="choose_page_left_bottom" class="choose_page_left_bottom main_tree">
					<div id="div_tree" class="main_tree_box">
						<div id="higherUp" class="higerUp" >
						    <span id="higherUpOrg" class="choose_higherUp" uitype="Button" label="上级组织" on_click="higherUpOrg" icon="images/higerUp.gif"></span>
						    <span id="backDefaultOrg" class="choose_higherUp" uitype="Button" label="默认组织" on_click="backDefaultOrg" icon="images/backDown.gif"></span>
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
					<div id="div_none" style="display: none; font-size: 12px;">没有数据</div>
				</div>
			</div>
			
			<div class="choose_page_center" id="chooseCenterDiv">
				<div class="center_btns">
					<a class="btns_group addBtn" href="javascript:;" title="添加" onclick="addData();return false;"></a>
   		 			<a class="btns_group addChildBtn" href="javascript:;" title="添加子节点" onclick="addDataChild();return false;"></a>
   		 			<a class="btns_group deleteBtn" href="javascript:;" title="删除选中节点" onclick="deleteSelectedData();return false;"></a>
				</div>
			</div>
			<div id="choose_page_right" class="choose_page_right">
				<div class="choose_page_right_top main_right_top">
					<c:choose>
						<c:when test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
							<div id="selectCountDiv">已选人员：0 个</div>
						</c:when>
						<c:otherwise>
							<div id="selectCountDiv">已选组织：0 个</div>
						</c:otherwise>
					</c:choose>
					<div id="sortDIV" class="selectedSot">
		    			<img src="images/arrow_up.png" alt="上移" title="上移" onmouseup="arrowUp();">
		    			<img src="images/arrow_down.png" alt="下移" title="下移" onmouseup="arrowDown();">
	    			</div>
				</div>
				<div id="div_selected" class="choose_page_right_bottom"></div>
			</div>
		</div>
		<div class="choose_page_bottom">
			<c:if test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
				<a id="batchImportUser" class="bottom_left_a" href="#" onclick="importUser();return false;">批量导入</a>
			</c:if>
			<span uitype="Button" id="ok" label="确定" on_click="submit"></span>
			<span uitype="Button" id="clear" label="清除" on_click="clearSelected"></span>
			<span uitype="Button" id="close" label="关闭" on_click="winClose"></span>
			<c:choose>
				<c:when test="${param.chooseType=='ChooseUser' || param.chooseType=='user' }">
					<span uitype="Button" id="joinFavorite" label="加入常用联系人" on_click="joinFavorite"></span>
				</c:when>
				<c:otherwise>
					<span uitype="Button" id="joinFavorite" label="加入常用组织" on_click="joinFavorite"></span>
				</c:otherwise>
			</c:choose>
				<div id="favoriteSelectWin" style="display: none;">
					<table>
						<tr>
							<td style="text-align: right;font-size: 12px; line-height: 20px; height:20px;">分组：</td>
							<td>
							<span uitype="PullDown" id="favoriteGroupSelect" mode="Single" select='0' width="150" value_field="favoriteGroupId" label_field="favoriteGroupName" datasource="[]" must_exist="false"></span>
							</td>
						</tr>
					</table>
				</div>
		</div> 
	</div>
	<!-- 常用组织start //-->
	<div id="favorite" class="choose_page_box">
		<div class="choose_page_top">
			<div class="choose_page_left">
				<div class="choose_page_left_top">
					<div class="left_top">
						<label style="font-size: 12px;">组织结构：</label>
						<span uitype="SinglePullDown" name="" select="0" id="orgStructure_favorite" editable="false" width="218" datasource="pullDownData" value_field="orgStructureId" label_field="orgStructureName" on_select_data="changeOrgStructureFavorite"></span>
					</div>
					<div class="left_top">
						<input type="hidden" id="queryDeptIdOfFavorite"/>
						<span class="query" onclick="fastFavoriteQuery();"></span>
						<span uitype="Input" name="" id="keyword_favorite" width="285" emptytext="输入名称、全拼、简拼查询" on_keyup="fastFavoriteQuery"></span>
					    <div id="searchDivOfFavorite" class="search_div" >
						    	<div id="queryDataAreaOfFavorite" class="queryList"></div>
						    <div id="moreDataOfFavorite" class="more_data"><a href="#" hidefocus="true" onclick="showMoreDataOfFavorite();return false;">更多数据...</a></div>
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
					<a href="#" onmousedown="updateFavoriteGroup('div_+-data[i].favoriteGroupId-+');return false;">&nbsp;修改</a>
					<a href="#" onclick="deleteFavoriteGroup('+-data[i].favoriteGroupId-+');return false;">&nbsp;删除</a>
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
	    		<a class="addFavoriteUser" hidefocus="true" onclick="addFavoriteUserWithRootId('+-data[i].favoriteGroupId-+');return false;"  href="#">添加常用联系人</a>
	    	</li>
        </ul>
    <!---
       }
    -->
		<li id="addFavoriteGroup_li">
	    	<div class="addFavoriteGroup" hidefocus="true" id="addFavoriteGroup">
			<div onclick="addFavoriteGroup();" class="addFavoriteGroup_click" id="addFavoriteDiv"><img  class="addFavorite" src="images/add.gif"/>&nbsp;添加自定义组</div>
			<div class="editFavoriteGroupName"><img class="addFavorite" src="images/add.gif"/>&nbsp;<span uitype="Input" maxLength="20" validate="[{'type':'required', 'rule':{'m': '分组名称必填'}},{ 'type':'custom','rule':{'against':'checkGroupName', 'm':'名称不能重复'}}]" id="groupName" name="input" width="100px"></span><a class="submit" hidefocus="true" onclick="saveGroup();return false;" href="#">&nbsp;&nbsp;确定</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="calcelGroup();return false;" href="#">取消</a></div>
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
				<div style="display:none"><a href="#" onmousedown="updateFavoriteGroup('div_+-data[i].favoriteGroupId-+');return false;">&nbsp;修改</a><a href="#" onclick="deleteFavoriteGroup('+-data[i].favoriteGroupId-+');return false;">&nbsp;删除</a></div>
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
				<a class="addFavoriteDept" hidefocus="true"  onclick="addFavoriteDept('+-data[i].favoriteGroupId-+');return false;"  href="#">添加常用组织</a>
	    	</li>
        </ul>
    <!---
       }
    -->
		<li id="addFavoriteGroup_li">
	    	<div class="addFavoriteGroup" hidefocus="true" id="addFavoriteGroup">
			<div onclick="addFavoriteGroup();" class="addFavoriteGroup_click" id="addFavoriteDiv"><img  class="addFavorite" src="images/add.gif"/>&nbsp;添加自定义组</div>
			<div class="editFavoriteGroupName"><img class="addFavorite" src="images/add.gif"/>&nbsp;<span uitype="Input" maxLength="20" validate="[{'type':'required', 'rule':{'m': '分组名称必填'}},{ 'type':'custom','rule':{'against':'checkGroupName', 'm':'名称不能重复'}}]" id="groupName" name="input" width="100px"></span><a class="submit" hidefocus="true" onclick="saveGroup();return false;" href="#">&nbsp;&nbsp;确定</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="calcelGroup();return false;" href="#">取消</a></div>
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
					<a class="btns_group addBtn" href="javascript:;" title="添加" onclick="addData();return false;"></a>
	   		 		<a class="btns_group addChildBtn" href="javascript:;" title="添加分组" onclick="addGroupAll();return false;"></a>
   		 			<a class="btns_group deleteBtn" href="javascript:;" title="删除选中节点" onclick="deleteSelectedData();return false;"></a>
				</div>
			</div>
			<div id="choose_page_right_favorite" class="choose_page_right">
				<div class="choose_page_right_top main_right_top">
					<c:choose>
						<c:when test="${param.chooseType=='ChooseUser' }">
							<div id="selectCountFavoriteDiv">已选人员：0 个</div>
						</c:when>
						<c:otherwise>
							<div id="selectCountFavoriteDiv">已选组织：0 个</div>
						</c:otherwise>
					</c:choose>
					<div id="sortFavoriteDIV" class="selectedSot">
		    			<img src="images/arrow_up.png" alt="上移" title="上移" onmouseup="arrowUp();">
		    			<img src="images/arrow_down.png" alt="下移" title="下移" onmouseup="arrowDown();">
    				</div>
				</div>
				<div id="div_selected_favorite" class="choose_page_right_bottom"></div>
			</div>
		</div>
		<div class="choose_page_bottom">
			<span uitype="Button" id="ok" label="确定" on_click="submit"></span>
			<span uitype="Button" id="clear_fav" label="清除" on_click="clearSelected"></span>
			<span uitype="Button" id="close" label="关闭" on_click="winClose"></span>
		</div> 
	</div>
	<!-- 常用组织end //-->
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
	//标签ID
	var cmpID = "<c:out value='${param.id}'/>";
	
	var jsID= "<c:out value='${param.jsId}'/>";
	var winType = "<c:out value='${param.winType}'/>";
	
	//获取标签对象
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
	//标签
	var cmp = getCmpObj();
	//选择类型
	var chooseType = cmpID!=''?(cmp.options.uitype=='ChooseUser'?'user':'org'):"<c:out value='${param.chooseType}'/>";
	//选择模式
	var chooseMode = cmpID!=''?cmp.options.chooseMode:"<c:out value='${param.chooseMode}'/>";
	//用户类型
	var userType = cmpID!=''?cmp.options.userType:"<c:out value='${param.userType}'/>";
	//组织结构ID
	var orgStructureId = cmpID!=''?cmp.options.orgStructureId:"<c:out value='${param.orgStructureId}'/>";
	//根节点ID
	var rootId = cmpID!=''?cmp.options.rootId:"<c:out value='${param.rootId}'/>";
	 //初始默认组织节点ID ,返回上级用到
	var defaultOrgId = cmpID!=''?cmp.options.defaultOrgId:"<c:out value='${param.defaultOrgId}'/>";
	//展示层级
	var showLevel = cmpID!=''?cmp.options.showLevel:"<c:out value='${param.showLevel}'/>";
    //全路径显示顺序，reverse:倒序，order:正序
	var showOrder = cmpID!=''?cmp.options.showOrder:"<c:out value='${param.showOrder}'/>";
	//树型结构展示到的层级
	var levelFilter = cmpID!=''?cmp.options.levelFilter:"<c:out value='${param.levelFilter}'/>";
	//只读组织id		
	var unselectableCode = cmpID!=''?cmp.options.unselectableCode:"<c:out value='${param.unselectableCode}'/>";
	//回调函数
	var callback = cmpID!=''?cmp.options.callback:"<c:out value='${param.callback}'/>";
	//选择的数据对象集合
	var selected = cmpID!=''?(cmp.getValue()):[];
	//项目路径
	var webPath = '${pageScope.cuiWebRoot}'; 
	//搜索结果为1个，按回车是否选中结果
	var singleChoose = cmpID!=''?cmp.options.singleChoose:"<c:out value='${param.singleChoose}'/>";
	//点击添加子节点，是否级联选中全部下级部门，默认为false
	var childSelect = cmpID!=''?cmp.options.childSelect:"<c:out value='${param.childSelect}'/>";

	var otherVo=[];//定义数组，保存外部输入的对象
	var favoriteName =chooseType=="org"?"常用组织":"常用联系人";
	
	//设置tab页名称
	var tabs = [
	 	{
	 		title: '组织结构',
	 		html: $('#choose_page_box')
	 	},
	 	{
	 		title: favoriteName,
	 		html: $('#favorite'),
	 		tab_width:'70px'
	 	}
	];
	
 	// 控制下拉搜索框最多显示多少条记录，默认10条
	var countPerPage = 10;
	var pageNo=1;;
    var pageSize=countPerPage;//快速查询每页显示条数
	//临时保存的根节点，返回上级组织用到
	var tmpRootId=rootId;
	//保存传递进来的树根，用于打开常用联系人、组织选择时确定树根
    var favoriteRootId = rootId;
	//标签的id
	var thisId = cmpID===''?jsID:cmpID;
    var choose_cst = cst.use('paas_chooseorgoruser_cst', 15),
        chooseCstData = choose_cst.get(thisId);
    jQuery(document).ready(function(){
		comtop.UI.scan();
		init();
    });
    
	//页面初始化方法
	function init(){
		if(orgStructureId){
			cui('#orgStructure').setValue(orgStructureId);
			cui('#orgStructure_favorite').setValue(orgStructureId);
		}
		if(chooseMode==1){//单选
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
			//初始化已选记录框
			for(var i=0;i<selected.length;++i){
				putToSelectedBox(selected[i]);
			}
			//初始化tab页点击事件
			changeTab();
			selectedClick();
		}
		repaint();
		//页面加载完毕后，绑定下拉框事件，两个tab页都绑定。
		keyboardEvent(false);//部门结构
		keyboardEvent(true);//常用联系人
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
	
	//切换常用组织下的组织结构
	function changeOrgStructureFavorite(){
		if(!cui('#orgStructure_favorite').getValue()){
			return ;
		}
		//重新初始化外协单位数据
		initFavoriteDept();
		//切换组织结构的时候，查询条件清空
		cui('#keyword_favorite').setValue('');
	}

	//切换组织结构
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
			//判断是应该显示rootId还是另一个组织结构
			var nodeVo= {};
			nodeVo.orgId = rootId;
			if(!rootId){
				nodeVo.orgId="-1";
			}
			vRootId = getRootId(nodeVo.orgId,orgStructureId);
		}
		//初始化组织结构
		initRoot(vRootId);
		//切换组织结果的时候,查询条件清空
		cui('#keyword').setValue('');
	}

	//组织结构下拉列表数据源
	function pullDownData(obj){
		ChooseAction.queryOrgStructList(orgStructureId,function(data){
			obj.setDatasource(data);
		});
	}

	/***
	初始化树根节点
	@param treeRootId 树的根节点
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
			//选人时传入的人员id及所属组织id
			//选组织时传入的组织id及undefined 
			setTimeout(function(){ 
				locationInTree(selected[0].id);				
			},500);
			
		}
	}
	
	//常用组织快速查询
	function fastFavoriteQuery(event){
		queryDataOfFavorite(event);
	}

	//快速查询
	function fastQuery(event){
		queryData(event);
	}

	/**
	 * 添加常用分组的所有组织
	 */
	function addGroupAll(){
		var $AllLi;
		if(globalGroupId !==""){
			$AllLi=$("li[name='groupLi'][favoriteGourpId='"+globalGroupId+"']").find("li[id^=li_]");
			putSelectedFavoriteToBox($AllLi);
		}
	}

	//关闭窗口
	function winClose(){
		//关闭窗口前记录当前的活动tab
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
	
	//从原来设置的值中取值，避免set进来的外部数据丢失字段
	
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
	
	//点击确定后，将获取到的数据写回标签对象并调用回调，关闭窗口
	function submitSelected(selectedId){
		var result= loadSelectedFromDb(selectedId);
		if(otherVo&&otherVo.length){ //如果有，则添加到指定的位置
			for(var i=0;i<otherVo.length;i++){
				if(otherVo[i]){ //对应的位置有值，则表示是外部输入的
					result.splice(i,0,getValueFromSet(otherVo[i]));
				}
			}
		}
		
		if(cmpID!=''){
			cmp.__setValue(result);
			//确定后调回调函数
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

	//从后台加载选中的节点数据 并返回
	function loadSelectedFromDb(selectedId){
		if(!$.isArray(selectedId)){
			selectedId=[selectedId]; 
		}
		if(!selectedId||!selectedId.length){
			return [];
		}
		var dbVo=[];
		//将排序后的id交由后台查询数据出来
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
	
	//点击确定按钮 提交
	function submit(){
		var selectedId = [];
		if(chooseMode!=1){  //多选
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
		}else{ //单选时，直接获取选择的节点
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
    
  //打开选择常用联系人页面
	function addFavoriteUserWithRootId(favoriteGroupId){
		var vRootId = "";
		if(rootId == ""){
			vRootId = cui('#tree').getRoot().firstChild().getData().key;
		}else{
			var orgStructId = cui('#orgStructure').getValue();
			var orgFavoriteStructId = cui('#orgStructure_favorite').getValue();
			//当两边的组织结构不一样
			if(orgFavoriteStructId!=orgStructId){
				vRootId = tmpRootId;
			}else{
				vRootId = rootId;
			}
		}
		addFavoriteUser(favoriteGroupId,vRootId);
	}
	
    //批量导入窗口
	this.bacthImportDialog;
    /**
	 * 打开批量导入用户窗口
	 */
	function importUser(){
		var width = getImportWindowWidth();
		var height = getImportWindowHeight();
		//组织结构Id
		var orgStructureId = cui('#orgStructure').getValue();
		var url = webPath + "/top/sys/usermanagement/orgusertag/userBatchGuide.jsp?rootDepartmentId=" + getRootId(rootId,orgStructureId)+"&userType="+userType+"&orgStructureId="+orgStructureId;
		bacthImportDialog = cui.dialog({
			src: url,
			title: "批量导入用户",
			width: width,
			height: height
		}).show();
	}
    
    /**获取导入窗口宽度*/
	function getImportWindowWidth(){
		if($.browser.msie){
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion !== "10.0" && $BrowserVersion !== "9.0"){
        		return 462;
        	}
		}
		return 464;
	}

	/**获取导入窗口高度*/
	function getImportWindowHeight(){
		if($.browser.msie){
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion !== "10.0" && $BrowserVersion !== "9.0"){
        		return 194;
        	}
		}
		return 202;
	}
	
	//添加导入人员数据到已选记录,此方法跟addDataToSelected功能一样，只是返回值不一样，为了导入的需要
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
