<%
  /**********************************************************************
	* CIP元数据建模----需求附件配置
	* 2015-9-10 丁庞  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:link href="/eic/css/eic.css" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/eic/js/comtop.eic.js" />
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/dwr/interface/AttElementAction.js" />
	</head>
	<style>
		.top_header_wrap {
			  padding-right: 5px;
		}
		.divTitle {
			  font-family: "Microsoft Yahei";
			  font-size: 14px;
			  color: #0099FF;
			  margin-left: 20px;
			  float: left;
		}
		.thw_operate{
				margin-top:4px;
				margin-bottom:4px;
		}
		th{
    font-weight: bold;
    font-size:14px;
}
	</style>
	<body>
		<div uitype="Borderlayout" id="border" is_root="true">
			<div position="center">
				<div class="top_header_wrap">
					<div class="divTitle">需求附件元素配置</div>
					<div class="thw_operate">
						<span uitype="button" label="新增" menu="addCommonButtonMenu" on_click="insertReqQueryRow"></span> 
						<span uitype="button" label="保存" on_click="beforeSave" ></span>
						<span uitype="button" label="删除" on_click="deleteSelectedReqEditRow" ></span>
					</div>
					<div class="editGrid">
						<table uitype="EditableGrid" edittype="attTypeEditType" id="attTypeGrid" primarykey="id" sorttype="1" datasource="initReqEleData" pagination="false"
					 	gridwidth="900px" resizewidth="resizeWidth"  gridheight="400px" resizeheight="resizeheight" colrender="columnRender" submitdata="save">
						 	<tr>
								<th style="width:50px"></th>
								<th bindName="1" style="width:6%;"  renderStyle="text-align: center" >序号</th>
								<th bindName="attLabel" style="width:20%;" renderStyle="text-align: left;">附件名称标签</th>
								<th bindName="jobTypeCode" style="width:32%;" renderStyle="text-align: left;">附件标签标识</th>
								<th bindName="objId" style="width:32%;" renderStyle="text-align: left;">业务单据ID</th>
							</tr>
					 	</table>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var reqType="${param.reqType}";
			//初始化 
			window.onload = function(){
				comtop.UI.scan();
		   	}
			
			//grid 宽度
			function resizeWidth(){
				return (document.documentElement.clientWidth || document.body.clientWidth) -5;
			}
			
			//grid 宽度
			function resizeheight(){
				return (document.documentElement.clientHeight || document.body.clientHeight) -50;
			}
			
			var vNull = [{'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}}];
			
			//需求元素单元格编辑类型 
			var attTypeEditType = {
			    "attLabel" : {
			        uitype: "Input",
			        maxlength: 100,
			        validate: [
			                   {'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}},
				        	   {'type':'custom','rule':{'against':checkAttLabel, 'm':'请勿使用重复的附件名称标签。'}}
					       		]
			    },
			    "jobTypeCode": {
			        uitype: "Input",
			        maxlength: 100,
			        validate:vNull
			    },
			    "objId" : {
			        uitype: "Input",
			        maxlength: 100,
			        validate:[
							  {'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}},
			        	      {'type':'custom','rule':{'against':checkObjId, 'm':'请勿使用重复的业务单据ID。'}}
				        	    ]
			    }
			};
			
			//插入行
			function insertReqQueryRow(a, b, mark) {
				var maxsort = getMaxsort(cui("#attTypeGrid").getData());
				cui("#attTypeGrid").insertRow({reqType:reqType,sort:maxsort + 1});
			}
			
			//删除行
			function deleteSelectedReqEditRow(){
				var selects = cui("#attTypeGrid").getSelectedRowData();
				if(selects == null || selects.length == 0){
					cui.alert("请选择要删除的数据。");
					return;
				}	
				cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
					onYes:function(){
						cui("#attTypeGrid").deleteSelectRow();
						var pageChangeData = cui("#attTypeGrid").getChangeData();
						var deleteData=pageChangeData.deleteData;
						dwr.TOPEngine.setAsync(false);
						AttElementAction.deleteAttElementlst(deleteData);
						dwr.TOPEngine.setAsync(true);
						cui.message('删除成功。','success');
						}
					});
			}
			
			//grid数据源 
			function initReqEleData(tableObj,query){
				dwr.TOPEngine.setAsync(false);
				AttElementAction.queryAttElementList(query,reqType,function(data){
					dataCount = data.count;
			    	tableObj.setDatasource(data.list, data.count);
			    	maxsort = dataCount;
				});
				dwr.TOPEngine.setAsync(true);
			}
			
			//editgrid验证
			function beforeSave(){
				var rel=cui("#attTypeGrid").submit();
				if(rel === "fail"){
					return false;
				}
				else{
					cui.message('保存成功。','success');
				}
			}
			
			//保存数据 
			function save(isBack) {
				var pageChangeData = cui("#attTypeGrid").getChangeData();
				var allData=cui("#attTypeGrid").getData();
				var flag=false;
				
				//新增数据 修改数据
				if(allData){
					Sort(allData);
					dwr.TOPEngine.setAsync(false);
					AttElementAction.saveAttElement(allData, function(bResult){
							flag=bResult;
					});
					dwr.TOPEngine.setAsync(true);
					if(flag){
						cui('#attTypeGrid').loadData();
					}
				}
				cui('#attTypeGrid').submitComplete();
			}

			//获得数据的最大的排序号 供添加新行初始化sort字段使用
			function getMaxsort(rowDatas){
				var max = 0;
				if(!rowDatas || rowDatas.length == 0){
					return max;
				}
				for(var i=0; i < rowDatas.length; i++){
					if(!rowDatas[i].sort){
						continue;
					}
					if(rowDatas[i].sort > max){
						max = rowDatas[i].sort;
					}
				}
				return max;
			}
			
			//重新编号排序
			function Sort(obj){
				if(obj){
					for(var i=0;i<obj.length;i++){
						obj[i].sort=i+1;
					}
				}
			}
			
			//截取附件名称标签
			function getattLabel(object){
				var array=[];
				for(var i=0;i<object.length;i++){
					array[i]=object[i].attLabel;
				}
				return array;
			}
			
			//截取业务单据ID
			function getobjId(object){
				var array=[];
				for(var i=0;i<object.length;i++){
					array[i]=object[i].objId;
				}
				return array;
			}
			
			//判断是否重复
			function isReapet(obj){
				for(var i = 0;i<obj.length;i++){
					for(var j=i+1;j<obj.length;j++){  
						if(obj[i].replace(/\s/g, "") == obj[j].replace(/\s/g, "")){
							return false;
						}
					}  
				}
				return true;
			}
			
			//校验附件名称标签是否重复
			function checkAttLabel(data){
				if(!data.replace(/\s/g, "")){
					return false;
				}
				var allData=cui("#attTypeGrid").getData();
				var attLabelList=getattLabel(allData);
				if(isReapet(attLabelList)){
					return true;
				}
				return false;
			}
			
			//校验附件名称标签是否重复
			function checkObjId(data){
				if(!data.replace(/\s/g, "")){
					return false;
				}
				var allData=cui("#attTypeGrid").getData();
				var objIdList=getobjId(allData);
				if(isReapet(objIdList)){
					return true;
				}
				return false;
			}
			
			//空格过滤
			function isBlank(data){
				if(data.replace(/\s/g, "")==""){
					return false;
				}
				return true;
			}
			function isSave(){
				var pageChangeData = cui("#attTypeGrid").getChangeData();
				var changeData=pageChangeData.changeData;
				return changeData;
			}
		</script>
	</body>
</html>
