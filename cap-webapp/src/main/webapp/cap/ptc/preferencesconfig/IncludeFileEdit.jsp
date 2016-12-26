<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html  ng-app='IncludeFileEdit'>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首选项配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/interface/IncludeFilePreferenceFacade.js"></script>
</head>
<body ng-controller="includeFileEditCtrl" data-ng-init="ready()" >
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span class="cap-label-title" size="12pt">页面引入文件编辑</span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span cui_button  id="saveIncludeFile"  ng-click="saveIncludeFile()" label="保存"></span> 
					 <span cui_button  id="goBack"  ng-click="returnToList()" label="返回"></span>
				</td> 
			</tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:100px">
					<font color="red">*</font>文件名：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_input id="fileName" ng-model="includeFileVO.fileName" width="70%" validate="validateFileName" ></span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:100px">
					<font color="red">*</font>文件路径：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_input id="filePath" ng-model="includeFileVO.filePath" width="70%" validate="validateFilePath" ></span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:100px">
					文件类型：
		        </td>
		        <td class="cap-td" style="text-align: left;" ng-switch="isCreateNewPage">
		        	<span cui_radiogroup id="fileType" ng-model="includeFileVO.fileType" name="fileType" width="100%"  readonly="false">
		        		<input type="radio" value="jsp" name="fileType" />Jsp
		        		<input type="radio" value="js" name="fileType" />Js
		        		<input type="radio" value="css" name="fileType" />CSS
		        	</span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:100px">
					默认引用：
		        </td>
		        <td class="cap-td" style="text-align: left;" ng-switch="isCreateNewPage">
		        	<span cui_radiogroup id="defaultReference" ng-model="includeFileVO.defaultReference" name="defaultReference" width="70%"  readonly="false" >
		        		<input type="radio" value="true" name="defaultReference"  />是
		        		<input type="radio" value="false" name="defaultReference" />否
		        	</span>
		        </td>
	        </tr>
        </table>
	</div>
	<script>
		var filePath = "<%=request.getParameter("filePath")%>";
		var fileName = "<%=request.getParameter("fileName")%>";
		var fileType = "<%=request.getParameter("fileType")%>";
		var defaultReference = "<%=request.getParameter("defaultReference")%>";
		var oldFilePath = "";
		var oldIncludeFileVO={};
	
	   function isDefaultReference(rowData, bindName){
		   var value;
	        if (bindName == "defaultReference") {
	            value = rowData[bindName];
	            if (value==true) {
	                return "是";
	            }else{
	                return "否";
	            }
	        }
	   }
	   
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
		}
		
		var validateFileName = [
		                        {type:'required',rule:{m:'文件名称：不能为空'}}
		                        ];
		var validateFilePath = [
		                        {type:'required',rule:{m:'文件路径：不能为空'}},
		                        {type:'custom',rule:{against:'checkFiletype', m:'文件类型错误，只能为Js，Jsp，Css。'}},
		                        {type:'custom',rule:{against:'isExistNewModelName', m:'文件路径已存在'}}
		                        ];
		
		function  checkFiletype(data){
			var fileName = data;
			if(fileName != null || fileName != ""|| fileName.indexOf(".")>0){
				var fileType = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length);
				var fileTypeUpperCase = fileType.toUpperCase();
				if(fileTypeUpperCase == "JS" || fileTypeUpperCase=="JSP" || fileTypeUpperCase=="CSS"){
					return true;
				}
			}
			return false;
		}
		//angularJS的scope
	    var scope=null;
	    var includeFileVO = {}; 
	    angular.module('IncludeFileEdit', ["cui"]).controller('includeFileEditCtrl', function ($scope, $compile) {
	    	$scope.root={};//作用域根节点
	    	$scope.includeFileVO = includeFileVO;//作用域中IncludeFile对象
	    	
	    	//预加载方法
	    	$scope.ready = function() {
		        	$scope.initData();
					scope = $scope;
			}
	    	
	    	//页面初始化数据
	    	$scope.initData = function() {
	    		if(filePath == null || filePath == "null"){
		    		$scope.includeFileVO.filePath = "";
		    		$scope.includeFileVO.fileName = "";
		    		$scope.includeFileVO.fileType = "jsp";
		    		$scope.includeFileVO.defaultReference="false";
	    		}else{
	    			dwr.TOPEngine.setAsync(false);
					IncludeFilePreferenceFacade.loadByFilePath(filePath,function(data) {
						if(data!=null){
							oldIncludeFileVO = data;
				    		$scope.includeFileVO.filePath = data.filePath;
				    		$scope.includeFileVO.fileName = data.fileName;
				    		$scope.includeFileVO.fileType = data.fileType;
				    		$scope.includeFileVO.defaultReference=data.defaultReference.toString();
						}else{
							$scope.includeFileVO.filePath = "";
				    		$scope.includeFileVO.fileName = "";
				    		$scope.includeFileVO.fileType = "jsp";
				    		$scope.includeFileVO.defaultReference="false";
						}
					});
					dwr.TOPEngine.setAsync(true);
	    		}
	    	}
	    	
	    	$scope.saveIncludeFile=function(){
	    			var rs = validataInfoRequired();
	    			if(!rs.validFlag){
	    				cui.error(rs.message);
	    				return;
	    			}
	    			console.log(oldIncludeFileVO);
	    			console.log("=============");
			    	dwr.TOPEngine.setAsync(false);
					IncludeFilePreferenceFacade.addIncludeFile(includeFileVO,oldIncludeFileVO,function(data) {
						rs = data;
						if(rs){
							oldFilePath =includeFileVO.filePath;
							oldIncludeFileVO.filePath = includeFileVO.filePath;
							oldIncludeFileVO.fileType = includeFileVO.fileType;
							oldIncludeFileVO.defaultReference = includeFileVO.defaultReference;
							oldIncludeFileVO.fileName = includeFileVO.fileName;
							console.log(oldIncludeFileVO);
							cui.message('保存成功！', 'success');
						}else{
							cui.error("保存失败！"); 
						}
					});
					dwr.TOPEngine.setAsync(true);
			 }
			    
	    	$scope.returnToList=function(){
			    	window.open("IncludeFileList.jsp","_self");
			}
	    });
	    
	  //新增或修改的文件是否已存在
	    function isExistNewModelName(filepath){
	    	var result = true;
	    	if(scope.isCreateNewPage){
		    	dwr.TOPEngine.setAsync(false);
		    	IncludeFilePreferenceFacade.isExistNewFile(filepath,function(data){
		    		result = !data;
				});	
				dwr.TOPEngine.setAsync(true);
	    	}
			return result;
	    }
	    
	  //保存按钮调用
	    function validataInfoRequired(){
			var validate = new cap.Validate();
	    	var valRule = {filePath:validateFilePath,fileName:validateFileName};
	    	return validate.validateAllElement(includeFileVO,valRule);
	    }
 	</script>
</body>
</html>