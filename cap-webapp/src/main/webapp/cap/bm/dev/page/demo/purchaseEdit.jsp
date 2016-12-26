
<%
    /**********************************************************************
			 * 示例页面
			 * 2015-5-13 肖威 新建
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>采购合同列表</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" />
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/css/table-layout.css" />
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>

<script type="text/javascript">
    
		//页面控件属性配置
   	var uiConfig={
   		 
          }
		
	var data={input:'绑定input', calender:'2015-05-07',checkboxGroup:[0,1],radioGroup:0,clickInput:'绑定clickInput',
            textarea:'绑定textarea',editor:'<span style="font-size: 20px;">绑定editor</span>'
        };

        var data2={listBox:'item1;item2',pullDown:'item1'
        };

        function initData(gridObj,query){
            console.log(gridObj);
            gridObj.setDatasource(gridData.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), 150);
        }

        /**
         * 编辑Grid数据加载
         * @param obj {Object} Grid组件对象
         * @param query {Object} 查询条件
         */
        function datasource(obj, query) {
            //模拟ajax
            setTimeout(function () {
                obj.setDatasource(editGridData.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), editGridData.length);
            }, 500);
        }

        function initDataBind(){
            for(var item in uiConfig){
                if(uiConfig[item].databind){
                    var bindObject=uiConfig[item].databind.split(".")[0];
                    var bindName=uiConfig[item].databind.split(".")[1];
                    cui(window[bindObject]).databind().addBind('#'+item, bindName);
                }
            }
        }

        function initValidate(){
            var validate = cui().validate();
            validate.add('input', 'required', {m: '不能为空', emptyVal:[0]});
        }

        jQuery(document).ready(function(){
            comtop.UI.scan();
            initDataBind();
            initValidate();
        });

        function testDataBind(){
            console.log(data);
        }    
        
    <!--  自定义JS函数 开始  -->
    
    <!--  自定义JS函数 结束  -->
    </script>
</head>
<body>
	<table>
		<tr>
			<td >采购单编辑</td>
			<td>
				<span id="exportWord" uiType="Button" label="导出Word"></span>
				<span id="saveData" uiType="Button" label="&nbsp;保&nbsp;存&nbsp;"></span>
				<span id="contractBackBtn" uiType="Button" label="&nbsp;返&nbsp;回&nbsp;"></span>
			</td>
		</tr>
		<tr>
			<td colspan="2">
					<table>
						<tr>
							<td >采购单编号</td>
							<td >
								<span id="purchaseId" uitype="Input"></span>
							</td>
							<td >合同编号</td>
							<td >
								<span id="contractCode" uitype="Input"></span>
							</td>
						</tr>
						<tr>
							<td >供应商名称</td>
							<td  colspan="3">
								<span id="vendorName" uitype="Input"></span>
							</td>
						<tr>
							<td >创建人</td>
							<td >
								<span id="creator" uitype="Input"></span>
							</td>
							<td >创建时间</td>
							<td >
								<span id="createDate" uitype="Input"></span>
							</td>
						</tr>
						<tr>
							<td >联系电话</td>
							<td >
								<span id="excutorPhone" uitype="Input"></span>
							</td>
							<td ></td>
							<td ></td>
						</tr>
						<tr>
							<td >备注<br> 
							</td>
							<td colspan="3">
								<span id="remark" uitype="Textarea"></span>
							</td>
						</tr>
					</table>
					<iframe name="ifram_purchaseItem" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/purchaseItemEdit.jsp" id="ifram_purchaseItem"
						width="100%" border="0" frameborder="0" scrolling="no"
						marginheight="0" marginwidth="0"></iframe>
					<iframe id="ifram_purchaseInfoTab" name="ifram_purchaseInfoTab"
						src="" width="100%" border="0" frameborder="0" scrolling="no"
						marginheight="0" marginwidth="0"></iframe>
			</td>
		</tr>
	</table>
</body>
</html>