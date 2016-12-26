<%
/**********************************************************************
* 示例页面
* 2015-6-23 业务组件示例 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>一些控件</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <!-- <link href="//cdn.bootcss.com/highlight.js/8.6/styles/darkula.min.css" rel="stylesheet"> -->
   </head>
<body>
<div uitype="Borderlayout" is_root="true" >
    <div position="left" width="200">
        左边区域
    </div>
    <div position="top" height="50" >
        <span style="line-height:50px;padding-left:20px">超大标题</span>
    </div>
    <div position="center">
        <span uitype="Input" emptytext="请选择"></span>
        <span id="pull" uitype="PullDown">
            <a value="1024px">1024px</a>
            <a value="1280px">1280px</a>
        </span>
        <!-- <span uitype="button" label="组件弹出树" on_click="showTree"></span>
        
        <pre><code class="javascript">
            //data为UI数据，fn为点击确定时候调用，参数node为选择的树的节点
            showDialog(data,function(node){
                    console.log(node);
                }); 
        </code>
        </pre>
        
        <span uitype="button" label="组件弹出树2" on_click="show"></span>
        <pre><code class="javascript">
        function show(){
            var top=(window.screen.availHeight-600)/2;
            var left=(window.screen.availWidth-800)/2;
            window.open ('../designer/TreeUI.jsp?packageId=com.comtop.fwms.defect.page.defectList','importExpressionWin','height=410,width=400,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
            }
           //点击确定获取选中数据，没选中为空数组[]
        function getSelectData(node){
            console.log(node); //数据为数组形式
        }
        </code>
        </pre> -->
    </div>
</div>

<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.all.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/treeui.js"></script>
<!-- <script src="//cdn.bootcss.com/highlight.js/8.6/highlight.min.js"></script>
<script src="//cdn.bootcss.com/highlight.js/8.6/languages/javascript.min.js"></script> 
<script type="text/javascript">hljs.initHighlightingOnLoad();console.log(hljs);</script>-->
<script type="text/javascript">
var data = [
            { title: "我不能被选择",  key: "k1",  unselectable: true },
            { title: "Folder 2", key: "k2", isFolder: true, children: [
            { title: "无形资产",  key: "k2-1" },
            { title: "有形资产",  key: "k2-2" , isFolder:true, children:[
            { title:"hello" }]
            }]
            },
            { title: "其他", key: "k3", hideCheckbox: true }
        ];

    function showTree(){
        showDialog(data,function(node){
            console.log(node);
        });        
	}
    
    function show(){
    	var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
    	window.open ('../designer/TreeUI.jsp?packageId=com.comtop.fwms.defect.page.defectList','importExpressionWin','height=420,width=400,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    }
    
    function getSelectData(node){
    	console.log(node);
    }
    comtop.UI.scan()
</script>
</body>
</html>