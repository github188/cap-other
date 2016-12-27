<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>日志下载列表</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/LogFileDownloadAction.js"></script>
  	 <style type="text/css">
	html{width:100%;} 

	body{
	    font: 12px/1.5 Arial, "宋体", Helvetica, sans-serif;
	    color: #000;
	    background:#fff;
	}
	.showHelpContent{
	  display: none;
	  margin: 0 auto;
	}

._1{background:url(${pageScope.cuiWebRoot}/top/sys/images/logHelpStep.png) no-repeat 0px -1126px;height:563px;padding-left:560px;}
._2{display:none ;background:url(${pageScope.cuiWebRoot}/top/sys/images/logHelpStep.png) no-repeat 0px -1689px;height:563px;padding-left:560px;}
._3{display:none ;background:url(${pageScope.cuiWebRoot}/top/sys/images/logHelpStep.png) no-repeat 0px 0px;height:563px;padding-left:560px;}
._4{display:none ;background:url(${pageScope.cuiWebRoot}/top/sys/images/logHelpStep.png) no-repeat 0px -563px;height:563px;padding-left:560px;}


	 .down{
	   float: left;
	}
	 .down >a{
	  font-size: 12px;
      font-weight: bold;
      color: blue;
	}
	
	.down   a:HOVER {
	  color: forestgreen;
     }
	
	.setp{
	  padding-left: 250px;
	  padding-top: 5px;
	  margin: 0 auto;
	}
	
	.tipSpanDiv{
        margin-bottom:5px;
        margin-top: 5px;
	}
	</style>
</head>

<body>
<div uitype="borderlayout"  id="le" is_root="true" >
 <div class="tipSpanDiv">
	 <span id="tipSpan"  ><font color="red">&nbsp;注：</font>IE浏览器下，下载远程日志需开启允许跨域访问权限，点击&nbsp;<a id='showHelp'    onclick='showHelp()' style='cursor: pointer;'>
	 <img src='${pageScope.cuiWebRoot}/top/sys/images/help.png' /></a>&nbsp;查看如何设置
	 </span>
 </div>

<div id="grid_wrap">
     <table uitype="Grid" id="logFileListGrid"    selectrows="no"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  >
		 <th  bindName="1"  renderStyle="text-align: center">序号</th>
		<th bindName="systemCode" sort="false" style="width:30%">系统编码</th>
		<th bindName="systemName" sort="false" style="width:30%">系统名称</th>
		<th bindName="ipAddress" sort="false"  style="width:20%" renderStyle="text-align: center">IP地址</th>
		<th bindName="port" sort="false"  style="width:20%" renderStyle="text-align: center">端口</th>
		<th bindName="logFilePath" sort="false" style="width:50%;"  >文件路径</th>
		<th sort="false"  bindName="download"  style="width:20%" renderStyle="text-align: center" render="setIcon" >下载</th>
	</table>
 </div>
 
  <div  id="showHelpContent" class="showHelpContent">
       <div id="_1"  class="_1"></div>
       <div id="_2"  class="_2"></div>
       <div id="_3"  class="_3"></div>
       <div id="_4"  class="_4"></div>
       <div  class="setp">
	        <div  id="down"  class="down"><a  onclick="nextDownStep()">下一步</a></div>
	         <div  id="back"  class="down"  style="display: none;"><a  onclick="nextDownStep()">重新浏览</a></div>
        </div>
    </div>
</div>

<script language="javascript">

      var fileNoExistFlag = "<c:out value='${param.fileNoExistFlag}'/>";//接收文件不存在的参数
      var fileMaxSizeFlag = "<c:out value='${param.fileMaxSizeFlag}'/>";//接收文件下载限制的参数
      
      
		window.onload = function(){
		    	comtop.UI.scan();
		    	if(fileNoExistFlag){ //文件不存在的异常 提示
		    		 cui.warn("读取文件失败，请检查文件路径是否正确！");
		    	}
		    	if(fileMaxSizeFlag){ //文件大小控制
		    		 cui.warn("文件过大，超过最大"+fileMaxSizeFlag+"M的下载限制！");
		    	}
		    	
		    	$('#grid_wrap').height(function(){
					return (document.documentElement.clientHeight || document.body.clientHeight) - 45;		
			});  
		}
		
		
		//渲染列表数据
		function initData(grid,query){
			
			    dwr.TOPEngine.setAsync(false);
			    LogFileDownloadAction.queryLogFileDownloadList(function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
	        	});
			    dwr.TOPEngine.setAsync(true);
			
	  	}
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-10;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
		}
		
		
		function setIcon(rowdata){
			   return  "<a target='a_blank'  onclick='downLoadFile(\""+rowdata["ipAddress"]+"\",\""+rowdata["port"]+"\",\""+rowdata["systemCode"]+"\");' title='下载文件'  style='cursor: pointer' ><img id='img_"+rowdata["systemCode"]+"' src='${pageScope.cuiWebRoot}/top/sys/images/download.png'  height='28px' width='28px'/></a>";    		
		}
		
		function downLoadFile(ipAddress,port,systemCode){
	
			var url = "http://"+ipAddress+":"+port+"${pageScope.cuiWebRoot}/top/sys/tools/downloadLog/fileDownLoadServlet.ac?systemCode="+systemCode;
			//IE下设置请求的js是否允许跨域访问的权限，true为允许
			jQuery.support.cors=true;
			//修改图片
			$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/loading.gif' ); 
			//测试连接是否正常
			 $.ajax({
			        type: "GET",
			        cache: false,
			        url: url,
			        data:{"Flag":"testPing"},
			        success: function() {
			        	$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/download.png' ); 
			        	  //下载文件
			        	  	url=url+"&Flag=downLoadFile";
			        	    window.location.href=url;	
			        },
			        error: function() {
			        	$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/download.png' ); 
			        	//如果是IE浏览器，提示是否已设置跨域访问权限
			        	if(!+[1,]){ 
			        		 cui.warn("IE浏览器需设置允许跨域访问，如已设置，请检查IP和端口是否正确！");
			        		}
			        	else{
			        	   cui.warn("网络连接失败，请检查IP和端口是否正确！");
			        	}
			        }
			    });
		}
        
		
 
		function showHelp(){
			 cui("#showHelpContent").dialog({
		            title : "IE开启跨域访问设置",
		            modal: false,
		            width:560,
		            height:600
		        }).show();
		}
		
		var num=1;
		function nextDownStep(){
			$("#_"+num).hide();
	       if(num==3){
	    		$("#back").show();
				$("#down").hide();
			}
			if(num==4){
			     num=0;
			     $("#back").hide();
				 $("#down").show();
		     }
			num++;
			$("#_"+num).show();
		}
		
	
		


</script>
</body>
</html>