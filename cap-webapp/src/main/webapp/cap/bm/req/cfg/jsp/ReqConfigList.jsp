<!doctype html>
<%
  /**********************************************************************
	* CIP元数据建模----模型对象属性
	* 2015-9-10 姜子豪  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<html>
	<head>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/eic/css/eic.css" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/eic/js/comtop.eic.js" />
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/dwr/interface/CapDocClassDefAction.js" />
		<top:script src="/cap/dwr/interface/CapDocAttributeDefAction.js" />
	</head>
	<style>
		.top_header_wrap {
			  padding-right: 5px;
		}
		.divImport {
			  font-family: "Microsoft Yahei";
			  float: left;
			  margin-top:4px;
			  margin-bottom:4px;
		}
		.thw_operate{
			margin-top:4px;
			margin-bottom:4px;
		}
		.thw_operate{
			margin-right : 0;
			}
					th{
    font-weight: bold;
    font-size:12px;
}
	</style>
	<body>
		<div uitype="Borderlayout" id="border" is_root="true">
			<div position="center">
				<div class="top_header_wrap">
<!-- 					<div class="divImport"> -->
<%-- 					<eic:excelImport id="btnImport" showDownloadBtn="true" excelId="excelImport" style="cui-button blue-button" userId="${userInfo.userId}" downloadBtnName="下载模板" buttonName="导  入"/> --%>
<%-- 					<eic:excelExport id="btnExport" excelId="excelExport" style="cui-button blue-button" userId="${userInfo.userId}" exportType="normal" buttonName="导  出" /> --%>
<!-- 					</div> -->
					<div class="thw_operate">
						<span uitype="button" label="新增" menu="addCommonButtonMenu" on_click="insertReqQueryRow"></span> 
						<span uitype="button" label="保存" on_click="beforeSave" ></span>
						<span uitype="button" label="删除" on_click="deleteSelectedReqEditRow" ></span>
						<span uitype="button" label="上移" id="MethodGridUpButton" on_click="pageEditUp" mark="MethodGrid" disable="true"></span> 
						<span uitype="button" label="下移" id="MethodGridDownButton"  on_click="pageEditDown" mark="MethodGrid" disable="true"></span> 
						<span uitype="button" label="置顶" id="MethodGridTopButton"  on_click="pageEditTop" mark="MethodGrid" disable="true"></span> 
						<span uitype="button" label="置底" id="MethodGridBottomButton" on_click="pageEditBottom" mark="MethodGrid" disable="true"></span> 
					</div>
					<div class="editGrid">
						<table uitype="EditableGrid" edittype="reqQueryEditType" id="MethodGrid" rowclick_callback="gridOneClick" selectall_callback="gridAllClick" primarykey="id" sorttype="1" datasource="initReqEleData" pagination="false"
					 	gridwidth="900px" resizewidth="resizeWidth"  gridheight="400px" resizeheight="resizeheight" submitdata="save">
						 	<tr>
								<th style="width:5%;"></th>
								<th bindName="1" style="width:5%;"  renderStyle="text-align: center" >序号</th>
								<th bindName="engName" style="width:12%;" renderStyle="text-align: left;">名称</th>
								<th bindName="chName" style="width:12%;" renderStyle="text-align: left;">中文名</th>
								<th bindName="valueType" style="width:10%;" renderStyle="text-align: center;">取值类型</th>
								<th bindName="elementType" style="width:10%;" renderStyle="text-align: center;">控件类型</th>
								<th bindName="codeExp" style="width:10%;" render="defaultValueRender" renderStyle="text-align: left;">编码表达式</th>
								<th bindName="attributeType" style="width:10%;" renderStyle="text-align: left;">属性类型</th>
								<th bindName="columnName" style="width:10%;" renderStyle="text-align: left;">字段名</th>
								<th bindName="remark" style="width:16%;" renderStyle="text-align: left;">描述</th>
							</tr>
					 	</table>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var reqType="${param.reqType}";
			var classUri="${param.classUri}";
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
			var reqQueryEditType = {
			    "engName" : {
			        uitype: "Input",
			        maxlength: 50,
			        validate:[
			                  {'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}},
			        	      {'type':'custom','rule':{'against':checkEngName, 'm':'名称只能为:'+reqType+'_+'+'英文字母及下划线的组合形式'}},
			                  {'type':'custom','rule':{'against':checkEngNameReapet, 'm':'请检查是否存在相同需求元素编码。'}}
			        	      ]
			    },
			    "chName": {
			        uitype: "Input",
			        maxlength: 100,
			        validate:vNull
			    },
			    "elementType": {
			        uitype: "PullDown",
			        mode: "Single",
			        datasource: [
			            {id: "editer", text: "Editor"},
			            {id: "input", text: "Input"},
			            {id: "textarea", text: "TextArea"},
			            {id: "pullDown", text: "PullDown"},
			            {id: "redioGroup", text: "RadioGroup"},
			            {id: "checkboxGroup", text: "CheckboxGroup"}
			        ]
			    },
			    "valueType" : {
			        uitype: "Input",
			        maxlength: 10
			    },
			    "codeExp" : {
			        uitype: "Input",
			        maxlength: 50
			    },
			    "attributeType" : {
			        uitype: "Input",
			        maxlength: 10
			    },
			    "columnName" : {
			        uitype: "Input",
			        maxlength: 30
			    },
			    "remark" : {
			        uitype: "Input",
			        maxlength: 500
			    }
			};
			var engName = reqType+"+[a-zA-Z_]+$";
			
			//检需求元素编码重复性
			function checkEngNameReapet(data){
				var allData=cui("#MethodGrid").getData();
				var EngNameArr=getArray(allData);
				if(!isReapet(EngNameArr)){
					return false;
				}
				return true;
			}
			
			//检需求元素编码格式 
			function checkEngName(data) {
				var allData=cui("#MethodGrid").getData();
				var EngNameArr=getArray(allData);
				if(data){
					for(var i=0;i<data.length;i++){
						var reg = new RegExp(engName);
						return (reg.test(data));
					}
				}
				return true;
			} 
			
			//需求元素grid插入新行
			function insertReqQueryRow() {
				var maxsort = getMaxsort(cui("#MethodGrid").getData());
				cui("#MethodGrid").insertRow({engName:reqType+"_",elementType:"input",classUri:classUri});
			}
			
			//删除需求元素行
			function deleteSelectedReqEditRow(){
				var selects = cui("#MethodGrid").getSelectedRowData();
				if(selects == null || selects.length == 0){
					cui.alert("请选择要删除的数据。");
					return;
				}	
				cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
					onYes:function(){
						var allData=cui("#MethodGrid").getData();
						var allDataCopy=[];
						var count=0;
						for(var i=0;i<allData.length;i++){
							if(allData[i].id){
								allDataCopy[count]=allData[i];
								count++;
							}
						}
						dwr.TOPEngine.setAsync(false);
						CapDocAttributeDefAction.saveRElement(allDataCopy);
						dwr.TOPEngine.setAsync(true);
						cui("#MethodGrid").deleteSelectRow();
						var pageChangeData = cui("#MethodGrid").getChangeData();
						var deleteData=pageChangeData.deleteData;
						dwr.TOPEngine.setAsync(false);
						CapDocAttributeDefAction.deleteReqElementlst(deleteData);
						dwr.TOPEngine.setAsync(true);
						cui.message('删除成功。','success');
						}
					});
			}
			
			//需求元素grid数据源 
			function initReqEleData(tableObj,query){
				dwr.TOPEngine.setAsync(false);
				CapDocAttributeDefAction.queryReqElementList(query,classUri,function(data){
					dataCount = data.count;
			    	tableObj.setDatasource(data.list, data.count);
			    	maxsort = dataCount;
				});
				dwr.TOPEngine.setAsync(true);
			}
			
			function beforeSave(){
				var rel=cui("#MethodGrid").submit();
				if(rel === "fail"){
					return false;
				}
				else{
					cui.message('保存成功。','success');
				}
			}
			
			//保存数据 
			function save(isBack) {
				var allData=cui("#MethodGrid").getData();
				var allEngNameArr=getArray(allData);
				var flag=false;
				//新增数据 修改数据
				if(allData){
					Sort(allData);
					dwr.TOPEngine.setAsync(false);
					CapDocAttributeDefAction.saveRElement(allData, function(bResult){
						flag=bResult;
					});
					dwr.TOPEngine.setAsync(true);
					if(flag){
						cui('#MethodGrid').loadData();
					}
				}
				cui('#MethodGrid').submitComplete();
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
			
			//editgrid上移下移，置顶，置底js
			//按钮区域
			function pageEditUp(event, self, mark){
				up(mark);
			}
			function pageEditDown(event, self, mark){
				down(mark);
			}
			function pageEditTop(event, self, mark){
				myTop(mark);
			}
			function pageEditBottom(event, self, mark){
				bottom(mark);
			}
			
			//按钮单选
			function oneClick(gridId){
				var indexs =  cui("#" + gridId).getSelectedIndex();
				var gridData = cui("#" + gridId).getData();
				if(indexs.length == 0){ //全不选-不能上移下移置顶置底
					setButtonIsDisable(gridId,true,true,true,true);
				}else{
					if(isContinue(indexs)){ // 是连续的-可上移下移
						if(indexs[0] == 0 && indexs[indexs.length-1] != gridData.length-1){ //包含了第一条记录只能下移、置底
							setButtonIsDisable(gridId,true,false,true,false);
						}else if(indexs[indexs.length-1] == gridData.length-1 && indexs[0] != 0 ){ //包含了最后一条记录只能上移、置顶
							setButtonIsDisable(gridId,false,true,false,true);
						}else if(indexs[0] == 0  && indexs[indexs.length-1] == gridData.length-1 ){//不能上移下移置顶置底
							setButtonIsDisable(gridId,true,true,true,true);
						}else{ //可上移下移置顶置底
						   setButtonIsDisable(gridId,false,false,false,false);
						}
					}else{ // 不是连续的
						setButtonIsDisable(gridId,true,true,true,true);
					}
				}
			}
			
			//按钮全选
			function allClick(gridId){
				setButtonIsDisable(gridId,true,true,true,true);
			}
			
			//设置grid的置灰显示
			function setButtonIsDisable(gridId,up,down,top,bottom){
				cui("#" + gridId + "UpButton").disable(up);
				cui("#" + gridId + "DownButton").disable(down);
				cui("#" + gridId + "TopButton").disable(top);
				cui("#" + gridId + "BottomButton").disable(bottom);
			}
			
			//判断数组是否是连续数组
			function isContinue(array){
				var len=array.length;
				var n0=array[0];
				var sortDirection=1;//默认升序
				if(array[0]>array[len-1]){
				        //降序
						sortDirection=-1;
				}
				if((n0*1+(len-1)*sortDirection) !== array[len-1]){
				        return false;
				}
				var isContinuation=true;
					for(var i=0;i<len;i++){
				        if(array[i] !== (i+n0*sortDirection)){
				            isContinuation=false;
				            break;
						}
					 }
					return isContinuation;
			}
			
			//上移
			function up(gridId){
				var indexs =  cui("#" + gridId).getSelectedIndex();
				var index = indexs[0];
				if(index == 0){
					return;
				}
				for(var i=0;i<indexs.length;i++){
					var datas = cui("#" + gridId).getData();
					var currentData   = datas[indexs[i]];
					var  frontData = datas[indexs[i]-1];
					
					var temp = currentData.sort;
					currentData.sort = frontData.sort;
					frontData.sort = temp;
					
					if(currentData.areaItemId && !frontData.areaItemId){
						frontData.areaItemId = currentData.areaItemId;
						frontData.areaId = currentData.areaId;
						delete currentData.areaItemId;
						delete currentData.areaId;
					}
					if(!currentData.areaItemId && frontData.areaItemId){
						currentData.areaItemId = frontData.areaItemId;
						currentData.areaId = frontData.areaId;
						delete frontData.areaItemId;
						delete frontData.areaId;
					}
					
					cui("#" + gridId).changeData(currentData, indexs[i] - 1,true,true);
					cui("#" + gridId).changeData(frontData,indexs[i],true,true);
					cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
					cui("#" + gridId).selectRowsByIndex(indexs[i], false);
				}
				//判断按钮是否置灰
				oneClick(gridId);
			}
			
			//下移
			function down(gridId){
				var indexs =  cui("#" + gridId).getSelectedIndex();
				var index = indexs[indexs.length-1];
				var datas = cui("#" + gridId).getData();
				if(index === datas.length - 1){
					return;
				}
				for(var i=indexs.length-1;i>=0;i--){
					var datas = cui("#" + gridId).getData();
					var currentData = datas[indexs[i]];
					var nextData = datas[indexs[i] + 1];
					
					var temp = currentData.sort;
					currentData.sort = nextData.sort;
					nextData.sort = temp;
					
					if(currentData.areaItemId && !nextData.areaItemId){
						nextData.areaItemId = currentData.areaItemId;
						nextData.areaId = currentData.areaId;
						delete currentData.areaItemId;
						delete currentData.areaId;
					}
					
					if(!currentData.areaItemId && nextData.areaItemId){
						currentData.areaItemId = nextData.areaItemId;
						currentData.areaId = nextData.areaId;
						delete nextData.areaItemId;
						delete nextData.areaId;
					}
					
					cui("#" + gridId).changeData(currentData, indexs[i] + 1,true,true);
					cui("#" + gridId).changeData(nextData, indexs[i],true,true);
					cui("#" + gridId).selectRowsByIndex(indexs[i], false);
					cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
				}
				//判断按钮是否置灰
				oneClick(gridId);
			}
			
			//置顶
			function myTop(gridId){
				var datas = cui("#" + gridId).getData();
				for(var i=0;i<(datas.length-1);i++){
					up(gridId);
				}
 				//判断按钮是否置灰
 				oneClick(gridId);
			}
			
			//置底
			function bottom(gridId){
				var datas = cui("#" + gridId).getData();
				for(var i=0;i<(datas.length-1);i++){
					down(gridId);
				}
 				//判断按钮是否置灰
				oneClick(gridId);
			}
			
			//grid单选
			function gridOneClick(){
				oneClick('MethodGrid');
			}
			
			//grid全选
			function gridAllClick(){
				allClick('MethodGrid');
			}

			//截取需求元素编码
			function getArray(object){
				var array=[];
				for(var i=0;i<object.length;i++){
					array[i]=object[i].engName;
				}
				return array;
			}
			
			//判断是否重复
			function isReapet(obj){
				for(var i = 0;i<obj.length;i++){
					for(var j=i+1;j<obj.length;j++){  
						if(obj[i]== obj[j]){
							return false;
						}
					}  
				}
				return true;
			}
			
			//重新编号排序
			function Sort(obj){
				if(obj){
					for(var i=0;i<obj.length;i++){
						obj[i].sort=i+1;
					}
				}
			}
			
			//空格过滤
			function isBlank(data){
				if(data.replace(/\s/g, "")==""){
					return false;
				}
				return true;
			}
			
		</script>
	</body>
</html>
