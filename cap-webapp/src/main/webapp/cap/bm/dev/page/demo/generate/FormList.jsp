<%
/**********************************************************************
* CRUD最佳实践代码
* 2015-5-27 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRUD最佳实践代码</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <style type="text/css">
    	
		
		
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
    <top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/top/sys/usermanagement/orgusertag/js/choose.js" />
	<top:script src="/top/sys/dwr/interface/ChooseAction.js"/>
	<top:script src='/cap/dwr/interface/FormListAction.js'></top:script>
    <script type="text/javascript">
	  	//页面参数自动生成JavaScript变量
		var stringAttr=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("stringAttr"))%>;
		var intAttr=<%=request.getAttribute("intAttr")%>;
		var verifyAttr=<%=request.getAttribute("verifyAttr")%>;
		var objectAttr=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("form"))%>;
        
        
        var data={};
        
        /**
         * 页面初始化数据行为
         */
        function pageInitLoadData(){
        	//加载数据前操作
        	
        	//数据加载完成后操作
        }
        
      	//页面初始化状态
        function pageInitState(){
      		
        }
      	
      	/**
         * 表格获取数据回调
         */
        function gridDatasource(obj, pageQuery) {
        	//获取查询条件
       		var query=cap.getQueryObject(data,pageQuery);
       		//调用前操作

       		//调用后台查询
       		FormListAction.queryList(query,function(result){
        		//数据设置前操作
        		
        		//设置到数据源
        		if(result!=null){
        			obj.setDatasource(result,result.length); 
	           	}else{
	           		obj.setDatasource([],0);
	           	}
        		//数据设置后操作
        		
        	});
        }
        
        /**
         * 新增方法
         */
       	function insert(){
			//返回前操作
     	   
			var pageAttrString=cap.getPageAttrString("intAttr","stringAttr");
			//新窗口打开模式
			window.open("${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/generate/formCRUD.ac"+pageAttrString);
			//当前窗口打开模式
     		//window.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/generate/formCRUD.ac"+pageAttrString;
        }
        
       	/**
         * 新增方法
         */
       	function deleteRow(){
       		//删除前操作

       		var gridId="requeryTable";
    		var selects = cui("#"+gridId).getSelectedPrimaryKey();
    		if(selects == null || selects.length == 0){
    			cui.alert("请选择要删除的数据。");
    			return;
    		}
    		
    		cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
    			onYes:function(){
    				FormListAction.deleteList(selects,function(result){
    					//数据刷新前处理
    					
    					
    					if(result){
    						cui("#"+gridId).loadData();
        				 	cui.message("删除成功！","success");
    					}else{
    						cui.error("删除失败，请重新操作！");
    					}
    					
    					//数据刷新后处理
    				});
    			}
    		});

    		//删除前操作

        }
        
        jQuery(document).ready(function(){
        	comtop.UI.scan();
        	pageInitLoadData();
        	cap.pageInit();
        	pageInitState();
        });
        
        function rowstylerenderFun(rowData){
        	if(rowData.id==1){
        		return "color:red"
        	}
        }
        
        function renderLink(rd, index, col){
        	if(rd.composite>0){
        		return '<span style="border-radius:3;background-color:#e3a21a;padding:2px"><a href="#">'+rd.composite+'</a></span>';
        	}
        	
        }
        
        
      	//页面控件属性配置
        var uiConfig={
        	insert:{
				uitype:'Button',
				name:'insert',
				label:'新增',
				on_click:insert
			},
			search:{
	            uitype:'Button',
	            name:'search',
	            label:'查询',
	            icon:"search",
	            on_click:null
            },
            formTitle:{
            	uitype:'Label',
            	name:'formTitle',
            	value:'停电申请列表',
            	'class':'cap-label-title'
            },
            deleteRow:{
	            uitype:'Button',
	            name:'deleteRow',
	            label:'删除',
	            on_click:deleteRow
            },
            applyStartTimeLabel:{
            	uitype:'Label',
            	name:'applyStartTimeLabel',
            	value:'申请开始时间:'
            },
            applyStartTime:{
            	uitype:'Calender',
                databind:'data.applyStartTime',
            	name:'applyStartTime',
            	model: 'date',
            	isrange:true,
            	format:'yyyy-MM-dd hh:mm',
            	panel:2
            	
            },
            outageReasonTypeLabel:{
            	uitype:'Label',
            	name:'outageReasonTypeLabel',
            	value:'停电原因类型：'
            },
            outageReasonType:{
            	uitype : "PullDown",
                databind:'data.outageReasonType',
                name:'outageReasonType',
                empty_text: "请选择",
                value_field : "value",
                label_field : "text",
                dictionary:"LCAM_zhengzhong_outageReasonTypeDic" //TOP配置管理(数据字典)编码
            },
            planPeopleLabel:{
            	uitype:'Label',
            	name:'planPeopleLabel',
            	value:'计划编制人：'
            },
            planPeopleId:{
            	uitype : "ChooseUser",
                databind:'data.planPeople',
                idName:"data.planPeopleId",
                name:'planPeopleId',
                valueName:'data.planPeopleName',
                chooseMode:1,
                isSearch:true,
                canSelect:true,
                width:'200px',
                height:'30px'
            },
            planDepartmentLabel:{
            	uitype:'Label',
            	name:'planDepartmentLabel',
            	value:'计划编制部门：'
            },
            planDepartmentId:{
            	uitype : "ChooseOrg",
                databind:'data.planDepartment',
                idName:"data.planDepartmentId",
                name:'planDepartmentId',
                valueName:'data.planDepartmentName',
                chooseMode:1,
                isSearch:true,
                canSelect:true,
                width:'200px',
                height:'30px'
            },
            codeLabel:{
            	uitype:'Label',
            	name:'codeLabel',
            	value:'申请编号：'
            },
            code:{
            	uitype:'Input',
                databind:'data.code',
            	name:'code',
            	validate:[
                    {'type':'required', 'rule':{m: '申请编号不能为空'}}
                ]
            },
            remark:{
            	uitype:'Label',
            	name:'remark',
            	value:'备注:'
            },
            remarkContent:{
            	uitype:'Label',
            	name:'remarkContent',
            	value:'橘黄色文字表明该计划申请工期和批注工期不一致 '
            },
            requeryTable:{
            	uitype:'Grid',
                datasource:gridDatasource,
                primarykey:'id',
                gridheight:"auto",
                selectrows:"multi",
                pagination:true,
                pagination_model:"pagination",
                pageno:1,
                pagesize:25,
                titleellipsis:false,
                ellipsis:false,
                custom_pagesize:false,
                pagesize_list:[25,50,100],
                titlelock:true,
                colmaxheight:"auto",
                loadtip:true,
                config:null,
                resizeheight:getBodyHeight,
                resizewidth:getBodyWidth,
                rowstylerender:rowstylerenderFun,
                operation:{
                    search:{
                        btn:"#search"
                    }
                },
                columns:[
                   [
                        {width:60,type:'checkbox'},
                        {width:150,renderStyle:"text-align: left;",sort:"true",bindName:"code",render:"a",
                        		options:"{'url':'${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/generate/formCRUD.ac','targets':'_blank','params': 'id'}",
                        		name:"申请编号"},
                        {renderStyle:"text-align: left;",sort:"true",bindName:"outageDevice",name:"停电设备",hide:false,disabled:false},
                        {renderStyle:"text-align: left;",sort:"true",bindName:"workContent",name:"工作内容"},
                        {width:150,renderStyle:"text-align: left;",sort:"true",bindName:"centerSubstation",name:"中心站"},
                        {width:150,renderStyle:"text-align: center;",format:'yyyy-MM-dd hh:mm',sort:"true",bindName:"applyStartTime",name:"申请开始时间"},
                        {width:150,renderStyle:"text-align: center;",format:'yyyy-MM-dd hh:mm',sort:"true",bindName:"applyEndTime",name:"申请结束时间"},
                        {width:100,renderStyle:"text-align: center;",render:"renderLink",sort:"true",bindName:"composite",name:"综合停电"},
                        {width:150,renderStyle:"text-align: left;",sort:"true",bindName:"source",name:"来源"}
                    ]
                ]
            }
        }
        

    </script>
</head>
<body style="background-color:#f5f5f5;">
<div id="pageRoot" class="cap-page" style="width:1280px;">
	<div class="cap-area">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label"  class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="applyStartTimeLabel" uitype="Label"></span>
		        	
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="applyStartTime" uitype="Calender" format='yyyy-MM-dd hh:mm'></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="outageReasonTypeLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="outageReasonType" uitype="PullDown" ></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="planPeopleLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="planPeopleId" uitype="ChooseUser" ></span>
		        </td>
		    </tr>
		    <tr>
		    	<td class="cap-td" style="text-align: left;">
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="planDepartmentLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="planDepartmentId" uitype="ChooseOrg" ></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="codeLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="code" uitype="Input" ></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="search" uitype="Button"></span>
		        	<span id="insert" uitype="Button"></span>
		        	<span id="deleteRow" uitype="Button"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" >
		        	<table id="requeryTable" uitype="Grid"></table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100%">
			        <span id="remark" uitype="Label" style="font-weight:bold;color:red "></span>
			        <span id="remarkContent" uitype="Label" style="font-weight:bold;"></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100%">
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>