<%
/**********************************************************************
* 人员扩展属性定义-列表
* 2014-07-14 陈佳山  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>人员扩展属性定义</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ExtendAttrAction.js"></script>
	<style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body class="body_layout">
	<div class="list_header_wrap" style="padding:10px">
		<div class="top_float_right">
			<span uitype="button" id="add" label="新增" on_click="editExpandDefine" ></span>
			<span uitype="button" id="delete" label="删除" on_click="deleteExpand"></span>
   	    	<span uitype="button" id="up"  label="上移" on_click="sortAttribute"></span>
   	    	<span uitype="button" id="down"  label="下移" on_click="sortAttribute"></span>
		</div>
	</div>
	<div id="userGridWrap" style="padding:0 15px 0 15px">
	<table uitype="grid" id="grid" primarykey="defineId"  selectrows="single"  datasource="initData" pagination="false"  adaptive="true" resizewidth="resizeWidth" sortstyle="3" resizeheight="resizeHeight" colrender="columnRenderer">
		<tr>
	        <th style="width:5%"></th>
	        <th renderStyle="width:35%;text-align:center;" bindName="attriName">扩展属性名</th>
	        <th renderStyle="width:30%;text-align:center;" bindName="attriType">属性类型</th>
	        <th style='width:30%' renderStyle="text-align: center" bindName="isRequired">是否必填项</th>
		</tr>
	</table>
	</div>
   <script language="javascript">
   	   // 选中行id
	   var selectedRowId="";
	   //扩展属性总数
	   var totalSize ="";  
	  //当前组织结构id
	   var curOrgStrucId ='';
	   //人员mark
	   var mark =1;
	   window.onload=function(){
			comtop.UI.scan();
			
		$('#userGridWrap').height(function(){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 50;		
		});  
	   }  
	   
	    //渲染列表数据
		function initData(grid,query){
		
				dwr.TOPEngine.setAsync(false);
				ExtendAttrAction.queryExtendDefineList(curOrgStrucId,mark,function(data){
			    	totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList);
					if(selectedRowId){
						grid.selectRowsByPK(selectedRowId);
					}
				});
				dwr.TOPEngine.setAsync(true);
			
	  	}
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-30;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 56 ;
		}

		//编辑页面回调函数 执行多任务的时候可以带参数，根据参数来判断执行什么操作。
		function editCallBack(key){
			selectedRowId=key;
			cui("#grid").loadData();
		}
		
		/**
		 * 删除扩展属性
		 */
		function deleteExpand(){
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length==0){
				cui.alert("没有选中记录。");
				return;
			}
			if(selectRow !=null && selectRow.length>0){
				var names = "";
				for(var i=0;i<selectRow.length;i++){
					names += selectRow[i].attriName+",";
				}
				names = names.substr(0,names.length-1);	
				
				var message = "所有人员的<font color='red'>&quot;"+names+"&quot;</font>属性值都会被删除，且无法恢复，是否确认删除？";
				cui.confirm(message,{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						ExtendAttrAction.delExpandDefine(selectRow,1,function(){
							selectedRowId="";
							cui("#grid").loadData();
							cui.message("删除成功。","success");
				        });
						dwr.TOPEngine.setAsync(true);
				  	}
				});
			}
		}

		 //编辑
		var dialog;
		function editExpandDefine(defineId){
			var title="";//"人员扩展属性编辑";
			var height = 365; //600
			var width =  480; // 680;
			var url='${pageScope.cuiWebRoot}/top/sys/usermanagement/user/UserExpandDefineEdit.jsp?totalSize='+totalSize+"&orgStrucId="+curOrgStrucId;
			if(typeof(defineId)=='string'){
				url += '&defineId='+defineId;
			}
			if(!dialog){
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
			}
			dialog.show(url);
		}

		//列渲染
		function columnRenderer(data,field) {
			if(field == 'attriName'){
				var attriName = data["attriName"];
				return "<a class='a_link' onclick='javascript:editExpandDefine(\""+data["defineId"]+ "\");'>"+attriName+"</a>";
		      }
			if(field == 'isRequired'){
				var isRequired = data["isRequired"];
				if(isRequired==1){
					return "是";
				}else{
					return "否";
				}
		     }
			if(field == 'attriType'){
				var attriType = data["attriType"];
				if(attriType==1){
					return "文本";
				}else if(attriType==3){
					return "下拉多选";
				} else{
					return "下拉单选";
				}
		     }
	    }
		/**
		* 扩展属性排序
		**/
		function sortAttribute(event,el){
			//取选中的记录
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length  == 0){
				cui.alert("没有选中记录。");
				return ;
			}
			var type='';
			if(el.options.label=='上移'){
				type='up';
			}
			if(el.options.label=='下移'){
				type='down';
			}
			dwr.TOPEngine.setAsync(false);
			ExtendAttrAction.changeAttributeSort(selectRow[0],type,function(data){
				if(data == 1){
					cui.alert("已经置顶了。");
					return;
				}else if(data == -1){
					cui.alert("已经置底了。");
					return;
				}
				cui("#grid").loadData();
				cui("#grid").selectRowsByPK(selectRow[0].defineId);
			});
			dwr.TOPEngine.setAsync(true);
		}
   </script>
</body>
</html>
