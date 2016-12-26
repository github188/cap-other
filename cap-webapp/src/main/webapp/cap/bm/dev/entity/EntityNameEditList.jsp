<%
/**********************************************************************
* 实体别名编辑
* 2016-5-13 林玉千 
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='pageInfoEdit'>
<head>
	<title>实体别名重复编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div  style="padding:10px 5px 5px 5px">
		<div class="thw_operate" style="float:right;height: 28px;">
			<span uitype="button" id="saveName" label="确定"  on_click="saveName" ></span>
			<span uitype="button" id="close" label="关闭"  on_click="close" ></span>
		</div>
	</div>
		<div class="cap-area">
		<table id="myTable"  gridwidth="500px" gridheight="300px" uitype="EditableGrid" align="center" submitdata="save" datasource="initData" edittype="edittype" primarykey="modelId"> 
			<thead>  
				<tr width="350px" height="20px">    
				<th width="10px"></th>     
				<th width="50px" height="20px" align="center" bindName="dbObjectName">数据库表名</th> 
				<th width="50px" height="20px" align="center" bindName="engName">实体名称</th>  
				<th width="50px" height="20px" align="center"  bindName="aliasName" >实体别名</th> 
				</tr> 
			</thead> 
		</table> 
	</div>
</div>
	<script type="text/javascript">
    //系统目录树的，应用模块编码
    var entityVO={};
    var entityList=new Array();
    var modelPackage="";
	//页面渲染
	jQuery(document).ready(function(){
	    comtop.UI.scan();
	});
	//初始化数据源
	function initData(obj){
		entityList=parent.entityList;
		obj.setDatasource(entityList); 
	}
	//实体别名检测
	var validateEntityAliasName = [
			{'type':'required','rule':{'m':'实体别名不能为空。'}},
			{'type':'custom','rule':{'against':checkEntityAliasNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'}},
			{'type':'custom','rule':{'against':checkEntityAliasNameIsExist, 'm':'实体别名已经存在。'}}
	    ];
	data={};
  	//校验实体名称字符
  	function checkEntityAliasNameChar(data) {
  		var regEx = "^([a-z])[a-zA-Z0-9_]*$";
  		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
  	}
	
  	//检验实体别名是否存在
  	function checkEntityAliasNameIsExist(aliasName,entity){
  		var flag = true;
  		dwr.TOPEngine.setAsync(false);
		EntityFacade.isExistSameAliasNameEntity(aliasName,entity.modelId,function(bResult){
			flag = !bResult;
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
  	}
  	//EditGrid数据属性调用方法
	var edittype = { 
		"aliasName": { 
			uitype: "Input",
			maxlength: 50,
			validate:validateEntityAliasName
		} 
	} 

	//保存模板
	function saveName(){
		var allData = cui("#myTable").getData();//获取EditGrid数据
	    for(var i=0;i<allData.length;i++){
	    	var currentAliasName = allData[i].aliasName;
	    	var currentModelId = allData[i].modelId;
	    	var currentEngName = allData[i].engName;
	    	var flag = true;
	    	//先进行列表自校验
	    	for(var j=0;j<allData.length;j++){
	    		if(currentAliasName == allData[j].aliasName && currentModelId != allData[j].modelId){
	    			flag = false;
	    			break;
	    		}
	    	}
	    	//如果列表没有重名 ,则发送后台做唯一校验 
	    	if(flag){
				flag = checkEntityAliasNameIsExist(allData[i].aliasName,allData[i]);
	    	}
			if(!flag){
				cui.alert(currentEngName+"实体别名已存在，请更改别名!")
				return false;
			}
		}
		var result = cui("#myTable").submit();
		//验证失败
		if(result == "fail"){
			return false;
		}else if(result == "noChange"){//数据没有改变
			cui.alert("实体别名已存在，请更改别名!")
			return false;
		}
		parent.entityList = entityList;
		window.parent.enSureData(entityList);
		close();
	}
	//保存数据
	function save(obj, changeData) {
		var updateData = changeData.updateData;
		var dataLen = entityList.length;
		var entityListTemp = new Array();
		var entityVO = {};
  		for (var j = dataLen; j--;) {
            var id = entityList[j].modelId;
            for (var i = 0, len = updateData.length ; i < len; i++ ) {
                if (updateData[i].modelId == id) {
                	entityVO = updateData[i];
                	entityListTemp.unshift(entityVO);
                }
            }
        }
  		entityList = entityListTemp;
  	}
	//关闭窗口
	function close(){
		window.parent.closeEntityNameWindow();
	}
	
	
	</script>
</body>
</html>