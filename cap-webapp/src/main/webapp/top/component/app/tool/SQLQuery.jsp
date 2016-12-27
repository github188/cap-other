
<%
	/**********************************************************************
	 * SQL��ѯҳ��
	 * 2014-12-17  zhangzunzhi  �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>SQL��ѯ</title>

<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" 
    src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/SQLQueryAction.js'></script>
<style type="text/css">
.imgMiddle {
	line-height: 350px;
	text-align: center;
}

.top_header_wrap {
	padding-right: 5px;
}
</style>
</head>
<body onload="window.status='Finished';">
	<div uitype="Borderlayout" id="body" is_root="true">
		<div class="top_header_wrap" >
			<div class="thw_title" style="padding-top: 3px;margin-top:0px;">
				<span><font id="pageTittle" class="fontTitle">SELECTִ�����</font>
				<font class="fontTitle" style="color: red">(��ע�������ѯ����ָ���У�������*����)</font></span>
			</div>
			<div class="thw_operate" style="padding-right:47px">
				<span uitype="button" label="��ѯ" id="sqlQuery" on_click="sqlQuery" ></span>
				&nbsp;
				<span uitype="button" label="ѡ��SQL" id="chooseSQL" on_click="chooseSQL" ></span>
			</div>
		</div>
		<div class="cui_ext_textmode" style="margin-top:5px;">
			<table class="form_table" style="table-layout: fixed;">
				<tr>
					<!--  <td class="td_label" width="10%">SELECTִ����䣺</td> -->
					<td class="td_content">
						<div style="width:98%;padding-left:15px" >
							<span uitype="textarea"  name=querySQL id = "querySQL"
								width="97%" databind="data.querySQL" height="150px" 
								maxlength="4000" relation="defect1" value = " SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd hh-mm-ss') FROM DUAL ">
							</span>
							
							
							<div style="float:right;padding-right:25px">
								<font>
								(����������<label id="defect1" style="color: red"></label>���ַ�)
								</font>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div  id="centerMain" position="center" url="" gap="0px 0px 0px 0px" />
	</div>

	<script language="javascript">
	window.onload = function() {
		comtop.UI.scan();
		
		$('#body').height(function(){
			return (document.documentElement.clientHeight || document.body.clientHeight);		
	});
	}

		//ִ�в�ѯ���
		function sqlQuery() {
			var selectSQL = cui("#querySQL").getValue();
			if(checkSQL(selectSQL)){
			 cui('#body').setContentURL("center",'${pageScope.cuiWebRoot}/top/component/app/tool/SQLQueryData.jsp');
			}
		}
		
		//SQL���
		function checkSQL(selectSQL){
			if (selectSQL == null) {
				cui.alert("SELECT��䲻��Ϊ�գ�");
                return false;
            }
			if(selectSQL.length == 0){
				cui.alert("SELECT��䲻��Ϊ�գ�");
				return false;
			}
            var selectLowerSQL = selectSQL.toLowerCase();
            if(selectLowerSQL.indexOf("select")==-1){
            	cui.alert("ֻ��ʹ�ò�ѯ��䣡");
           	    return false;
            }
            if(selectLowerSQL.indexOf("drop ")>-1||selectLowerSQL.indexOf("delete ")>-1||selectLowerSQL.indexOf("commit")>-1
            		||selectLowerSQL.indexOf("alter")>-1||selectLowerSQL.indexOf("create ")>-1
            		||selectLowerSQL.indexOf("roll")>-1||selectLowerSQL.indexOf("rollback")>-1
            		||selectLowerSQL.indexOf("copy ")>-1||selectLowerSQL.indexOf("grant ")>-1){
            	cui.alert("ֻ��ʹ�ò�ѯ��䣡");
           	    return false;
            }
            if(selectLowerSQL.indexOf(" into ")>-1||selectLowerSQL.indexOf(" set ")>-1||selectLowerSQL.indexOf(" set")>-1||selectLowerSQL.indexOf(" into")>-1){
            	 cui.alert("�������������޸���䣡");
            	 return false;
            }
            return true;
		}
		
		//ѡ��SQLҳ��
		function chooseSQL(){
			var url = '${pageScope.cuiWebRoot}/top/component/app/tool/QuerySQLList.jsp';
			var title = "";
			var height = 600;
			var width = 800;
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}
		

	</script>
</body>
</html>