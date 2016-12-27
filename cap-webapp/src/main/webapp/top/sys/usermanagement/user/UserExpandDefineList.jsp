<%
/**********************************************************************
* ��Ա��չ���Զ���-�б�
* 2014-07-14 �¼�ɽ  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��Ա��չ���Զ���</title>
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
			<span uitype="button" id="add" label="����" on_click="editExpandDefine" ></span>
			<span uitype="button" id="delete" label="ɾ��" on_click="deleteExpand"></span>
   	    	<span uitype="button" id="up"  label="����" on_click="sortAttribute"></span>
   	    	<span uitype="button" id="down"  label="����" on_click="sortAttribute"></span>
		</div>
	</div>
	<div id="userGridWrap" style="padding:0 15px 0 15px">
	<table uitype="grid" id="grid" primarykey="defineId"  selectrows="single"  datasource="initData" pagination="false"  adaptive="true" resizewidth="resizeWidth" sortstyle="3" resizeheight="resizeHeight" colrender="columnRenderer">
		<tr>
	        <th style="width:5%"></th>
	        <th renderStyle="width:35%;text-align:center;" bindName="attriName">��չ������</th>
	        <th renderStyle="width:30%;text-align:center;" bindName="attriType">��������</th>
	        <th style='width:30%' renderStyle="text-align: center" bindName="isRequired">�Ƿ������</th>
		</tr>
	</table>
	</div>
   <script language="javascript">
   	   // ѡ����id
	   var selectedRowId="";
	   //��չ��������
	   var totalSize ="";  
	  //��ǰ��֯�ṹid
	   var curOrgStrucId ='';
	   //��Աmark
	   var mark =1;
	   window.onload=function(){
			comtop.UI.scan();
			
		$('#userGridWrap').height(function(){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 50;		
		});  
	   }  
	   
	    //��Ⱦ�б�����
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
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-30;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 56 ;
		}

		//�༭ҳ��ص����� ִ�ж������ʱ����Դ����������ݲ������ж�ִ��ʲô������
		function editCallBack(key){
			selectedRowId=key;
			cui("#grid").loadData();
		}
		
		/**
		 * ɾ����չ����
		 */
		function deleteExpand(){
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length==0){
				cui.alert("û��ѡ�м�¼��");
				return;
			}
			if(selectRow !=null && selectRow.length>0){
				var names = "";
				for(var i=0;i<selectRow.length;i++){
					names += selectRow[i].attriName+",";
				}
				names = names.substr(0,names.length-1);	
				
				var message = "������Ա��<font color='red'>&quot;"+names+"&quot;</font>����ֵ���ᱻɾ�������޷��ָ����Ƿ�ȷ��ɾ����";
				cui.confirm(message,{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						ExtendAttrAction.delExpandDefine(selectRow,1,function(){
							selectedRowId="";
							cui("#grid").loadData();
							cui.message("ɾ���ɹ���","success");
				        });
						dwr.TOPEngine.setAsync(true);
				  	}
				});
			}
		}

		 //�༭
		var dialog;
		function editExpandDefine(defineId){
			var title="";//"��Ա��չ���Ա༭";
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

		//����Ⱦ
		function columnRenderer(data,field) {
			if(field == 'attriName'){
				var attriName = data["attriName"];
				return "<a class='a_link' onclick='javascript:editExpandDefine(\""+data["defineId"]+ "\");'>"+attriName+"</a>";
		      }
			if(field == 'isRequired'){
				var isRequired = data["isRequired"];
				if(isRequired==1){
					return "��";
				}else{
					return "��";
				}
		     }
			if(field == 'attriType'){
				var attriType = data["attriType"];
				if(attriType==1){
					return "�ı�";
				}else if(attriType==3){
					return "������ѡ";
				} else{
					return "������ѡ";
				}
		     }
	    }
		/**
		* ��չ��������
		**/
		function sortAttribute(event,el){
			//ȡѡ�еļ�¼
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length  == 0){
				cui.alert("û��ѡ�м�¼��");
				return ;
			}
			var type='';
			if(el.options.label=='����'){
				type='up';
			}
			if(el.options.label=='����'){
				type='down';
			}
			dwr.TOPEngine.setAsync(false);
			ExtendAttrAction.changeAttributeSort(selectRow[0],type,function(data){
				if(data == 1){
					cui.alert("�Ѿ��ö��ˡ�");
					return;
				}else if(data == -1){
					cui.alert("�Ѿ��õ��ˡ�");
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
