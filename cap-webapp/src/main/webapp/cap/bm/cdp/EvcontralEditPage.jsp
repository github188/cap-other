<%
/**********************************************************************
* 环境管理编辑页面
* 2016-10-27 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>环境管理编辑页面</title>
    <top:link href="/cap/rt/common/base/css/base.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
    <style type="text/css">
    	.cap-page{
    		width: 100%;
    		min-width: 600px;
    		padding: 0;
    	}
    </style>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.extend.dictionary.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EvcontralEditPageAction.js'></top:script>
	<top:script src='/cap/bm/cdp/js/CdpCinfigUtils.js'></top:script>
	<top:script src='/cap/dwr/interface/CdpConfigAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_bm_cdp_evcontralEditPage'}]"/> 
    
</head>
<body>
<div id="pageRoot" class="cap-page">
<div class="cap-area" style="width:100%;">
	<table id="tableid-34423556085675955" class="cap-table-fullWidth">
		<tr id="trid-9196089173201472">
			<td id="tdid-5912058073095977" class="cap-td" style="text-align:right;" >
            	<span id="btnSave" uitype="Button" ></span>
            	<span id="btnBackTo" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-3737458574945278" class="cap-table-fullWidth">
		<tr id="trid-7260793251809828">
			<td id="tdid-8410049218927863" class="cap-td"  >
            	<span id="uiid-915372895579982" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-09551620265566452" class="cap-table-fullWidth">
		<tr id="trid-04519761789676193">
			<td id="tdid-6693517773351576" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-998969623477786" uitype="Label" ></span>
			</td>
			<td id="tdid-27206478160351026" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-06158914289141091" uitype="Input" ></span>
			</td>
			<td id="tdid-8011650295479225" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-2503942812698437" uitype="Label" ></span>
			</td>
			<td id="tdid-25137582528123943" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-05665276811771153" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-04032630684874824">
			<td id="tdid-6405800407343649" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-4179345927215262" uitype="Label" ></span>
			</td>
			<td id="tdid-9016110339236612" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-023276897489640413" uitype="Input" ></span>
			</td>
			<td id="tdid-951108972458797" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="startportlabel" uitype="Label" ></span>
			</td>
			<td id="tdid-9572585326437341" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="startPort" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-05377636069100645">
			<td id="tdid-1150454045169112" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-933823102747375" uitype="Label" ></span>
			</td>
			<td id="tdid-3967073012439471" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-7666960397605162" uitype="Input" ></span>
			</td>
			<td id="tdid-1911971994161977" class="cap-td" style="text-align:right;width:20%;" >
			</td>
			<td id="tdid-7178149280333375" class="cap-td" style="text-align:right;width:30%;" >
			</td>
		</tr>
		<tr id="trid-3303175375892654">
			<td id="tdid-18543867466178483" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-5964029599780435" uitype="Label" ></span>
			</td>
			<td id="tdid-7453268527559536" class="cap-td" style="text-align:left;width:80%;" colspan='3'>
            	<span id="uiid-0006945957841856365" uitype="Textarea" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-25615668195165398" class="cap-table-fullWidth">
		<tr id="trid-2640076709559677">
			<td id="tdid-29449430348119215" class="cap-td"  >
            	<span id="uiid-14771500750210379" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-6123003025794473" class="cap-table-fullWidth">
		<tr id="trid-6402639191377537">
			<td id="tdid-18112763432907478" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-17104999568340133" uitype="Label" ></span>
			</td>
			<td id="tdid-2937566516700381" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-4447264761237558" uitype="Input" ></span>
			</td>
			<td id="tdid-8469983180704695" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-7444652593929331" uitype="Label" ></span>
			</td>
			<td id="tdid-8875013484172439" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-78161699957912" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-3199467911403479">
			<td id="tdid-7524717349553163" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-3934916967531974" uitype="Label" ></span>
			</td>
			<td id="tdid-2621528906334717" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-531259167316493" uitype="Input" ></span>
			</td>
			<td id="tdid-6019535959066592" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-7695477026706101" uitype="Label" ></span>
			</td>
			<td id="tdid-3356645675787353" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-6634143172225376" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-8128557560663864">
			<td id="tdid-7068071326915575" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-29490308153256837" uitype="Label" ></span>
			</td>
			<td id="tdid-7705516003410517" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-9800679062656464" uitype="Input" ></span>
			</td>
			<td id="tdid-5980400194771011" class="cap-td" style="text-align:right;width:20%;" >
			</td>
			<td id="tdid-18178954133717895" class="cap-td" style="text-align:right;width:30%;" >
			</td>
		</tr>
	</table>
	<table id="tableid-20465483342267206" class="cap-table-fullWidth">
		<tr id="trid-49863342209692064">
			<td id="tdid-3980594017248056" class="cap-td"  >
            	<span id="uiid-31329873621425904" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-6137405122863129" class="cap-table-fullWidth">
		<tr id="trid-98020229046233">
			<td id="tdid-49583365542348474" class="cap-td" style="text-align:left;" >
            	<span id="btnAddOnEGird" uitype="Button" ></span>
            	<span id="btnDeleteOnEGrid" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-0808739654216993" class="cap-table-fullWidth">
		<tr id="trid-39595755618065596">
			<td id="tdid-985950362868607" class="cap-td"  >
            	<table id="uiid-6543082100442268" uitype="Grid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-26281263982751423" class="cap-table-fullWidth">
		<tr id="trid-7413229409403726">
			<td id="tdid-1531642305922025" class="cap-td"  >
            	<span id="uiid-45353267439766825" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-28334052035814764" class="cap-table-fullWidth">
		<tr id="trid-7480856305703765">
			<td id="tdid-5341388069823995" class="cap-td"  >
            	<span id="btnAddDB" uitype="Button" ></span>
            	<span id="btnDeleteDB" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-7192108376540232" class="cap-table-fullWidth">
		<tr id="trid-8329742482858468">
			<td id="tdid-23065232734579308" class="cap-td"  >
            	<table id="uiid-9380211805991624" uitype="Grid" ></table>
			</td>
		</tr>
	</table>
</div>
</div>
</body>

<script type="text/javascript">
var primaryValue=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("primaryValue"))%>;
var pageMode=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("pageMode"))%>;
var id=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("id"))%>;


cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;


var environment={};

var evcontralListPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/evcontralListPage.ac';
var appPatternCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/appPatternCroEditPage.ac';
var appPatternEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/appPatternCroEditPage.ac';
var dbconfigCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/dbconfigCroEditPage.ac';
var dbconfigEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/dbconfigCroEditPage.ac';

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作
	if(!id){
		id = primaryValue;
	}
	var paramArray =[];
	cap.formId = id;
	var param = "id";
    if (param) {
       paramArray = param.split(",");
    }
	if(!cap.isUndefinedOrNullOrBlank(cap.formId) && paramArray.length>0){
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.Environment';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.Environment';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'getEnvironmentVO',paramArray);
		dwr.TOPEngine.setAsync(false);
		EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作
			
			cui("#uiid-023276897489640413").setReadonly(true);
			
			environment=result;
			//TODO 数据设置后操作
			if(environment.startPort){
				cui("#startPort").setReadonly(true);
        }
		},
		errorHandler:function(message, exception){
		   //TODO 后台异常信息回调

		}
		});
		dwr.TOPEngine.setAsync(true);
	}else{
		var defaultValue = {};
		var expression = "default";
		//TODO 改变expression

		switch (expression){
			case "default":
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("environment"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		environment = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作
    gridAppDatasource(cui("#uiid-6543082100442268"));
    gridDBDatasource(cui("#uiid-9380211805991624"));
    appPatternCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/appPatternCroEditPage.ac'+'?envId='+environment.id+'&pageMode='+pageMode+'&envtype='+environment.type;
    dbconfigCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/dbconfigCroEditPage.ac'+'?envId='+environment.id+'&envtype='+environment.type;
	$("#startportlabel").find("sup").hide();
}
	

		
//初始化查询行为 列表查询行为方法
function gridAppDatasource(obj, pageQuery) {
	var gridData = [];
	var gridDataCount = 0;
 	//TODO 自定义列表初始化行为
   gridData = environment.relationAppPatternList;
	obj.setDatasource(gridData,gridDataCount);
}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作
   var isExistEvnCode = isExistEvnCodeForSave(environment.code);
	if(isExistEvnCode === "existed"){
		var message ="环境编码不可重复";
		cui.alert(message);
		return;
	}else if(isExistEvnCode === "exception"){
		var message ="环境编码正在集群中校验，请稍候再试";
		cui.alert(message);
		return;
	}
	var saveContinue=4;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作
		if(!environment.creator||!environment.createTime){
			environment.creator = globalUserId;
			environment.createTime = new Date();
		}
		var paramArray = [];
		var paramsStr = 'environment';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.Environment';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.Environment';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'insertEnvironmentVO',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="environment.id"){
				eval("environment.id=_result");
			}

			
			//默认保存成功
			var type = 'success';
			var message = '保存成功！';
			
			cui.message(message, type,{'callback':function(){
				//回调的操作

				if(type != "success"){
					return;
				}
				var pWindow = cap.searchParentWindow("reloadGridData");
				if(pWindow && typeof pWindow["reloadGridData"] === "function"){
					pWindow["reloadGridData"]();
				}
				if(saveContinue==1){
					window.location=window.location;
				}else if(saveContinue==2){
					window.close();
				}else if(saveContinue==4){
					var reloadURL = window.location.href;
					var localURL = window.location.href;
					if(localURL.indexOf("?")>0){
						if(localURL.indexOf("primaryValue")<0){
							reloadURL = localURL +"&primaryValue="+environment.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+environment.id; 
					}
					window.location.href=reloadURL;
				}
			}});
    	},
    	errorHandler:function(message, exception){
		   //TODO 后台异常信息回调
		   var type = 'error';
		   var message ="保存失败,存在异常信息:"+message;

		   cui.message(message);
		}
    	});
    	dwr.TOPEngine.setAsync(true);
	}
	//TODO 可自定义设置返回值

}
	

		
/*
 * 点击按钮跳转页面 点击按钮跳转页面
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function backTo(event, self, mark) { 
	var pageJumpURL=cap.getforwardURL(evcontralListPage);
	var container=window;
	//TODO  调用后台前处理逻辑

	//带查询条件返回设置
  	var saveQueryData='yes';
  	 if(saveQueryData=='yes'){
  		pageJumpURL=cap.buildURL(pageJumpURL,{clearSession:false});
  	}
  	//当打开的页面为新窗口，并且当前window实现了backTo_pageJump方法，则调用backTo_pageJump方法来打开新页面
  	var _openWindow = window["backTo_pageJump"]; 
  	if("location" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"location",container);
  	}
}
		
	

		
/*
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRow(event, self, mark) { 
	var gridId="uiid-2106563819450277";
	var initObj={};
	//自定义初始始化逻辑

	cui("#"+gridId).insertRow(initObj);
}
	

		
/*
 * editGrid删除事件 editGrid删除事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function deleteRows(event, self, mark) { 
	var gridId="uiid-7901557899778709";
	//自定义删除前处理逻辑

	cui("#"+gridId).deleteSelectRow();
}
	

		
/*
 * 新增行事件 最后一行开始追加
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addAppRow(event, self, mark) { 
	var gridId="uiid-7901557899778709";
	var initObj={};
	//自定义初始始化逻辑

	cui("#"+gridId).insertRow(initObj);
}
	

		
//删除应用行事件 删除选中的行以及数据
function deleteAppRows(){
	//删除前操作

	var gridId="uiid-6543082100442268";
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
		onYes:function(){
			var paramArray = [];
			paramArray[0] = selects;
			var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.AppPattern';
			aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.AppPattern';	
			var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'deleteAppPatternList',paramArray);
			EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
				//数据刷新前处理
           if(result){
             for(var i=0;i<environment.relationAppPatternList.length;i++){
					 for(var j=0;j<selects.length;j++){
							if(environment.relationAppPatternList[i].id==selects[j].id){
								environment.relationAppPatternList.splice(i,1);
								if(i>0){
									i--;
								}
							}
						}
					}
            }
				
				if(result){
					gridObj.loadData();
				 	cui.message("删除成功！","success");
				}else{
					cui.error("删除失败，请重新操作！");
				}
				
				//数据刷新后处理
				
			},
			errorHandler:function(message, exception){
			   //TODO 后台异常信息回调
			   var message ="删除失败,存在异常信息:"+message;

			   cui.message(message);
			}
			});
		}
	});
	//TODO 可自定义设置返回值

}
	

		
//新增数据库行事件 最后一行开始追加
function addDBRow(){
	var pageJumpURL=cap.getforwardURL(dbconfigCroEditPage);
	var container=window;
	//TODO  调用后台前处理逻辑
   if(!environment.id){
   		cui.message("请先保存环境再新增数据库");
		return;
	}
	//当打开的页面为新窗口，并且当前window实现了addDBRow_pageJump方法，则调用addDBRow_pageJump方法来打开新页面
  	var _openWindow = window["addDBRow_pageJump"]; 
  	if("location" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"location",container);
  	}
	
}
	

		
//删除数据库行事件 删除选中的行以及数据
function deleteDBRows(){
	//删除前操作

	var gridId="uiid-9380211805991624";
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
		onYes:function(){
			var paramArray = [];
			paramArray[0] = selects;
			var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
			aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.DatabaseConfig';	
			var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'deleteList',paramArray);
			EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
				//数据刷新前处理
         if(result){
		             for(var i=0;i<environment.relationDatabaseList.length;i++){
							 for(var j=0;j<selects.length;j++){
									if(environment.relationDatabaseList[i].id==selects[j].id){
										environment.relationDatabaseList.splice(i,1);
										if(i>0){
											i--;
										}
									}
								}
							}
		            }
				
				if(result){
					gridObj.loadData();
				 	cui.message("删除成功！","success");
				}else{
					cui.error("删除失败，请重新操作！");
				}
				
				//数据刷新后处理

			},
			errorHandler:function(message, exception){
			   //TODO 后台异常信息回调
			   var message ="删除失败,存在异常信息:"+message;

			   cui.message(message);
			}
			});
		}
	});
	//TODO 可自定义设置返回值

}
	

		
//页面初始化之后行为(自定义) 页面初始化之后行为(自定义)
function pageInitAfterProcess(){
	//TODO 自定义页面加载逻辑

}
	

		
//新增行事件 最后一行开始追加
function addAppPattern(){

	var pageJumpURL=cap.getforwardURL(appPatternCroEditPage);
	var container=window;
	//TODO  调用后台前处理逻辑
	if(!environment.id){
   		cui.message("请先保存环境再新增应用模式");
		return;
	}
	var appPatternGridData = cui("#uiid-6543082100442268").getData();
	var middleWare;
	var imgTag;
	if(appPatternGridData.length > 0){
		middleWare = appPatternGridData[0].middleWare;
		imgTag = appPatternGridData[0].imgTag;
	}
	appPatternCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/appPatternCroEditPage.ac'+'?envId='+environment.id+'&pageMode='+pageMode+'&envtype='+environment.type
    +'&middleWare='+middleWare + '&imgTag=' + imgTag;
	pageJumpURL=cap.getforwardURL(appPatternCroEditPage);
	//当打开的页面为新窗口，并且当前window实现了addAppPattern_pageJump方法，则调用addAppPattern_pageJump方法来打开新页面
  	var _openWindow = window["addAppPattern_pageJump"]; 
  	if("location" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"location",container);
  	}
	

}
	

		
//初始化查询行为 列表查询行为方法
function gridDBDatasource(obj, pageQuery) {
	var gridData = [];
	var gridDataCount = 0;
 	//TODO 自定义列表初始化行为
gridData = environment.relationDatabaseList;
	obj.setDatasource(gridData,gridDataCount);
}
	

		
//数据库是否默认渲染 grid自定义字典数据列渲染
function getDBDefDataByCode(rd, index, col) {
	var colDicSet = cap.getDicByAttr(col.bindName);
	if(colDicSet.length == 0){
		var dicData = cap.getDicData('cap_cdp_db_default');
		if(dicData.length > 0){
			cap.dicDatas.push({"attrs":[col.bindName],"list":dicData,"code":'cap_cdp_db_default'});
		}
		colDicSet = dicData;
	}
	var content=cap.getTextOfDicValue(colDicSet,rd[col.bindName]);
	//自定义处理方式

	return content;
}
	

		
//判断环境编码是否存在 调用新版action方法
function isExistEvnCodeForSave(code){
	if(environment.id){
		return "notExist";
    }
	var paramArray = [];
	var paramsStr = 'environment';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理
	var flag = "notExist";
	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.Environment';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.Environment';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'isExistEvnCode',paramArray);
		EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
			if(data == 1){
	        	flag = "existed";
	        }else if(data == 2){
	        	flag = "exception";
	        }else{
	        	flag = "notExist";
	        }
		},
		errorHandler:function(message, exception){
			flag = "exception";
			//var message ="调用后台服务失败,存在异常信息:"+message;
			//cui.message(message);
		}
	});
	dwr.TOPEngine.setAsync(true);
	return flag;

}
	

		
//端口是否被占用 调用新版action方法
function isPortExist(){
	if(environment.id||!environment.startPort){
     return true;
   }
	var paramArray = [];
	var paramsStr = 'environment';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理
	var flag = false;
	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.Environment';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.Environment';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'isPortExist',paramArray);
	//TODO  调用后台前处理逻辑

	EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
		if("true"==String(data)){
			flag =  true;
		}else{
			flag = false;
		}
		
		//TODO  后台调用返回后的处理逻辑  

	},
	errorHandler:function(message, exception){
		   //TODO 后台异常信息回调
		   var message ="调用后台服务失败,存在异常信息:"+message;

		   cui.message(message);
	}
	});
	dwr.TOPEngine.setAsync(true);
	//TODO 可自定义设置返回值
	
	return flag;

}
	

		
//初始化输入框行为 自定义形参,多个参数使用英文逗号隔开
function initInputValidate(value){
	//TODO 自定义页面加载逻辑
	if(isDevEnTypeMatch(value.id)){
		$("#startportlabel").find("sup").show();
		cap.validater.add('startPort', 'required', {
            m:'启动端口不能为空'
        });
      proposePort();
	}else{
		$("#startportlabel").find("sup").hide();
		cap.validater.remove('startPort', 'required');
	}
}
	

		
//查看应用链接渲染 grid查看链接渲染
function gridAppLinkRender(rd, index, col){
 
	if(rd[col.bindName] == null){
		return;
	}
	var url=cap.getforwardURL(appPatternEditPage);
	url = cap.buildURL(url,{'primaryValue':rd['primaryValue'],'id':rd['primaryValue'], 'envId':environment.id,'envtype':environment.type});
	var content= "<a style=\"cursor:pointer\" onclick=\"cap.pageJump('"+url+"','_self',window)\">" + rd[col.bindName] + "</a>";
	//自定义content内容

	return content;

}
	

		
//编辑数据库链接渲染 grid编辑链接渲染
function gridDBLinkRender(rd, index, col) { 
	if(!rd[col.bindName]){
		return;
	}
	var url=cap.getforwardURL(dbconfigCroEditPage);
	url=cap.buildURL(url,{primaryValue:rd['primaryValue']});
	//自定义URL内容
	url = cap.buildURL(url,{'primaryValue':rd['primaryValue'],'id':rd['primaryValue'], 'envId':environment.id,'envtype':environment.type});
	var content= "<a style=\"cursor:pointer\" onclick=\"cap.pageJump('"+url+"','_self',window)\">" + rd[col.bindName] + "</a>";
	//自定义content内容

	return content;
}
	

		
//设置默认数据库 自定义形参,多个参数使用英文逗号隔开
function setDefDB(){
var gridId="uiid-9380211805991624";
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要设置为默认的数据库。");
		return;
	}
	if(selects.length > 1){
		cui.alert("只能选择一条数据设置");
		return;
	}
	for(var i=0;i<environment.relationDatabaseList.length;i++){
		if(environment.relationDatabaseList[i].id==selects[0].id){
			environment.relationDatabaseList[i].defaultDb = 1;
		}else{
			environment.relationDatabaseList[i].defaultDb = 2;
		}
	}
	gridObj.loadData();
}
	

		
//环境编辑自动宽度 环境编辑自动宽度
function getEnvBodyWidth(params){
return parseInt(jQuery("#pageRoot").css("width"))- 35;
}
	

		
//推荐端口 调用新版action方法
function proposePort(){

	var paramArray = [];
	var paramsStr = '';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理

	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.Environment';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.Environment';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'proposePort',paramArray);
	//TODO  调用后台前处理逻辑

	EvcontralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
		if(!environment.startPort){
          	cui("#startPort").setValue(data);
			window["environment.startPort"] = data;
		}
		
		//TODO  后台调用返回后的处理逻辑  
	},
	errorHandler:function(message, exception){
		   //TODO 后台异常信息回调
		   var message ="调用后台服务失败,存在异常信息:"+message;

		   cui.message(message);
	}
	});
	dwr.TOPEngine.setAsync(true);
	//TODO 可自定义设置返回值


}
	


//页面初始化状态
function pageInitState(){
	    if(pageMode=='readonly'){
		    cap.setUIState('btnSave',"hide");
	        cap.disValid('btnSave', true);
		    cap.setUIState('btnAddOnEGird',"hide");
	        cap.disValid('btnAddOnEGird', true);
		    cap.setUIState('btnDeleteOnEGrid',"hide");
	        cap.disValid('btnDeleteOnEGrid', true);
	    }
}
        
jQuery(document).ready(function(){
	cap.beforePageInit.fire();
	cap.executeFunction("pageInitBeforeProcess");
	if(window['pageMode'] == "textmode" || window['pageMode'] == "readonly"){
		comtop.UI.scan[pageMode]=true;
	}
	comtop.UI.scan();
	cap.errorHandler();
	cap.executeFunction("pageInitLoadData");
	cap.pageInit();
	pageInitState();
	cap.executeFunction("pageInitAfterProcess");
});
        
        
//页面控件属性配置
var uiConfig={
    "btnSave":{
        "id":"btnSave",
        "on_click":saveForm,
        "uitype":"saveButton",
        "label":"保存",
        "name":"btnSave"
    },
    "btnBackTo":{
        "id":"btnBackTo",
        "on_click":backTo,
        "uitype":"backToButton",
        "label":"返回",
        "name":"btnBackTo"
    },
    "uiid-915372895579982":{
        "value":"基本信息配置",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "uiid-998969623477786":{
        "value":"环境名称: ",
        "uitype":"Label",
        "label":"环境名称",
        "isReddot":true,
        "name":"nameLabel"
    },
    "uiid-06158914289141091":{
        "maxlength":"32",
        "databind":"environment.name",
        "name":"name",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"环境名称长度不能大于32个字符"}},{"type":"required","rule":{"m":"环境名称不能为空"}}]
    },
    "uiid-2503942812698437":{
        "value":"环境类型: ",
        "uitype":"Label",
        "label":"环境类型",
        "isReddot":true,
        "name":"typeLabel"
    },
    "uiid-05665276811771153":{
        "on_change":initInputValidate,
        "name":"type",
        "databind":"environment.type",
        "width":"80%",
        "uitype":"PullDown",
        "dictionary":"app_cdp_env_code",
        "validate":[{"type":"required","rule":{"m":"环境类型不能为空"}}]
    },
    "uiid-4179345927215262":{
        "value":"环境编码: ",
        "uitype":"Label",
        "label":"环境编码",
        "isReddot":true,
        "name":"codeLabel"
    },
    "uiid-023276897489640413":{
        "maxlength":"8",
        "databind":"environment.code",
        "name":"code",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":8,"maxm":"环境编码长度不能大于8个字符"}},{"type":"required","rule":{"m":"环境编码不能为空"}},{"type":"format","rule":{"m":"环境编码只能由小写字母数字组成","pattern":"^[a-z0-9]+$"}}]
    },
    "startportlabel":{
        "value":"启动端口: ",
        "id":"startportlabel",
        "uitype":"Label",
        "label":"启动端口",
        "isReddot":true,
        "name":"startPortLabel"
    },
    "startPort":{
        "id":"startPort",
        "maxlength":5,
        "databind":"environment.startPort",
        "name":"startPort",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"numeric","rule":{"notim":"必须为整数","min":30000,"minm":"端口需大于30000","max":32767,"maxm":"端口需小于32767"}},{"type":"custom","rule":{"m":"端口号已被占用","against":"isPortExist","args":"this"}}]
    },
    "uiid-933823102747375":{
        "value":"还原时间间隔(小时): ",
        "uitype":"Label",
        "label":"还原时间间隔(小时)",
        "isReddot":false,
        "name":"revertMaxIntervalLabel"
    },
    "uiid-7666960397605162":{
        "maxlength":5,
        "databind":"environment.revertMaxInterval",
        "name":"revertMaxInterval",
        "width":"80%",
        "emptytext":"24",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":5,"maxm":"还原最大时间间隔 单位小时长度不能大于5个字符"}},{"type":"numeric","rule":{"notim":"还原时间间隔只能为正整数","min":1,"minm":"最小还原时间间隔为1小时"}}]
    },
    "uiid-5964029599780435":{
        "value":"描述: ",
        "uitype":"Label",
        "label":"描述",
        "isReddot":false,
        "name":"descriptionLabel"
    },
    "uiid-0006945957841856365":{
        "height":"100px",
        "maxlength":"1000",
        "databind":"environment.description",
        "name":"description",
        "width":"100%",
        "uitype":"Textarea",
        "validate":[{"type":"length","rule":{"max":2000,"maxm":"描述长度不能大于2000个字符"}}]
    },
    "uiid-14771500750210379":{
        "value":"测试服务配置",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "uiid-17104999568340133":{
        "value":"测试帐号: ",
        "uitype":"Label",
        "label":"测试帐号",
        "isReddot":false,
        "name":"autotestUserLabel"
    },
    "uiid-4447264761237558":{
        "maxlength":"32",
        "databind":"environment.autotestUser",
        "name":"autotestUser",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"测试帐号长度不能大于32个字符"}}]
    },
    "uiid-7444652593929331":{
        "value":"测试密码: ",
        "uitype":"Label",
        "label":"测试密码",
        "isReddot":false,
        "name":"autotestPasswordLabel"
    },
    "uiid-78161699957912":{
        "maxlength":"100",
        "databind":"environment.autotestPassword",
        "name":"autotestPassword",
        "width":"80%",
        "uitype":"Input",
        "type":"password",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"测试密码长度不能大于100个字符"}}]
    },
    "uiid-3934916967531974":{
        "value":"ftp用户名: ",
        "uitype":"Label",
        "label":"ftp用户名",
        "isReddot":false,
        "name":"autoTestFtpUserLabel"
    },
    "uiid-531259167316493":{
        "maxlength":"50",
        "databind":"environment.autoTestFtpUser",
        "name":"autoTestFtpUser",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":50,"maxm":"ftp用户名长度不能大于50个字符"}}]
    },
    "uiid-7695477026706101":{
        "value":"ftp密码: ",
        "uitype":"Label",
        "label":"ftp密码",
        "isReddot":false,
        "name":"autoTestFtpPasswordLabel"
    },
    "uiid-6634143172225376":{
        "maxlength":"50",
        "databind":"environment.autoTestFtpPassword",
        "name":"autoTestFtpPassword",
        "width":"80%",
        "uitype":"Input",
        "type":"password",
        "validate":[{"type":"length","rule":{"max":50,"maxm":"ftp密码长度不能大于50个字符"}}]
    },
    "uiid-29490308153256837":{
        "value":"测试服务地址: ",
        "uitype":"Label",
        "label":"测试服务地址",
        "isReddot":false,
        "name":"autotestRootPathLabel"
    },
    "uiid-9800679062656464":{
        "maxlength":"100",
        "databind":"environment.autotestRootPath",
        "name":"autotestRootPath",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"自动化测试服务根地址长度不能大于100个字符"}}]
    },
    "uiid-31329873621425904":{
        "value":"应用模式管理",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "btnAddOnEGird":{
        "id":"btnAddOnEGird",
        "on_click":addAppPattern,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"btnAddOnEGird"
    },
    "btnDeleteOnEGrid":{
        "id":"btnDeleteOnEGrid",
        "on_click":deleteAppRows,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"btnDeleteOnEGrid"
    },
    "uiid-6543082100442268":{
        "resizeheight":getBodyHeight,
        "columns":[{"name":"应用模式名称","bindName":"name","sort":false,"hide":false,"disabled":false,"render":"gridAppLinkRender"},{"name":"应用模式编码","bindName":"code","sort":false,"hide":false,"disabled":false},{"name":"应用描述","bindName":"description","sort":false,"hide":false,"disabled":false}],
        "gridheight":"auto",
        "resizewidth":getEnvBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "uitype":"Grid",
        "lazy":true,
        "pagination":true,
        "datasource":gridAppDatasource
    },
    "uiid-45353267439766825":{
        "value":"数据库管理",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "btnAddDB":{
        "id":"btnAddDB",
        "on_click":addDBRow,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"btnAddDB"
    },
    "btnDeleteDB":{
        "id":"btnDeleteDB",
        "on_click":deleteDBRows,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"btnDeleteDB"
    },
    "uiid-9380211805991624":{
        "resizeheight":getBodyHeight,
        "columns":[{"name":"数据库名称","bindName":"name","sort":false,"hide":false,"disabled":false,"render":"gridDBLinkRender"},{"name":"数据库编码","bindName":"code","sort":false,"hide":false,"disabled":false},{"name":"数据库类型","bindName":"type","sort":false,"hide":false,"disabled":false},{"name":"数据库地址","bindName":"databaseUrl","sort":false,"hide":false,"disabled":false},{"name":"是否默认","bindName":"defaultDb","sort":false,"hide":false,"disabled":false,"render":"getDBDefDataByCode"}],
        "gridheight":"auto",
        "resizewidth":getEnvBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "uitype":"Grid",
        "lazy":true,
        "pagination":true,
        "datasource":gridDBDatasource
    }
}

</script>
</html>