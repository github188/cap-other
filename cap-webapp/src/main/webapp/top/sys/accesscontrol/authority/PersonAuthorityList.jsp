
<%
    /**********************************************************************
	 * 人员权限查看
	 * 2014-07-08 谢阳  新建
	 * 2015-03-25 汪超  改造
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>人员权限查看</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AuthorityFinderAction.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" ></script>

</head>
<style type="text/css">

html{width:97%;} 
th {
	font-weight: bold;
	font-size: 14px;
}
 .post_label {
        display: inline-block;
        padding: 2px 4px;
        font-size: 12px;
        font-weight: bold;
        line-height: 14px;
        color: #fff; 
        vertical-align: baseline;
        white-space: nowrap;
        text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
        border-radius: 3px;
        cursor: pointer;
        margin:2px 5px;
    }
    .post_name_color{
        background-color: #22A7B8; 
    }
    .post_other_name_color{
    	background-color: #38B3E8; 
    }
</style>

<body>
	<div style="width: 90%;">
		<table class="form_table" style="table-layout:fixed;">
			<tr>
				<td class="td_content" style="text-align: center">
					<span uitype="ChooseUser" id="userId" name="userId" width="400px" height="29px"  chooseMode="1" userType="1"  isSearch="true" callback='keyWordQuery'>
					</span>
				</td>
			</tr>
			<tr >
				<td class="divTitle" style="padding-left:10%;">岗位信息</td>
			</tr>
			<tr>    
				<td id="role_div" style="padding-left:15%;">
					<div id="post_div">无</div>
				</td>
			</tr>
			<tr>
				<td class="divTitle" style="padding-left:10%;">权限列表</td>
			</tr>
			<tr>
				<td>
					<div id="menuAuthorityDiv" style="padding-left:11%; width: 80%;">
						 <div style="margin-bottom:8px; margin-right: 5px;"> 
							    <span uitype="clickInput"  editable="true" id="keyword" name="keyword" on_iconclick="iconclick" 
										emptytext="输入应用名称搜索" icon="search" width="240px" enterable="true"></span>
								<div uitype="checkboxGroup" id="showAllPermissionFunc" name="showAllPermissionFunc" on_change="showAllPermission" style="margin-left: 18px;">
								 		<input type="checkbox" name="showAllPermissionFuncbox" id="showAllPermissionFuncCheckbox" value="1" > 只显示授权应用
								 </div>
								<span style="margin-left: 18px;">
									应用分类：<span id="classifyTypeName" uitype="PullDown" mode="Single" value_field="CLASSIFYID" label_field="CLASSIFYNAME" datasource="initClassifyTypeNameData" empty_text="请选择分类" on_change="changeClassifyType"></span>
								</span>		
			  			</div> 
						<table id="menuAuthorityGrid" uitype="grid" datasource="menuDataProvider" selectrows="no" pagination="true" titlelock="false" 
							 primarykey="funcId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
							<tr>
								<th bindName="funcName" style="width:20%;" renderStyle="text-align: left">应用名称</th>
								<th bindName="funcCode" style="width:20%;" renderStyle="text-align: left">应用编码</th>
								<th bindName="permissionType" style="width:10%;" renderStyle="text-align: center">是否需授权</th>
								<th bindName="classifyName" style="width:20%;" renderStyle="text-align: center">应用分类</th>
							</tr>
						</table>
				</td>
			</tr>
		</table>
	</div>
	
<script language="javascript">
	var keyword="";//查询关键字
	$(document).ready(function() {
		comtop.UI.scan();
	});
	
	/**
	* 应用分类数据源
	*/
	function initClassifyTypeNameData(obj){
		var names = [];
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			var userId_val = cui("#userId").getValue()['0']['id'];
			//坑爹的加上全部和其他
			names.push({'CLASSIFYID':'all','CLASSIFYNAME':'全部'});
			dwr.TOPEngine.setAsync(false);
			AuthorityFinderAction.getCategory(userId_val,function(data){
				if(data&&data.length>0){
					for(var i = 0 ;i<data.length;i++){
							names.push(data[i]);
					}
				}
			});
			dwr.TOPEngine.setAsync(true);
			obj.setDatasource(names);
		}else{
			obj.setDatasource(names);
		}
	}
	
	var showAllPermissionFunc;
	function showAllPermission(){
		var values = cui('#showAllPermissionFunc').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			showAllPermissionFunc = 'yes'
		}else{
			showAllPermissionFunc = 'no'
		}
		 //重新查询，设置页码为1
		cui("#menuAuthorityGrid").setQuery({pageNo:1});
		cui("#menuAuthorityGrid").loadData();
	}
	
	function changeClassifyType(){
		cui("#menuAuthorityGrid").loadData();
	}
	/**
	** 查询人员权限
	**/
	function keyWordQuery(){
		var userId_val = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			userId_val = cui("#userId").getValue()['0']['id'];
		}
		AuthorityFinderAction.queryPostListByUserId(userId_val,function(data){
			var postInfo = data;
			if(postInfo&&postInfo.length>0){
                 var postName = [];
                 for(var i=0;i<postInfo.length;i++){
                	 if(postInfo[i].POSTNAME){
                		 if(postInfo[i].POSTTYPE == 1){
		                     postName.push($('<label class="post_label post_name_color" title="'+postInfo[i].FULLNAME+'">'+postInfo[i].POSTNAME+'</label>').data('post-info',postInfo[i]));
                		 }else{
                			 postName.push($('<label class="post_label post_other_name_color" title="'+postInfo[i].FULLNAME+'">'+postInfo[i].POSTNAME+'</label>').data('post-info',postInfo[i]));
                		 }
                	 }
                 }
                 $('#post_div').html(postName);
			}else{//无岗位信息，清空
				  $('#post_div').html("无");
			}
		});
			cui("#menuAuthorityGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
			cui("#menuAuthorityGrid").loadData();
			//重新加载classifyTypename数据
			initClassifyTypeNameData(cui('#classifyTypeName'));
	}
		
  $('#post_div').on('click','.post_label',function(){
			   var postInfo = $(this).data('post-info');
			   cui.dialog({
			       src:webPath + '/top/workbench/personal/RoleListForPost.jsp?postId='+postInfo.POSTID,
		            refresh:false,
		            modal: true,
		            title: '角色列表',
		            width:600,
		            height:400
			   }).show();
			});

	//键盘回车键查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			keyWordQuery();
		}
	}
	
	//定义grid宽度 
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 200;
	}

	//定义grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 250;
	}
	//展示数据
	function menuDataProvider(tableObj,query){
		//获取排序字段信息
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		
		var userId = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			userId = cui("#userId").getValue()['0']['id'];
			condition.userId = userId;
			//关键字查询
			condition.keyword = keyword;
			//按授权应用查询
			if(showAllPermissionFunc == 'yes'){
				condition.permissionType = 2;
			}
			//按分类查询
			var classifyType = cui('#classifyTypeName').getValue();
			if(classifyType){
				condition.classifyId = classifyType;
			}
			dwr.TOPEngine.setAsync(false);
			AuthorityFinderAction.queryPersonFuncList(condition,function(data){
		    	tableObj.setDatasource(data.list, data.count);
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			tableObj.setDatasource([],0);
		}
	}

	//搜索框图片点击事件
	function iconclick() {
		keyword = cui("#keyword").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
	   cui("#menuAuthorityGrid").setQuery({pageNo:1});
	   //刷新列表
		cui("#menuAuthorityGrid").loadData();
	}
	
	/**
	*列渲染
	**/
	function columnRenderer(data,field) {
		if(field == "permissionType"){
			if(data["permissionType"] == 1){
				return "否";
			}else{
				return "是";
			}
		}else if(field == "funcName"){
			return "<a onclick='javascript:viewFuncPermission(\"" + data["funcId"] + "\",\""+data["funcName"]+"\");'><font style='color:#096DD1;'>" + data["funcName"] + "</font></a>";
		}else if(field == 'classifyName' && !data["classifyName"]){
			return "其他";
		}
	}
	
	/**
	* 展现权限
	*/
	function viewFuncPermission(funcId, funcName){
		var userId = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			//待查询的人员id
			userId = cui("#userId").getValue()['0']['id'];
		}
		var height = (document.documentElement.clientHeight || document.body.clientHeight)-100;
		var width = (document.documentElement.clientWidth || document.body.clientWidth)-100;  
		var url = 'PersonAccessFuncList.jsp?funcId=' + funcId + "&userId=" + userId; 
		var title = "【" + funcName + "】权限信息";
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		});
		dialog.show(url);
	}
</script>
</body>
</html>
