
<%
/**********************************************************************
* 元数据建模：实体属性列表
* 2015-9-22 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='entityAttibuteList'>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8"/>
    <title>实体属性列表页</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/BizObjDataItemAction.js'></top:script>
	<top:script src='/cap/bm/dev/consistency/js/consistency.js'></top:script>
	<top:script src='/cap/dwr/interface/ReqFunctionSubitemAction.js'></top:script>
	<script language="javascript">
	//获得传递参数
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
    var moduleCode=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	var pageStorage = new cap.PageStorage(modelId);
	var entity = pageStorage.get("entity");
	//当表达式为空时，初始化为数组
    entity.attributes=entity.attributes==null?[]:entity.attributes;
    entity.lstRelation =entity.lstRelation==null?[]:entity.lstRelation;
	var root = {
			entityAttributes:entity.attributes
		}
	
	//监听属性变动，填充源实体属性下拉框
	function watchRelationships(){
		if(scope&&scope!=null&&scope.root){
		   addRelationShipToAttribute();
		}
		cap.addObserve(entity.lstRelation,watchRelationships);
		cap.digestValue(scope);
	}
	cap.addObserve(entity.lstRelation,watchRelationships);
	
	var _=cui.utils;
	//当触发“查询规则”onchange事件时，是否执行onchange事件的逻辑
	var changeFlag= true;
	
	//拿到angularJS的scope
	var scope=null;
	//点击数据字典弹出选择页面
	var selectDictionaryDialog;
	//其他属性选择界面
	var otherTypeSelectionDialog;
	//关联实体选择界面
	var entityDialog;
	//属性同步数据库界面
	var syncAttributeDialog;
	//泛型设置界面
	var genericDialog;
	//快速拷贝属性界面
	var copyAttrDialog;
	//从业务对象导入界面
	var bizObjDialog;
	//业务数据项界面
	var dialog;
	angular.module('entityAttibuteList', ["cui"]).controller('entityAttibuteCtrl', function ($scope, $timeout) {
	   	$scope.root=root;
	   	$scope.entityAttributeCheckAll=false;
	   	$scope.bizObjInfoDataCheckAll=false;
	   	$scope.selectEntityAttributeVO=root.entityAttributes.length>0?root.entityAttributes[0]:{};
	   	//父属性
	   	$scope.parentEntityAttributes =[];
	    //默认显示属性tab标签
    	$scope.active='attr';
    	$scope.attrLstStyle = {"height":window.screen.height-410,"overflow-y":"auto"};
    	$scope.parentAttrLst = {"height":window.screen.height-190,"overflow-y":"auto","overflow-x":"hidden"};
	   	//属性过滤关键字
    	$scope.attributeFilter="";
	   	
	   	$scope.hideButtonFlag = entity.entitySource=="exist_entity_input"?true:false;
	   	
	   	$scope.ready=function(){
	    	comtop.UI.scan();
	    	
// 	    	$(".cap-page").css("height", $(window).height()-20);
// 			$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
// 		       jQuery(".cap-page").css("height", $(window).height()-20);
// 		    });
	    	
	    	$scope.setReadonlyAreaState(globalReadState);
	    	scope=$scope;
	    	$scope.init();
	    	$scope.loadParentAttributes();
	    	$scope.initBizObjInfoDataItem();
	    }
	   	
	   	/**
		 * 设置区域读写状态
		 * @param globalReadState 状态标识
		 */
		$scope.setReadonlyAreaState=function(globalReadState){
			//设置为控件为自读状态（针对于CAP测试建模）
		   	if(globalReadState){
		    	$timeout(function(){
		    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'])"], ["input[type='checkbox']"]);
		    	}, 0);
	    	}
		}
	   	
	   	$scope.init=function(){

	   		//允许为空和查询字段从boolean转换为字符串，为了ridio按钮自动选中
	   		for(var i in root.entityAttributes){
	   		  root.entityAttributes[i].queryField = root.entityAttributes[i].queryField+"";
	   		  root.entityAttributes[i].allowNull = root.entityAttributes[i].allowNull+"";
	   		  if(root.entityAttributes[i].relationId==null){
	   			root.entityAttributes[i].relationId ="";
	   		  }
	   		}
	   	}
	   	
	    //切换Tab标签
    	$scope.showPanel=function(msg){ 
    		$scope.active=msg;
    		//切换Tab标签时默认选中第一个属性
    		if(msg=="parentAttr"){
    			var attribute =  $scope.parentEntityAttributes[0];
    			if(!attribute){
    				return;
    			}
    			$scope.entityAttributeTdClick(attribute,'parent')
    		}else{
    			var attribute = $scope.root.entityAttributes[0];
    			if(!attribute)
    				return;
    			$scope.entityAttributeTdClick(attribute,'')
    		}
    	} 
	   	
	   	//加载父实体
	   	$scope.loadParentAttributes=function(){
	   		readParentAttibutes(entity.parentEntityId);
	   	}
	   	
	   	//初始化业务对象数据项
	   	$scope.initBizObjInfoDataItem=function(){
	   		readBizObjInfoDataItem($scope.selectEntityAttributeVO.dataItemIds);
	   	}

	   	$scope.entityAttributeTdClick=function(entityAttributeVo,nodeType){
	   		//前一个属性的类型
   			//var _oldType = $scope.selectEntityAttributeVO.attributeType.type;
   			//当前选中的属性的类型
	   		var _newType = entityAttributeVo.attributeType.type;
   			var _oldQueryMatchRule = $scope.selectEntityAttributeVO.queryMatchRule;
   			var _newQueryMatchRule = entityAttributeVo.queryMatchRule;
   			
   			
	   		//设置选中的属性对象
	   		$scope.selectEntityAttributeVO=entityAttributeVo;
	   		//是否为查询字段
	   		if(entityAttributeVo.queryField=="true"){
	   			//如果两次类型不一致，则重新设置“查询规则”的datasource
	   			//if(_oldType && _newType && _oldType != _newType){
			   		cui("#queryMatchRule").setDatasource(queryMatchRuleData[_newType]);
			   		/* 
			   		 * 原则上属性切换不能执行“查询规则”的onchange事件。所以这里判断两次的“查询规则”值不一样，则设置changeFlag = false。
			   		 * 因为设置不一样的值，下面的setValue会触发“查询规则”的onchange事件，而这时又不需要执行onchange的逻辑。
			   		 * 做这样的控制，是因为cui重置了datasource，会清除控件上显示的值，当值没有变化的时候，又不会触发onchange事件，没触发onchange事件，cui2Angular.js中的onchange代码就不会执行，就不会进行渲染。
			   		 */
			   		if(_oldQueryMatchRule != _newQueryMatchRule){
			   			changeFlag = false;
			   		}
			   		cui("#queryMatchRule").setValue(_newQueryMatchRule);
		   		//}
	   		}

	   	    //根据父实体和当前实体，控制只读
	   		if(nodeType=="parent"){
	   			setTimeout('setEditReadOnly()',10);
	   			cui("#defaultValue").setReadOnly(true);
	   			cui("#btnAdd").hide();
	   			cui("#btnDelete").hide();
	   		}else{
	   			cui("#btnAdd").show();
	   			cui("#btnDelete").show();
		   		if(entityAttributeVo.relationId&&entityAttributeVo.relationId!=""){ 
		   			//延迟设置只读，主要为控制click控制，让angularjs先显示
		   			setTimeout('setEditReadOnly()',10);
		   		}else{
		   			comtop.UI.scan.setReadonly(false, '#form');
		   			cui("#dbFieldVOEngName").setReadonly(true);
		   			if(entityAttributeVo.dbFieldId==''){
		   				cui("#queryField").setReadonly(false);
		   			}
		   		}
		   		
		   		var isPrimaryKey=$scope.selectEntityAttributeVO.primaryKey;
		   		if(isPrimaryKey){
		   			cui("#defaultValue").setReadOnly(true);
		   		}else{
		   			var attrType = $scope.selectEntityAttributeVO.attributeType.type;
			   		switch(attrType){
					case "int": cui("#defaultValue").setReadOnly(false);break;
					case "String":cui("#defaultValue").setReadOnly(false);break;
					case "double": cui("#defaultValue").setReadOnly(false);break;
					case "long": cui("#defaultValue").setReadOnly(true);break;
					case "float": cui("#defaultValue").setReadOnly(false);break;
					case "java.math.BigDecimal": cui("#defaultValue").setReadOnly(false);break;
					case "Integer": cui("#defaultValue").setReadOnly(false);break;
					default : cui("#defaultValue").setReadOnly(true);break;
					}
		   		}
	   		}
	   	    
	   	    //加载属性关联的业务对象数据项
	   		readBizObjInfoDataItem($scope.selectEntityAttributeVO.dataItemIds);
	   	    //
	   	    
	   	    //之前如果业务对象数据项全部选中则设置为不选中
	   		$scope.bizObjInfoDataCheckAll=false;
	   		$scope.setReadonlyAreaState(globalReadState);
	    }
	   	
	    //属性列表过滤
    	$scope.$watch("attributeFilter",function(){
    		for(var i=0;i<$scope.root.entityAttributes.length;i++){
    			if($scope.attributeFilter==""){
    				$scope.root.entityAttributes[i].isFilter=false;
    			}else if($scope.root.entityAttributes[i].engName.indexOf($scope.attributeFilter)==-1&&$scope.root.entityAttributes[i].chName.indexOf($scope.attributeFilter)==-1){
    				$scope.root.entityAttributes[i].isFilter=true;
    			}else{
    				$scope.root.entityAttributes[i].isFilter=false;
    			}
            }
    		$scope.checkBoxCheck($scope.root.entityAttributes,"entityAttributeCheckAll");
    	});
	    
	   	//监控全选checkbox，如果选择则联动选中列表所有数据
	   	$scope.allCheckBoxCheck=function(ar,isCheck){
	   		if(ar!=null){
	   			for(var i=0;i<ar.length;i++){
	    			if(isCheck && !ar[i].isFilter){
	    				ar[i].check=true;
		    		}else{
		    			ar[i].check=false;
		    		}
	    		}	
	   		}
	   	}
	   	
	   	//监控全选checkbox，如果选择则联动选中列表所有数据
	   	$scope.allBizCheckBoxCheck=function(ar,isCheck){
	   		if(ar!=null){
	   			for(var i=0;i<ar.length;i++){
	    			if(isCheck){
	    				ar[i].check=true;
		    		}else{
		    			ar[i].check=false;
		    		}
	    		}	
	   		}
	   	}
	   	
	   	//监控选中，如果列表所有行都被选中则选中allCheckBox
	   	$scope.checkBoxCheck=function(ar,allCheckBox){
	   		if(ar!=null){
	   			var checkCount=0;
	   			var allCount=0;
	    		for(var i=0;i<ar.length;i++){
	    			if(ar[i].check&&ar[i].relationId==""&&ar[i].primaryKey==false){
	    				checkCount++;
		    		}
	    			
	    			if(!ar[i].isFilter&&ar[i].relationId==""&&ar[i].primaryKey==false){
	    				allCount++;
	    			}
	    		}
	    		if(checkCount==allCount && checkCount!=0){
	    			eval("$scope."+allCheckBox+"=true");
	    		}else{
	    			eval("$scope."+allCheckBox+"=false");
	    		}
	   		} 
	   	}
	   	
	   	//业务对象数据项的选中
	   	$scope.checkBoxBizCheck=function(ar,allCheckBox){
	   		if(ar!=null){
	   			var checkCount =0;
	   			var allCount =ar.length;
	   			for(var i=0;i<ar.length;i++){
	   				 if(ar[i].check){
	   					 checkCount++;
	   				 }
	   			}
	   			if(checkCount==allCount&&checkCount!=0){
	   				eval("$scope."+allCheckBox+"=true");
	   			}else{
	   				eval("$scope."+allCheckBox+"=false");
	   			}
	   		}
	   	}
	   	
	   	//业务对象数据项单项选中
	   	$scope.bizInfoItemTdClick=function(bizInfoItem,arr,allCheckBox){
	   		bizInfoItem.check = !bizInfoItem.check;
	   		$scope.checkBoxBizCheck(arr,allCheckBox);
	   	}
	   	
		//新增属性
	   	$scope.addEntityAttribute=function(){
			//如果当前选中了关系属性，点击新增的时候需要放开只读
	   		comtop.UI.scan.setReadonly(false, '#form');
	   		cui("#dbFieldVOEngName").setReadonly(true);
   		    cui("#queryField").setReadonly(false);
	   		var iSortNo = $scope.root.entityAttributes.length+1;
			var newEntityAttribute = {
					relationId:"",sortNo:iSortNo,engName:"",chName:'',primaryKey:false,attributeType:{source:"primitive",type:"String"},dbFieldId:"",queryField:"false",allowNull:"true",accessLevel:"private"};
			
			$scope.root.entityAttributes.push(newEntityAttribute);
			$scope.selectEntityAttributeVO=newEntityAttribute;
			$scope.checkBoxCheck($scope.root.entityAttributes,"entityAttributeCheckAll");
	   	}
		
		//属性上移
		$scope.upAttribute=function(){
			var sortNo = $scope.selectEntityAttributeVO.sortNo;
			if(undefined === sortNo ||sortNo==1){
				return;
			}
			var attributeVOTemp = $scope.root.entityAttributes[sortNo-2];
			$scope.root.entityAttributes[sortNo-2] = $scope.selectEntityAttributeVO;
			$scope.root.entityAttributes[sortNo-1] = attributeVOTemp;
			$scope.selectEntityAttributeVO.sortNo = sortNo-1;
			attributeVOTemp.sortNo = sortNo;
			cap.digestValue($scope);
		}
		
		//属性下移
		$scope.downAttribute=function(){
			var sortNo = $scope.selectEntityAttributeVO.sortNo;
			var length = $scope.root.entityAttributes.length;
			if(undefined === sortNo || sortNo==length){
				return;
			}
			var attributeVOTemp = $scope.root.entityAttributes[sortNo];
			$scope.root.entityAttributes[sortNo] = $scope.selectEntityAttributeVO;
			$scope.root.entityAttributes[sortNo-1] = attributeVOTemp;
			$scope.selectEntityAttributeVO.sortNo = sortNo+1;
			attributeVOTemp.sortNo = sortNo;
			cap.digestValue($scope);
		}
		
		//数字字典选择界面
		$scope.selectDictionary=function(){
			//需要定位到的配置项所属模块的Id
			var gotoModulId = packageId;
			
			//通过配置项全编码查询配置项所属的模块Id
			var dicDataFullCode = $scope.selectEntityAttributeVO.attributeType.value;
			if(dicDataFullCode){
				var cfgVO;
				dwr.TOPEngine.setAsync(false);
				EntityFacade.getModulIdByCfgFullCode(dicDataFullCode,function(data){
					cfgVO = data;
				});
				dwr.TOPEngine.setAsync(true);
				if(cfgVO && cfgVO.configClassifyId){
					gotoModulId = cfgVO.configClassifyId;
				}
			}
			
			var url = "SelectDictionary.jsp?sourceModuleId="+gotoModulId+"&code="+dicDataFullCode;
			var title ="选择数据字典";
			var height = 500; 
			var width =  680; 
			selectDictionaryDialog = cui.dialog({
				id : "selectDictionaryDialog",
				title : title,
				src : url,
				width : width,
				height : height
			});
			selectDictionaryDialog.show(url);
		}
		
		//关联实体属性选择界面
		$scope.setAttributeGeneric=function(){
			var url = "SetEntityAttributeGeneric.jsp?packageId=" + packageId + "&modelId=" + modelId;
			var title="属性泛型设置";
			var height = 600; 
			var width =  700; 
			
			genericDialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			genericDialog.show(url);
		}
		
		//快速拷贝属性
		$scope.addAttrFromOtherEntity=function(){
			//modelId不传递，则定位到上级模块选择 
			var url = "SelectionAttrMain.jsp?packageId=" + packageId + "&modelId="+"&actionType=selMultiAttr";
			var title="实体属性选择";
			var height = 600; 
			var width =  700; 
			copyAttrDialog = cui.dialog({
				id : "copyAttrDialog",
				title : title,
				src : url,
				width : width,
				height : height
			});
			copyAttrDialog.show(url);
		}
		
		//从业务对象导入 ，//打开业务对象Dialog操作页面
		$scope.addAttrFromBizObj = function(){
			var strDomainIds = "";
			dwr.TOPEngine.setAsync(false);
			ReqFunctionSubitemAction.queryDomainListByfuncCode(moduleCode, function(res){
				if(res){
					for(var i = 0; i <res.length ; i++){
						if(i == res.length-1){
							strDomainIds = strDomainIds+res[i].id;
						}else{
							strDomainIds = strDomainIds+res[i].id +",";
						}
					}
				}
			});
			dwr.TOPEngine.setAsync(true);
			if(strDomainIds && strDomainIds.length>0){
				var impBizObjUrl = "<%=request.getContextPath() %>/cap/bm/biz/info/SelectBizObjectMain.jsp?packageId=" + packageId +"&tabLen=1&showValueFlag=false&domainIds="+strDomainIds;
				if(!bizObjDialog){
					bizObjDialog = cui.dialog({
						title : "业务对象属性选择主页",
						src : impBizObjUrl,
						width : 800,
						height : 600
					});
				}else{
					bizObjDialog.reload(impBizObjUrl);
				}
				bizObjDialog.show();
			}else{
				cui.alert("当前应用无关联业务域，无法获取业务对象,请先在应用中添加功能项!");
			}
		}
		
		
		//关联实体属性选择界面
		$scope.otherTypeSelection=function(){
			var url = "SelectionAttrMain.jsp?packageId=" + packageId + "&modelId=" + modelId;
			var title="选择关联实体属性";
			var height = 600; 
			var width =  700; 
			
			otherTypeSelectionDialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			otherTypeSelectionDialog.show(url);
		}
		
		//业务对象数据项选择界面
		$scope.dddBizObjInfoData=function(){
			var url = "${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoDataItemSelect.jsp?packageId=" + packageId + "&modelId=" + modelId;
			var title="业务对象数据项选择";
			var height = 650; 
			var width =  850; 
			
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			dialog.show(url);
		}
		
		//删除业务对象数据库项
		$scope.deleteBizObjInfoData=function (){
			//展示数据的删除序号集合
			var deleteDataItemsIndex =[];
			//后台维护的删除序号集合
			var deleteDataItemIdsIndex =[];
			var selectBizItems = $scope.selectEntityAttributeVO.bizObjInfoDataItems;
			for(var i =0;i<selectBizItems.length;i++){
				if(selectBizItems[i].check){
					deleteDataItemsIndex.push(i);
					for(var k=0;k<$scope.selectEntityAttributeVO.dataItemIds.length;k++){
						if(selectBizItems[i].id===$scope.selectEntityAttributeVO.dataItemIds[k]){
							deleteDataItemIdsIndex.push(k);
						}
					}
				}
			}
			
			//删除展示数据
			for(var j=deleteDataItemsIndex.length-1;j>=0;j--){
				$scope.selectEntityAttributeVO.bizObjInfoDataItems.splice(deleteDataItemsIndex[j],1);
			}
			//删除后台维护的业务对象数据项ID
			for(var l=deleteDataItemIdsIndex.length-1;l>=0;l--){
				$scope.selectEntityAttributeVO.dataItemIds.splice(deleteDataItemIdsIndex[l],1);
			}
			if($scope.selectEntityAttributeVO.bizObjInfoDataItems.length==0){
				$scope.bizObjInfoDataCheckAll = false;
			}
		}
		
		//其他实体选择界面
		$scope.selEntity=function(){
			var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&sourceEntityId="+modelId;
			var title="选择目标实体";
			var height = 600; 
			var width =  400; 
			
			entityDialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			entityDialog.show(url);
		}
	   	
	   	//删除属性
	   	$scope.deleteEntityAttribute=function(){
	   		var deleteArr = [];
	        for(var i=0;i<$scope.root.entityAttributes.length;i++){
		        if($scope.root.entityAttributes[i].check){
		        	deleteArr.push($scope.root.entityAttributes[i]);
		          }
		     }
	   		
 	        var deleteTitle = "";
			for(var k=0;k<deleteArr.length;k++){
				 deleteTitle += deleteArr[k].engName+"<br/>";
			}
			
			if(deleteArr.length>0){
			cui.confirm("确定要删除<br/>"+deleteTitle+"这些属性吗？",{
				onYes:function(){ 
						//删除时一致性校验
					    if(!checkConsistency(deleteArr,entity)){
			            	return ;
			            }

				   		var newArr=[];//需要删除的数据序号
				   		var _dbFieldIdArray = []; //记录删除的属性的dbFieldId
				        for(var i=0;i<$scope.root.entityAttributes.length;i++){
					        if($scope.root.entityAttributes[i].check){
					        	newArr.push(i);
					        	var _queryRangeBy = $scope.root.entityAttributes[i].dbFieldId;
					        	if(_queryRangeBy){
						        	_dbFieldIdArray.push({"queryRangeBy" : _queryRangeBy});
					        	}
					          }
					     }
						  //根据坐标删除数据
				        for(var j=newArr.length-1;j>=0;j--){
				        	$scope.root.entityAttributes.splice(newArr[j],1);
				        }
				      
				        //如果当前选中的行被删除则默认选择第一行
				        var isSelectIsDelete=true;
				        for(var i=0;i<$scope.root.entityAttributes.length;i++){
					        if($scope.root.entityAttributes[i].sortNo==$scope.selectEntityAttributeVO.sortNo){
					            isSelectIsDelete=false;
					            break;
					        }
				        }
				        if(isSelectIsDelete){
							$scope.selectEntityAttributeVO=$scope.root.entityAttributes[0];
				        }
				        
				        //删除自动生成的范围查询字段
				        if(_dbFieldIdArray.length > 0){
				        	cap.array.remove($scope.root.entityAttributes,_dbFieldIdArray,true);
				        }
				        //删除属性之后重置sortNo
				        $scope.resetSortNo();
				        
				        $scope.checkBoxCheck($scope.root.entityAttributes,"entityAttributeCheckAll");	
				        $scope.$digest();
				        cui.message("删除成功.");
					}
				}); 
			}
	   	}
	   	
		/**
		 * 重置属性的sortNo
		 */
	   	$scope.resetSortNo = function(){
	   		//重新维护序号
	        for(var i=0;i<$scope.root.entityAttributes.length;i++){
	        	$scope.root.entityAttributes[i].sortNo = i+1;
	        }
	   	}
	   	
	   	/**
		 * 检测实体属性的变化，弹出属性无变化的提示或属性变化的列表。
		 */
		$scope.syncAttribute=function(){
			createAttributeMsgHM();
			EntityFacade.compareEntity(modelId,function(data){
				removeAttributeMsgHM();
				if (!data.hasChanged){
					cui.alert("没有变化的属性。");
				}else{
					$scope.changedAttributes = data.changedAttributes;
					var url = "SyncAttributes.jsp";
					var height = 400; 
					var width =  680; 
					if(!syncAttributeDialog){
						syncAttributeDialog = cui.dialog({
							id : "syncAttributeDialog",
							title : "实体属性同步数据库",
							src : url,
							width : width,
							height : height,
							onClose: function () {
								$scope.removeCompareEntity(); 
				            }
						});
					}
					syncAttributeDialog.show(url);
				}
			});
		};
		
		/**
		 * 变化的属性同步数据库
		 * 
		 * @param syncAll 是否同步所有变化的属性
		 * @param 需要同步的属性
		 */
		$scope.sync = function(syncAll,changedAttributes){
			dwr.TOPEngine.setAsync(false);
			EntityFacade.syncDatabaseToMeta(syncAll,changedAttributes,function(data) {
				syncDatabaseToMeta(data);//数据同步
				cui.message("同步成功。","success");
            });
			dwr.TOPEngine.setAsync(true);
		};
		
		/**
		 * 移除session中缓存的实体对比结果。
		 */
		$scope.removeCompareEntity = function(){
			dwr.TOPEngine.setAsync(false);
			EntityFacade.removeCompareEntity();
			dwr.TOPEngine.setAsync(true);
		};
		
		//自定义sql查询条件
		$scope.customSqlCondition=function(){
			var url = "${cuiWebRoot}/cap/bm/dev/entity/CustomSqlCondition.jsp?modelId=${param.modelId}&packageId=${param.packageId}";
			window.open(url);
			window.focus();
		}
		
		//保存自定义查询条件
		$scope.saveSqlCondition=function(data){
			entity.customSqlConditionEnable=data.customSqlConditionEnable
			entity.customSqlCondition=data.customSqlCondition;
		}
		
		//属性类型改变事件
		$scope.attributeTypeChangeEvent=function(){
			var attrType = $scope.selectEntityAttributeVO.attributeType.type;
			//属性来源和属性值的控制
			switch(attrType){
				case "java.util.List": $scope.selectEntityAttributeVO.attributeType.source = "collection";break;
				case "java.util.Map": $scope.selectEntityAttributeVO.attributeType.source = "collection";break;
				case "thirdPartyType": $scope.selectEntityAttributeVO.attributeType.source = "thirdPartyType";break;
				case "entity": $scope.selectEntityAttributeVO.attributeType.source = "entity";break;
				case "java.lang.Object": $scope.selectEntityAttributeVO.attributeType.source = "javaObject";break;
				default : $scope.selectEntityAttributeVO.attributeType.source = "primitive";break;
			}
			
			$scope.selectEntityAttributeVO.attributeType.value = "";
			$scope.selectEntityAttributeVO.attributeType.generic = null;
			var defaultValue =$scope.selectEntityAttributeVO.defaultValue;
			//属性长度和精度的控制
			switch(attrType){
				case "int": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				case "String":cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				case "double": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				case "long": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(true);cui("#defaultValue").setValue(null);break;
				case "float": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				case "java.math.BigDecimal": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				case "Integer": cui("#attributeLength").setReadOnly(false);cui("#precision").setReadOnly(false);cui("#defaultValue").setReadOnly(false);cui("#defaultValue").setValue(defaultValue);break;
				default : cui("#attributeLength").setReadOnly(true);cui("#precision").setReadOnly(true);cui("#defaultValue").setReadOnly(true);cui("#defaultValue").setValue(null);break;
			}
			$scope.selectEntityAttributeVO.attributeLength = "";
			$scope.selectEntityAttributeVO.precisionc = "";
			//主键则默认值不可编辑
			var isPrimaryKey=$scope.selectEntityAttributeVO.primaryKey;
	   		if(isPrimaryKey){
	   			cui("#defaultValue").setReadOnly(true);
	   		}
		}
		
		//属性来源改变事件
		$scope.attributeTypeSourceChangeEvent=function(){
			$scope.selectEntityAttributeVO.attributeType.value = "";
			$scope.selectEntityAttributeVO.attributeType.generic = null;
		}
	   	
	   	//查询字段切换，填充查询规则
	   	$scope.queryMatchRuleChange=function(){
	   		if($scope.selectEntityAttributeVO.queryField == "true"){
	   			var attributeTypeType = $scope.selectEntityAttributeVO.attributeType.type;
		   		cui("#queryMatchRule").setDatasource(queryMatchRuleData[attributeTypeType]);
		   		//如果是数据库字段,则默认把规则设置为“=”，并把查询表达式拼出来。
		   		if($scope.selectEntityAttributeVO.dbFieldId){ 
		   			$scope.selectEntityAttributeVO.queryMatchRule = "1";
		   			$scope.selectEntityAttributeVO.queryExpr = "T1." + $scope.selectEntityAttributeVO.dbFieldId + " = #{" + $scope.selectEntityAttributeVO.engName + "}";
		   		}
	   		}else{
	   			$scope.selectEntityAttributeVO.queryMatchRule="";
	   			$scope.selectEntityAttributeVO.queryExpr="";
	   		}
	   	}
	   	
	   	//查询规则改变事件
	   	$scope.queryMatchRuleChangeEvent=function(){
	   		if(!changeFlag){
	   			changeFlag = true;
	   			return;
	   		}
	   		var rule= $scope.selectEntityAttributeVO.queryMatchRule;
	   		var coll = $scope.selectEntityAttributeVO.dbFieldId;//"TOP_USER";
			var attr = $scope.selectEntityAttributeVO.engName;//"topUser";
			dwr.TOPEngine.setAsync(false);
			EntityFacade.genQueryExpression(rule,coll,attr,function(data){
				//如果是查询规则为范围,把表达式拆分成两个范围表达式1和范围表达式2
				if(rule == "11"){ 
					$scope.selectEntityAttributeVO.queryExpr = null;
					//var _regex = new RegExp(".*\\sAND\\s.*", "g");
					var _regex = /(.*)\sAND\s(.*)/;
					var _resultArray = _regex.exec(data);
					if(_resultArray != null){
						$scope.selectEntityAttributeVO.queryRange_1 = _resultArray[1] ? _resultArray[1] : "";
						$scope.selectEntityAttributeVO.queryRange_2 = _resultArray[2] ? _resultArray[2] : "";
					}
				}else{
					$scope.selectEntityAttributeVO.queryExpr =data;
					$scope.selectEntityAttributeVO.queryRange_1 = null;
					$scope.selectEntityAttributeVO.queryRange_2 = null;
				}
			});
			dwr.TOPEngine.setAsync(true);
			
			//处理范围查询的查询字段的生成与删除
			$scope.processRangeAttributes(rule);
	   	}
	   	
	   	
	   	/**
	   	 * 处理范围查询的查询字段的生成与删除
	   	 *
	   	 * @param queryRuleCode 查询规则的code
	   	 */
	   	$scope.processRangeAttributes = function(queryRuleCode){
	   		//若选择的“查询规则”为“范围”，则自动生成2个范围查询的属性
			if(queryRuleCode == "11"){
				//取得生成的属性的engName
				var autoAttrRegex = /.*[#$]{(.+)}.*/;
				var rang_1_result = autoAttrRegex.exec($scope.selectEntityAttributeVO.queryRange_1);
				var rang_2_result = autoAttrRegex.exec($scope.selectEntityAttributeVO.queryRange_2);
				var rang_1_ename = rang_1_result ? rang_1_result[1] : "";
				var rang_2_ename = rang_2_result ? rang_2_result[1] : "";
				$scope.root.entityAttributes.push($scope.createEntityAttribute($.trim(rang_1_ename),"（开始查询）"));
				$scope.root.entityAttributes.push($scope.createEntityAttribute($.trim(rang_2_ename),"（结束查询）"));
			}else{ //若选择的“查询规则”非“范围”，则检测使用该属性生成的范围查询字段是否存在，存在则删除。
				$scope.deleteRangeAttributes();
			}
	   	}
	   	
	   	/**
	   	 * 删除当前选中属性的范围查询的字段    $scope.resetSortNo
	   	 *
	   	 */
	   	$scope.deleteRangeAttributes = function(){
	   		var _queryRangeBy = $scope.selectEntityAttributeVO.dbFieldId;
	   		if(_queryRangeBy){
	   			cap.array.remove($scope.root.entityAttributes,[{"queryRangeBy" : _queryRangeBy}],true);
	   			$scope.resetSortNo();
	   		}
	   	}
	   	
	   	/**
	   	 * 改变自动创建的范围查询属性（字段）VO的属性
	   	 *
	   	 * @param _ename 属性英文名称
	   	 * @param _cname 属性中文名称（追加）
	   	 */
	   	$scope.createEntityAttribute = function(_ename,_cname){
	   		var _obj = _.parseJSON(_.stringifyJSON($scope.selectEntityAttributeVO));
	   		_obj.allowNull = true;
	   		_obj.associateListAttr = false;
	   		_obj.chName += _cname;
	   		_obj.engName = _ename;
	   		_obj.dbFieldId = "";
	   		_obj.description += _cname;
	   		_obj.primaryKey = false;
	   		_obj.queryExpr = null;
	   		_obj.queryRange_1 = null;
	   		_obj.queryRange_2 = null;
	   		_obj.queryField = "false";
	   		_obj.queryMatchRule = "";
	   		_obj.relationId = null;
	   		_obj.sortNo = $scope.root.entityAttributes.length+1;
	   		_obj.dataItemIds = null;
	   		_obj.queryRangeBy = $scope.selectEntityAttributeVO.dbFieldId;
	   		return _obj;
	   	}
	   	
	});
	
	//读取业务对象数据项
	function readBizObjInfoDataItem(dataItemIds){
		if(dataItemIds&&dataItemIds.length>0){
			dwr.TOPEngine.setAsync(false);
			BizObjDataItemAction.queryBizObjDataItemListByIds(dataItemIds,function(result){
				scope.selectEntityAttributeVO.bizObjInfoDataItems = result;
				if(result==null||result==""){
					scope.selectEntityAttributeVO.dataItemIds=[];
				}
	   		});
	 		dwr.TOPEngine.setAsync(true);
		}
	}
	
	//设置编辑页面为只读
	function setEditReadOnly(){
		comtop.UI.scan.setReadonly(true, '#form');
	}
	
	//添加新的关系到属性中
	function addRelationShipToAttribute(){
		//区分新增
		var newRelation = [];
		var updateRelation = [];
		for(var i=0;i<entity.lstRelation.length;i++){
			var relationVO= entity.lstRelation[i];
			//检测关系VO属性值不能为空，才执行下面的操作
			if(checkRelationVO(relationVO)){
				continue;
			}
			var addFlag = true;
			for(var j=0;j<scope.root.entityAttributes.length;j++){
				var attributeVO = scope.root.entityAttributes[j];
				if(relationVO.relationId == attributeVO.relationId){
					addFlag = false;
				}
			}
			if(addFlag){
				newRelation.push(relationVO);	
			}else{
			   updateRelation.push(relationVO);
			}
			
		}
		var relationChangeArr = [];
		//更新
		for(var i=0;i<updateRelation.length;i++){
			var updateRelationVO = updateRelation[i];
			for(var j=0;j<scope.root.entityAttributes.length;j++){
				var updateAttributeVO = scope.root.entityAttributes[j];
				if(updateRelationVO.relationId == updateAttributeVO.relationId){
					//确定当前的关系实体属性是否是从一对一，一对多，多对一。变成多对多
					var sameAttributeSerial = checkChangeToMany(updateRelationVO,updateAttributeVO);
					if(updateRelationVO.multiple!="Many-Many"&&sameAttributeSerial.length>1){
						relationChangeArr = relationChangeArr.concat(sameAttributeSerial);
						newRelation.push(updateRelationVO);
						break;
					}else if(updateRelationVO.multiple=="Many-Many"&&sameAttributeSerial.length==1){//确定当前的关系实体属性是否是从多对多。变成一对一，一对多，多对一
						relationChangeArr = relationChangeArr.concat(sameAttributeSerial);
						newRelation.push(updateRelationVO);
						break;
					}else{//关系的多重性没有改变
						if(updateRelationVO.multiple=="One-One"||updateRelationVO.multiple=="Many-One"){
							 updateAttributeVO.engName="relation"+updateRelationVO.engName.substring(0,1).toUpperCase()+updateRelationVO.engName.substring(1);
							 updateAttributeVO.chName=updateRelationVO.chName;
							 updateAttributeVO.attributeType.type="entity";
							 updateAttributeVO.attributeType.source="entity";
							 updateAttributeVO.attributeType.value=updateRelationVO.targetEntityId;
						}else if(updateRelationVO.multiple=="One-Many"){
							 updateAttributeVO.engName="relation"+updateRelationVO.engName.substring(0,1).toUpperCase()+updateRelationVO.engName.substring(1);
							 updateAttributeVO.chName=updateRelationVO.chName;
							 updateAttributeVO.attributeType.source="collection";
							 updateAttributeVO.attributeType.value="java.util.List<"+updateRelationVO.targetEntityId+">";
							 updateAttributeVO.attributeType.type="java.util.List";
							 updateAttributeVO.attributeType.generic[0].source="entity";
							 updateAttributeVO.attributeType.generic[0].type="entity";
							 updateAttributeVO.attributeType.generic[0].value=updateRelationVO.targetEntityId;
						}else if(updateRelationVO.multiple=="Many-Many"){//原本为多对多的更新，需要更新两个
							if(updateAttributeVO.associateListAttr){//如果为true，则是更新中间属性的
								 updateAttributeVO.engName="relationAssociate"+updateRelationVO.engName.substring(0,1).toUpperCase()+updateRelationVO.engName.substring(1);
								 updateAttributeVO.chName = "中间实体"+updateRelationVO.chName;
								 updateAttributeVO.attributeType.source="collection";
								 updateAttributeVO.attributeType.type="java.util.List";
								 updateAttributeVO.attributeType.value="java.util.List<"+updateRelationVO.associateEntityId+">";
								 updateAttributeVO.attributeType.generic[0].type="entity";
								 updateAttributeVO.attributeType.generic[0].source="entity";
								 updateAttributeVO.attributeType.generic[0].value=updateRelationVO.associateEntityId;
							}else{
								 updateAttributeVO.engName="relation"+updateRelationVO.engName.substring(0,1).toUpperCase()+updateRelationVO.engName.substring(1);
								 updateAttributeVO.chName = updateRelationVO.chName;
								 updateAttributeVO.attributeType.source="collection";
								 updateAttributeVO.attributeType.value="java.util.List<"+updateRelationVO.targetEntityId+">";
								 updateAttributeVO.attributeType.type="java.util.List";
								 updateAttributeVO.attributeType.generic[0].type="entity";
								 updateAttributeVO.attributeType.generic[0].source="entity";
								 updateAttributeVO.attributeType.generic[0].value=updateRelationVO.targetEntityId;
							}
						}
					}	
				}
			}
		}
		
		//如果有关系多重性改变，则先删除，再添加
		if(relationChangeArr.length>0){
			relationChangeArr.sort(function(a,b){return a>b?1:-1});//从小到大排序
			//根据坐标删除数据
	        for(var j=relationChangeArr.length-1;j>=0;j--){
	        	scope.root.entityAttributes.splice(relationChangeArr[j],1);
	        }
		}
		
		//新增
		for(var i=0;i<newRelation.length;i++){
			var newRelationVO = newRelation[i];
			var iSortNo = scope.root.entityAttributes.length+1;
			var newEntityAttribute;
			if(newRelationVO.multiple=="One-One"||newRelationVO.multiple=="Many-One"){
			 newEntityAttribute = {relationId:newRelationVO.relationId,associateListAttr:false,sortNo:iSortNo,engName:"relation"+newRelationVO.engName.substring(0,1).toUpperCase()+newRelationVO.engName.substring(1),chName:newRelationVO.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"entity",value:newRelationVO.targetEntityId,type:"entity",generic:[{source:"",value:"",type:""}]}};
			}else if(newRelationVO.multiple=="One-Many"){
			 newEntityAttribute = {relationId:newRelationVO.relationId,associateListAttr:false,sortNo:iSortNo,engName:"relation"+newRelationVO.engName.substring(0,1).toUpperCase()+newRelationVO.engName.substring(1),chName:newRelationVO.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+newRelationVO.targetEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:newRelationVO.targetEntityId}]}};
			}else if(newRelationVO.multiple=="Many-Many"){
			var newEntityAssociateAttribute = {relationId:newRelationVO.relationId,associateListAttr:true,sortNo:iSortNo,engName:"relationAssociate"+newRelationVO.engName.substring(0,1).toUpperCase()+newRelationVO.engName.substring(1),chName:"中间实体"+newRelationVO.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+newRelationVO.associateEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:newRelationVO.associateEntityId}]}};
			 scope.root.entityAttributes.push(newEntityAssociateAttribute);	
			 newEntityAttribute = {relationId:newRelationVO.relationId,associateListAttr:false,sortNo:iSortNo+1,engName:"relation"+newRelationVO.engName.substring(0,1).toUpperCase()+newRelationVO.engName.substring(1),chName:newRelationVO.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+newRelationVO.targetEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:newRelationVO.targetEntityId}]}};
			}
			scope.root.entityAttributes.push(newEntityAttribute);	
		}
		
		//查找被删除了的关系，在属性中也需要删除
		deleteRelationAttribute();
	}
	
	//确定当前的关系实体属性是否是从一对一，一对多，多对一。变成多对多
	//updateRelationVO关系对象
	//updateAttributeVO 关系属性对象
	//return 返回存在的关系 属性的序号数组
	function checkChangeToMany(updateRelationVO,updateAttributeVO){
		var changeArr=[];
		for(var i=0;i<scope.root.entityAttributes.length;i++){
			var entityRelationAttr = scope.root.entityAttributes[i];
		  if(updateRelationVO.relationId==entityRelationAttr.relationId){
			  changeArr.push(i);
		  }
		}
		return changeArr;
	}
	
	function deleteRelationAttribute(){
		var delRelationArr=[];//需要删除的数据序号
		var entityRelationLst = entity.lstRelation;
		for(var i=0;i<scope.root.entityAttributes.length;i++){
			var delFlag=true;
			var entityAttributeVO = scope.root.entityAttributes[i]; 
			if(entityAttributeVO.relationId!=null&&entityAttributeVO.relationId!=""){
				for(var j=0;j<entityRelationLst.length;j++){
				   if(entityAttributeVO.relationId==entityRelationLst[j].relationId){
					   delFlag = false;
				   }
				}
				if(delFlag){
					delRelationArr.push(i);
				}
			}
		}
		
		//根据坐标删除数据
        for(var j=delRelationArr.length-1;j>=0;j--){
        	scope.root.entityAttributes.splice(delRelationArr[j],1);
        }
      
        //如果当前选中的行被删除则默认选择第一行
        var isSelectIsDelete=true;
        for(var i=0;i<scope.root.entityAttributes.length;i++){
	        if(scope.root.entityAttributes[i].sortNo==scope.selectEntityAttributeVO.sortNo){
	            isSelectIsDelete=false;
	            break;
	        }
        }
        if(isSelectIsDelete){
			scope.selectEntityAttributeVO=scope.root.entityAttributes[0];
			 //重新维护序号
	        for(var i=0;i<scope.root.entityAttributes.length;i++){
	        	scope.root.entityAttributes[i].sortNo = i+1;
	        }
	        scope.checkBoxCheck(scope.root.entityAttributes,"entityAttributeCheckAll");
        }
       
	}
	
	//检测关系VO属性值不能为空
	function checkRelationVO(relationVO){
		if(relationVO.engName==""||relationVO.chName==""||relationVO.sourceField==""||relationVO.targetField==""){
			return true;
		}
		
		if(relationVO.multiple=="Many-Many"){
			if(relationVO.associateSourceField==""||relationVO.associateTargetField==""){
				return true;
			}
		}
		return false;
	}
	
	//回调关闭
	function callbackClose(){
		bizObjDialog.hide();
	}
	//业务对象点击确定后回调
	function callbackConfirm(bizObjInfos){
		if(bizObjInfos){
			var dataArrList = [];
			//将多个业务对象的数据项拼成一个大数组
			for(var k = 0 ; k < bizObjInfos.length ; k++ ){
				if(bizObjInfos[k].dataItems){
					dataArrList = dataArrList.concat(bizObjInfos[k].dataItems); 
				}
			}
			//数据项转换实体属性
			tranferDataItemToAttributes(dataArrList);
		}
		scope.$digest();
		window.top.cui.message("导入成功!","success");
		bizObjDialog.hide();
	}
	//数据项转换实体属性
	function tranferDataItemToAttributes(dataArrList){
		//var iSortNo = 100;
		for (var i = 0; i < dataArrList.length; i++) {
			var continueFlag = false;
			for(var n = 0 ; n< scope.root.entityAttributes.length; n++ ){
				if (dataArrList[i].name == scope.root.entityAttributes[n].chName) {
					continueFlag = true;
					break;
				}
			}
			if (continueFlag) {
				continue;
			}
            //iSortNo += 1;
			var attribute = {};
			attribute.relationId = "";
			//attribute.sortNo = iSortNo;
			attribute.engName = dataArrList[i].code?dataArrList[i].code.replace("-", "_"):"";
			attribute.chName = dataArrList[i].name;
			attribute.primaryKey=false;
			var attributeType = {};
			attributeType.generic = null;
			attributeType.source = "primitive";
			attributeType.type = "String";
			attributeType.value = "";
			attribute.attributeType = attributeType;
			attribute.dbFieldId = "";
			attribute.queryField = "false";
			attribute.allowNull="true";
			attribute.accessLevel="private";
			if(entity.attributes){
				scope.root.entityAttributes.push(attribute);
			}else{
				entity.attributes = [];
				scope.root.entityAttributes.push(attribute);
			}
			if(i == dataArrList.length -1){
				scope.selectEntityAttributeVO=attribute;
			}
        }
		//重置sortNo
        scope.resetSortNo();
	}
	
	
	//根据当前实体ID加载父实体
	function readParentAttibutes(parentEntityId){
		if(scope!=null){
			if(parentEntityId==""||parentEntityId==null){
				scope.parentEntityAttributes = [];
			}else{
				scope.parentEntityAttributes = [];
				dwr.TOPEngine.setAsync(false);
		   		EntityFacade.getAllParentEntity(parentEntityId, function(result){
		   			if(result){
		   				result.forEach(function(item){
		   					if(item.attributes){
		   						item.attributes.forEach(function(_item){
		   							scope.parentEntityAttributes.push(_item);
			   					});
		   					}
		   				});
		   			}
		   		});
		 		dwr.TOPEngine.setAsync(true);
			}
		}
	}
	
	var objAttributeMsgHM;
	//数据库同步生成遮罩层
	function createAttributeMsgHM(){
		if(!objAttributeMsgHM){
			objAttributeMsgHM = cui.handleMask({
		        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在检查变化的属性，预计需要2~3分钟，请耐心等待。</div>'
		    });
		}
		objAttributeMsgHM.show();
	}
	
	//数据库同步生成遮罩层
	function removeAttributeMsgHM(){
		objAttributeMsgHM.hide();
	}
	
	//同步数据库数据
	function syncDatabaseToMeta(data){
		var EntityCompareResult = data[0];
		var lstAttributeCompareResult = EntityCompareResult.attrResults;
		var delArr=[];
		for(var i=0;i<lstAttributeCompareResult.length;i++){
			var AttributeCompareResult = lstAttributeCompareResult[i];
			if(AttributeCompareResult.result=="0"){
				continue;
			}
			if(AttributeCompareResult.result=="-1"){//新增
				AttributeCompareResult.srcAttribute.queryField = AttributeCompareResult.srcAttribute.queryField+"";
				scope.root.entityAttributes.push(AttributeCompareResult.srcAttribute);	
			}else if(AttributeCompareResult.result=="2"){//描述不同，忽略
				var _objSrc = AttributeCompareResult.srcAttribute;
			    for(var k=0;k<scope.root.entityAttributes.length;k++){
			    	if(_objSrc.dbFieldId==scope.root.entityAttributes[k].dbFieldId){
			    		scope.root.entityAttributes[k].description = _objSrc.description; 
			    	}
			    }
			}else if(AttributeCompareResult.result=="-2"){//删除
				var delAttribute = AttributeCompareResult.targetAttribute;
			    var delNum = -1;
			    for(var k=0;k<scope.root.entityAttributes.length;k++){
			    	if(delAttribute.dbFieldId ==scope.root.entityAttributes[k].dbFieldId){
			    		delNum = k;
			    		break;
			    	}
			    }
			    scope.root.entityAttributes.splice(delNum,1);
			}else if(AttributeCompareResult.result=="1"){//更新
				var objSrc = AttributeCompareResult.srcAttribute;
			    for(var j=0;j<scope.root.entityAttributes.length;j++){
			    	if(objSrc.dbFieldId==scope.root.entityAttributes[j].dbFieldId){
			    		scope.root.entityAttributes[j].allowNull = objSrc.allowNull;
			    		scope.root.entityAttributes[j].primaryKey = objSrc.primaryKey;
			    		scope.root.entityAttributes[j].chName = objSrc.chName; 
			    		//scope.root.entityAttributes[j].description = objSrc.chName; 
			    		scope.root.entityAttributes[j].attributeLength = objSrc.attributeLength; 
			    		scope.root.entityAttributes[j].precision = objSrc.precision; 
			    		scope.root.entityAttributes[j].attributeType.type=objSrc.attributeType.type;
			    		scope.root.entityAttributes[j].defaultValue=objSrc.defaultValue==null || objSrc.defaultValue=="null" ? "": objSrc.defaultValue;
			    	}
			    }
			}
		}
		
		//重新维护序号
		for(var i=0;i<scope.root.entityAttributes.length;i++){
        	scope.root.entityAttributes[i].sortNo = i+1;
        }
		scope.$digest();
	}
	
	//查询规则的数组
	var queryMatchRuleData = {
            "int": [
			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"6",queryMatchRuleName:"!="},
               {queryMatchRule:"7",queryMatchRuleName:">"},
               {queryMatchRule:"8",queryMatchRuleName:">="},
               {queryMatchRule:"9",queryMatchRuleName:"<"},
               {queryMatchRule:"10",queryMatchRuleName:"<="},
               {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "String" :[
			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"2",queryMatchRuleName:"全匹配 "},
               {queryMatchRule:"3",queryMatchRuleName:"右匹配"},
               {queryMatchRule:"4",queryMatchRuleName:"左匹配"},
               {queryMatchRule:"5",queryMatchRuleName:"in"}
            ],
            "boolean" :[
   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"是"},
               {queryMatchRule:"2",queryMatchRuleName:"否 "}
            ],
            "double" :[
   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"6",queryMatchRuleName:"!="},
               {queryMatchRule:"7",queryMatchRuleName:">"},
               {queryMatchRule:"8",queryMatchRuleName:">="},
               {queryMatchRule:"9",queryMatchRuleName:"<"},
               {queryMatchRule:"10",queryMatchRuleName:"<="},
               {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "byte" :[
   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"6",queryMatchRuleName:"!="},
               {queryMatchRule:"7",queryMatchRuleName:">"},
               {queryMatchRule:"8",queryMatchRuleName:">="},
               {queryMatchRule:"9",queryMatchRuleName:"<"},
               {queryMatchRule:"10",queryMatchRuleName:"<="},
               {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "short" :[
           			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
                       {queryMatchRule:"1",queryMatchRuleName:"="},
                       {queryMatchRule:"6",queryMatchRuleName:"!="},
                       {queryMatchRule:"7",queryMatchRuleName:">"},
                       {queryMatchRule:"8",queryMatchRuleName:">="},
                       {queryMatchRule:"9",queryMatchRuleName:"<"},
                       {queryMatchRule:"10",queryMatchRuleName:"<="},
                       {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "char" :[
           			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
                       {queryMatchRule:"1",queryMatchRuleName:"="},
                       {queryMatchRule:"6",queryMatchRuleName:"!="},
                       {queryMatchRule:"7",queryMatchRuleName:">"},
                       {queryMatchRule:"8",queryMatchRuleName:">="},
                       {queryMatchRule:"9",queryMatchRuleName:"<"},
                       {queryMatchRule:"10",queryMatchRuleName:"<="},
                       {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "float" :[
         			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
                     {queryMatchRule:"1",queryMatchRuleName:"="},
                     {queryMatchRule:"6",queryMatchRuleName:"!="},
                     {queryMatchRule:"7",queryMatchRuleName:">"},
                     {queryMatchRule:"8",queryMatchRuleName:">="},
                     {queryMatchRule:"9",queryMatchRuleName:"<"},
                     {queryMatchRule:"10",queryMatchRuleName:"<="},
                     {queryMatchRule:"11",queryMatchRuleName:"范围"}
           ],
          "long" :[
       			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
                   {queryMatchRule:"1",queryMatchRuleName:"="},
                   {queryMatchRule:"6",queryMatchRuleName:"!="},
                   {queryMatchRule:"7",queryMatchRuleName:">"},
                   {queryMatchRule:"8",queryMatchRuleName:">="},
                   {queryMatchRule:"9",queryMatchRuleName:"<"},
                   {queryMatchRule:"10",queryMatchRuleName:"<="},
                   {queryMatchRule:"11",queryMatchRuleName:"范围"}
            ],
            "java.sql.Date" :[
   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"7",queryMatchRuleName:">"},
               {queryMatchRule:"8",queryMatchRuleName:">="},
               {queryMatchRule:"9",queryMatchRuleName:"<"},
               {queryMatchRule:"10",queryMatchRuleName:"<="},
               {queryMatchRule:"11",queryMatchRuleName:"范围"}
           ],
           "java.sql.Timestamp" :[
  			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
               {queryMatchRule:"1",queryMatchRuleName:"="},
               {queryMatchRule:"7",queryMatchRuleName:">"},
               {queryMatchRule:"8",queryMatchRuleName:">="},
               {queryMatchRule:"9",queryMatchRuleName:"<"},
               {queryMatchRule:"10",queryMatchRuleName:"<="},
               {queryMatchRule:"11",queryMatchRuleName:"范围"}
           ],
          "java.util.List": [
   			    {queryMatchRule:"0",queryMatchRuleName:"请选择"},
                {queryMatchRule:"5",queryMatchRuleName:"in"},
                {queryMatchRule:"11",queryMatchRuleName:"范围"}
           ]
        };
	
	//初始化查询规则
	if(entity.attributes[0]&&entity.attributes[0].attributeType){
	var initQueryMatchRuleData = queryMatchRuleData[entity.attributes[0].attributeType.type];
	}
	
	//实体选择回调
	function selEntityBack(selectNodeData) {
		scope.selectEntityAttributeVO.attributeType.value = selectNodeData.modelId;
		scope.$digest();
		if(entityDialog){
			entityDialog.hide();
		}
	}
	
	//父实体改变
    function messageHandle(e) {
    	if(scope != null){
	    	if(e.data.type=="parentEntityIdChange"){
	    		var parentEntityId = e.data.data;
	    		readParentAttibutes(parentEntityId);
	    		scope.$digest();
	    	}
    	}
    }
    
    window.addEventListener("message", messageHandle, false);
	
	//实体选择界面清空按钮
	function setDefault(){
		scope.selectEntityAttributeVO.attributeType.value = "";
		scope.$digest();
		if(entityDialog){
			entityDialog.hide();
		}
	}
	
	//业务对象数据选择回调
	function chooseBizObjInfoCallback(dataItems,BizObjInfoId){
		//如果之前全选，点击新增业务对象数据项，则可以直接清除全部标志
		scope.bizObjInfoDataCheckAll = false;
		if(!scope.selectEntityAttributeVO.bizObjInfoDataItems){
			scope.selectEntityAttributeVO.bizObjInfoDataItems = [];
		}
		if(scope.selectEntityAttributeVO.dataItemIds==null){
			scope.selectEntityAttributeVO.dataItemIds = [];
		}
		//先找出之前没有添加的对象，然后新增到当前业务对象信息集合中
		var exitDataItems = scope.selectEntityAttributeVO.bizObjInfoDataItems;
		var addDataItems = [];
		for(var i=0;i<dataItems.length;i++){
			var isAdd = true;
			for(var j=0;j<exitDataItems.length;j++){
				if(exitDataItems[j].id===dataItems[i].id){
					isAdd = false;
				}
			}
			if(isAdd){
				addDataItems.push(dataItems[i]);
			}
		}
		for(var k=0;k<addDataItems.length;k++){
			scope.selectEntityAttributeVO.bizObjInfoDataItems.push(addDataItems[k]);
			scope.selectEntityAttributeVO.dataItemIds.push(addDataItems[k].id);
		}
		 scope.$digest();
	}
	
	//实体选择界面取消按钮
	function closeEntityWindow(){
		if(entityDialog){
			entityDialog.hide();
		}
	}
	
	//泛型设置回调
	function setGeneric(genericString,genericDataList){
		scope.selectEntityAttributeVO.attributeType.value = genericString;
		scope.selectEntityAttributeVO.attributeType.generic = genericDataList;
		scope.$digest();
		if(genericDialog){
			genericDialog.hide();
		}
	}
	
	//关联属性选择回调
	function editCallBackOtherTypeSelect(nodeId, nodeTitle, otherType, attributeType) {
		if(otherType == "AttributeData") {
			scope.selectEntityAttributeVO.attributeType.value = nodeId+"."+nodeTitle;
			scope.$digest();
			if(otherTypeSelectionDialog){
				otherTypeSelectionDialog.hide();
			}
		}
	}
	
	//关联属性取消回调
	function closeAttrWindow(){
		if(otherTypeSelectionDialog){
			otherTypeSelectionDialog.hide();
		}
	}
	
	//快速拷贝确定回调
	//selectNodeId 选中的实体ID
	// selectData  选中的实体属性集合，数组
	function multiAttrSelCallBack(selectNodeId, selectAttrData){
		var iSortNo =0;
		
		var sameArray = new Array();
		for (var j = 0; j < selectAttrData.length; j++) {
			var selectName = selectAttrData[j].engName;
			//去除重名的实体属性
			for (var i = 0; i < scope.root.entityAttributes.length; i++) {
				var curName = scope.root.entityAttributes[i].engName;
				if (selectName && curName && selectName == curName) {
					sameArray.unshift({engName:selectAttrData[j]["engName"]});
				}
			}
		}
		
		var selectAttrData=cap.array.remove(selectAttrData,sameArray,false);
		
		for(var i=0;i<selectAttrData.length;i++){
			iSortNo = scope.root.entityAttributes.length+1;
			//修改sortNo
			selectAttrData[i].sortNo = iSortNo;
			//字段信息置空 
 			selectAttrData[i].primaryKey=false;//是否为主键
 			selectAttrData[i].queryField=false;//是否作为查询字段
 			selectAttrData[i].queryExpr="";//查询表达式
 			
 			selectAttrData[i].queryMatchRule="";//查询语句的匹配规则
 			selectAttrData[i].associateListAttr=false;//查询语句的匹配规则
 			selectAttrData[i].relationId="";//关联关系的Id
 			selectAttrData[i].queryRange_1=null;//范围查询字段1
 			selectAttrData[i].queryRange_2=null;//范围查询字段2
 			selectAttrData[i].queryRangeBy=null;//范围查询字段的归属字段
 			
 			scope.root.entityAttributes.push(selectAttrData[i]);
     	} 

		scope.$digest();
		if(copyAttrDialog){
			copyAttrDialog.hide();
		}
	}
	
	//快速拷贝取消回调
	function closeMultiAttrWindow(){
		if(copyAttrDialog){
			copyAttrDialog.hide();
		}
	}
	
	//选择数据字典的回调函数
	function dictionaryCallBack(data){
		scope.selectEntityAttributeVO.attributeType.value = data.configItemFullCode;
		scope.$digest();
		if(selectDictionaryDialog){
			selectDictionaryDialog.hide();
		}
	}
	
	//选择数据字典清空按钮的回调函数
	function clearDataCallBack(){
		scope.selectEntityAttributeVO.attributeType.value = "";
		scope.$digest();
		if(selectDictionaryDialog){
			selectDictionaryDialog.hide();
		}
	}
	
	//属性名称检测 
	var validateAttrEnName = [
	      {'type':'required','rule':{'m':'属性名称不能为空。'}},
	      {'type':'custom','rule':{'against':checkAttrEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}},
	      {'type':'custom','rule':{'against':checkAttrEnName, 'm':'属性名称已存在。'}}
	    ];
	
	//属性中文名称检测 
	var validateAttrChName = [
	      {'type':'required','rule':{'m':'属性中文名称不能为空。'}}
	    ];
	
	var validateAttrDictionary=[{'type':'required','rule':{'m':'属性关联字典不能为空。'}}];
	
	var validateAttrEnum=[{'type':'required','rule':{'m':'属性关联枚举不能为空。'}}];
	
	//区间开始点检测 
	var checkStartRange = [ 
          {'type':"numeric",'rule':{'notnm':'必须为数字'}},
          {'type':"length",'rule':{max:9,maxm:"长度不能超过9"}},
          {'type':'custom','rule':{'against':checkMinValue, 'm':'最小值必须小于最大值。'}}
	];
	//区间结束点检测 
	var checkEndRange = [
         {'type':"numeric",'rule':{'notnm':'必须为数字'}},
         {'type':"length",'rule':{max:9,maxm:"长度不能超过9"}},
         {'type':'custom','rule':{'against':checkMaxValue, 'm':'最大值必须大于最小值。'}}
	];
	
	var validateAttributeLenth = [{'type':'numeric','rule':{'oi':true,'notim':'必须为整数!'}}];

    //默认值校验
	var validateDefaultValue = [
	/* {'type': "length",'rule': {max: 20, maxm: "长度不能超过20"}}, */ //这种默认值就超出了20长度，TO_DATE('1980-01-01 23:50:55','yyyy-mm-dd hh24:mi:ss')
	{'type':'custom','rule':{'against':defaultValue_checkInteger, 'm':'必须为整数'}},
	{'type':'custom','rule':{'against':defaultValue_checkNumber, 'm':'必须为数字'}}
	];

	function checkMinValue(data) {
  		var iMaxValue = cui("#endRange").getValue();
  		if(!iMaxValue) {
  			return true;
  		}
  		
  		if(parseInt(data) <= parseInt(iMaxValue)){
  			return true;
  		}
  		return false;
  	}
  	
	function checkMaxValue(data) {
		var iMinValue = cui("#startRange").getValue();
  		if(!iMinValue) {
  			return true;
  		}
  		
		if(parseInt(data) >= parseInt(iMinValue)){
  			return true;
  		}
  		return false;
  	}
	
	//检查属性英文名称字符
	function checkAttrEnNameChar(data) {
		var regEx = "^(?![0-9_])[a-zA-Z0-9_]+$";
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	
	//校验属性名称是否存在
	function checkAttrEnName(engName) {
		var ret = true;
		var num = 0;
		if (typeof (engName) == 'undefined') {
			engName = cui("#engName").getValue();
		}
		for ( var i in root.entityAttributes) {
			if (engName == root.entityAttributes[i].engName) {
				num++;
			}
			if (num > 1) {
				ret = false;
				break;
			}
		}
		return ret;
	}
	
	//统一校验函数
	function validateAll() {
		var validate = new cap.Validate();
		var valRule = {
			engName: validateAttrEnName,
			chName : validateAttrChName
		};
		
		var entityAttributesArray = [];
		for(var j =0;j<root.entityAttributes.length;j++){
			entityAttributesArray.push(root.entityAttributes[j]);
		}
		var result = validate.validateAllElement(entityAttributesArray, valRule);
		
		//解决重复的提示，将结果分割成数组，然后对数组进行过滤处理 add by linyuqian 20160829
    	var resultMessages = new Array();
    	resultMessages = result.message.split("<br/>");
    	if(resultMessages.length>2){
    		resultMessages = _.uniq(resultMessages);
    		var resultTemp = {validFlag:result.validFlag,message:''};
    		for(var k = 0 ; k < resultMessages.length-1 ; k++ ){
    			resultTemp.message +=  resultMessages[k] + "<br/>";
    		}
    		result = resultTemp;
    	}
    	
		var resultDictionary = checkDictionaryAndDefaultVal();
		return cap.finalValiResComposite([result,resultDictionary]); 
	}
	
	//默认值校验必须为整数
	function defaultValue_checkInteger(data) {
		var type = cui("#attributeTypeType").getValue();
		if (type == "int" || type == "Integer") {
			//整数校验
			return checkInteger(data);
		}
		return true;
	}

    //默认值校验必须为数字
	function defaultValue_checkNumber(data) {
		var type = cui("#attributeTypeType").getValue();
		if (type == "double" || type == "float" || type == "java.math.BigDecimal") {
			//数字校验
			return checkNumber(data);
		}
		return true;
	}
	
	//检查属性关联数据字典、枚举不能为空和默认值
	function checkDictionaryAndDefaultVal(){
		var result = {validFlag:true,message:''};
		for(var i=0;i<root.entityAttributes.length;i++){
			var entityVO = root.entityAttributes[i];
			if(!entityVO.accessLevel){
				result.validFlag = false;
				result.message+="属性"+entityVO.engName+"访问级别不能为空"+"<br/>";
			}
			if(!entityVO.attributeType || !entityVO.attributeType.type){
				result.validFlag = false;
				result.message+="属性"+entityVO.engName+"属性类型不能为空"+"<br/>";
			}
			if(entityVO.attributeType.source=="dataDictionary" && entityVO.attributeType.value==""){
				result.validFlag = false;
				result.message+="属性"+entityVO.engName+"关联字典不能为空"+"<br/>";
			}else if(entityVO.attributeType.source=="enumType" && entityVO.attributeType.value==""){
				result.validFlag = false;
				result.message+="属性"+entityVO.engName+"关联枚举不能为空"+"<br/>";
			}
			
			//校验默认值
			var type=entityVO.attributeType.type;
			var defaultValue=entityVO.defaultValue;
			if(defaultValue){
				if(type=="int" || type=="Integer"){
					if(!checkInteger(defaultValue)){
						//整数校验
						result.validFlag = false;
						result.message+="属性"+entityVO.engName+"的默认值,必须为整数"+"<br/>";
					}
				}
				
				if(type=="double" || type=="float" || type=="java.math.BigDecimal"){
					if(!checkNumber(defaultValue)){
						//数字校验
			            result.validFlag = false;
			            result.message+="属性"+entityVO.engName+"的默认值,必须为数字"+"<br/>";
			        }
				}
			}
			
		}
		return result;
	}

    //整数校验
	function checkInteger(data){
		var regEx = "^-?\\d+$";
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}

    //数字校验
	function checkNumber(data){
		var regEx = "^[0-9]+.?[0-9]*$";
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	
    //设置数据库字段查询规则是否只读
    function setQueryFieldReadOnly(flag){
    	cui("#queryField").setReadonly(flag);
    	cui("#queryMatchRule").setReadonly(flag);
    	cui("#queryExpr").setReadonly(flag);
    	cui("#queryRange_1").setReadonly(flag);
    	cui("#queryRange_2").setReadonly(flag);
    }
    
    /**
     * 整合实体属性操作的按钮，把不是很常用的按钮整合到按钮下拉菜单中
     */
    var moreAction = function (){
    	var actionArray = [
    	                   {id : "button_up", label : "上移", click : "scope.upAttribute"},
    	                   {id : "button_down", label : "下移", click : "scope.downAttribute"},
    	                   {id : "sync", label : "数据库同步", click : "scope.syncAttribute"},
    	                   {id : "customSqlCondition", label : "自定义查询条件", click : "scope.customSqlCondition"},
    	                   {id : "copyAttr", label : "快速拷贝", click : "scope.addAttrFromOtherEntity"},
    	                   {id : "addFromBizObj", label : "从业务对象导入", click : "scope.addAttrFromBizObj"}
    	                   ];
    	//业务实体，不显示“快速拷贝”，"从业务对象导入"
   		if("biz_entity" == entity.entityType){
   			cap.array.remove(actionArray,[{id : "copyAttr"}]);
//    			cap.array.remove(actionArray,[{id : "addFromBizObj"}]);
   		}
   		//查询实体，不显示“同步数据库”，"从业务对象导入"
   		if("query_entity" == entity.entityType){
   			cap.array.remove(actionArray,[{id : "sync"}]);
//    			cap.array.remove(actionArray,[{id : "addFromBizObj"}]);
   			if('exist_entity_input' == entity.entitySource ){
   				cap.array.remove(actionArray,[{id : "addFromBizObj"}]);
   				cap.array.remove(actionArray,[{id : "customSqlCondition"}]);
   				cap.array.remove(actionArray,[{id : "copyAttr"}]);
   			}
   		}
   		//数据实体不显示“数据库同步、自定义查询条件”
   		if("data_entity" == entity.entityType ){
   			cap.array.remove(actionArray,[{id : "sync"}]);
   			cap.array.remove(actionArray,[{id : "customSqlCondition"}]);
   			if('exist_entity_input' == entity.entitySource ){
   				cap.array.remove(actionArray,[{id : "addFromBizObj"}]);
   				cap.array.remove(actionArray,[{id : "copyAttr"}]);
   			}
   		}
    	return {
			datasource : actionArray,
			on_click : function(obj){
				eval(obj.click)();
			 }
		};
    };
    
    //var dependOnCurrentData =[];
    //var currentDependOnData =[];
    var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?checkType=main&init=true";

    /**
    *检查元数据一致性 是否通过
    *@deleteArr 当前所选对象数组 
    *@entity 数据类型
    */
    function checkConsistency(deleteArr,entity){
    	var checkflag = true;
    	dwr.TOPEngine.setAsync(false);
    	//删除之前先检查元素一致性依赖
    	window.parent.dependOnCurrentData = [];
       	window.parent.currentDependOnData = [];
    	EntityFacade.checkEntityAttributeBeingDependOn(deleteArr,entity,function(redata){
	 		if(redata){
	 			  if (!redata.validateResult) {//有错误
	 				  window.parent.dependOnCurrentData = redata.dependOnCurrent==null?[]:redata.dependOnCurrent;
	 				  window.parent.initOpenConsistencyImage(checkUrl);
	 				  checkflag = false;
	 				  cui.message('当前选择实体属性不能被删除，请检查元数据一致性！');
	 			  }else{
	 				  window.parent.initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
	 			  }
	 		  }else{
	 			  cui.error("元数据一致性效验异常，请联系管理员！"); 
	 		  }
	 	});
    	dwr.TOPEngine.setAsync(true);
    	return checkflag;
    }
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="entityAttibuteCtrl" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;height:100%">
		<table class="cap-table-fullWidth" style="width:100%; height: 100%;">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:350px;padding-right: 5px">
		        <div id="attr_area">
					<ul class="tab"> 	
						<li ng-class="{'attr':'active'}[active]" class="notUnbind" ng-click="showPanel('attr')">实体属性</li>
						<li ng-class="{'parentAttr':'active'}[active]" class="notUnbind" ng-click="showPanel('parentAttr')">父实体属性</li>
					</ul>
					<div class="tab_panel">
					 <div id="tab_attr" ng-show="active=='attr'">
			        	<table class="cap-table-fullWidth" style="width:100%;">
						    <tr>
						       <td class="cap-form-td" style="text-align: left;width：180px;">
						        	<span cui_input  id="attributeFilter" ng-model="attributeFilter" width="160px" emptytext="请输入属性英文/中文名称"></span>
						        </td>
						    	<td class="cap-form-td" style="text-align: right;" nowrap="nowrap" colspan="2">
						            <span cui_button id="add" ng-click="addEntityAttribute()" label="新增" ></span>
						            <span cui_button id="delete" ng-click="deleteEntityAttribute()" label="删除" ></span>
						            <span uitype="button" label="更多" id="moreAction"  menu="moreAction"></span>
						        </td>
						    </tr>
						    <tr>
						    	<td class="cap-form-td" colspan="2">
						    		<div id="attrLst" ng-style="attrLstStyle"> 
						            <table class="custom-grid" style="width: 100%">
						                <thead>
						                    <tr>
						                    	<th style="width:30px">
						                    		<input type="checkbox" name="entityAttributeCheckAll" ng-model="entityAttributeCheckAll" ng-change="allCheckBoxCheck(root.entityAttributes,entityAttributeCheckAll)">
						                        </th>
						                        <th>
					                            	属性名称
						                        </th>
						                        <th>
					                            	中文名称
						                        </th>
						                    </tr>
						                </thead>
				                        <tbody>
				                            <tr ng-repeat="entityAttributeVo in root.entityAttributes track by $index" ng-hide="entityAttributeVo.isFilter"  style="background-color: {{selectEntityAttributeVO==entityAttributeVo? '#99ccff':'#ffffff'}}">
				                            	<td style="text-align: center;">
				                            	<div ng-show="(entityAttributeVo.relationId==null || entityAttributeVo.relationId=='')&&entityAttributeVo.primaryKey==false">
				                                    <input type="checkbox" name="{{'entityAttribute'+($index + 1)}}" ng-model="entityAttributeVo.check" ng-change="checkBoxCheck(root.entityAttributes,'entityAttributeCheckAll')">
				                               </div>
				                                </td>
				                                <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="entityAttributeTdClick(entityAttributeVo,'')">
				                                    {{entityAttributeVo.engName}}
				                                    &nbsp;<img src='images/zhujian.jpg' ng-if="entityAttributeVo.primaryKey==true"/>
				                                </td>
				                                <td style="text-align: center;" class="notUnbind" ng-click="entityAttributeTdClick(entityAttributeVo,'')">
				                                    {{entityAttributeVo.chName}}
				                                </td>
				                            </tr>
				                       </tbody>
						            </table>
						            </div>
						    	</td>
						    </tr>
						</table>
					  </div>
					  <div id="tab_parentAttr" ng-show="active=='parentAttr'" class="tab_property">
						  <table class="cap-table-fullWidth" style="width:100%;">
						  <tr ng-if="parentEntityAttributes && parentEntityAttributes.length ==0">
							  <td class="cap-form-td" colspan="2">
							  <table class="custom-grid" style="width: 369px">
							          <div style="padding:20px; color:#ccc">提示：暂无父实体属性</div>
							  </table>
							  </td>
						  </tr>	
 						<tr ng-if="parentEntityAttributes && parentEntityAttributes.length > 0">
					    	<td class="cap-form-td" colspan="2">
					    	<div id="parentAttrLst" ng-style="parentAttrLst"> 
					            <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<span class="cui-icon" title="" style="font-size:14pt;color:#808080;cursor:pointer;"></span>
					                        </th>
					                        <th>
				                            	属性名称
					                        </th>
					                        <th>
				                            	中文名称
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="pEntityAttributeVo in  parentEntityAttributes track by $index"  style="background-color: {{selectEntityAttributeVO == pEntityAttributeVo ? '#99ccff' : '#ffffff'}}">
			                            	<td style="text-align: center;">
			                                </td>
			                                <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="entityAttributeTdClick(pEntityAttributeVo,'parent')">
			                                    {{pEntityAttributeVo.engName}}
			                                </td>
			                                <td style="text-align: center;" class="notUnbind" ng-click="entityAttributeTdClick(pEntityAttributeVo,'parent')">
			                                    {{pEntityAttributeVo.chName}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					            </div>
					    	</td>
					    </tr>
						  </table>
					  </div>
					</div>
				</div>
		        </td>
		        <td style="text-align: center;border-left:1px solid #ddd;vertical-align:middle">
		        	<span style="opacity: 0.2;font-size:18px" ng-if="!selectEntityAttributeVO.sortNo">请新增属性</span>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectEntityAttributeVO.sortNo">
		        	<table class="cap-table-fullWidth" id="form">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">基本信息</span>
					        </td>
					    </tr>
					    <tr>
					    	<td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
								   <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="属性名称："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input id="engName" ng-model="selectEntityAttributeVO.engName" validate="validateAttrEnName" width="100%"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="中文名称："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							   				<span cui_input id="chName" ng-model="selectEntityAttributeVO.chName" validate="validateAttrChName" width="100%"/>
								        </td>
								    </tr>
								     <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="访问级别："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_pulldown id="accessLevel" ng-model="selectEntityAttributeVO.accessLevel" value_field="id" editable="false" label_field="text" width="100%">
													<a value="private">private</a>
													<a value="">default</a>
													<a value="protected">protected</a>
													<a value="public">public</a>
											 </span>
								        </td>
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="允许为空："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_radiogroup name="allowNull" id="allowNull" ng-model="selectEntityAttributeVO.allowNull" readonly="false">
					                            <input type="radio" value="true" name="allowNull"  />是
					                            <input type="radio" value="false" name="allowNull" />否
					                        </span>
								        </td>
								    </tr>
								    <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="属性类型："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_pulldown id="attributeTypeType" ng-model="selectEntityAttributeVO.attributeType.type" editable="false" ng-change="attributeTypeChangeEvent()" value_field="id" label_field="text" width="100%">
													<a value="int">int</a>
													<a value="String">String</a>
													<a value="entity">entity</a>
													<a value="java.util.List">java.util.List</a>
													<a value="java.util.Map">java.util.Map</a>
													<a value="boolean">boolean</a>
													<a value="java.sql.Date">java.sql.Date</a>
													<a value="java.sql.Timestamp">java.sql.Timestamp</a>
													<a value="java.math.BigDecimal">java.math.BigDecimal</a>
													<a value="java.sql.Blob">java.sql.Blob</a>
													<a value="java.sql.Clob">java.sql.Clob</a>
													<a value="java.lang.Object">java.lang.Object</a>
													<a value="thirdPartyType">第三方类型</a>
													<a value="byte">byte</a>
													<a value="Integer">Integer</a>
													<a value="double">double</a>
													<a value="short">short</a>
													<a value="long">long</a>
													<a value="float">float</a>
													<a value="char">char</a>
											 </span>
								        </td>
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								          <span uitype="Label" value="关联实体：" ng-show="selectEntityAttributeVO.attributeType.type=='entity'" ></span>
								          <span uitype="Label" value="泛型定义：" ng-show="selectEntityAttributeVO.attributeType.type=='java.util.List'||selectEntityAttributeVO.attributeType.type=='java.util.Map'" ></span>
								          <span uitype="Label" value="第三方类型：" ng-show="selectEntityAttributeVO.attributeType.type=='thirdPartyType'" ></span>
								          <span uitype="Label" value="属性来源：" ng-show="selectEntityAttributeVO.attributeType.type=='String'||selectEntityAttributeVO.attributeType.type=='double'||selectEntityAttributeVO.attributeType.type=='char'||selectEntityAttributeVO.attributeType.type=='float'||selectEntityAttributeVO.attributeType.type=='long'||selectEntityAttributeVO.attributeType.type=='short'||selectEntityAttributeVO.attributeType.type=='byte'||selectEntityAttributeVO.attributeType.type=='java.math.BigDecimal'||selectEntityAttributeVO.attributeType.type=='java.sql.Timestamp'||selectEntityAttributeVO.attributeType.type=='java.sql.Date'||selectEntityAttributeVO.attributeType.type=='boolean'||selectEntityAttributeVO.attributeType.type=='Integer'||selectEntityAttributeVO.attributeType.type=='int'" ></span>
								         </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" ng-if="selectEntityAttributeVO.attributeType.type=='entity'" >
								           <span cui_clickinput id="attributeTypeValue1" ng-model="selectEntityAttributeVO.attributeType.value" ng-click="selEntity()" width="100%"></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" ng-if="selectEntityAttributeVO.attributeType.type=='java.util.List'||selectEntityAttributeVO.attributeType.type=='java.util.Map'" >
								           <span cui_clickinput id="attributeTypeValue2" ng-model="selectEntityAttributeVO.attributeType.value" ng-click="setAttributeGeneric()" width="100%"></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" ng-if="selectEntityAttributeVO.attributeType.type=='thirdPartyType'" >
								           <span cui_input id="attributeTypeValue3" ng-model="selectEntityAttributeVO.attributeType.value" validate="" width="100%"/>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" ng-if="selectEntityAttributeVO.attributeType.type=='String'||selectEntityAttributeVO.attributeType.type=='double'||selectEntityAttributeVO.attributeType.type=='char'||selectEntityAttributeVO.attributeType.type=='float'||selectEntityAttributeVO.attributeType.type=='long'||selectEntityAttributeVO.attributeType.type=='short'||selectEntityAttributeVO.attributeType.type=='byte'||selectEntityAttributeVO.attributeType.type=='java.math.BigDecimal'||selectEntityAttributeVO.attributeType.type=='java.sql.Timestamp'||selectEntityAttributeVO.attributeType.type=='java.sql.Date'||selectEntityAttributeVO.attributeType.type=='boolean'||selectEntityAttributeVO.attributeType.type=='Integer'||selectEntityAttributeVO.attributeType.type=='int'" >
								         <span cui_radiogroup name="attributeTypeSource" id="attributeTypeSource" ng-model="selectEntityAttributeVO.attributeType.source" readonly="false" ng-change="attributeTypeSourceChangeEvent()">
					                            <input type="radio" value="dataDictionary" name="attributeTypeSource"  />关联字典
					                            <input type="radio" value="enumType" name="attributeTypeSource" />关联枚举
					                            <input type="radio" value="otherEntityAttibute" name="attributeTypeSource" />关联属性
					                            <input type="radio" value="primitive" name="attributeTypeSource" />不关联
					                        </span>
								        </td>
								     </tr> 
								     <tr ng-show="selectEntityAttributeVO.attributeType.source=='dataDictionary'">
								       <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								          <font color="red">*</font><span uitype="Label" value="关联字典："></span>
								         </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								           <span cui_clickinput id="attributeTypeValue4" ng-model="selectEntityAttributeVO.attributeType.value" ng-click="selectDictionary()" validate="validateAttrDictionary" width="100%"></span>
								         </td>
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
								        </td>
								     </tr>
								     <tr ng-show="selectEntityAttributeVO.attributeType.source=='enumType'">
								     	<td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="关联枚举："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input id="enumAttributeType" ng-model="selectEntityAttributeVO.attributeType.value" validate="validateAttrEnum" width="100%"></span>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
								        </td>
								     </tr>
								      <tr ng-show="selectEntityAttributeVO.attributeType.source=='otherEntityAttibute'">
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								           <span uitype="Label" value="关联属性："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
								         <span cui_clickinput id="attributeTypeValue5" ng-model="selectEntityAttributeVO.attributeType.value" ng-click="otherTypeSelection()" width="100%"></span>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								         </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								         </td>
								     </tr>
								      <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="总长度："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input readonly="false" id="attributeLength" ng-model="selectEntityAttributeVO.attributeLength" validate="validateAttributeLenth" width="100%"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="精度："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							   				<span cui_input readonly="false" id="precision" ng-model="selectEntityAttributeVO.precision" validate="validateAttributeLenth" width="100%"/>
								        </td>
								    </tr>  
								    <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="默认值："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" title="默认值需符合json格式">
								        	<span cui_input readonly="true" id="defaultValue" ng-model="selectEntityAttributeVO.defaultValue" validate="validateDefaultValue" width="100%"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        </td>
								    </tr>  
								    <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="描述："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
			      		                   <span cui_textarea id="description" ng-model="selectEntityAttributeVO.description" width="100%" height="80px" ></span>
								        </td>
								    </tr>
								</table>
					    	</td>
					    </tr>
					  </br>
					    <tr>
					       <td style="text-align: left;">
					         <table class="cap-table-fullWidth">
								<tr>
					              <td class="cap-form-td" style="text-align: left;" colspan="2">
								    <span class="cap-group">业务对象数据项</span>
					             </td>
					              <td class="cap-form-td" style="text-align: right;padding-right:5px" colspan="2">
								   <span cui_button id="btnAdd"  label="新增" ng-click="dddBizObjInfoData()"  ng-hide="hideButtonFlag"></span>
					        	   <span cui_button id="btnDelete"  label="删除" ng-click="deleteBizObjInfoData()" ng-hide="hideButtonFlag"></span>
					              </td>
					              <tr>
					              <td class="cap-td" style="text-align: left;" colspan="4">
					                <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="bizObjInfoDataCheckAll" ng-model="bizObjInfoDataCheckAll" ng-change="allBizCheckBoxCheck(selectEntityAttributeVO.bizObjInfoDataItems,bizObjInfoDataCheckAll)">
					                        </th>
					                         <th  style="width:20%">
				                            	名称
					                        </th>
					                        <th style="width:120px">
				                            	编码
					                        </th>
					                        <th style="width:30%">
				                            	编码引用说明
					                        </th>
					                        <th style="width:30%">
				                            	备注
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                        <tr ng-repeat="bizInfoDataItem in selectEntityAttributeVO.bizObjInfoDataItems track by $index" style="background-color: {{bizInfoDataItem.check == true ? '#99ccff' : '#ffffff'}}">
			                           <td style="text-align: center;">
		                                    <input type="checkbox" name="{{'bizInfoDataItem'+($index + 1)}}" ng-model="bizInfoDataItem.check" ng-click="checkBoxBizCheck(selectEntityAttributeVO.bizObjInfoDataItems,'bizObjInfoDataCheckAll')">
		                               </td>
			                           <td title="{{bizInfoDataItem.name}}" style="text-align:left;text-overflow:ellipsis; /* for IE */-moz-text-overflow: ellipsis; /* for Firefox,mozilla */overflow:hidden; white-space: nowrap;border:1px #ff000 solid;" ng-click="bizInfoItemTdClick(bizInfoDataItem,selectEntityAttributeVO.bizObjInfoDataItems,'bizObjInfoDataCheckAll')">
			                            {{bizInfoDataItem.name}}
			                           </td>
			                           <td title="{{bizInfoDataItem.code}}"  style="text-align: center;" ng-click="bizInfoItemTdClick(bizInfoDataItem,selectEntityAttributeVO.bizObjInfoDataItems,'bizObjInfoDataCheckAll')">
			                            {{bizInfoDataItem.code}}
			                           </td>
			                           <td title="{{bizInfoDataItem.codeNote}}" style="text-align:left;text-overflow:ellipsis; /* for IE */-moz-text-overflow: ellipsis; /* for Firefox,mozilla */overflow:hidden; white-space: nowrap;border:1px #ff000 solid;" ng-click="bizInfoItemTdClick(bizInfoDataItem,selectEntityAttributeVO.bizObjInfoDataItems,'bizObjInfoDataCheckAll')">
			                            {{bizInfoDataItem.codeNote}}
			                           </td>
			                           <td title="{{bizInfoDataItem.remark}}"  style="text-align:left;text-overflow:ellipsis; /* for IE */-moz-text-overflow: ellipsis; /* for Firefox,mozilla */overflow:hidden; white-space: nowrap;border:1px #ff000 solid;" ng-click="bizInfoItemTdClick(bizInfoDataItem,selectEntityAttributeVO.bizObjInfoDataItems,'bizObjInfoDataCheckAll')">
			                            {{bizInfoDataItem.remark}}
			                           </td>
			                        </tr>
			                        <tr ng-if="!selectEntityAttributeVO.dataItemIds || selectEntityAttributeVO.dataItemIds.length == 0 ">
		                            	<td colspan="5" class="grid-empty"> 本列表暂无记录</td>
		                            </tr>
			                        </tbody>
			                        </table>
					              </td>
					              </tr>
					           </tr>
							</table>	
					       </td>
					    </tr>
					    <!--  
					     <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">字段约束</span>
					        </td>
					    </tr>
					     <tr>
					    	<td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
								   <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="约束类型 ："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_pulldown id="constraintType" ng-model="selectEntityAttributeVO.constraintType" value_field="id" label_field="text" width="100%">
													<a value="regular">regular</a>
													<a value="script">script</a>
													<a value="numerical">numerical</a>
											 </span>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span ng-show="selectEntityAttributeVO.constraintType=='regular'||selectEntityAttributeVO.constraintType=='script'" uitype="Label" value="约束内容："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							   				<span ng-show="selectEntityAttributeVO.constraintType=='regular'||selectEntityAttributeVO.constraintType=='script'" cui_input id="content" ng-model="selectEntityAttributeVO.content" validate="" width="100%"/>
								        </td>
								    </tr>
								     <tr ng-show="selectEntityAttributeVO.constraintType=='numerical'">
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="区间开始点："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input id="startRange" ng-model="selectEntityAttributeVO.startRange" validate="checkStartRange" width="100%"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="区间结束点："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							   				<span cui_input id="endRange" ng-model="selectEntityAttributeVO.endRange" validate="checkEndRange" width="100%"/>
								        </td>
								    </tr>
								    <tr ng-show="selectEntityAttributeVO.constraintType!='null'&&selectEntityAttributeVO.constraintType!=null&&selectEntityAttributeVO.constraintType!=''">
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="错误消息：" ></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
			      		                   <span cui_textarea id="errorInfo" ng-model="selectEntityAttributeVO.errorInfo" width="100%" height="80px" ></span>
								        </td>
								    </tr>
								  </table>
							 </td>
						 </tr>
						 -->		    
					     <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">数据库字段</span>
					        </td>
					    </tr>
					    <tr>
					        <td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
								   <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="对应字段："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input readonly="true" id="dbFieldVOEngName" ng-model="selectEntityAttributeVO.dbFieldId" validate="" width="100%"/>
								        </td>
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="查询字段："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
					                        <span cui_radiogroup readonly="false" name="queryField" id="queryField" ng-model="selectEntityAttributeVO.queryField" ng-change="queryMatchRuleChange()">
					                            <input type="radio" value="true" name="queryField"  />是
					                            <input type="radio" value="false" name="queryField" />否
					                        </span>
								        </td>
								    </tr>
								    </tr>
								    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''">
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	查询规则：
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
								          <span cui_pulldown id="queryMatchRule" ng-model="selectEntityAttributeVO.queryMatchRule" datasource="initQueryMatchRuleData" ng-change="queryMatchRuleChangeEvent()"  value_field="queryMatchRule" label_field="queryMatchRuleName" width="100%" >
										  </span>
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        </td>
								    </tr>
								    
								    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''&&selectEntityAttributeVO.queryMatchRule==11">
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	范围表达式1：
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
								          <span cui_input id="queryRange_1" ng-model="selectEntityAttributeVO.queryRange_1"  width="100%"/>
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	范围表达式2：
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
									         <span cui_input id="queryRange_2" ng-model="selectEntityAttributeVO.queryRange_2"  width="100%"/>
								        </td>
								    </tr>
								    
								    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''&&selectEntityAttributeVO.queryMatchRule!=11">
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	查询表达式：
								        </td>
								         <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
			      		                   <span cui_textarea id="queryExpr" ng-model="selectEntityAttributeVO.queryExpr" width="100%" height="80px" ></span>
								        </td>
								    </tr>
								    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''">
					                    <td >
					                    </td>	
				                        <td colspan="3"><span><font style="color: #B5B5B5">&nbsp;表别名必须为<span style="color:red;">T1</span>,多条SQL语句请用“;”加换行进行分隔。</font></span></td>
				                     </tr>
								  </table>
								  </br>
							 </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
	</div>	
</div>
</body>
</html>