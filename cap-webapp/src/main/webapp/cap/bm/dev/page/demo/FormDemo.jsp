<%
/**********************************************************************
* 示例页面
* 2015-5-13 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CUI控件占位和定义分离</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/css/table-layout.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>
</head>
<body>
<table class="table">
    <tbody>
        <tr>
            <td class="cell" style="font-weight:bold;width:50%;text-align:left;">
                <span id="title" uitype="Label"></span>
            </td>
            <td class="cell"style="font-weight:bold;width:50%;text-align:right;">
                <span id="pullbtn" uitype="Button"></span>
                <span id="printbtn" uitype="Button"></span>
                <span id="previewbtn" uitype="Button"></span>
                <span id="savebtn" uitype="Button"></span>
                <span id="submitbtn" uitype="Button"></span>
                <span id="returnbtn" uitype="Button"></span>
            </td>
        </tr>
    </tbody>
</table>
<table class="table">
    <tbody>
        <tr>
            <td class="cell" style="width:100%">
                <table class="customform">
                    <tbody>
                        <tr>
                            <td style="width:8%;text-align:right;padding:5px 7px;"><span id="orderNumLabel" uitype="Label"></span></td>
                            <td style="width: 25%;padding:5px 7px;"><span id="orderNum" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">入库类型：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="orderType" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">合同编号：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="contractNum" uitype="Input"></span></td>
                        </tr>   
                        <tr>    
                            <td style="width:8%;text-align:right;padding:5px 7px;">采购单号：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="purchaseNum" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">预算情况：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="budget" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">供应商：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="provider" uitype="Input"></span></td>
                        </tr>   
                        <tr>    
                            <td style="width:8%;text-align:right;padding:5px 7px;">制单人：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="creator" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">制单时间：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="creatTime" uitype="Input"></span></td>
                            <td style="width:8%;text-align:right;padding:5px 7px;">存放仓库：</td>
                            <td style="width: 25%;padding:5px 7px;"><span id="warehouse" uitype="Input"></span></td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </tbody>
</table>
<table class="table">
    <tbody>
        <tr>
            <td class="cell" style="width: 8%;text-align:right;">
                统签统付:
            </td>
            <td class="cell" style="width: 92%;">
                <span id="sign" uitype="RadioGroup"></span>
            </td>
        </tr>
        <tr>
            <td class="cell" style="height:40px;text-align:right;">
                备注:
            </td>
            <td class="cell">
                <span id="remark" uitype="Textarea"></span>
            </td>
        </tr>
        <tr>
            <td class="cell" colspan="2">
                注：标有*为必填项
            </td>
			<td>
			</td>
        </tr>
    </tbody>
</table>
<table class="table">
    <tbody>
        <tr>
            <td class="cell" style="width:100%">
                入库登记明显列表
            </td>
        </tr>
        <tr>
            <td class="cell" style="text-align:right;">
                <span id="suggestbtn" uitype="Button"></span>
                <span id="importbtn" uitype="Button"></span>
                <span id="detailSavebtn" uitype="Button"></span>
                <span id="detailDelbtn" uitype="Button"></span>
                <span id="detailBatchSetbtn" uitype="Button"></span>
            </td>
        </tr>
    </tbody>
</table>
<table class="table">
    <tbody>
        <tr>
            <td class="cell"  style="width:100%">
                <table id="orderGrid" uitype="Grid"></table>
            </td>
        </tr>
        <tr>
            <td class="cell">
                注：表示属于计量物资。表示计量物资入库数量等于选择的实物数量。表示计量物资入库数量不等于选择的实物数量
            </td>
        </tr>
    </tbody>
</table>
<script type="text/javascript">
    var tdOption = {
        width:"",
        height:"",
        "text-align":'left',
        padding:"5px",
        margin:'0'
    }

    function initData(gridObj,query){
        gridObj.setDatasource(gridData.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), 150);
    }
	var uiConfig ={
        "title":{uitype:"Label",value:"入库单编辑"},
        "pullbtn":{uitype:"Button",label:"入库单(4A)"},
        "printbtn":{uitype:"Button",label:"打印"},
        "previewbtn":{uitype:"Button",label:"预览验收单"},
        "savebtn":{uitype:"Button",label:"保存"},
        "submitbtn":{uitype:"Button",label:"上报"},
        "returnbtn":{uitype:"Button",label:"返回"},
        "orderNumLabel":{uitype:"Label",value:"入库单号："},
        "orderNum":{uitype:"Input"},
        "orderType":{uitype:"Input"},
        "contractNum":{uitype:"Input"},
        "purchaseNum":{uitype:"Input"},
        "budget":{uitype:"Input"},
        "provider":{uitype:"Input"},
        "creator":{uitype:"Input"},
        "creatTime":{uitype:"Input"},
        "warehouse":{uitype:"Input"},
        "sign":{uitype:"RadioGroup",name:"sign",radio_list: [{
                    text: '非统签非统付',
                    value: '0'
                },{
                    text: '统签非统付',
                    value: '1'
                },{
                    text: '统签统付',
                    value: '2'
                }]
            },
        "remark":{uitype:"Textarea",name:"remark"},
        "suggestbtn":{uitype:"Button",label:"库位推荐"},
        "importbtn":{uitype:"Button",label:"导入"},
        "detailSavebtn":{uitype:"Button",label:"保存"},
        "detailDelbtn":{uitype:"Button",label:"删除"},
        "detailBatchSetbtn":{uitype:"Button",label:"批量设置入库明细信息"},
        "orderGrid":{
            uitype:'Grid',
            datasource:initData,
            primarykey:'ID',
            gridwidth:1200,
            gridheight:"300",
            tablewidth:1200,
            columns:[
                        {renderStyle:"text-align: center;",bindName:"info.name",render:"a",options:"{'url':'#'}",name:"姓名"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"info.class",name:"班级",hide:false,disabled:false},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chinese",name:"语文"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"english",name:"英语"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"politics",name:"政治"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"history",name:"历史"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"geography",name:"地理"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"math",name:"数学"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"physics",name:"物理"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"organisms",name:"生物"},
                        {renderStyle:"text-align: center;",sort:"true",bindName:"chemistry",name:"化学"} ]
        }
    }


    function renerUIconfig(config){
            var $ = comtop.cQuery;
            function s(name){
                if(typeof name ==="string"){
                    var first = name.substr(0,1).toLowerCase();
                    return first + name.substr(1,name.length-1);
                }
                return name;
            }

            function $invoke(obj, funcName , argsList){
                obj=obj||window;
                var func= obj[s(funcName)] ;
                if (typeof(func)=='function'){
                    return func.apply(obj,argsList||[] );
                }
            };
            $.each(config,function(key,item){
                $invoke(cui("#"+key),item.uitype,item);
            })
        }

    jQuery(document).ready(function(){
        comtop.UI.scan();
    });
</script>
</body>
</html>