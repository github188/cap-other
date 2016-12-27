
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>分类编辑界面</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
	
</head>
<body>
<div class="top_header_wrap">
   <div class="thw_title" style="font-size:15px;">分类编辑</div>
   <div class="thw_operate">
	  <span uitype="button" label="保存" on_click="savePostClassify"></span>
	  <span uitype="button" label="取消" on_click="closeSelf"></span>
   </div>
</div>
    <table class="form_table">
       <tbody>
       <tr>         
		<td class="td_label" width="30%">
			<span  class="top_required">*</span>分类名称 ：
		</td>
		<td class="td_content">
			<span uitype="input" id="classifyName" name="classifyName" databind="data.classifyName" maxlength="80" width="300" validate="validatePostClassifyName"></span>
		</td>
	 </tr> 
	 <tr>  
	    <td class="td_label" width="30%">
	    	 <span  class="top_required">*</span>分类编码 ：
	    </td>
		<td class="td_content">
			<span uitype="input" id="classifyCode" name="classifyCode" databind="data.classifyCode" maxlength="100" width="300" validate="validatePostClassifyCode"></span>
		</td>
	 </tr>
	
	<tr>
		<td class="td_label">描述</td>
		<td>	
			<span uitype="textarea" name="description" databind="data.description" height="100px" maxlength="100"></span>
		</td>
	</tr>
	
	
	
	</tbody>
  </table>
<script language="javascript">
    var parentId = "<c:out value='${param.parentId}'/>";
    var classifyId = "<c:out value='${param.classifyId}'/>";
	
    var validatePostClassifyName = [
                             		{'type':'required','rule':{'m':'请填写分类名称。'}},
                             		{'type':'custom','rule':{'against':isClassifyNameContainSpecial, 'm':'名称只能为中英文、数字或下划线。'}},
                             		{'type':'custom','rule':{'against':checkNameUnique, 'm':'同一分类下名称已存在。'}}
                             	];
    var validatePostClassifyCode = [
                                  {'type':'required','rule':{'m':'请填写分类编码。'}},
                                  {'type':'custom','rule':{'against':isClassifyCodeContainSpecial, 'm':'编码只能为英文、数字或下划线。'}},
                                  {'type':'custom','rule':{'against':checkUnique, 'm':'编码已存在。'}}
                                ];                        
    
	var data = {};
	//扫描，相当于渲染
	window.onload=function(){
		
		if(classifyId){//编辑
			 dwr.TOPEngine.setAsync(false);
			 PostOtherAction.readPostOtherClassify(classifyId,function(userData){
		    		//填充数据
	    			data = userData;
				});
	    	 dwr.TOPEngine.setAsync(true);	
		}
		comtop.UI.scan();
		
	}
	
	
	
	
	//保存
	function savePostClassify(){
			 //设置验证获取信息
		     var map = window.validater.validAllElement();
		   	 var inValid = map[0];//放置错误信息
		   	 var valid = map[1]; //放置成功信息
	         if (inValid.length > 0) {
	            var str = "";
	            for (var i = 0; i < inValid.length; i++) {
					str +=  inValid[i].message + "<br />";
				}
	         }else {
	        	 //获取表单信息
	         	 var vo = cui(data).databind().getValue();
	        	     vo.parentClassifyId=parentId;
	         	if(classifyId){//编辑
	         		dwr.TOPEngine.setAsync(false);
	         		PostOtherAction.updatePostOtherClassify(vo,function(flag) {
	                	     window.parent.cui.message('修改分类成功。','success');
	                		 window.parent.refrushNode("edit",classifyId,parentId,vo.classifyName);
	                		 window.parent.dialog.hide();
		 				});
	         		dwr.TOPEngine.setAsync(true);
	         	}else{  //新增
	         		
	         		   var addtype="add";
	         		   if(parentId=="-1"){
	         			  addtype="addRoot";
	         		   }
			           dwr.TOPEngine.setAsync(false);
			           PostOtherAction.inserPostOtherClassify(vo,function(classifyId){
				            //刷新树
				           window.parent.refrushNode(addtype,classifyId,parentId,vo.classifyName);
			        	   window.parent.cui.message('新增分类成功。','success');
			        	   window.parent.dialog.hide();
				          
			    		});
			    	   dwr.TOPEngine.setAsync(true);
	                
	            }
	         }
	        
   	}
	
	
	//关闭窗口
	function closeSelf(){
		window.parent.dialog.hide();
	}

	
	//判断名称是否包含特殊字符
	function isClassifyNameContainSpecial(){
		var name = data.classifyName;
		if(name == "")return true;
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_ ]+$");
		return (reg.test(name));
	}

	//判断编码是否包含特殊字符
	function isClassifyCodeContainSpecial(){
		var name = data.classifyCode;
		if(name == "")return true;
		var reg = new RegExp("^[A-Za-z0-9_]+$");
		return (reg.test(name));
	}
	
	//检测同一父分类下是否有重名分类
	function checkNameUnique(){
		var flag = true;
		var classifyName = data.classifyName;
		if(classifyName != ""){
			dwr.TOPEngine.setAsync(false);
			PostOtherAction.isPostClassifyNameUnique(classifyName,parentId,classifyId,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}
	
	
	//检测同一父分类下编码是否唯一
	function checkUnique(){
		var flag = true;
		var codeVal = data.classifyCode;
		if(codeVal != ""){
			dwr.TOPEngine.setAsync(false);
			PostOtherAction.isPostClassifyCodeUnique(codeVal,parentId,classifyId,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}


</script>
</body>
</html>