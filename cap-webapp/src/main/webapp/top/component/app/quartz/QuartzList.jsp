<%
/**********************************************************************
* ��ʱ����Ϣ�༭ҳ��
* 2013-03-14 ���� �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>��ʱ�����ƹ���</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.validate.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/QuartzAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/json2.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js'></script>

<style type="text/css">
 .top_nav_left {
    float:left;
	padding:5px 0;
  }
</style>

<script type="text/javascript">
    var data = {};
    var queryData ={};
	/** �����б�����*/
	function loadGridData(obj, query){
		queryData.sortFieldName = query.sortName.length!=0?query.sortName[0]:"jobName";
		queryData.sortType = query.sortType.length!=0?query.sortType[0]:"DESC";
		queryData.pageNo = query.pageNo;
		queryData.pageSize = query.pageSize;
		QuartzAction.queryJobList(queryData,function(data){
		     obj.setDatasource(data.list, data.count);
        });
	}
	
	//����table�߶�
	function resizeHeight(){
   		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
	}
	
	//����table���
	function resizewidth(){
   		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}
	//����
	function addJob(){
		var url="QuartzEdit.jsp";
		window.open(url,"_self");
	}
	//ɾ��
	function deleteJob(){
		var idList = cui("#tableList").getSelectedRowData();
		var length = idList.length;
		if(length == 0 ){
			cui.error("��ѡ��Ҫɾ�������ݡ�");
		}else{
			cui.confirm("ȷ��Ҫɾ����"+length+"��������",{
					onYes:function (){
				             QuartzAction.deleteJobs(idList,function(){
								cui.message("�ɹ�ɾ��"+length+"�����ݡ�");
								cui("#tableList").loadData();//��������
							  });
					}
				});
			}
		}
	//��Ⱦ����������
	function renderJobName(rowData){
		return "<a href='QuartzEdit.jsp?jobId=" + rowData['jobId'] + "'>" + rowData['jobName'] + "<a>";
	}
	function renderJobState(rowData){
        if(rowData['jobState'] == 1){
            return "����";
        }else if(rowData['jobState'] == 2){
        	return "ͣ��";
        }
	}

	function runJob(){
		var idList = cui('#tableList').getSelectedRowData();
		if(idList!=null&&idList.length>0){
			cui.confirm("ȷ��Ҫ������" + idList.length + "����ʱ��������",{
				onYes:function (){
				      QuartzAction.runJobs(idList,function(){
							cui("#tableList").loadData();//��������
							cui.message("����" + idList.length+"����ʱ������ɹ�");
					  });
				}
			});
		}else{
			cui.message("��ѡ����Ҫ���õĶ�ʱ������");
		}
	}

	function pauseJob(){
		var idList = cui('#tableList').getSelectedRowData();
		if(idList!=null&&idList.length>0){
			cui.confirm("ȷ��Ҫͣ����" + idList.length + "����ʱ��������",{
				onYes:function (){
			            QuartzAction.pauseJobs(idList,function(){
							cui("#tableList").loadData();//��������
							cui.message("ͣ��" + idList.length+"����ʱ������ɹ�");
						});
				}
			});
		}else{
			cui.message("��ѡ����Ҫͣ�õĶ�ʱ������");
		}
	}

	function excuteJobs(){
		var idList = cui('#tableList').getSelectedRowData();
		if(idList!=null&&idList.length>0){
           var bFlag = false,job;
	       for(var i=0,j=idList.length;i < j;i++){
               if(idList[i]["jobState"] == 2){
                    bFlag = true;
               }
           }    
           if(bFlag){
        	 cui.message("����ͣ�õĶ�ʱ������");
             return ;
           } 
			
			cui.confirm("ȷ��Ҫ����ִ����" + idList.length + "����ʱ��������",{
				onYes:function (){
			            QuartzAction.excuteJobs(idList,function(){
							cui("#tableList").loadData();//��������
							cui.message("ִ��" + idList.length+"����ʱ������ɹ�");
						});
				}
			});
		}else{
			cui.message("��ѡ����Ҫ����ִ�еĶ�ʱ������");
		}
	}
</script>
</head>
<body>
            
            <div class="top_nav_left" style="padding:5px;">
                <span uitype="ClickInput" id="quartzId" name="quartzName" emptytext="��ʱ������" enterable="true" editable="true" width="300" on_iconclick="refreshData" 
                   icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif" iconwidth="23px"></span>
				&nbsp;
				<div id="jobStateId" uitype="RadioGroup" name="jobState" on_change="refreshData" value="0" >
					<input type="radio" name="jobState" color="green" value="0" />ȫ��
					<input type="radio" name="jobState" color="blue" value="1" />����
					<input type="radio" name="jobState" color="red" value="2" />ͣ��
				</div>
            </div>
			<div class="top_nav_right" style="padding:5px;">
			    <span uitype="Button" label="&nbsp;��&nbsp;��&nbsp;" on_click="addJob"></span>
			    <span uitype="Button" label="&nbsp;ɾ&nbsp;��&nbsp;" on_click="deleteJob"></span>
			    <span uitype="Button" label="&nbsp;��&nbsp;��&nbsp;" on_click="runJob"></span>
			    <span uitype="Button" label="&nbsp;ͣ&nbsp;��&nbsp;" on_click="pauseJob"></span>
			    <span uitype="Button" label="&nbsp;ִ&nbsp;��&nbsp;" on_click="excuteJobs"></span>
			</div>
        
        	<div id="gridWrap" style="padding:0 5px 0 5px">
            	<table id="tableList" uitype="grid" ellipsis="true"  
			    	datasource="loadGridData" resizewidth="resizewidth" resizeheight="resizeHeight" primarykey="jobId">
		        	<thead>
			        	<tr>
			            	<th renderStyle="width:5%;align:center;" ><input type="checkbox"/></th>
			            	<th renderStyle="width:15%;align:center;" bindName="jobName" sort="true" render="renderJobName">��ʱ������</th>
			            	<th renderStyle="width:15%;align:center;" bindName="describe" sort="true" >����</th>
			            	<th renderStyle="width:15%;align:center;" bindName="cronEL">���ʽ</th>
			            	<th renderStyle="width:25%;align:center;" bindName="jobData">����</th>
			            	<th renderStyle="width:10%;align:center;" bindName="jobState" renderStyle="text-align:center;" render="renderJobState">��ʱ��״̬</th>
			        	</tr>
		        	</thead>
		    	</table>
		    </div>
			<!-- �б���� -->	
			

	<script type="text/javascript">
		window.onload=function(){
			comtop.UI.scan();
		
			$('#gridWrap').height(function(){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 60;		
			});  
  	 	}  
		function refreshData(){
           	queryData.jobName = handleStr(cui("#quartzId").getValue());
           	queryData.jobState = cui("#jobStateId").getValue();
            cui("#tableList").loadData();//��������
		}
	</script>
</body>
</html>