<%
/**********************************************************************
* 应用列表页面:应用资源列表页
* 2014-7-6 石刚 新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>应用资源列表页</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/map.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
</head>
<body>
<div class="list_header_wrap" style="padding-bottom: 15px;padding-left: 1px;padding-right:5px;">
	<div class="top_float_left">
		<div class="thw_title" style="margin-top:0px;">
			<font id="pageTittle" class="fontTitle">应用资源列表</font> 
		</div>
		<span uitype="RadioGroup" name="ball" value="0" br="[2, 4]" on_change="changeHandler">
		        <input type="radio" value="0" text="全部资源视图" />
		        <input type="radio" value="1" text="菜单视图" /> 
    	</span>
	</div>
	<div class="top_float_right" <% if(isHideSystemBtn){ %> style="display:none" <% } %>>
		<span uitype="button" label="查看权限" id="button_right" on_click="rightRecommend"></span>
		<span uitype="button" id="sysSameButtonGroup" label="新增同级" menu="sysSameButtonGroup"></span>
		<span uitype="button" id="sysSubButtonGroup" label="新增下级" menu="sysSubButtonGroup"></span>
		<span uitype="button" label="编辑" id="button_edit" on_click="updateFunc"></span>
		<span uitype="button" label="删除" id="button_del" on_click="delFunc"></span>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="上移" id="button_up" on_click="upFunc"></span>
		<span uitype="button" label="下移" id="button_down" on_click="downFunc"></span>
	</div>
</div>
<div style="padding:0 5px 0 15px">
<table id="FuncGrid" uitype="grid" datasource="dataProvider"  titlelock="true" pagination="false" selectrows="single"
	primarykey="funcId" colrender="columnRenderer" rowclick_callback="selectFuncData" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
	<tr>
		<th style="width:5%;display:none"></th>
		<th bindName="firstName" style="width:15%;" renderStyle="text-align: left">目录/菜单/页面/操作</th>
		<th bindName="secondName" style="width:15%;" renderStyle="text-align: left">菜单/页面/操作</th>
		<th bindName="threeName" style="width:30%;" renderStyle="text-align: left">操作</th>
	</tr>
</table>
</div>
<div style="padding-top:10px;padding-left: 15px;">
	注：<img src="${pageScope.cuiWebRoot}/top/sys/images/func_menu_dir.gif"/>表示目录，
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_menu.gif"/>表示菜单，
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_page.gif"/>表示页面，
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_oper.gif"/>表示操作
</div>
<script language="javascript"> 
	//父节点ID及父节点名称
	var parentFuncId = "<c:out value='${param.parentResourceId}'/>";
	var parentFuncName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentName}'/>"));
	var parentPermissionType = "<c:out value='${param.permissionType}'/>";
	
	window.onload = function(){
		comtop.UI.scan();
		cui('#button_up').hide();
		cui('#button_down').hide();
		cui('.grid-head').hide();
		
		cui('#button_right').hide();
	}
	
	//新增同级按钮初始化
  	var sysSameButtonGroup = {
    	datasource: [
             {id:'insertSameMenuDir',label:'新增同级目录'},
             {id:'insertSameMenu',label:'新增同级菜单'},
             {id:'insertSamePage',label:'新增同级页面'},
             {id:'insertSameOper',label:'新增同级操作'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSameMenuDir'){
        		insertSameFunc(1);
        	}else if(obj.id=='insertSameMenu'){
        		insertSameFunc(2);
        	}else if(obj.id == 'insertSamePage'){
        		insertSameFunc(4);
        	}else if(obj.id == 'insertSameOper'){
        		insertSameFunc(5);
        	}
        }
    };
	
  	//新增下级按钮初始化
	var sysSubButtonGroup = {
		datasource: [
             {id:'insertSubMenuDir',label:'新增下级目录'},
             {id:'insertSubMenu',label:'新增下级菜单'},
             {id:'insertSubPage',label:'新增下级页面'},
             {id:'insertSubOper',label:'新增下级操作'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSubMenuDir'){
        		insertSubFunc(1);
        	}else if(obj.id=='insertSubMenu'){
        		insertSubFunc(2);
        	}else if(obj.id == 'insertSubPage'){
        		insertSubFunc(4);
        	}else if(obj.id == 'insertSubOper'){
        		insertSubFunc(5);
        	}
        }
	}
	
	//上移
	function upFunc(){
		nodeSort("up");
	}
	
	//下移
	function downFunc(){
		nodeSort("down");
	}
	
	//上移或者下移，sortType 为 up 或者 down
	function nodeSort(sortType){
		//如果当前列表数据为0 或者 为1 ，则不用排序
		if(dataCount == 0 || dataCount == 1){
			return ;
		}
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		   return;
		} 
		var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]); 
		var selectIndex = cui('#FuncGrid').getSelectedIndex(); 
		var index = selectIndex[0];
		if(sortType == 'up' && index == 0){
			//已经置顶了
			return ;
		}else if(sortType == 'down' && index == dataCount-1){
			//已经置底了			
			return ;
		} 
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		//向上遍历数据，先判断当前需要移动的数据是在第几列
		var nodeLevel = $('input[name="checkFunc"]:checked').attr("level");
		var exchangeId = "";
		if(nodeLevel == 1){
			//如果是第一列，则判断当前第一列集合的顺序
			exchangeId = getExchangeFuncId(firstLevelResource, sortType, nodeData[0].funcId); 
		}else if(nodeLevel == 2){
			//如果是第二列，则判断当前父节点下子节点集合的顺序
			exchangeId = getExchangeFuncId(secondLevelMap.get(nodeData[0].parentFuncId), sortType, nodeData[0].funcId); 
		}
		if(exchangeId != null){
			var sortArrays = [];
			sortArrays.push(exchangeId);
			sortArrays.push(nodeData[0].funcId);
			//替换当前节点及指定节点的顺序
			dwr.TOPEngine.setAsync(false);
			FuncAction.updateFuncSortNo(sortArrays,function(data){
				//更新完成后，刷新资源列表，同时继续选中当前节点 
				cui('#FuncGrid').loadData();
				selectFunc(nodeData[0].funcId, nodeData[0].funcNodeType, nodeData[0].funcName, nodeData[0].permissionType);
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//获得需要替换顺序的节点
	function getExchangeFuncId(resourceArrays, sortType, selectFuncId){
		if(resourceArrays.length == 1){
			//集合只有一行，则也不用排序
			return null;
		}
		var changeFuncId = "";
		for(var i=0 ;i<resourceArrays.length;i++){
			if(resourceArrays[i] == selectFuncId){
				if(sortType == 'up'){
					if(i  == 0){
						//集合的第一行，也不用排序
						return null;	
					}else{
						//需要替换的是当前行的上一行的功能ID
						return resourceArrays[i-1];
					}
				}else if(sortType == 'down'){
					//集合的最后一行，不用排序
					if(i == resourceArrays.length -1){
						return null;
					}else{
						//需要替换的是下一行的功能ID
						return resourceArrays[i+1];
					}
				}				
			}
		}
	}
	
  	//功能录入
	var dialog;
  	
  	//新增同级功能资源 1 菜单目录 2 菜单 4 页面 5 操作 
  	function insertSameFunc(funcNodeType){
  		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=add&parentFuncType=FUNC&funcNodeType='+funcNodeType;
  		if(!selectData.funcLevel || selectData.funcLevel == 1){
  			url = url + '&parentFuncId='+parentFuncId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(parentFuncName)) +"&parentPermissionType="+parentPermissionType;
  		}else{
  			url = url + '&parentFuncId='+selectData.parentNodeId;
  		}
  		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 700,
			height : 300
	    }, window.parent.parent).show(url);
  	}
	
	//新增下级功能资源，1 菜单目录 2 菜单 4 页面 5 操作 
	function insertSubFunc(funcNodeType){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=add&parentFuncType=FUNC&funcNodeType='+funcNodeType;
		if(selectData.funcId){
			url = url + '&parentFuncId='+selectData.funcId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(selectData.funcName)) +"&parentPermissionType=" + selectData.permissionType;
		}else{
			url = url + '&parentFuncId='+parentFuncId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(parentFuncName)) +"&parentPermissionType="+parentPermissionType;		
		}
		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 750,
			height : 300
	    }, window.parent.parent).show(url);
	}
	
	//点击按钮编辑
	function updateFunc(){
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("请选择要编辑的资源。");
		} else {
			var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
			editFunc(nodeData[0].funcId, nodeData[0].funcNodeType);
		}
	}
	
	//编辑功能资源
	function editFunc(funcId, funcNodeType){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=edit&funcId='+funcId+'&funcNodeType='+funcNodeType;
		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 750,
			height : 300
	    }, window.parent.parent).show(url);
	}
	
	//显示菜单的角色和岗位引用
	function rightRecommend(){
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("请选择要查看的资源。");
		} else {
			var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
			var url = '${pageScope.cuiWebRoot}/top/sys/menu/RoleList.jsp?actionType=edit&funcId='+nodeData[0].funcId;
			cui.extend.emDialog({
				id: 'roleDialog',
				title : '授权信息',
				src : url,
				width : 750,
				height : 450
	    	}, window.parent.parent).show(url);
		}
	}
	
	
	//资源列表切换，只显示菜单或全部显示
	function changeHandler(value){
		cui('#button_right').hide();
		if(value == 1){
			cui('#button_up').show();
			cui('#button_down').show();
			//只查询目录菜单数据
			condition.funcLevel = 2;
		}else{
			cui('#button_up').hide();
			cui('#button_down').hide();
			//全部查询
			condition.funcLevel = 0;
		}
		selectData = {};
		
		cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
		
		cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",false);	 
		cui('#FuncGrid').loadData();
	}
	
	//一级目录显示
	var firstLevelResource = [];
	var secondLevelMap = new Map();
	
	var dataCount = 0;
	var condition={funcLevel:0};
	//grid数据源
	function dataProvider(tableObj,query){
		condition.parentFuncId = parentFuncId;
		dwr.TOPEngine.setAsync(false);
		FuncAction.queryAllFunc(condition,function(data){
			firstLevelResource = [];
			secondLevelMap = new Map();
			var dataList = data;
			tableObj.setDatasource(dataList);
			if(dataList && dataList.length > 0){
				dataCount = dataList.length;
			}
		});
		dwr.TOPEngine.setAsync(true);
		jQuery('.grid-container').height(jQuery('.grid-container').height()-30);
	}
	
	//grid列渲染
	function columnRenderer(data,field){
		var funcId = data["funcId"];
		var funcName = data["funcName"];
		var parentId = data["parentFuncId"];
		var funcCode = data["funcCode"];
		var funcNodeType = data["funcNodeType"];
		var permissionType = data["permissionType"];
		var funcLevel = data["funcLevel"];
		var imgurl = "${pageScope.cuiWebRoot}/top/sys/images/";
		//指定图标
		if(funcNodeType == 1){
			imgurl = imgurl + "func_menu_dir.gif";
		}else if(funcNodeType == 2){
			imgurl = imgurl + "func_menu.gif";
		}else if(funcNodeType == 4){
			imgurl = imgurl + "func_page.gif";
		}else if(funcNodeType == 5){
			imgurl = imgurl + "func_oper.gif";
		}
		if((field == 'firstName'&&funcLevel == 1)
				||(field == 'secondName'&&funcLevel == 2)
				   ||(field == 'threeName'&&funcLevel == 3)){
			//初始化一级顺序值
			if(funcLevel == 1){
				firstLevelResource.push(funcId);
			}else if(funcLevel == 2){
				//初始化二级顺序值
				var valarray = secondLevelMap.get(parentId);
				if(valarray){
					valarray.push(funcId);
				}else{
					valarray = [];
					valarray.push(funcId);
					secondLevelMap.put(parentId, valarray);
				}
			}
			return "<a href='javascript:editFunc(\""+funcId+"\",\""+data["funcNodeType"]+"\");'><input id=\""+funcId+"\" type=\"radio\" level=\""+funcLevel+"\" name=\"checkFunc\" value=\""+funcName+"\" onclick=\"selectFunc(\'"+funcId+"\',"+funcNodeType+",\'"+funcName+"\',"+permissionType+","+funcLevel+",\'"+parentId+"\')\" /> <img src=\""+imgurl+"\">&nbsp;"+funcName+"</a>";
		}
	}
	
	//选中值
	var selectData = {};
	
	//选中应用资源列表中的某条数据 
	function selectFuncData(rowData, isChecked, index){
		selectFunc(rowData.funcId, rowData.funcNodeType, rowData.funcName, rowData.permissionType, rowData.funcLevel, rowData.parentFuncId);
	}
	
	//选中功能项
	function selectFunc(funcId, funcNodeType, funcName, permissionType, funcLevel, parentNodeId){ 
		selectData.funcId = funcId;
		selectData.funcNodeType = funcNodeType;
		selectData.funcName = funcName;
		selectData.permissionType = permissionType;
		selectData.funcLevel = funcLevel;
		selectData.parentNodeId = parentNodeId;
		$('#'+funcId).attr("checked","true");
		cui('#FuncGrid').selectRowsByPK(funcId);
		//选中菜单，判断当前级别，如果是第一级，也是可以新增任何东西
		if(funcLevel == 1){
			cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
		}
		//选中目录需要保留 菜单、页面按钮
		if(funcNodeType == 1){
			//目录必然是第一级，同级可以新增任何东西。
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",false);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",false);	
		}else if(funcNodeType == 2 || funcNodeType == 4){
			//选中菜单需要保留 操作 按钮
			if(funcLevel == 2){
				//如果是第二级，则只能新增同级菜单或者页面
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
			}
			//新增下级
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",false);
		}else if(funcNodeType == 5){
			//选中操作，所有按钮均禁用
			if(funcLevel != 1){
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",true);
			}
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",true);
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",true);
		}
		
		if(funcNodeType != 1 && condition.funcLevel == 0 && permissionType == 2){
			cui('#button_right').show();
		}else{
			cui('#button_right').hide();
		}
	}
	
	//删除指定的应用数据
	function delFunc(){
	    var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("请选择要删除的资源。");
		} else {
		    var msg = "确定要删除选中的资源吗？";
		    var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
		    cui.confirm(msg, {
		        onYes: function () {
		        	//删除页面或者菜单时直接删除，删除目录时需判断下级是否还有节点
		        	var hasChild = true;
		        	if(nodeData[0].funcNodeType == 1){
		        		dwr.TOPEngine.setAsync(false);
			            FuncAction.getNoDelFuncId(selData, function(data){
			            	if(data != null && data.length > 0){
		            			var selectName = nodeData[0].funcName;
			            		cui.message('目录"' + selectName + "\"下存在菜单或者页面数据，不能删除。","alert");
			            		hasChild = false;
			            	}
			            });
			            dwr.TOPEngine.setAsync(true);
		        	}
		        	if(hasChild){
		        		dwr.TOPEngine.setAsync(false);
		        		FuncAction.deleteFunc(nodeData[0].funcId, nodeData[0].funcNodeType, function () {
			            	var cuiTable = cui("#FuncGrid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("资源删除成功。", "success");
	                        cui('#button_right').hide();
	                        cui("#FuncGrid").loadData();
			            });
		        		dwr.TOPEngine.setAsync(true);
		        	}
		        }
		    });
		}
	}
	
	//回调函数
	function editFuncCallBack(type, key){
		//新增信息
		if(type=="add"){
			cui('#FuncGrid').setQuery({pageNo:1,sortType:[],sortName:[]});
			cui.message("资源新增成功。","success");
		}else{
			cui.message("资源修改成功。","success");
		}
		//刷新应用资源列表，同时选中新增项
		cui('#FuncGrid').loadData();
		var nodeData = cui('#FuncGrid').getRowsDataByPK(key);
		if(nodeData){
			selectFunc(nodeData[0].funcId, nodeData[0].funcNodeType, nodeData[0].funcName, nodeData[0].permissionType, nodeData[0].funcLevel, nodeData[0].parentFuncId);
		}
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 38;
	}
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 95;
	}
 </script>
</body>
</html>