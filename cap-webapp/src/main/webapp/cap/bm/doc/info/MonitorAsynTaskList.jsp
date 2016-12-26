<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/eic/cui/themes/default/css/comtop.ui.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/eic/css/eic.css" type="text/css">
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/utils.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.fileDownload.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
		
		
<title>异步任务监控</title>
<style>
	body {
		background-color: #fff;
		margin:0;
	}
</style>
<%
  String subSystem = request.getParameter("subSystem");
  if(subSystem == null || "null".equals(subSystem) || "".equals(subSystem)){
      subSystem = "";
  } else if (!subSystem.startsWith("/")) {
      subSystem = "/" + subSystem;
  }
%>
<script type="text/javascript">
  //var _pt = window.top.cuiEMDialog.wins.taskMonitorDialogId;
  //定义全局map
  var paramsMap = new Map();
  var dataCount = 0;
  //关闭AJAX请求缓存
  $.ajaxSetup ({
	    cache: false
  });

  function getWidth(rate){
		return (document.documentElement.clientWidth || document.body.clientWidth)* rate;
  }

  function getHeight(rate){
  	return (document.documentElement.clientHeight || document.body.clientHeight)* rate;
  }

  var MouseAspects = function(){};
  MouseAspects.prototype={
	    after:function(target,method,advice){
	  	var original = target[method];
	  	target[method] = function(){
	  		//arguments函数参数对象
	  		original.apply(target,arguments);
	  		(advice)();
	  	};
	  	return target;
	    }		
  };

  var trMap = new Map();
  function delMouse(imgId){
  	var trObj = document.getElementById(imgId).parentNode.parentNode;
  	var mAspects = new MouseAspects();
  	mAspects.after(trObj, "onmouseover", function(){
  		 $("#"+imgId).css("visibility","visible");
		});
  	mAspects.after(trObj, "onmouseout", function(){
  		$("#"+imgId).css("visibility","hidden");
		});
  }

  function setLiBgColor(self){
	  if(null == trMap.get(self.id) || typeof(trMap.get(self.id)) == "undefined"){
        $(self).css("background-color","#abedfe");
	  }
  }

  function clearLiBgColor(self){
	  if(null == trMap.get(self.id) || typeof(trMap.get(self.id)) == "undefined"){
        $(self).css("background-color","");
	  }
  }

  function setTrColor(self){
	  var trArr = trMap.values();
	  if(null != trArr){
         for(var i = 0; i < trArr.length; i++){
        	 $(trArr[i]).css("background-color","");
         }
	  }
	  trMap.clear();
	  trMap.put(self.id,self);
	  $(self).css("background-color","#e4e4e4");
  }
</script>
</head>
<body>
        <table border="0" width="100%" height="100%" id="dataTableId">
             <tr>
               <td>
	               <div style="height:220px;overflow-y:auto;">
	                 <table id="taskTableId" class="line-table">
	                             
		            </table>
                </div>
               </td>
             </tr>
             <tr>	
			    <td>
			      <div id="pg"></div>
			    </td>
			  </tr>	
          </table>
          
	<!-- 做form方式提交请求 -->
	<table style="display:none;">
	 <tr>
	   <td>
	      <form method="post" action="<%=request.getContextPath()%><%=subSystem%>/eic.monitorAsynTask" id="bizFormId" name="bizFormName">
	         <input type="hidden" name="userId" value="<%=request.getParameter("userId") == null?"":request.getParameter("userId")%>">
	         <input type="hidden" id="currPageId" name="currPage" value="">
	         <input type="hidden" id="pageSizeId" name="pageSize" value="">
	         <input type="hidden" id="itaskId" name="taskId" value="">
	         <input type="hidden" id="fileNameId" name="fileName" value="">
	         <input type="hidden" id="fileNamePathId" name="filePath" value="">
	         <input type="hidden" id="serverIPId" name="serverIP" value="">
	         <input type="hidden" id="serverPortId" name="serverPort" value="">
	         <input type="hidden" id="methodId" name="actionType" value="">
	         <input type="hidden"  name="isDelete" value="false">
	         <input type="hidden" id="sysNameId" name="subSystem" value="<%=subSystem%>">
	         <input type="hidden" id="errorId" name="errorInfo">
	         <input type="hidden" id="returnUrlId" name="returnUrl">
	         <input type="hidden" id="syncDownLoadId" name="syncDownload" value="false">
	      </form>
	   </td>
	 </tr>
	</table>
	<iframe id="syncDownloadIFrame" name="syncDownloadIFrame"
			style='display: none; width: 0px; height: 0px;' src=""></iframe>
