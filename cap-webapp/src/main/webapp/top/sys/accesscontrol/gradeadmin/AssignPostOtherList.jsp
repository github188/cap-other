<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>非行政岗位列表</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AssignManageAuthorityAction.js"></script>
</head>
<body>
	<div class="list_header_wrap" style="padding:0 0 10px 0px;">
	  	<div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入岗位名称、全拼、简拼" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>&nbsp;&nbsp;&nbsp;&nbsp;
	   	</div>
			<div class="top_float_right">
				<input type="checkbox" id="associateQuery" align="middle"  title="未分配岗位查询" onclick="setAssociate(0)" style="cursor:pointer;"/>
				<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">只显示未分配岗位</font></label>
				<span uitype="button" id="button_saveall" label="分配所有岗位" on_click="doSaveAll"></span>
				<span uitype="button" id="button_add" label="保存" on_click="doAdd"></span>
			</div>
	 </div>
	 <div id="doSaveAllBtn" style="display: none;text-align: left; margin-top:30px;margin-left:5px;line-height: 20px;"></div>
     <table uitype="grid" id="otherPostGrid"  primarykey="OTHER_POST_ID" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:5%"><input type="checkbox" /></th>
		<th bindName="OTHER_POST_NAME" style="width:25%" renderStyle="text-align: left" sort="true">岗位名称</th>
		<th bindName="OTHER_POST_CODE" style="width:25%" renderStyle="text-align: left" sort="true">岗位编码</th>
		<th bindName="NAME_FULL_PATH" style="width:25%" renderStyle="text-align: left" sort="true">所属分类全路径</th>
		<th bindName="OTHER_POST_FLAG" style="width:20%" renderStyle="text-align: left" sort="true">是否标准岗位</th>
	</table>
 
