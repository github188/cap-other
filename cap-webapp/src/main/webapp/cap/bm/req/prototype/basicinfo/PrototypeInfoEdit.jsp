<%
/**********************************************************************
* 页面建模基本信息
* 2016-10-25 zhuhuanhui 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@page import="com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum" %>
<!DOCTYPE html>
<html ng-app='prototypeInfoEdit'>
	<head>
		<meta charset="UTF-8">
		<title>页面建模基本信息</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
		 
		<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
		<top:script src='/cap/dwr/interface/PrototypeFacade.js'></top:script>
		<top:script src='/cap/dwr/interface/PageAttributePreferenceFacade.js'></top:script>
	</head>
	<body style="background-color:#f5f5f5;" ng-controller="prototypeInfoEditCtrl" data-ng-init="ready()">
		<div class="cap-page">
			<div class="cap-area" style="width:100%; height: 100%; text-align: center; overflow-y: auto">
				<table class="cap-table-fullWidth">
				    <tr>
				        <td class="cap-td" style="text-align: left;">
				        	<span id="formTitle" uitype="Label" value="页面基本信息" class="cap-label-title" size="12pt"></span>
				        </td>
				    </tr>
				</table>
				<table class="cap-table-fullWidth">
				    <tr>
				        <td class="cap-td" style="text-align: left;">
				        	<span>
					        	<blockquote class="cap-form-group">
									<span>页面属性</span>
								</blockquote>
							</span>
				        </td>
				    </tr>
				</table>
				<table class="cap-table-fullWidth" style="margin: auto;">
					<tr>
				    	<td class="cap-td" style="text-align: right; width:100px">
							<font color="red">*</font>页面文件名：
				        </td>
				        <td class="cap-td" style="text-align: left;" ng-switch="isCreateNewPage">
				        	<span cui_input ng-switch-when="true" id="modelName" ng-model="page.modelName" width="100%" validate="pageModelNameValRule"></span>
				        	<span cui_input ng-switch-default readonly="true" id="modelName" ng-model="page.modelName" width="100%"></span>
				        </td>
				        <td class="cap-td" style="text-align: right;width:100px">
				        	<font color="red">*</font>页面标题：
				        </td>
				        <td class="cap-td" style="text-align: left;">
				        	<span cui_input id="cname" ng-model="page.cname" width="100%" validate="pageCnameValRule"></span>
				        </td>
				    </tr>
				    <tr>
				        <td class="cap-td" style="text-align: right;width:100px">
				        	<font color="red">*</font>页面编码：
				        </td>
				        <td class="cap-td" style="text-align: left;">
				        	<span cui_pulldown id="charEncode" ng-model="page.charEncode" width="100%" value_field="id" label_field="text">
								<a value="UTF-8">UTF-8</a>
								<a value="GBK">GBK</a>
							</span>
				        </td>
				        <td class="cap-td" style="text-align: right;width:100px">
				        	<font color="red">*</font>最小分辨率：
				        </td>
				        <td class="cap-td" style="text-align: left;">
				        	<span cui_pulldown id="minWidth" ng-model="page.minWidth" width="100%" must_exist="false" value_field="id" label_field="text" validate="[{'type':'format', 'rule':{'pattern': '^([0-9]*|100%|1024px|1280px)$', 'm':'自定义宽度必须为数字，系统默认以像素(px)为单位'}}]">
								<a value="100%">自适应</a>
								<a value="1024px">1024px</a>
								<a value="1280px">1280px</a>
							</span>
				        </td>
				    </tr>
				    <tr>
				        <td class="cap-td" style="text-align: right;width:100px">
				         	<span ng-if="page.minWidth=='100%'"><font color="red">*</font>最小宽度：</span>
				        </td>
				        <td class="cap-td" style="text-align: left;" colspan="3">
				        	<span  ng-if="page.minWidth=='100%'" cui_pulldown id="pageMinWidth" ng-model="page.pageMinWidth" width="100%" must_exist="false" value_field="id" label_field="text" validate="[{'type':'format', 'rule':{'pattern': '^([0-9]*|100%|600px|800px|1024px)$', 'm':'自定义宽度必须为数字，系统默认以像素(px)为单位'}}]">
								<a value="100%">自适应</a>
								<a value="600px">600px</a>
								<a value="800px">800px</a>
								<a value="1024px">1024px</a>
							</span>
				        </td>
				    </tr>
				    <tr>
				    	<td  class="cap-td" style="text-align: right;width:100px">
							引入文件：
				        </td>
				        <td class="cap-td" style="text-align: left;" colspan="3">
				        	<table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="includeFileCheckAll" ng-model="includeFileCheckAll" ng-change="allCheckBoxCheck(page.includeFileList,includeFileCheckAll)">
				                        </th>
				                        <th class="notUnbind" ng-click="showOrHidenIncludeFiles(displayFlag)" style="cursor:pointer;">
			                            	文件路径(<a>点击{{displayFlag?'隐藏':'展开'}}默认引入文件</a>)
				                        </th>
				                        <th style="width:100px">
			                            	文件类型
				                        </th>
				                        <th style="width:150px">
			                            	<span class="cui-icon" title="添加引入文件" style="font-size:12pt;color:#545454;cursor:pointer;padding-right:10px" ng-click="insertIncludeFileFile()">&#xf067;</span>
			                            	<span class="cui-icon" title="删除引入文件" style="font-size:14pt;color:rgb(255, 68, 0);cursor:pointer;padding-right:10px" ng-click="batchDeleteIncludeFile()">&#xf00d;</span>
				                        </th>
				                    </tr>
				                </thead>
			                       <tbody>
			                           <tr ng-repeat="includeFileVo in page.includeFileList track by $index" style="background-color: {{includeFileVo.check? '#99ccff':'#ffffff'}}" ng-hide="displayFlag==false && includeFileVo.defaultReference" >
			                           	<td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                                   <input type="checkbox" name="{{'includeFileVo'+($index + 1)}}" ng-model="includeFileVo.check" ng-change="checkBoxCheck(page.includeFileList,'includeFileCheckAll')">
			                               </td>
			                               <td style="text-align:left;" ng-if="!includeFileVo.defaultReference">
			                                   <span cui_input id="{{'filePath'+($index + 1)}}" ng-model="includeFileVo.filePath" width="100%" validate="includeFilePathValRule"></span>
			                               </td>
			                               <td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                               	<span cui_pulldown id="{{'fileType'+($index + 1)}}" ng-model="includeFileVo.fileType" value_field="id" label_field="text" width="100%">
												<a value="js">js</a>
												<a value="css">css</a>
											</span>
			                               </td>
			                               <td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                               	<span class="cui-icon" title="删除引入文件" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="deleteIncludeFile($index)">&#xf00d;</span>
			                               </td>
			                               
			                               <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                               </td>
			                               <td style="text-align:left;" ng-if="includeFileVo.defaultReference">
			                               	{{includeFileVo.filePath}}
			                               </td>
			                               <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                               	{{includeFileVo.fileType}}
			                               </td>
			                               <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                               </td>
			                           </tr>
			                      </tbody>
				            </table>
				        </td>
				    </tr>
				</table>
				<table class="cap-table-fullWidth">
				    <tr>
				        <td class="cap-td" style="text-align: left;">
				        	<hr/>
				        	<span>
					        	<blockquote class="cap-form-group">
									<span>描述</span>
								</blockquote>
							</span>
							<hr/>
				        </td>
				    </tr>
				</table>
				<table class="cap-table-fullWidth">
				    <tr>
				        <td class="cap-td" style="text-align: left;width:100%">
				        	<span cui_textarea id="description" ng-model="page.description" width="100%" height="50px"  validate="pageDesValRule"  maxlength="500"></span>
				        </td>
				    </tr>
				</table>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		var namespaces = "<%=request.getParameter("namespaces")%>";
		var pageSession = new cap.PageStorage(namespaces);
		var page = pageSession.get("page");
	    var scope=null;
		angular.module('prototypeInfoEdit', [ "cui"]).controller('prototypeInfoEditCtrl', function ($scope) {
			$scope.page=page;
			$scope.isCreateNewPage = (!page.modelId || !page.modelName) ? true : false;
			//是否显示引入文件列表
			$scope.displayFlag=true;
			$scope.ready=function(){
				$(".cap-page").css("height", $(window).height()-20);
				$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
			       jQuery(".cap-page").css("height", $(window).height()-20);
			    });
		    	comtop.UI.scan();
		    	scope = $scope;
		    }
	    	
			$scope.includeFileCheckAll=false;
			
			//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheck=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck && !ar[i].defaultReference){
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
		    			if(ar[i].check){
		    				checkCount++;
			    		}
		    			
		    			if(!ar[i].defaultReference){
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
	    	
	    	$scope.batchDeleteIncludeFile=function(){
	    		var newArr=[];
	    		for(var i=0;i<$scope.page.includeFileList.length;i++){
	    			if(!$scope.page.includeFileList[i].check){
	    				newArr.push($scope.page.includeFileList[i]);
	    			}
	    		}
	    		$scope.page.includeFileList=newArr;
	    	}
	    	
	    	$scope.deleteIncludeFile=function(index){
	    		$scope.page.includeFileList.splice(index,1); 
	    	}
	    	
	    	//显示和隐藏引入文件的列表
	    	$scope.showOrHidenIncludeFiles=function(flag){
	    		$scope.displayFlag = typeof flag == 'undefined' || flag ? false : true;
	    	}
	    	
	    	//导入引入文件
	    	$scope.importIncludeFileFile=function(){
	    		var fileJsp = "${pageScope.cuiWebRoot}/cap/bm/dev/page/preference/IncludeFilePreference.jsp";
	    		var params = "?fileType="+""
	    		var top=(window.screen.availHeight-600)/2;
	    		var left=(window.screen.availWidth-800)/2;
	    		window.open (fileJsp+params,'importIncludeFileFileWin','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	    	}
	    	
	    	$scope.insertIncludeFileFile=function(){
	    		$scope.page.includeFileList.push({fileName:'',filePath:'',fileType:'js'});
	    	}
	    	
	    	$scope.batchDeleteIncludeFile=function(){
	    		var newArr=[];
	    		for(var i=0;i<$scope.page.includeFileList.length;i++){
	    			if(!$scope.page.includeFileList[i].check){
	    				newArr.push($scope.page.includeFileList[i]);
	    			}
	    		}
	    		$scope.page.includeFileList=newArr;
	    	}
	    	
	    	$scope.deleteIncludeFile=function(index){
	    		page.includeFileList.splice(index,1); 
	    	}
	    	
	    	$scope.insertAttribute=function(){
	    		$scope.page.pageAttributeVOList.push({attributeName:'',attributeType:'String',attributeValue:'',attributeDescription:'',defaultReference:false,userDefined:true});
	    	}
	    	
	    	$scope.deletePageAttribute=function(){
	    		var iSize= $scope.page.pageAttributeVOList.length;
	    		for(var i=iSize-1;i>=0;i--){
	    			if($scope.page.pageAttributeVOList[i].check){
	    				$scope.page.pageAttributeVOList.splice(i,1);
	    			}
	    		}
	    	}
	    	
	    });
		
		function pagePrametersData(){
	    	var parametersArray = [];
	    	dwr.TOPEngine.setAsync(false);
			PageAttributePreferenceFacade.queryOptionalParameters(function(data) {
				for(var i = 0, len=data.length;i < len; i++){
					parametersArray.push({id:data[i].attributeName,label:data[i].attributeName,
						attributeName:data[i].attributeName,
						attributeType:data[i].attributeType,
						attributeValue:data[i].attributeValue,
						defaultReference:data[i].defaultReference,
						userDefined:data[i].userDefined,
						attributeDescription:data[i].attributeDescription,
						attributeSelectValues:data[i].attributeSelectValues
					});
				}
			});
			dwr.TOPEngine.setAsync(true);
			return parametersArray;
		};
		
		/**
		 * 点击选择参数图标的下拉选项，增加一条页面参数
		 * @param obj 新增页面对象参数
		 */
		function insertReferenceAttribute(obj){
			scope.page.pageAttributeVOList.push({
				attributeName:obj.attributeName,
				attributeType:obj.attributeType,
				attributeValue:obj.attributeValue,
				attributeDescription:obj.attributeDescription,
				defaultReference:obj.defaultReference,
				userDefined:obj.userDefined,
				attributeSelectValues:obj.attributeSelectValues
			});
			cap.digestValue(scope);
		}
		
		//验证规则
	    var pageModelNameValRule = [{type:'required',rule:{m:'页面属性->页面文件名不能为空'}},{type:'format', rule:{pattern:'\^[A-Z]\\w+\$', m:'页面属性->页面文件名只能输入由字母、数字或者下划线组成的字符串,且首字符必须为大写字母'}},{type:'custom',rule:{against:'isExistNewModelName', m:'页面属性->页面文件名称已存在'}}];
	    var pageCnameValRule = [{type:'required',rule:{m:'页面属性->页面标题不能为空'}}];
	    var includeFilePathValRule = [{type:'required',rule:{m:'文件路径不能为空'}},{type:'format', rule:{pattern:'\^common\/', m:'只能引用common目录下的文件，其他目录下的文件视为无效'}},{type:'format', rule:{pattern:'(\.js)\$|(\.css)\$', m:'文件格式错误'}},{type:'custom',rule:{against:'validateIncludeFilePath', m:'文件路径不能重复'}}];
	    var pageDesValRule = [{'type':'length', 'rule':{"max":500,"maxm":"页面描述长度不能大于500个字符"}}];
	    
	  	//新增或修改的页面文件名是否已存在
	    function isExistNewModelName(modelName){
	    	var result = true;
	    	if(scope.isCreateNewPage){
		    	dwr.TOPEngine.setAsync(false);
		    	PrototypeFacade.isExistNewModelName(modelName, function(data){
		    		result = !data;
				});	
				dwr.TOPEngine.setAsync(true);
	    	}
			return result;
	    }
	    
	    //参数路径不能重复校验
	    function validateIncludeFilePath(filePath){
	    	return isExistValidate(page.includeFileList, 'filePath', filePath);
	    }
	  	
	    //是否已存在
	    function isExistValidate(objList, key, value){
	    	var ret = true;
	    	//num=1表示当前值
	    	var num = 0;
	    	for(var i in objList){
	    		if(objList[i][key]==value){
	    			num++;
	    		}
	    		if(num > 1){
	    			ret=false;
	        		break;
	        	}
	    	}
	    	return ret;
	    }
	    
	    //统一校验函数
		function validateAll(){
	    	var validate = new cap.Validate();
	    	var result = validate.validateAllElement(page, {modelName: pageModelNameValRule, cname: pageCnameValRule, description: pageDesValRule});
	    	var validateResult = validate.validateAllElement(page.includeFileList, {filePath: includeFilePathValRule}, "&diams;引入文件->第【{value}】行：");
	    	result.validFlag=result.validFlag && validateResult.validFlag;
			if(!validateResult.validFlag){
				result.message+=validateResult.message+"<br/>";
			}
			return result;
		}
	    
	</script>
</html>