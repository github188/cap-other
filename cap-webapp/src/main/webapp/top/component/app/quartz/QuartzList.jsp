<%
/**********************************************************************
* 定时器信息编辑页面
* 2013-03-14 陈萌 新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>定时器定制管理</title>
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
	/** 加载列表数据*/
	function loadGridData(obj, query){
		queryData.sortFieldName = query.sortName.length!=0?query.sortName[0]:"jobName";
		queryData.sortType = query.sortType.length!=0?query.sortType[0]:"DESC";
		queryData.pageNo = query.pageNo;
		queryData.pageSize = query.pageSize;
		QuartzAction.queryJobList(queryData,function(data){
		     obj.setDatasource(data.list, data.count);
        });
	}
	
	//调整table高度
	function resizeHeight(){
   		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
	}
	
	//调整table宽度
	function resizewidth(){
   		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}
	//新增
	function addJob(){
		var url="QuartzEdit.jsp";
		window.open(url,"_self");
	}
	//删除
	function deleteJob(){
		var idList = cui("#tableList").getSelectedRowData();
		var length = idList.length;
		if(length == 0 ){
			cui.error("请选择要删除的数据。");
		}else{
			cui.confirm("确定要删除这"+length+"条数据吗？",{
					onYes:function (){
				             QuartzAction.deleteJobs(idList,function(){
								cui.message("成功删除"+length+"条数据。");
								cui("#tableList").loadData();//更新数据
							  });
					}
				});
			}
		}
	//渲染待办名称列
	function renderJobName(rowData){
		return "<a href='QuartzEdit.jsp?jobId=" + rowData['jobId'] + "'>" + rowData['jobName'] + "<a>";
	}
	function renderJobState(rowData){
        if(rowData['jobState'] == 1){
            return "启用";
        }else if(rowData['jobState'] == 2){
        	return "停用";
        }
	}

	function runJob(){
		var idList = cui('#tableList').getSelectedRowData();
		if(idList!=null&&idList.length>0){
			cui.confirm("确定要启用这" + idList.length + "个定时器任务吗？",{
				onYes:function (){
				      QuartzAction.runJobs(idList,function(){
							cui("#tableList").loadData();//更新数据
							cui.message("启用" + idList.length+"个定时器任务成功");
					  });
				}
			});
		}else{
			cui.message("请选择需要启用的定时器任务");
		}
	}

	function pauseJob(){
		var idList = cui('#tableList').getSelectedRowData();
		if(idList!=null&&idList.length>0){
			cui.confirm("确定要停用这" + idList.length + "个定时器任务吗？",{
				onYes:function (){
			            QuartzAction.pauseJobs(idList,function(){
							cui("#tableList").loadData();//更新数据
							cui.message("停用" + idList.length+"个定时器任务成功");
						});
				}
			});
		}else{
			cui.message("请选择需要停用的定时器任务");
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
        	 cui.message("存在停用的定时器任务");
             return ;
           } 
			
			cui.confirm("确定要立即执行这" + idList.length + "个定时器任务吗？",{
				onYes:function (){
			            QuartzAction.excuteJobs(idList,function(){
							cui("#tableList").loadData();//更新数据
							cui.message("执行" + idList.length+"个定时器任务成功");
						});
				}
			});
		}else{
			cui.message("请选择需要立即执行的定时器任务");
		}
	}
</script>
</head>
<body>
            
            <div class="top_nav_left" style="padding:5px;">
                <span uitype="ClickInput" id="quartzId" name="quartzName" emptytext="定时器名称" enterable="true" editable="true" width="300" on_iconclick="refreshData" 
                   icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif" iconwidth="23px"></span>
				&nbsp;
				<div id="jobStateId" uitype="RadioGroup" name="jobState" on_change="refreshData" value="0" >
					<input type="radio" name="jobState" color="green" value="0" />全部
					<input type="radio" name="jobState" color="blue" value="1" />启用
					<input type="radio" name="jobState" color="red" value="2" />停用
				</div>
            </div>
			<div class="top_nav_right" style="padding:5px;">
			    <span uitype="Button" label="&nbsp;新&nbsp;增&nbsp;" on_click="addJob"></span>
			    <span uitype="Button" label="&nbsp;删&nbsp;除&nbsp;" on_click="deleteJob"></span>
			    <span uitype="Button" label="&nbsp;启&nbsp;用&nbsp;" on_click="runJob"></span>
			    <span uitype="Button" label="&nbsp;停&nbsp;用&nbsp;" on_click="pauseJob"></span>
			    <span uitype="Button" label="&nbsp;执&nbsp;行&nbsp;" on_click="excuteJobs"></span>
			</div>
        
        	<div id="gridWrap" style="padding:0 5px 0 5px">
            	<table id="tableList" uitype="grid" ellipsis="true"  
			    	datasource="loadGridData" resizewidth="resizewidth" resizeheight="resizeHeight" primarykey="jobId">
		        	<thead>
			        	<tr>
			            	<th renderStyle="width:5%;align:center;" ><input type="checkbox"/></th>
			            	<th renderStyle="width:15%;align:center;" bindName="jobName" sort="true" render="renderJobName">定时器名称</th>
			            	<th renderStyle="width:15%;align:center;" bindName="describe" sort="true" >描述</th>
			            	<th renderStyle="width:15%;align:center;" bindName="cronEL">表达式</th>
			            	<th renderStyle="width:25%;align:center;" bindName="jobData">数据</th>
			            	<th renderStyle="width:10%;align:center;" bindName="jobState" renderStyle="text-align:center;" render="renderJobState">定时器状态</th>
			        	</tr>
		        	</thead>
		    	</table>
		    </div>
			<!-- 列表结束 -->	
			

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
            cui("#tableList").loadData();//更新数据
		}
	</script>
</body>
</html>