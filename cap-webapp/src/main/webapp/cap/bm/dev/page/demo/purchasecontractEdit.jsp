
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
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" />
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/css/table-layout.css" />
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>
	<!-- Action相关联JS  -->
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/PurchaseContractEditiAction.js'></script>
	
	
<script type="text/javascript">
	//页面参数自动生成JavaScript变量
	var stringAttr="<%=request.getAttribute("stringAttr")%>";
	var intAttr=<%=request.getAttribute("intAttr")%>;
	var verifyAttr=<%=request.getAttribute("verifyAttr")%>;

	//页面控件属性配置
	var uiConfig = {
			saveData:{
				uitype:'Button',
                name:'saveData',
                label:'&nbsp;保&nbsp;存&nbsp;'
			},
			contractBackBtn:{
				uitype:'Button',
                name:'contractBackBtn',
                label:'&nbsp;返&nbsp;回&nbsp;'
			},
			csgContractCode:{
				uitype:'Input',
				databind:'data.csgContractCode',    //将控件与数据模型中的属性绑定
				validate:[
		                    {'type':'required', 'rule':{m: '合同编码不能为空'}}
		                ]
			},
            contractCode:{
				uitype:'Input',
				databind:'data.contractCode',
				validate:[
		                    {'type':'required', 'rule':{m: '合同编号不能为空'}},
		                    {'type':'length', 'rule':{max:20,maxm: '合同编号小余20个字符'}},
		                ]
			},
			contractName:{
				uitype:'Input',
				databind:'data.contractName',
				validate:[
		                    {'type':'required', 'rule':{m: '合同名称不能为空'}}
		                ]
			},
			contractType:{
                uitype: "PullDown",
                mode: "Single",
                databind:'data.contractType',
                value: '-1',
                readonly: true,
                datasource: [
                    {id:'-1',text:'一级采购合同'},
                    {id:'1',text:'省公司组织采购合同'},
                    {id:'2',text:'授权地市局（厂）采购合同'},
                    {id:'3',text:'历史三方合同'}
                ],
                validate:[
		                    {'type':'required', 'rule':{m: '合同类型不能为空'}}
		                ]
            },
            projectKind:{
                uitype: "PullDown",
                mode: "Single",
                empty_text: "--请选择--",
                databind:'data.projectKind',
                datasource: [
                    {id:'1',text:'重点项目合同'},
                    {id:'2',text:'重点设备合同'}
                ]
            },
            creatorPhone:{
                uitype: "Input",
                databind:'data.creatorPhone',
                validate:[
		                    {'type':'required', 'rule':{m: '合同起草人电话不能为空'}}
		                ]
            },
            contractTemplateName:{
                uitype: "Input",
                databind:'data.contractTemplateName',
                validate:[
		                    {'type':'required', 'rule':{m: '合同模板名称不能为空'}}
		                ]
            },
            contractObject:{
                uitype: "ClickInput",
                databind:'data.contractObject',
                validate:[
		                    {'type':'required', 'rule':{m: '合同物资目录不能为空'}}
		                ]
            },
            agentName:{
                uitype: "ClickInput",
                databind:'data.agentName'
            },
            deliveryDateStart:{
            	uitype: 'Calender',
                databind:'data.deliveryDateStart'
            },
            deliveryDate:{
            	uitype: 'Calender',
                databind:'data.deliveryDate'
            },
            deliverySpot:{
                uitype: "Input",
                databind:'data.deliverySpot'
            },
            isStandard:{
            	 uitype: "RadioGroup",
                 databind:'data.isStandard',
                 radio_list: [{
                     text: '否',
                     value: '0'
                 },{
                     text: '是',
                     value: '1'
                 }],
            },
            needTechCode:{
            	 uitype: "RadioGroup",
                 databind:'data.needTechCode',
                 radio_list: [{
                     text: '否',
                     value: '0'
                 },{
                     text: '是',
                     value: '1'
                 }]
            },
            orgDeptId:{
            	 uitype: "Input",
            	 databind:'data.orgDeptId'
            },
            remark:{
            	 uitype: 'Textarea',     //组件类型
           		 relation: 'remark_text',           //剩余可输入字符数显示的元素ID
           		 maxlength: 400,
            	 databind:'data.remark'
            },
            projectName:{
            	 uitype: "Input",
            	 databind:'data.projectName'
            },
            localProjectCode:{
           	 uitype: "Input",
        	 databind:'data.localProjectCode'
        	},
        	uniqueProjectCode:{
           	 uitype: "Input",
        	 databind:'data.uniqueProjectCode'
        	},
        	subprojectName:{
           	 uitype: "Input",
        	 databind:'data.subprojectName'
        	},
        	projectType:{
           	 uitype: "SinglePullDown",
        	 databind:'data.projectType'
        	},
        	voltageLevel:{
           	 uitype: "SinglePullDown",
        	 databind:'data.voltageLevel'
        	},
        	produceDate:{
           	 uitype: "Input",
        	 databind:'data.produceDate'
        	},
        	buildAddress:{
           	 uitype: "Input",
        	 databind:'data.buildAddress'
        	},
        	designer:{
           	 uitype: "Input",
        	 databind:'data.designer'
        	},
        	designerContactMan:{
           	 uitype: "Input",
        	 databind:'data.designerContactMan'
        	},
        	designerContactPhone:{
           	 uitype: "Input",
        	 databind:'data.designerContactPhone'
        	},
        	requireCompany:{
           	 uitype: "Input",
        	 databind:'data.requireCompany'
        	},
        	reqCorrespondAddress:{
           	 uitype: "Input",
        	 databind:'data.reqCorrespondAddress'
        	},
        	reqPostalcode:{
           	 uitype: "Input",
        	 databind:'data.reqPostalcode'
        	},
        	reqContactMan:{
           	 uitype: "Input",
        	 databind:'data.reqContactMan'
        	},
        	reqContactPhone:{
           	 uitype: "Input",
        	 databind:'data.reqContactPhone'
        	},
        	reqFaxPhone:{
           	 uitype: "Input",
        	 databind:'data.reqFaxPhone'
        	}
		}
		
	    //页面对应数据模型
	 	var data={csgContractCode:'',contractCode:'合同编号',contractName:'采购合同名称',contractType:1,projectKind:1,
			creatorPhone:'合同起草人电话',contractTemplateName:'合同模板名称',contractObject:'合同物资目录',agentName:'代理商名称',
			deliveryDateStart:'2015-05-12',deliveryDate:'2015-06-01',deliverySpot:'交货地点',isStandard:'0',needTechCode:'0',orgDeptId:'合同承办部门'
				};

        function initData(gridObj,query){
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

        /*
        * 通过uiConfig databind属性设置数据绑定
        */
        function initDataBind(){
            for(var item in uiConfig){
                if(uiConfig[item].databind){
                    var bindObject=uiConfig[item].databind.split(".")[0];
                    var bindName=uiConfig[item].databind.split(".")[1];
                    cui(window[bindObject]).databind().addBind('#'+item, bindName);
                }
            }
        }

        /**
         * 根据模型生成校验
         */
        var validater = cui().validate();
        function initValidate(){
            /*var validateRule=[
             {'type':'required', 'rule':{m: '缺陷名称不能为空'}},
             {'type':'length', 'rule':{max:3,maxm: '缺陷名称小余3个字符'}},
             {'type':'numeric', 'rule':{'oi':true,'notim':'学号必是数字'}},
             {'type':'numeric', 'rule':{'min':5.4,'max':10.2,minm:'学号应该大于等于5.4',maxm:'学号应该小余等于10'}},
             {'type':'format', 'rule':{pattern: '(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)',m: 'IP输入不合法'}},
             {'type':'custom', 'rule':{against:'input_custom_validate',m:'输入的学号必须大于10000'}}
             ]*/

            for(var item in uiConfig){
                if(uiConfig[item].validate){
                    for(var validateNode in uiConfig[item].validate){
                        var vl=uiConfig[item].validate[validateNode];
                        validater.add(item, vl.type, vl.rule);
                    }
                }
            }


        }

        //自定义验证方法
        function input_custom_validate(value){
            if(value>10000){
                return true;
            }else{
                return false;
            }
        }

        /**
         * 弹出校验错误信息
         */
        function alertValidateMessage(){
        	var validOjb=validater.validAllElement();
            var validateResult=validOjb[2];
            var validateMessage=validOjb[0];
            var str="";
            if(!validateResult){
                for(var i=0;i<validateMessage.length;i++){
                    str=str+validateMessage[i].message;
                }
                cui.error(str);
            }
        }
        
        // state 1:编辑  2：只读  3：隐藏
        var pageState={
       		tempCheck:{
       			button:{
    				state:1,
    				isValidate:false
                },
                input:{
	   				state:2,
	   				isValidate:false
                }
       		}
        }
        
        //切换页面状态
        function changePageState(stateName){
        	var uiList=pageState[stateName];
        	for(var id in uiList){
        		
        		//设置控件状态
        		if(uiList[id].state==1){
        			cui('#'+id).show();
        			cui('#'+id).setReadonly(false);
        		}else if(uiList[id].state==2){
        			cui('#'+id).show();
        			cui('#'+id).setReadonly(true);
        		}else if(uiList[id].state==3){
        			cui('#'+id).hide();
        		}
        		
        		//设置控件是否校验
        		if(uiList[id].isValidate){
        			validater.disValid(id, false);
        		}else{
        			validater.disValid(id, true);
        		}
        	}
        }
        
      	//页面初始过程
        function pageInit(){
        	comtop.UI.scan();
            initDataBind();
            initValidate();
            //设置页面到初始化状态
            pageInitState();
        }
        
        //页面初始化状态
        function pageInitState(){
        	if(verifyAttr){
        		cui('#button').hide();
        		cui('#button').show();
        		cui('#button').setReadonly(true);
        		cui('#button').setReadonly(false);
        	}
        }
        
      	//页面初始化行为
        function pageInitAction(){
	         /* 	PurchaseContractEditiAction.readFormById(stringAttr,function(data){
        		cui(window['data']).databind().setValue(data); */
         		pageInit();
				/* });  */
        }
        
        //页面行为绑定页面参数
        function readFormById(){
        	var validOjb=validater.validAllElement();
            var validateResult=validOjb[2];
            var validateMessage=validOjb[0];
            var str="";
            if(!validateResult){
                for(var i=0;i<validateMessage.length;i++){
                    str=str+validateMessage[i].message;
                }
               cui.error(str);
            }else{
	        	PurchaseContractEditiAction.readFormById(stringAttr,function(data){
	        		cui(window['data']).databind().setValue(data);
				});
            }
		}
        
		//页面行为绑定页面参数
		function insertForm(){
		   // FormAction.insertForm(cui(window['data']).databind().getValue(),function(data){
		   // 	alert(data);
			//});
		}

        jQuery(document).ready(function(){
        	pageInitAction();
        });

        function testDataBind(){
            console.log(data);
        }
	
<!--  自定义JS函数 开始  -->
	function openShutManager(oSourceObj,oTargetObj,shutAble,oOpenTip,oShutTip){  
		var sourceObj = typeof oSourceObj == "string" ? document.getElementById(oSourceObj) : oSourceObj;  
		var targetObj = typeof oTargetObj == "string" ? document.getElementById(oTargetObj) : oTargetObj;  
		var openTip = oOpenTip || "";  
		var shutTip = oShutTip || "";  
		if(targetObj.style.display!="none"){   
		   if(shutAble) return;  
	   	   		targetObj.style.display="none";  
	   		if(openTip  &&  shutTip){  
   			   sourceObj.innerHTML = shutTip;   
	   		}  
		} else {  
	   		targetObj.style.display="block";  
	  		if(openTip  &&  shutTip){  
	    		sourceObj.innerHTML = openTip;   
	   		}  
		}  
	}

<!--  自定义JS函数 结束  -->
</script>
</head>
<body>
	<table class="table">
		<tr>
			<td style="vertical-align: top; width: 100%;">
				<table>
					<tr>
						<td colspan="3" class="table_title">
							<span class="title_naviga_linkpictrue"></span> &nbsp;合同信息&nbsp; <span style="width: 94%; height: 1px;"></span>
						</td>
						<td colspan="3" >
							<span id="saveData" uiType="Button" onclick="readFormById()"></span>
							<span id="contractBackBtn" uiType="Button"></span>
						</td>
					</tr>
					<tr>
						<td>
							<font color="red" id="contractCodeTitleStyle">*</font>合同编码：
						</td>
						<td >
							<span id="csgContractCode" uitype="Input" ></span>
						</td>
						<td >
						<font color="red" id="contractIdTitleStyle">*</font>合同编号：</td>
						<td >
							<span id="contractCode" uitype="Input"></span>
						</td>
						<td ><font color="red">*</font>合同名称：</td>
						<td >
							<span id="contractName" uitype="Input"></span>
						</td>
					</tr>
					<tr>
						<td ><font color="red">*</font>合同类别：</td>
						<td >
							<span id="contractType" name="contractType" uitype="SinglePullDown"></span>
						</td>
						<td >合同性质：</td>
						<td >
							<span id="projectKind" name="projectKind" uitype="SinglePullDown"></span>
						</td>
						<td ><font color="red">*</font>合同起草人电话：</td>
						<td >
							<span id="creatorPhone" uitype="Input"></span>
						</td>
					</tr>
					<tr>
						<td ><font color="red"
							id="contractIdTitleStyle">*</font>合同模板名称：</td>
						<td >
							<span id="contractTemplateName" uitype="Input"></span>
						</td>
						<td ><font color="red">*</font>合同物资目录：</td>
						<td >
							 <span id="contractObject" uitype="ClickInput" ></span>
						</td>
						<td></td>
						<td>
						</td>
					</tr>
					<tr>
						<td >代理商名称：</td>
						<td >
							<span id="agentName" uitype="ClickInput"></span>
						</td>
						<td ><font color="red">*</font>交货日期：</td>
						<td  colspan="3" style="width: 500px;">
							<span id="deliveryDateStart" uitype="Calender"  name="deliveryDateStart" emptytext="请填写交货日期"  validate="交货日期不能为空"></span>
				            <span id ="deliveryDateContent">
				             &nbsp;至     
				             </span>
				            <span id="deliveryDate" uitype="Calender" name="deliveryDate" emptytext="请填写交货日期"  validate="交货日期不能为空"></span>
						</td>
					</tr>

					<tr>
						<td >交货地点：</td>
						<td >
							<span id="deliverySpot" uitype="Input"></span>
						</td>
						<td >是否标准合同：</td>
						<td >
							<span id="isStandard" uitype="RadioGroup" name="isStandard" ></span>	                        	
						</td>
						<td ><font color="red">*</font>是否提交技术协议：</td>
						<td >
							<span id="needTechCode" uitype="RadioGroup" name="needTechCode"  validate="是否提交技术协议不能为空"></span>	
						</td>
					</tr>
					<tr>
						<td ><font color="red">*</font>合同承办部门：</td>
						<td  colspan="5">
							<span uitype="Input" id="orgDeptId"  idName="deptId"></span>
						</td>
					</tr>
					<tr>
						<td colspan="6">
							<table class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;" onclick="openShutManager('this','projectInfo',false)">
													&nbsp;工程建设信息、设计单位信息&nbsp;
									</td>
								</tr>
								<tr  id="projectInfo"  style="display:none">
									<td>
										<table>
											<tr>
												<td >项目名称：</td>
												<td >
													<span id="projectName" uitype="Input" ></span>
												</td>
												<td >地市局(厂)项目编号：</td>
												<td >
													<span id="localProjectCode" uitype="Input"></span>
												</td>
												<td >项目编号：</td>
												<td >
													<span id="uniqueProjectCode" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >单项工程名称：</td>
												<td >
													<span id="subprojectName" uitype="Input"></span>
												</td>
												<td >项目类型：</td>
												<td >
													 <span id="projectType" name="projectType" qtype="cui" uitype="SinglePullDown" mode="Multi" databind="" datasource="" empty_text="请选择"></span>
												</td>
												<td >电压等级：</td>
												<td >
													<span id="voltageLevel" name="voltageLevel" qtype="cui" uitype="SinglePullDown" mode="Multi"  empty_text="请选择" ></span>
												</td>
											</tr>
											<tr>
												<td >投产日期：</td>
												<td >
													<span id="produceDate" uitype="Input"></span>
												</td>
												<td >建设地点：</td>
												<td >
													<span id="buildAddress" uitype="Input"></span>
												</td>
												<td >设计单位：</td>
												<td >
													<span id="designer" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >设计单位联系人：</td>
												<td >
													<span id="designerContactMan" uitype="Input"></span>
												</td>
												<td >设计单位联系电话：</td>
												<td  colspan="3">
													<span id="designerContactPhone" uitype="Input"></span>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;"  onclick="openShutManager('this','requireInfo',false)">
													&nbsp;需方信息&nbsp;
									</td>
								</tr>
								<tr  id="requireInfo"  style="display:none">
									<td>
										<table>
											<tr>
												<td colspan="6" style="vertical-align: top; width: 100%;">
											</tr>
											<tr>
												<td >需方单位：</td>
												<td >
													<span id="requireCompany" uitype="ClickInput" label="请选择收货单位" icon="th-list" onclick="selectContractPart('')" databind="" ></span>
												</td>
												<td >通信地址：</td>
												<td >
													<span id="reqCorrespondAddress" uitype="Input"></span>
												</td>
												<td >邮政编码：</td>
												<td >
													<span id="reqPostalcode" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >联系人：</td>
												<td >
													<span id="reqContactMan" uitype="Input"></span>
												</td>
												<td >联系人电话：</td>
												<td >
													<span id="reqContactPhone" uitype="Input"></span>
												</td>
												<td >传真电话：</td>
												<td >
													<span id="reqFaxPhone" uitype="Input"></span>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;"  onclick="openShutManager('this','reportInfo',false)">
									<span class="title_naviga_linkpictrue"></span>&nbsp;中标成交通知书信息<span
													style="width: 88.2%; height: 1px;"></span>
									</td>
								</tr>
								<tr id="reportInfo" style="display:none">
									<td>
										<table >
											<tr>
												<td  colspan="6"> 中标通知书信息iframe</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;"   onclick="openShutManager('this','purchaseInfo',false)">
										<span class="title_naviga_linkpictrue"></span>&nbsp;采购信息<span style="width: 94%; height: 1px;"></span>
									</td>
								</tr>
								<tr id="purchaseInfo" style="display:none">
									<td>
										<table>
											<tr>
												<td  colspan="6">采购信息iframe</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;"   onclick="openShutManager('this','receiptInfo',false)">
										<span class="title_naviga_linkpictrue"></span> &nbsp;收货、结算单位信息 <span style="width: 89%; height: 1px;"></span>
									</td>
								</tr>
								<tr id="receiptInfo" style="display:none">
									<td>
										<table>
											<tr>
												<td >收货单位：</td>
												<td >
													<span id="receiverCompany" uitype="ClickInput" label="请选择收货单位" icon="th-list" onclick="selectContractPart('')" databind="" ></span>
												</td>
												<td >收货单位联系人：</td>
												<td >
													<span id="receiverContactMan" uitype="Input"></span>
												</td>
												<td >收货单位联系电话：</td>
												<td >
													<span id="receiverContactPhone" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >结算单位：</td>
												<td >
													<span id="settlement" uitype="ClickInput" label="请选择结算单位" icon="th-list" onclick="selectContractPart('')" databind=""></span>
												</td>
												<td >结算方联系人：</td>
												<td >
													<span id="settlementContactMan" uitype="Input"></span>
												</td>
												<td >结算方联系电话：</td>
												<td >
													<span id="settlementContactPhone" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >结算方开户银行：</td>
												<td >
													<span id="settlementBank" uitype="Input"></span>
												</td>
												<td >结算方结算账号：</td>
												<td >
													<span id="settlementAccount" uitype="Input"></span>
												</td>
												<td >结算方税号：</td>
												<td >
													<span id="settlementTaxcode" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >结算方账户名称：</td>
												<td >
													<span id="settlementAccountName" uitype="Input"></span>
												</td>
												<td >结算方法人代表：</td>
												<td  colspan="3">
													<span id="settlementLegalRepresentative" uitype="Input"></span>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table cellspacing="0" cellpadding="0" class="table">
								<tr>
									<td style="vertical-align: top; width: 100%;"  onclick="openShutManager('this','vendorInfo',false)">
										<span class="title_naviga_linkpictrue"></span> &nbsp;供方信息 <span style="width: 94%; height: 1px;"></span>
									</td>
								</tr>
								<tr  id="vendorInfo" style="display:none">
									<td>
										<table>
											<tr>
												<td >通信地址：</td>
												<td >
													<span id="supplyCorrespondAddress" uitype="Input"></span>
												</td>
												<td >联系人：</td>
												<td >
													<span id="supplyContactMan" uitype="ClickInput"></span>
												</td>
												<td >联系电话：</td>
												<td >
													<span id="supplyContactPhone" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >传真电话：</td>
												<td >
													<span id="supplyFaxPhone" uitype="Input"></span>
												</td>
												<td >开户银行：</td>
												<td >
													<span id="supplySettlementBank" uitype="ClickInput" label="请选择开户银行" icon="th-list" onclick="editBank()" databind=""></span>
												</td>
												<td >账户名称：</td>
												<td >
													<span id="supplySettlementAccountName" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >结算账户：</td>
												<td >
													<span id="supplySettlementAccount" uitype="Input"></span>
												</td>
												<td >邮政编码：</td>
												<td >
													<span id="supplyPostalcode" uitype="Input"></span>
												</td>
												<td >法人代表：</td>
												<td >
													<span id="supplyLegalRepresentative" uitype="Input"></span>
												</td>
											</tr>
											<tr>
												<td >税号：</td>
												<td  colspan="5">
													<span id="supplyTaxCode" uitype="Input"></span>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td >备注：<br> 您还能输入 <span id="remark_text"></span>个字符
						</td>
						<td  colspan="5">
							 <span id="remark" uitype="Textarea"></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>