<script language="javascript">
		var  classifyId= "<c:out value='${param.classifyId}'/>";//节点ID
	    var associateType ="<c:out value='${param.associateType}'/>";//级联查询
	    var adminId = "<c:out value='${param.adminId}'/>";//管理员ID
	    var classifyName = "<c:out value='${param.classifyName}'/>";//分类名 
	    var pageNo=""; 
	    var pageSize=""; 
	    var keyword="";
	    var dataList = null;
	    var oldResourceId_arr = [];
	    
	    
	    //管辖部门ID
    	var rootOrgId = "";
	    
		window.onload = function(){
		    comtop.UI.scan();
		}
		
		
		//渲染列表数据
		function initData(grid,query){
		    pageNo=query.pageNo;
		    pageSize=query.pageSize;
		    var isSelected=$('#associateQuery')[0].checked==true?1:0;
			//获取排序字段信息
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		   
		    if(associateType==null){
		    	//默认为不级联
		    	associateType=0;
		    }
		    //设置查询条件
		    var condition = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortName:sortFieldName,sortType:sortType};
		    condition.adminId = adminId;
		    condition.creatorId = globalUserId;
		    condition.classifyId = classifyId;
		    condition.isCascade = associateType;
		    condition.isSelected = isSelected;
		    dwr.TOPEngine.setAsync(false);
		    if(globalUserId=='SuperAdmin'){
		    	AssignManageAuthorityAction.querySuperAssignPostOtherList(condition,function(data){
			    	var totalSize = data.count;
					dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
	        	});
		    } else {
		    	AssignManageAuthorityAction.queryAssignPostOtherList(condition,function(data){
		    		var totalSize = data.count;
		    		dataList = data.list;
		    		grid.setDatasource(dataList,totalSize);
		    	});
		    }
		    dwr.TOPEngine.setAsync(true);
		    oldResourceId_arr = [];
			for(var index in dataList){
				if(dataList[index].ISSELECTED==2){
					oldResourceId_arr.push(dataList[index].OTHER_POST_ID);
					grid.selectRowsByPK(dataList[index].OTHER_POST_ID);
				}
			}
	  	}
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-21;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}
		
		
		//列渲染
		function columnRenderer(data,field) {
	    	if(field == 'OTHER_POST_FLAG'){
				if(data["OTHER_POST_FLAG"]==1){
					   return "否";
				   }
				if(data["OTHER_POST_FLAG"]==2){
					   return "是";
				  }
			}
		}
		
		//设置是否只显示未分配  1为 未分配，0为默认
		function setAssociate(type){
			var isSelected=$('#associateQuery')[0].checked;
			if(type==1){
				if(isSelected)$('#associateQuery')[0].checked=false;
				else $('#associateQuery')[0].checked=true;
			}
			//执行查询
			cui("#otherPostGrid").loadData();
		}
		
		 //搜索框图片点击事件
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	        cui("#otherPostGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#otherPostGrid").loadData();
	     }
		 
		 //搜索框图片点击事件
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	     }
		 
		//给管理员分配指定部门下所有岗位的维护权限
		function doSaveAll(){
			var msg = "是否需要将分类【"+classifyName+"】下的所有岗位分配给指定管理员？";
			if(associateType == 1){
				msg = "是否需要将分类【"+classifyName+"】及其下级分类下的所有岗位分配给指定管理员？";
			}
			$('#doSaveAllBtn').html(msg);
			cui('#doSaveAllBtn').dialog({
				title:"岗位分配",
				 buttons : [
	                {
	                    name : '&nbsp;&nbsp;是&nbsp;&nbsp;',
	                    handler : function() {
	                    	var condition = {};
	                    	condition.adminId = adminId;
	                		condition.classifyId = classifyId;
	                		condition.isCascade = associateType;
	                		condition.creatorId = globalUserId;
	                		dwr.TOPEngine.setAsync(true);
	                		if(globalUserId=='SuperAdmin'){
		                		AssignManageAuthorityAction.assignAllPostOther(condition, function(){
		                			cui.message('岗位授权成功。','success');
		                			cui('#doSaveAllBtn').hide();
		            				setTimeout('cui("#otherPostGrid").loadData()',500);
		                		});
	                		} else {
	                			AssignManageAuthorityAction.assignAdminAllPostOther(condition, function(){
		                			cui.message('岗位授权成功。','success');
		                			cui('#doSaveAllBtn').hide();
		            				setTimeout('cui("#otherPostGrid").loadData()',500);
		                		});
	                		}
	                		dwr.TOPEngine.setAsync(true);
	                    }
	                }, {
	                    name : '&nbsp;&nbsp;否&nbsp;&nbsp;',
	                    handler : function() {this.hide();}
	                }
	            ]
			}).show(); 
		}

		function doAdd(){
			// isCascade orgId  resourceList
			if(!adminId){
				return;
			}
			var selected = [];
			selected = cui("#otherPostGrid").getSelectedPrimaryKey();
			dwr.TOPEngine.setAsync(true);
			var condition = {};
			condition.adminId = adminId;
			condition.classifyId = classifyId;
			condition.isCascade = associateType;
			condition.creatorId = globalUserId;
			//循环遍历所有选中的列表数据
			var post_other_arr = [];
			if(selected!=null && selected.length>0){
				for(var i=0; i<selected.length; i++) {
					if(selected[i]){
						var post_other_obj = {};
						post_other_obj.subjectId= adminId;
						post_other_obj.resourceId= selected[i];
						post_other_obj.creatorId = globalUserId;
						post_other_arr.push(post_other_obj);
					}
				}
			}
			condition.resourceList = post_other_arr;
			condition.oldResourceIdList = oldResourceId_arr;
			dwr.TOPEngine.setAsync(false);
			AssignManageAuthorityAction.assignPostOther(condition,function(result) {
				if("success"==result){
					cui.message('岗位授权成功。','success');
					setTimeout('cui("#otherPostGrid").loadData()',500);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
</script>
</body>
</html>