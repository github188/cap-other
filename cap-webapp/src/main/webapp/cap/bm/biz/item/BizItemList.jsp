<%
  /**********************************************************************
	* CAP业务事项列表 
	* 2015-11-12 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>业务事项列表</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
</head>
<style>
.queryDiv {
	float:left;
	margin-left :30px;
	margin-top :4px;
	margin-bottom:4px;
	}
.thw_operate{
	margin-right:25px;
	margin-top: 4px;
	margin-bottom:4px;
	}
.itemGridDiv{
	margin-top: 4px;
	}
</style>
<body>
<div uitype="Borderlayout" is_root="true">
	<div class="queryDiv">
		<span class="keywords">编码/名称：</span>
		<span uitype="Input" id="keywords" maxlength="100" align="left" width="40%" readonly="false" databind="searchInfo.keywords"></span>
		<span uitype="button" id="search_btn" label="查询" on_click="search" ></span>
		<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch"></span>
	</div>
	<div id="itemDiv" align="center">
		<div class="thw_operate" id="operateDiv">
			<span uitype="Button" id="addItem" label="新增" button_type="blue-button" on_click="addItem"></span>
			<span uitype="Button" id="deleteItem" label="删除" button_type="blue-button" on_click="deleteItem"></span>
			<span uitype="Button" id="itemGridUpButton" label="上移" button_type="blue-button" on_click="upItem" mark="itemGrid"></span>
			<span uitype="Button" id="itemGridDownButton" label="下移" button_type="blue-button" on_click="downItem" mark="itemGrid"></span>
			<span uitype="Button" id="itemGridTopButton" label="置顶" button_type="blue-button"  on_click="topItem" mark="itemGrid"></span>
			<span uitype="Button" id="itemGridBottomButton" label="置底" button_type="blue-button" on_click="bottomItem" mark="itemGrid"></span>
		</div>
		<div class="itemGridDiv">
			<table id="itemGrid" uitype="EditableGrid" datasource="initData" selectrows="multi" primarykey="id" colhidden="false" resizeheight="resizeHeight" ellipsis="true" resizewidth="resizeWidth" 
			pagesize_list="[10, 20, 30]" pagesize="10" pageno="1" sorttype="DESC" sortname="sortNo" rowclick_callback="itemGridOneClick" selectall_callback="itemGridAllClick" submitdata="save">
				<thead>
					<tr>
						<th width="3%"></th>
						<th width="12%" renderStyle="text-align: center;" bindName="code">编码</th>
						<th width="15%" sort="true" align="center" bindName="name" render="itemInfo">名称</th>
						<th width="35%" align="center" bindName="bizDesc">业务说明</th>
						<th width="35%" align="center" bindName="managePoints">管理要点</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
</div>
<top:script src="/cap/dwr/interface/BizItemsAction.js" />
<script type="text/javascript">
	var selectDomainId = "${param.selectDomainId}";
	window.onload = function(){
		comtop.UI.scan();
		setButtonIsDisable("itemGrid",true,true,true,true);
	}
	//grid数据源
	function initData(tableObj,query){
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		if(selectDomainId){
			query.domainId=selectDomainId;
			dwr.TOPEngine.setAsync(false);
			BizItemsAction.queryItemsListByDomainId(query,function(data){
				dataCount = data.count;
		    	tableObj.setDatasource(data.list,dataCount);
			});
			dwr.TOPEngine.setAsync(true);
		}
		else{
			tableObj.setDatasource(null);
		}
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}
	
	//grid 高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) -40;
	}
	
	//新增事项 
	function addItem() {
		var url = "BizItemEdit.jsp?selectDomainId="+selectDomainId;
		window.location.href = url;
	}
	
	//删除
	function deleteItem(){
		var selects = cui("#itemGrid").getSelectedRowData();
		var deleteItemList=[];
		var message="";
		var count=0;
		for(var i=0;i<selects.length;i++){
			dwr.TOPEngine.setAsync(false);
			BizItemsAction.checkItemIsUse(selects[i],function(data){
				if(data>0){
					message+=selects[i].name+",";
					
				}
				else{
					deleteItemList[count]=selects[i];
					count++;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		if(message !=""){
			if(count >0){
				var str=message+"已被引用无法删除,是否要删除其他未被引用的数据?"
				deleteItemLst(str,deleteItemList);
			}
			else{
				cui.alert("所选数据已被引用无法删除");
				return;
			}
		}
		else{
			var str="确定要删除这"+selects.length+"条数据吗?"
			var allData=cui("#itemGrid").getData();
			var query={};
			if(deleteItemList.length == allData.length){
					query.pageNo=1;
					cui("#itemGrid").setQuery(query);
			}
			deleteItemLst(str,deleteItemList);	
		}
	}
	
	//
	function deleteItemLst(str,deleteRoleList){
		cui.confirm(str,{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				BizItemsAction.deleteBizItemsList(deleteRoleList);
				dwr.TOPEngine.setAsync(true);
				cui("#itemGrid").loadData();
				cui.message('删除成功。','success');
			}
		});
	}
		
	
	//名称行渲染（点击进入编辑界面）
	function itemInfo(rd,index,col){
		return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>"+rd[col.bindName] + "</a>";
	}
	
	//点击grid名称行事件
	function edit(selectItemId){
		var url = "BizItemEdit.jsp?selectDomainId="+selectDomainId+"&selectItemId="+selectItemId;
		window.location.href = url;
    }
	
	//
	function reflesh(ItemInfoVO){
		cui("#itemGrid").loadData();
		cui("#itemGrid").selectRowsByPK(ItemInfoVO.id);
	}
	
	/**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(searchInfo).databind().getValue();
        if(data.keywords){
        	data.keywords=trim(data.keywords);
        }
        else{
        	data.keywords="";
        }
        data.pageNo=1;
        //设置Grid的查询条件
        cui('#itemGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#itemGrid').loadData();
    }
	
    /**
     * 清空查询表单
     */
    function clearSearch(){
    	cui(searchInfo).databind().setEmpty();
        search();
    }
    
    //去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
 	
 	function save(){
 		cui('#itemGrid').loadData();
 		
 	}
</script>
<top:script src="/cap/bm/biz/item/js/BizItems.js" />
</body>
</html>