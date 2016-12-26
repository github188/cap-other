<%
/**********************************************************************
* 工作流附件管理jsp
* 2016-4-8 许畅 新建
**********************************************************************/
%>
<!DOCTYPE html>
<head>
   <top:link href="/top/atm/css/xtheme-default.css"/>
   <top:script src='/top/atm/attachment/js/atm.js'></top:script>
   
   <script type="text/javascript">
     var webRoot= "<%=pageContext.getAttribute("cuiWebRoot") %>";
    
     $(function() {
    	//加载 ATM附件
    	loadAttach();
     });
     
     //ATM附件加载
     function loadAttach(){
    	 
    	//jquery 选择器
         var selectors = "attach";
    	 //如果没有业务单据id则不出现附件
    	 var objId = $(selectors).attr("objId");
    	 if(!objId)
    	    return;
    	 
    	 //浏览器类型
         var agent = navigator.userAgent.toLowerCase();
    	 
    	 for(var j=0;j<$(selectors).length;j++){
    		 
    		 var selector=$(selectors)[j];
    		 //附件元素id
    		 var attachId = $(selector).attr("id");
    		 
    		 if(!attachId)
    			continue;
             
             var attach = new Attachment();
             
             if(attach.notProxy){
        		 $(".col-todo-attach").css("padding-top","0px");
        		 return;
        	 }
             
             //附件属性值数组
             var keys = ["id","jobTypeCode", "objId", "displayMode", "operateMode", "relateMode",
                 "operationRight", "title", "hiddenId", "hrefName", "creatorId", "creatorName", "afterUpload", "afterDelete",
                 "afterEditFileName", "isNeeded", "isShowAttachmentType", "showFields", "showExtendAttribute", "icon", "extendClass",
                 "extendParam", "dwrUrl", "readOnly", "returnURL", "queryClass", "extendClassify","frameHeight",
                 "objectIdList", "attachmentTypeIdList", "attachmentTypeControl"
             ];

             for (var i in keys) {
                 var key = keys[i];
                 var attr = $(selector).attr(key);
                 if (!attr){
                    continue;
                 }
                 
                 //处理chrome下frameHeight的设置
                 if(key=="frameHeight"){
                	 if(agent && agent.indexOf("chrome")>-1 && attachId.indexOf("atm_done_div")>-1){
                		 attr = "60";
                	 }
                	 
                	 if(agent && agent.indexOf("chrome")>-1 && attachId.indexOf("atm_todo_div")>-1){
                		 attr = "50";
                	 }
                 }
                 
                 var func = "attach.set" + replaceFirstUper(key) + "('"+attr+"');";
                 eval(func);
             }
             
             attach.setWebRoot(webRoot);
             //生成附件
		     attach.init(attachId);
    	 }
    	
     }

     //正则将首字符替换为大写
     var replaceFirstUper = function(str) {
        if(str && str.length>0){
            return str.substring(0,1).toUpperCase()+str.substring(1,str.length);
        }
        return str;
     };
   </script>
   
  
</head>


