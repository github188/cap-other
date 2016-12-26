<%
/**********************************************************************
* 示例页面
* 2015-5-13 肖威 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购合同列表</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/css/table-layout.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>
    <script type="text/javascript">
    
		//页面控件属性配置
   	var uiConfig={
		labContractType:{
   				value:"合同类型："
   			},
   	listContractType : {
                uitype : "PullDown",
                empty_text: "请选择",
                value: '0',
                readonly: false,
                textmode: false,
                width: "300",
                height: "200",
                editable: true,
                //下拉渲染模式，暂时可以为"Single"和"Multi"。
                mode : "Single",
                datasource: [
                    {id:'0',text:'--全部--'},
                    {id:'-1',text:'一级采购合同'},
                    {id:'1',text:'省公司组织采购合同'},
                    {id:'2',text:'授权地市局（厂）采购合同'},
                    {id:'3',text:'历史三方合同'}
                ],
                //下面这个是用于数据字典的，不与后端结合的时候，不需要理会此参数
                dictionary: '',
                //下面为继承部分参数内容。
                name : "pullDown",
                select: -1,
                must_exist: true,
                auto_complete: false,
                value_field : "id",
                label_field : "text",
                filter_fields : [],
                on_filter_data: null,
                on_change: null,
                on_filter: null
            },
            exportWord:{
            	uitype:"Button",label:"导出Word"
            },
            exportExcel:{
            	uitype:"Button",label:"导出Excel"
            },
            deleteContract:{
            	uitype:"Button",label:"删除"
            },
            reprot:{
            	uitype:"Button",label:"上报"
            },
            outsideSys:{
            	uitype:"Button",label:"系统外合同直接签约完成"
            },
            query:{
            	uitype:"Button",label:"查询"
            },
            colDefined:{
            	uitype:"Button",label:"列自定义"
            },
            "lstContract":{
                uitype:'Grid',
                datasource:initData,
                primarykey:'ID',
                gridwidth:1200,
                gridheight:"auto",
                tablewidth:1200,
                adaptive:true,
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

        function save(){

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
    </script>
</head>
<body>
<table  class="table">
 	<tr>
 		<td colspan="2" align="left" width="100%">
 			<span id="labContractType" uitype="Label"></span>
 			<span id="listContractType" uitype="pullDown"></span></td>
 		</tr>
  <tr>
  	<td align="left" width="50%"></td>
  	<td align="right" width="50%">
  		<span id="exportWord" uitype="Button"></span>
  		<span id="exportExcel" uitype="Button"></span>
  		<span id="deleteContract" uitype="Button"></span>
  		<span id="reprot" uitype="Button"></span>
  		<span id="outsideSys" uitype="Button"></span>
  		<span id="query" uitype="Button"></span>
  		<span id="colDefined" uitype="Button"></span>
  		</td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<table id="lstContract" uitype="Grid"></table>
  			</td>
  		</tr>
  			<td colspan="2">
  				<font color=red size=2px>注：单号红色表示回退的单据.合同名称红色表示省公司核价不通过,请确认是否修改.  合同签订剩余时间
  					和合同审批剩余时间<font color=green>绿色</font>表示剩余的时间,<font color=orange>橙色</font>表示即将超期的警告时间,红色表示超期时间. </font>
  				</td>
  			</tr>  	
</table>
</body>
</html>