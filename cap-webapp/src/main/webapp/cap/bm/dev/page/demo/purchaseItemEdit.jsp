
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
   			"lstPurchaseItem":{
                uitype:'Grid',
                datasource:initData,
                primarykey:'ID',
                gridwidth:1200,
                gridheight:"auto",
                tablewidth:1200,
                adaptive:false,
                titleellipsis:false,
                lazy:false,
                selectrows:"multi",
                selectedrowclass:"selected_row",
                sortstyle:1,
                sortname:[],
                sorttype:[],
                pagination:true,
                pagination_model:"pagination_min_1",
                pageno:1,
                pagesize:50,
                custom_pagesize:false,
                pagesize_list:[25,50,100],
                colrender:null,
                colstylerender:null,
                rowsstylerender:null,
                resizeheight:null,
                resizewidth:null,
                titlelock:true,
                fixcolumnnumber:0,
                oddevenrow:false,
                oddevenclass:'cardinal_row',
                titlerender:null,
                colhidden:true,
                colmaxheight:"auto",
                colmove:false,
                loadtip:true,
                adddata_callback:null,
                removedata_callback:null,
                rowclick_callback:null,
                rowdblclick_callback:null,
                loadcomplate_callback:null,
                selectall_callback:null,
                onstatuschange:null,
                config:null,
                operation:{
                    search:{
                        btn:"#searchBtn"
                    }
                },
                columns:[
                   [
                        {renderStyle:"text-align: center;",bindName:"info.name",render:"a",options:"{'url':'#'}",name:""},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"info.name",name:"检查"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"info.class",name:"流程位置",hide:false,disabled:false},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chinese",name:"签约确认书编号"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"english",name:"合同编号"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"politics",name:"合同名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"history",name:"合同金额（元）"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"geography",name:"供应商名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"math",name:"采购单号"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"physics",name:"项目名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"organisms",name:"项目编号"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"地市局（厂）项目编号"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"项目类型"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"单项工程名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"合同物资目录"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"合同类别"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"交货日期"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"合同承办部门名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"代理商名称"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"制作人"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"制作时间"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"合同起草人电话"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"采购合同备注"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"合同模板名称"}

                    ]
                ]
            },
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
	<table class="table">
		<tr>
		<td>
		 <h4>采购明细列表</h4>
		 </td>
		</tr>
		<tr>
		 <td>
		 <table id="lstPurchaseItem" uitype="Grid"></table>
		 </td>
		</tr>
	</table>
</body>
</html>