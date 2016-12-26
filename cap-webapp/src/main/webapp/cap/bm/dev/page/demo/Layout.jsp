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
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript">
        //页面控件属性配置
        var uiConfig={
            borderlayout: {
                uitype : "Borderlayout",
                is_root: false,
                gap : "0px 0px 0px 0px",
                resizable:true,
                fixed: {
                    "top": true,
                    "middle": false,
                    "left": true,
                    "center": false,
                    "right": true,
                    "bottom": true
                },
                items: [
                    {position:"top",height:100,url:""},
                    {position:"left",width:200,url:""},
                    {position:"center",height:100,url:"FormDemo.jsp" ,id:"panel"},
                    {position:"right",width:200,url:""},
                    {position:"bottom",height:100,url:""}
                ],
                on_sizechange: null
            },
            panel: {
                uitype: "Panel",
                header_title: "",
                width: 0,
                height: 0,
                url: "", // iframe
                html: "sdfd", // innerHTML/DOM Element; url,html只能选一个.
                on_change: null, // fn
                collapsible: true, // 是否可收缩
                status: 1, // 默认是展开的
                animate: "" // 动画,默认为""表示关闭动画; 可选值:"slide"为滑动效果;
            },
            tab: {
                uitype: "Tab",
                width: $($("table td").get(2)).width(),
                head_width:44,
                height: 0,
                tab_width:65,
                active_index: 0,
                tabs:  [
                    {
                        title: 'tab1',
                        html: "<div style='height:200px; background-color:#2489C5'>hello</div>"
                    },
                    {
                        title: 'tab2',
                        html: '这是tab内部内容，支持HTML'
                    }
                ],
                fill_height : false,
                reload_on_active: true, //激活时重新加载内容
                closeable: false, //是否可关闭
                trigger_type: "click"
            }
        }

        jQuery(document).ready(function(){
            comtop.UI.scan();
        });
    </script>
</head>
<body>
<table width="100%">
    <tr>
        <td style="height: 300px;">
            <span id="borderlayout" uitype="Borderlayout"></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="panel" uitype="Panel" ></span>
        </td>
    </tr>
    <tr>
        <td>
            <span id="tab" uitype="Tab"></span>
        </td>
    </tr>
</table>
</body>
</html>