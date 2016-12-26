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
	<top:script src='/cap/dwr/interface/FormCRUDAction.js'></top:script>
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
        	
        	dwr.TOPEngine.setAsync(false);
        	FormCRUDAction.readFormById("123",function(data1){
        		//数据设置前操作
        		
        		data=data1;
        	});
        	dwr.TOPEngine.setAsync(true);
        	
        	//数据加载完成后操作
        }
        
      	//页面初始化状态
        function pageInitState(){
      		
        	if(verifyAttr){
        		cui('#insert').hide();
        		cui('#insert').show();
        		cui('#insert').setReadonly(true);
        		cui('#insert').setReadonly(false);
        	}
        	
        	<c:if test="${form.code!='aaa11'}">
        		cui('#insert').hide();
        	</c:if>
        }
        
        
        /**
         * 保存方法
         */
         function save(saveContinue){
        	//校验前操作
        	
        	if(cap.validateForm()){
        		cap.beforeSave();
        		
        		//提交数据前操作
        		
        		FormCRUDAction.insertForm(data,function(data1){
        			//赋值前操作
        			
        			var ss=data1;
        			
        			
        			//赋值后操作
        			
        			cui.message('**保存成功！', 'success',{'callback':function(){
        				alert();
        			}});
        			
        			/*if(saveContinue==true){
        				window.location=window.location;
        			}*/
            	});
        	}
        }
        
         /**
          * 保存继续
          */
        function saveContinue(){
        	save(true);
        }
        
       /**
        * 关闭方法
        */
        function closeWindow(){
    	   //关闭前操作
    	   
        	window.close();
        }
       
        /**
         * 返回方法
         */
       	function back(){
			//返回前操作
     	   
			var pageAttrString=cap.getPageAttrString("intAttr","stringAttr");
     		window.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/generate/formList.ac"+pageAttrString;
        }
        
       	/**
         * 打开
         */
        function openWindow(){
        	window.open('${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/generate/formCRUD.ac','newwindow','height=768,width=1280,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
        }
        
        jQuery(document).ready(function(){
        	comtop.UI.scan();
        	pageInitLoadData();
        	cap.pageInit();
        	pageInitState();
        });
        
        
      	//页面控件属性配置
        var uiConfig={
       		open:{
   				uitype:'Button',
   				name:'open',
   				label:'打开',
   				on_click:openWindow
   			},
        	insert:{
				uitype:'Button',
				name:'insert',
				label:'新增',
				on_click:save
			},
       		save:{
	            uitype:'Button',
	            name:'save',
	            label:'保存',
	            on_click:save
            },
            saveContinue:{
	            uitype:'Button',
	            name:'saveContinue',
	            label:'保存继续',
	            on_click:saveContinue
            },
            back:{
	            uitype:'Button',
	            name:'back',
	            label:'返回',
	            on_click:back
            },
            close:{
	            uitype:'Button',
	            name:'close',
	            label:'关闭',
	            on_click:closeWindow
            },
            pageArea:{
            	uitype:'Label',
            	name:'pageArea',
            	value:'页面区域',
            	'class':'cap-label-title'
            },
            formTitle:{
            	uitype:'Label',
            	name:'formTitle',
            	value:'停电申请编制',
            	'class':'cap-label-title'
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
            workPlanIdLabel:{
            	uitype:'Label',
            	name:'workPlanIdLabel',
            	value:'生产计划编号：'
            },
            workPlanId:{
            	uitype:'Input',
                databind:'data.workPlanId',
            	name:'workPlanId',
            	readonly: true 
            },
            applyDateLabel:{
            	uitype:'Label',
            	name:'applyDateLabel',
            	value:'编制日期：'
            },
            applyDate:{
                uitype: 'Calender',
                databind:'data.applyDate',
                name: 'applyDate',
                model: 'date'
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
            overhaulTypeLabel:{
            	uitype:'Label',
            	name:'overhaulTypeLabel',
            	value:'检修类别：'
            },
            overhaulType:{
            	uitype : "PullDown",
                databind:'data.overhaulType',
                name:'overhaulType',
                empty_text: "请选择",
                value_field : "id",
                label_field : "text",
                datasource: [
                    {id:'1',text:'临时检修'},
                    {id:'2',text:'紧急检修'},
                    {id:'3',text:'事故抢修'}
                ]
            },
            isNeedInsideLabel:{
            	uitype:'Label',
            	name:'isNeedInsideLabel',
            	value:'是否停电站内设备：'
            },
            isNeedInside:{
            	uitype : "RadioGroup",
                databind:'data.isNeedInside',
                name:'isNeedInside',
                radio_list: [{
                    text: '是',
                    value: '1'
                },{
                    text: '否',
                    value: '2'
                }]
            },
            longTimeOutageReasonLabel:{
            	uitype:'Label',
            	name:'longTimeOutageReasonLabel',
            	value:'长时间停电原因：'
            },
            longTimeOutageReason:{
            	uitype : "RadioGroup",
                databind:'data.longTimeOutageReason',
                name:'longTimeOutageReason',
                dictionary:"LCAM_zhengzhong_longTimeOutageReason" //TOP配置管理(数据字典)编码
            },
            notTurnpowerReasonLabel:{
            	uitype:'Label',
            	name:'notTurnpowerReasonLabel',
            	value:'未转供电原因：'
            },
            notTurnpowerReason:{
            	uitype : "CheckboxGroup",
                databind:'data.notTurnpowerReason',
                name:'notTurnpowerReason',
                dictionary:"LCAM_zhengzhong_notTurnpowerReasonDic" //TOP配置管理(数据字典)编码
            },
            notInMonplanReasonLabel:{
            	uitype:'Label',
            	name:'notInMonplanReasonLabel',
            	value:'没有纳入月度计划<br/>的原因：'
            },
            notInMonplanReason:{
            	uitype : "Textarea",
                databind:'data.notInMonplanReason',
                name:'notInMonplanReason',
                relation: 'notInMonplanReasonRelation',
                width: '700',
                height: '50',
                maxlength: 500,
                autoheight: true
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
            outageDeviceTableInsert:{
				uitype:'Button',
				name:'outageDeviceTableInsert',
				label:'新增行',
				on_click:cap.insertRowByButton,
				mark:'outageDeviceTable'
			},
			outageDeviceTableDelete:{
				uitype:'Button',
				name:'outageDeviceTableDelete',
				label:'删除选中行',
				on_click:cap.deleteSelectRowByButton,
				mark:'outageDeviceTable'
			},
            outageDeviceTableLabel:{
            	uitype:'Label',
            	name:'outageDeviceTableLabel',
            	value:'停电设备：'
            },
            outageDeviceTable:{
            	uitype:"EditableGrid",
            	name:'outageDeviceTable',
            	databind:'data.outageDeviceTableList',
                datasource: cap.editGridDatasource,
                primarykey: "id",
                gridwidth:800,
                gridheight:300,
                tablewidth:800,
                adaptive:false,
                pagination:false,
                colhidden:false,
                //submitdata: save,
                columns:[
					{renderStyle:"text-align: center",bindName:"1",name:"<span style='font-weight:bold'>序号</span>"},
                    {renderStyle:"text-align: left",bindName:"depertment",name:"<span style='font-weight:bold'>管理部门</span>"},
                    {renderStyle:"text-align: left",bindName:"substation",name:"<span style='font-weight:bold'>变电站</span>"},
                    {renderStyle:"text-align: left",bindName:"line",name:"<span style='font-weight:bold'>线路</span>"},
                    {renderStyle:"text-align: center",bindName:"device",name:"<span style='font-weight:bold'>设备类型</span>"},
                    {renderStyle:"text-align: center",render:"renderEditGridDeleteOperator",name:'<a title="添加" style="cursor:pointer" onclick="cap.insertRowByIcon(\'outageDeviceTable\')"><span class="cui-icon" style="font-size:12pt;color:#545454">&#xf067;</span></a>'}
                ],
                selectrows:"multi",
                edittype: {
                    "depertment" : {
                        uitype: "Input",
                        validate: [
                            {
                                type: 'required',
                                rule: {
                                    m: '管理部门不能为空'
                                }
                            }
                        ]
                    },
                    "substation": {
                    	uitype: "Input"
                    },
                    "line": {
                    	uitype: "Input"
                    },
                    "device": {
                        uitype: "PullDown",
                        mode: "Single",
                        datasource: [
                            {id: "1", text: "变电站"},
                            {id: "2", text: "杆塔"},
                            {id: "3", text: "绝缘子"}
                        ]
                    }
                }
            },
            requeryTableInsert:{
				uitype:'Button',
				name:'requeryTableInsert',
				label:'新增行',
				on_click:cap.insertRowByButton,
				mark:'requeryTable'
			},
			requeryTableDelete:{
				uitype:'Button',
				name:'requeryTableDelete',
				label:'删除选中行',
				on_click:cap.deleteSelectRowByButton,
				mark:'requeryTable'
			},
			requeryTableLabel:{
            	uitype:'Label',
            	name:'requeryTableLabel',
            	value:'对系统要求：'
            },
            requeryTable:{
            	uitype:"EditableGrid",
            	name:'requeryTable',
            	databind:'data.requeryTableList',
                datasource: cap.editGridDatasource,
                primarykey: "id",
                gridwidth:800,
                gridheight:300,
                tablewidth:800,
                adaptive:false,
                pagination:false,
                colhidden:false,
                //submitdata: save,
                columns:[
					{renderStyle:"text-align: center",bindName:"1",name:"<span style='font-weight:bold'>序号</span>"},
                    {renderStyle:"text-align: left",bindName:"requery",name:"<span style='font-weight:bold'>对系统要求</span>"},
                    {renderStyle:"text-align: center",render:"renderEditGridDeleteOperator",name:'<a title="添加" style="cursor:pointer" onclick="cap.insertRowByIcon(\'requeryTable\')"><span class="cui-icon" style="font-size:12pt;color:#545454">&#xf067;</span></a>'}
                ],
                selectrows:"multi",
                edittype: {
                    "requery" : {
                        uitype: "Input",
                        validate: [
                            {
                                type: 'required',
                                rule: {
                                    m: '对系统要求不能为空'
                                }
                            }
                        ]
                    }
                }
            }
        }
        

    </script>
</head>
<body style="background-color:#f5f5f5;">
<div class="cap-page" style="width:1280px;">
	<table class="cap-table-fullWidth">
	    <tr>
	        <td class="cap-td" style="text-align: left;">
	        	<span id="pageArea" uitype="Label" value="页面区域" class="cap-label-title"></span>
	        </td>
	    </tr>
	</table>
	<div class="cap-area" style="width:1024px;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="停电申请编制" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="open" uitype="Button"></span>
		        	<span id="insert" uitype="Button"></span>
		        	<span id="save" uitype="Button"></span>
		        	<span id="saveContinue" uitype="Button"></span>
		        	<span id="back" uitype="Button"></span>
		        	<c:if test="${form.code=='aaa111'}">
		        	<span id="close" uitype="Button"></span>
		        	</c:if>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>基本信息</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td>
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<font color="red">*</font>
					        	<span id="codeLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="code" uitype="Input" ></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="workPlanIdLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="workPlanId" uitype="Input" ></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="applyDateLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="applyDate" uitype="Calender" ></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="outageReasonTypeLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="outageReasonType" uitype=PullDown ></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="overhaulTypeLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="overhaulType" uitype="PullDown" ></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="isNeedInsideLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="isNeedInside" uitype=RadioGroup ></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="longTimeOutageReasonLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="longTimeOutageReason" uitype="RadioGroup"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="notTurnpowerReasonLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
					        	<span id="notTurnpowerReason" uitype=CheckboxGroup ></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="notInMonplanReasonLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:85%" colspan="3">
								您还能输入<span id="notInMonplanReasonRelation" style="color:red"></span>个字符<br>
					        	<span id="notInMonplanReason" uitype="Textarea" ></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="planPeopleLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
								<span id="planPeopleId" uitype="ChooseUser"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:15%">
					        	<span id="planDepartmentLabel" uitype="Label"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
								<span id="planDepartmentId" uitype="ChooseOrg"></span>
					        </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>转供电信息</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: right;width:100%" colspan=2>
		        	<span id="outageDeviceTableInsert" uitype="Button"></span>
		        	<span id="outageDeviceTableDelete" uitype="Button"></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: right;width:15%">
		        	<font color="red">*</font>
		        	<span id="outageDeviceTableLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="width:85%">
		        	<table id="outageDeviceTable" uitype="EditableGrid"></table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>停电影响信息</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: right;width:100%" colspan=2>
		        	<span id="requeryTableInsert" uitype="Button"></span>
		        	<span id="requeryTableDelete" uitype="Button"></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: right;width:15%">
		        	<font color="red">*</font>
		        	<span id="requeryTableLabel" uitype="Label"></span>
		        </td>
		        <td class="cap-td" style="width:85%">
		        	<table id="requeryTable" uitype="EditableGrid"></table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>附件</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;width:15%">
		        </td>
		        <td class="cap-td" style="text-align: left;width:85%">
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>