<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��־�����б�</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/LogFileDownloadAction.js"></script>
  	 <style type="text/css">
	html{width:100%;} 

	body{
	    font: 12px/1.5 Arial, "����", Helvetica, sans-serif;
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
	 <span id="tipSpan"  ><font color="red">&nbsp;ע��</font>IE������£�����Զ����־�迪������������Ȩ�ޣ����&nbsp;<a id='showHelp'    onclick='showHelp()' style='cursor: pointer;'>
	 <img src='${pageScope.cuiWebRoot}/top/sys/images/help.png' /></a>&nbsp;�鿴�������
	 </span>
 </div>

<div id="grid_wrap">
     <table uitype="Grid" id="logFileListGrid"    selectrows="no"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  >
		 <th  bindName="1"  renderStyle="text-align: center">���</th>
		<th bindName="systemCode" sort="false" style="width:30%">ϵͳ����</th>
		<th bindName="systemName" sort="false" style="width:30%">ϵͳ����</th>
		<th bindName="ipAddress" sort="false"  style="width:20%" renderStyle="text-align: center">IP��ַ</th>
		<th bindName="port" sort="false"  style="width:20%" renderStyle="text-align: center">�˿�</th>
		<th bindName="logFilePath" sort="false" style="width:50%;"  >�ļ�·��</th>
		<th sort="false"  bindName="download"  style="width:20%" renderStyle="text-align: center" render="setIcon" >����</th>
	</table>
 </div>
 
  <div  id="showHelpContent" class="showHelpContent">
       <div id="_1"  class="_1"></div>
       <div id="_2"  class="_2"></div>
       <div id="_3"  class="_3"></div>
       <div id="_4"  class="_4"></div>
       <div  class="setp">
	        <div  id="down"  class="down"><a  onclick="nextDownStep()">��һ��</a></div>
	         <div  id="back"  class="down"  style="display: none;"><a  onclick="nextDownStep()">�������</a></div>
        </div>
    </div>
</div>

<script language="javascript">

      var fileNoExistFlag = "<c:out value='${param.fileNoExistFlag}'/>";//�����ļ������ڵĲ���
      var fileMaxSizeFlag = "<c:out value='${param.fileMaxSizeFlag}'/>";//�����ļ��������ƵĲ���
      
      
		window.onload = function(){
		    	comtop.UI.scan();
		    	if(fileNoExistFlag){ //�ļ������ڵ��쳣 ��ʾ
		    		 cui.warn("��ȡ�ļ�ʧ�ܣ������ļ�·���Ƿ���ȷ��");
		    	}
		    	if(fileMaxSizeFlag){ //�ļ���С����
		    		 cui.warn("�ļ����󣬳������"+fileMaxSizeFlag+"M���������ƣ�");
		    	}
		    	
		    	$('#grid_wrap').height(function(){
					return (document.documentElement.clientHeight || document.body.clientHeight) - 45;		
			});  
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
			
			    dwr.TOPEngine.setAsync(false);
			    LogFileDownloadAction.queryLogFileDownloadList(function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
	        	});
			    dwr.TOPEngine.setAsync(true);
			
	  	}
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-10;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
		}
		
		
		function setIcon(rowdata){
			   return  "<a target='a_blank'  onclick='downLoadFile(\""+rowdata["ipAddress"]+"\",\""+rowdata["port"]+"\",\""+rowdata["systemCode"]+"\");' title='�����ļ�'  style='cursor: pointer' ><img id='img_"+rowdata["systemCode"]+"' src='${pageScope.cuiWebRoot}/top/sys/images/download.png'  height='28px' width='28px'/></a>";    		
		}
		
		function downLoadFile(ipAddress,port,systemCode){
	
			var url = "http://"+ipAddress+":"+port+"${pageScope.cuiWebRoot}/top/sys/tools/downloadLog/fileDownLoadServlet.ac?systemCode="+systemCode;
			//IE�����������js�Ƿ����������ʵ�Ȩ�ޣ�trueΪ����
			jQuery.support.cors=true;
			//�޸�ͼƬ
			$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/loading.gif' ); 
			//���������Ƿ�����
			 $.ajax({
			        type: "GET",
			        cache: false,
			        url: url,
			        data:{"Flag":"testPing"},
			        success: function() {
			        	$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/download.png' ); 
			        	  //�����ļ�
			        	  	url=url+"&Flag=downLoadFile";
			        	    window.location.href=url;	
			        },
			        error: function() {
			        	$("#img_"+systemCode).attr('src','${pageScope.cuiWebRoot}/top/sys/images/download.png' ); 
			        	//�����IE���������ʾ�Ƿ������ÿ������Ȩ��
			        	if(!+[1,]){ 
			        		 cui.warn("IE��������������������ʣ��������ã�����IP�Ͷ˿��Ƿ���ȷ��");
			        		}
			        	else{
			        	   cui.warn("��������ʧ�ܣ�����IP�Ͷ˿��Ƿ���ȷ��");
			        	}
			        }
			    });
		}
        
		
 
		function showHelp(){
			 cui("#showHelpContent").dialog({
		            title : "IE���������������",
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