</body>
<script type="text/javascript">
    var requestIntervalTime = "";
    var count = "";
    var pageSize = "";
    var currPage = "";
    var userId = "";
    var filePathMap = new Map();
    //对页面元素进行操作标识 true 进行中 false 无操作
    var redrawFlag = false; 
    var timeId = null;
    $(document).ready(function() {
    	
    	queryTaskInfoData();
    	setPageTagSize();
    	cui('#pg').pagination({
			count: parseInt(count,10),
			pagesize: parseInt(pageSize,10),
			pageno: parseInt(currPage,10),
			pagesize_list: [5,10],
			display_page: 3,
			cls:"pagination_min_4",
			tpls:{'pagination':'pagination_min_4'},
			on_page_change: changePage
		});
		var timeNumber = parseInt("" == requestIntervalTime?5:requestIntervalTime,10);
		//5秒进行一次异步信息获取
		timeId = window.setInterval(asynGetTaskInfo,timeNumber); 
        if(timeNumber > 2){
        	//先初始化一次
    		window.setTimeout(asynGetTaskInfo,2000);
        }
    });

    var delImgId = new Array();
    function queryTaskInfoData(){
    	 var params = {};
         params.method = "ASYNTASKLIST";
         params.userId = "<%=request.getParameter("userId")%>";
         params.pageSize = htmlSpecialChars("<%=request.getParameter("pageSize")%>");
         params.currPage = "<%=request.getParameter("currPage") == null?"1":request.getParameter("currPage")%>";
     	 $.ajax({    
     		type: "post",    
     		url: "<%=request.getContextPath()%><%=subSystem%>/eic.monitorAsynTask",    
     		dataType: "json",
     		data: params,
     		async:false,
     		success: function (data) {
         	   if(data[0] && typeof(data[0].error) != "undefined"){
             	$("#dataTableId").hide();   
                $("#errorId").val(escape(data[0].error));
    			$("#returnUrlId").val(data[0].returnUrl);
    			$("#bizFormId").attr("action","<%=request.getContextPath()%>/eic/view/Error.jsp");
    			document.bizFormName.submit();
                return;
               }    
     		   if(2 == data.length){
     			   requestIntervalTime = data[0].requestIntervalTime;
     			   count = data[0].count;
     			   pageSize = data[0].pageSize;
     			   currPage = data[0].currPage;
     			   userId = data[0].userId;
     			   var html = "";
     			   if(!data[1] || 0 == data[1].length){
     				  html = "<tr>";
     				  html = html + "<td style=\"text-align:center\">本 列 表 暂 无 记 录。</td>";
     				  html = html + "</tr>";
         		   }else{
             		  var obj = null; 
             		  dataCount = data[1].length;
         			  for(var i = 0; i < data[1].length;i++){
         				 obj = data[1][i];
         				 if("2" != obj.taskStatus && "3" != obj.taskStatus){
         					obj.downloadBtnId = obj.taskId+ "_download_btnId";
         					obj.pbId = obj.taskId + "_bpId";
         					obj.delImageId = obj.taskId + "_delId";
         					obj.runtimeId = obj.taskId + "_runtimeId";
         					obj.pimageId = obj.taskId + "_pimgId";
						    paramsMap.put(obj.taskId,obj);
             		     }
         				html = html + getTableHtml(obj);
            		  }
             	   }
     			   $("#taskTableId").html("");
     			   $("#taskTableId").html(html);
     			   for(var j = 0; j < delImgId.length;j++){
     				  delMouse(delImgId[j]);
         		   }
         	   }else{
         		 $("#dataTableId").hide();   
                 $("#errorId").val(escape("请求异常。"));
     			 $("#returnUrlId").val("<%=request.getContextPath()%>/eic/view/MonitorAsynTaskList.jsp?userId="+params.userId);
     			 $("#bizFormId").attr("action","<%=request.getContextPath()%>/eic/view/Error.jsp");
     			 document.bizFormName.submit();
               }
     		},    
     		error: function (XMLHttpRequest, textStatus, errorThrown) {
     			$("#dataTableId").hide();   
                $("#errorId").val(escape("请求异常。"));
    			$("#returnUrlId").val("<%=request.getContextPath()%>/eic/view/MonitorAsynTaskList.jsp?userId="+params.userId);
    			$("#bizFormId").attr("action","<%=request.getContextPath()%>/eic/view/Error.jsp");
    			document.bizFormName.submit();
     		}    
        }); 
    }

    function getTableHtml(taskObj){
      var html = '<tr id="'+taskObj.taskId+'_TrId" onclick="setTrColor(this)" onmouseover="setLiBgColor(this)" onmouseout="clearLiBgColor(this)">';
      html = html + '<td style="padding-left:5px;">';
      if("1" == taskObj.taskType){
    	  html = html + '<img title="导入" src="<%=request.getContextPath()%>/eic/images/import.png">';
      }else{
    	  html = html + '<img title="导出" src="<%=request.getContextPath()%>/eic/images/export.png">';
      }
      html = html + '</td>';

      html = html + '<td title='+taskObj.fileName+'>';
      html = html + taskObj.shortName;
      html = html + '</td>';
      
      if("" != taskObj.errorInfo && null != taskObj.errorInfo && "null" != taskObj.errorInfo){
          if("" != taskObj.filePath && null != taskObj.filePath && "null" != taskObj.filePath){
        	  taskObj.errorInfo = taskObj.errorInfo + "[详情请下载异常文件]";
          }
          html = html + '<td class="left" id="'+taskObj.taskId+'_bpId" title="'+taskObj.errorInfo+'">';
      }else{
    	  html = html + '<td class="left" id="'+taskObj.taskId+'_bpId">';
      }
      if("0" == taskObj.taskStatus){
    	  html = html + '<img id="'+taskObj.taskId+'_pimgId" class="progress"  src="<%=request.getContextPath()%>/eic/images/progress_suspending.gif" title=""/>';
      }else if("1" == taskObj.taskStatus){
    	  html = html + '<img id="'+taskObj.taskId+'_pimgId" class="progress"  src="<%=request.getContextPath()%>/eic/images/progress_handling.gif" title=""/>';
      }else if("2" == taskObj.taskStatus){
          if("1" == taskObj.taskType){
        	   html = html + '<font style="padding-left:22px;"  color="#009933">导入成功</font>';
          }else{
               html = html + '<font style="padding-left:22px;"  color="#009933">导出成功</font>';
          }
      }else{
          if("1" == taskObj.taskType){
        	  html = html + '<font style="padding-left:22px;"  color="red">导入失败</font>';
          }else{
        	  html = html + '<font style="padding-left:22px;"  color="red">导出失败</font>';
          }
      }
      html = html + '</td>';
      
      html = html + '<td class="last">';
      if("0" == taskObj.taskType){
      	if("" != taskObj.filePath && null  != taskObj.filePath && "null"  != taskObj.filePath){
      		 html = html + '<input class="button" onclick="downloadFile(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.fileName+'\',\''+taskObj.serverIp+'\',\''+taskObj.serverPort+'\',\''+taskObj.subSystem+'\')" id="'+taskObj.taskId+'_download_btnId" type="button" value="下载" />';
      	}else{
      		 html = html + '<input class="button" onclick="downloadFile(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.fileName+'\',\''+taskObj.serverIp+'\',\''+taskObj.serverPort+'\',\''+taskObj.subSystem+'\')" id="'+taskObj.taskId+'_download_btnId" style="visibility:hidden;" type="button" value="下载" />';
      	}
      }else if("1" == taskObj.taskType){
      	if("3" == taskObj.taskStatus &&  "" != taskObj.filePath && null  != taskObj.filePath && "null"  != taskObj.filePath){
      		html = html + '<input class="button" onclick="downloadFile(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.fileName+'\',\''+taskObj.serverIp+'\',\''+taskObj.serverPort+'\',\''+taskObj.subSystem+'\')" id="'+taskObj.taskId+'_download_btnId" type="button" value="下载" />';
      	}else{
      		html = html + '<input class="button" onclick="downloadFile(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.fileName+'\',\''+taskObj.serverIp+'\',\''+taskObj.serverPort+'\',\''+taskObj.subSystem+'\')" id="'+taskObj.taskId+'_download_btnId" style="visibility:hidden;" type="button" value="下载" />';
      	}
      }
      html = html + '</td>';

      html = html + '<td class="last">';
      if("2" == taskObj.taskStatus || "3" == taskObj.taskStatus){
    	  html = html + '&nbsp;&nbsp;<img id="'+taskObj.taskId+'_delId" class="cursorimg" style="vertical-align:middle;visibility:hidden;" onclick="delTask(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.subSystem+'\')" src="<%=request.getContextPath()%>/eic/images/del.gif"></img>&nbsp;&nbsp;';
    	  delImgId.push(taskObj.taskId+"_delId");
      }else{
    	  html = html + '&nbsp;&nbsp;<img id="'+taskObj.taskId+'_delId" class="cursorimg" style="vertical-align:middle;visibility:hidden;" onclick="delTask(\''+taskObj.taskId+'\',\''+taskObj.filePath+'\',\''+taskObj.subSystem+'\')" src="<%=request.getContextPath()%>/eic/images/del.gif" ></img>&nbsp;&nbsp;';
      }
      html = html + '</td>';
      html = html + '</tr>';
      return html;
    }

    var errorCount = 0;
    //通过ajax异步获取任务的信息
    function asynGetTaskInfo(){
        //进行动态设置页面元素时不发送请求
        if(true == redrawFlag){ 
            return;
        }
        if(true == paramsMap.isEmpty() || true == loadAll()){
        	window.clearInterval(timeId);  
            return;
        }
        var params = {};
        params.method = "QUERYTASKINFO";
        params.taskIds = paramsMap.keys();
    	$.ajax({    
    		type: "post",    
    		url: "<%=request.getContextPath()%><%=subSystem%>/eic.monitorAsynTask",    
    		dataType: "json",
    		data: params,
    		async:true,
    		success: function (data) {    
    			dynamicSetPageTag(data);
    		},    
    		error: function (XMLHttpRequest, textStatus, errorThrown) {
    			errorCount++;
    			if(errorCount >= 3){
    				window.clearInterval(timeId);
        		}
    		}    
       }); 
    }

    //删除任务
    function delTask(id,filePath,subSystem){
    	if("" == filePath || typeof(paramsMap.get(id)) != "undefined" || null != filePathMap.get(id)){
    		filePath = filePathMap.get(id);
        }
    	cui.confirm("\u786e\u5b9a\u5220\u9664\uff1f",{
			onYes:function(){
    		  asynDelTask(id,filePath,subSystem);
            }
	    });
    }

    function asynDelTask(id,filePath,subSystem){
        var params = {};
        params.method = "DELETETASKINFO";
        params.fileNamePath = filePath;
        params.taskId = id;
        params.pageSize = pageSize;
    	$.ajax({    
    		type: "post",    
    		url: "<%=request.getContextPath()%><%=subSystem%>/eic.monitorAsynTask",
    		data: params,
    		async:true,
    		success: function (data) {
        		var cpage = currPage;
    			dataCount = dataCount - 1;
    			if(dataCount <= 0){
    				cpage = cpage - 1;
    				if(cpage <= 0){
    					cpage = 1;
        			}
        		}
    			changePage(cpage, pageSize);
    		},    
    		error: function (XMLHttpRequest, textStatus, errorThrown) {
    			cui.alert("\u5220\u9664\u4efb\u52a1\u5f02\u5e38");
    		}    
       }); 
    }

    //下载文件
    function downloadFile(id,filePath,fileName,ip,port,subSystem){
    	if("" == filePath || typeof(paramsMap.get(id)) != "undefined" || null != filePathMap.get(id)){
    		filePath = filePathMap.get(id);
        }
		try{
		  asynDownloadFile(filePath,fileName,ip,port,subSystem);
		}catch(e){
			//异步方式js有问题时，进行同步下载
			$("#fileNamePathId").val(encodeURIComponent(filePath));
			$("#fileNameId").val(encodeURIComponent(fileName));
			$("#serverIPId").val(ip);
			$("#serverPortId").val(port);
			$("#methodId").val("fileDownload");
			$("#syncDownLoadId").val("true");
			$("#bizFormId").attr("action","<%=request.getContextPath()%><%=subSystem%>/eic.fileDownload");
			$("#bizFormId").attr('target', 'syncDownloadIFrame');
			$("#bizFormId").submit();
			$('#syncDownloadIFrame').load();
	    }
    }

    function showErrorMsg(errorInfo){
        cui.alert(errorInfo);
    }

    function asynDownloadFile(filePath,fileName,ip,port,subSystem){
    	filePath = encodeURIComponent(encodeURIComponent(filePath));
    	fileName = encodeURIComponent(encodeURIComponent(fileName));
    	$.fileDownload("<%=request.getContextPath()%><%=subSystem%>/eic.fileDownload?actionType=fileDownload&filePath="+filePath+"&fileName="+fileName+"&serverIP="+ip+"&serverPort="+port+"&isDelete=false&sysName="+subSystem)
        .done(function () {})
        .fail(function (e) {
        	cui.alert("\u6587\u4ef6\u4e0b\u8f7d\u5931\u8d25");
         }
        );
    }

    //动态设置页面元素
    function dynamicSetPageTag(data){
      redrawFlag = true;  
      var taskJson = null;
      var taskObject = null;
      try{
	      for(var i = 0; i < data.length;i++){
	    	  taskJson = data[i];
	    	  taskObject = paramsMap.get(taskJson.taskId);
	    	  filePathMap.remove(taskJson.taskId);
	    	  filePathMap.put(taskJson.taskId,taskJson.filePath);
	    	  setImageSrc(taskObject,taskJson);
	    	  //设置运行时长
	    	  //$("#"+taskObject.runtimeId).text(formatSeconds(taskJson.runTheLength));
	    	  //任务已完成
	    	  if("2" == taskJson.taskStatus){
                  //显示删除按钮图标
	    		  //$("#"+taskObject.delImageId).css("visibility","visible");
	    		  delMouse(taskObject.delImageId);
	    		  //如果是导出任务类型，则显示下载按钮
	    		  if("0" == taskObject.taskType){
	    			  $("#"+taskObject.downloadBtnId).css("visibility","visible");
		    	  }
		    	  //移出任务，不再进行异步查询数据更新元素
	    		  paramsMap.remove(taskJson.taskId);
	    		  taskMonitorPrompt();    
		      }else if("3" == taskJson.taskStatus){
			      //导入异常,提供下标按钮
		    	  if("1" == taskObject.taskType && null != taskJson.filePath && "" != taskJson.filePath && "null" != taskJson.filePath){
	    			  $("#"+taskObject.downloadBtnId).css("visibility","visible");
		    	  }
		    	  //异常结束显示删除按钮图标
	    		  //$("#"+taskObject.delImageId).css("visibility","visible");
	    		  delMouse(taskObject.delImageId);
	    		  //移出任务，不再进行异步查询数据更新元素
	    		  paramsMap.remove(taskJson.taskId);
	    		  taskMonitorPrompt();
			  }
	      }
      }catch(e){
      }
      //判断paramsMap任务是否全部完成，是 则停止 定时asynGetTaskInfo()任务
      if(true == paramsMap.isEmpty() || true == loadAll()){
    	  window.clearInterval(timeId);
      }
      redrawFlag = false;
    }

    function loadAll(){
       var returnFlag = true;
       var objs = paramsMap.values();
       if(null != objs){
    	   var taskObject = null;
           for(var i = 0; i < objs.length;i++){
        	   taskObject = objs[i];
        	   if("2" != taskObject.taskStatus && "3" != taskObject.taskStatus){
        		   returnFlag = false;
        		   break;
               }
           }
       }
       return returnFlag;
    }

    function taskMonitorPrompt(){
        try{
	        if(window.top.eic_TaskMonitorPrompt){
	        	window.top.eic_TaskMonitorPrompt();
	        }
        }catch(e){
        }
    }

    //设置图片
    function setImageSrc(taskObject,taskJson){
      if(0 == taskJson.taskStatus){
          $("#"+taskObject.pimageId).attr("src","<%=request.getContextPath()%>/eic/images/progress_suspending.gif");
      }else if(1 == taskJson.taskStatus){
    	  $("#"+taskObject.pimageId).attr("src","<%=request.getContextPath()%>/eic/images/progress_handling.gif");
      }else if(2 == taskJson.taskStatus){
    	  $("#"+taskObject.pbId).empty();
    	  if("1" == taskObject.taskType){
    	    $("#"+taskObject.pbId).html("<font style=\"padding-left:22px;\"  color=\"#009933\">导入成功</font>");
    	  }else{
    		$("#"+taskObject.pbId).html("<font style=\"padding-left:22px;\"  color=\"#009933\">导出成功</font>");
          }
    	  
      }else{
    	  $("#"+taskObject.pbId).empty();
    	  if("1" == taskObject.taskType && null != taskJson.filePath && "" != taskJson.filePath 
    	    	  && null !=  taskJson.filePath && "null" != taskJson.filePath){
    		  if("" != taskJson.errorInfo){
    	         $("#"+taskObject.pbId).attr("title",taskJson.errorInfo+"[详情请下载异常文件]");
    	      }
    	  }else{
    		  if("" != taskJson.errorInfo){
    	         $("#"+taskObject.pbId).attr("title",taskJson.errorInfo);
    	      }
          }
    	  if("1" == taskObject.taskType){
    	    $("#"+taskObject.pbId).html("<font style=\"padding-left:22px;\"  color=\"red\">导入失败</font>");
    	  }else{
    		$("#"+taskObject.pbId).html("<font style=\"padding-left:22px;\"  color=\"red\">导出失败</font>");
          }
      }
    }

	function changePage(pageno, pagesize) {
		$("#currPageId").val(pageno);
		$("#pageSizeId").val(pagesize);
		$("#methodId").val("ASYNTASKLIST");
		$("#bizFormId").attr("action","<%=request.getContextPath()%>/eic/view/MonitorAsynTaskList.jsp");
		document.bizFormName.submit();
	}
	
	//设置页面元素的宽高
    function setPageTagSize(){
    	$('.task-title').css("width",getWidth(0.25));
		$('.progress').css("width",getWidth(0.26));
	}

    //监听窗口变化
	$(window).resize(function(){
		setPageTagSize();
	});
	
	//过滤特殊字符
	function htmlSpecialChars(s) {
	    var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）&mdash;—|{}【】‘；：”“'。，、？]");
	    var rs = "";
	    for (var i = 0; i < s.length; i++) {
	        rs = rs + s.substr(i, 1).replace(pattern, '');
	    }
	    return rs;
	}
</script>
</html>
