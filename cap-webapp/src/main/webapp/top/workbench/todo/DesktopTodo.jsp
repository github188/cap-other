<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>桌面待办</title>
<%//360浏览器指定webkit内核打开%>
<meta name="renderer" content="webkit">
<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/todo/css/todo.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
</head>
<body style="background-color:white">
<div id="list_id" ></div>
<!-- 定义模版 -->	
<script type="text/template" id="template_id">	
<@
	var length = dataSourceList.length;
	var leg = parseInt(length/8)+ (length % 8 > 0 ? 1 : 0);
@>
<@  if(length==0)  {@>
	<div style="text-align:center;font-size:12px;color:#888888;">暂无记录</div>
<@  }else{ @>
<div class="scroll-wrap">
	<div class="scroll-body">
		<@  if(leg>1)  {@>
		<a class="left-button" href="javascript:void(0);" >
      	</a>
		<@  } @>
		<div class="scroll-inner">
			<@ 
				for(var i=0;i<leg;i++){
			@>
			<ul class="scroll-item" id="scrollItem<@=i@>">
			<@  _.each(dataSourceList,function(item,index){  
				if(parseInt(index/8)==i){
			@>
				<li>
					<a hidefocus="true" style="border-color: <@=colorArray[index%8]@>;" href="javascript:void(0);" onclick="gotoTodoCenter('<@= item.todoId @>')">
						<strong style="height:25px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap" title="<@= item.todoName @>"><@= item.todoName @></strong>
						<span><@= item.todoCount @></span>
					</a>
				</li>
			<@ }});  @>
			</ul>
			<@ 
				}
			@> 
		</div>	
		<@  if(leg>1)  {@>
		<a class="right-button" href="javascript:void(0)" >
      	</a>
		<@  } @>
	</div>
	<div class="scroll-btn">
	</div>
</div>
<@}@>
</script>


<!-- 定义模版 -->	

<script language="javascript">

	function gotoTodoCenter(todoId){
		var url = '${pageScope.cuiWebRoot}/top/workbench/todo/TodoCenter.jsp?todoId='+todoId;
		window.parent.location.href = url;
	}

	var dataSourceList;
	//定义默认颜色
	var colorArray = ["#559701","#014EC2","#D58B0E","#7D54E1","#D38C0E","#CE5252","#32A6A5","#1C50AD"];
	
	require(['underscore','workbench/dwr/interface/DesktopTodoAction'], function() {
		
		DesktopTodoAction.queryTodoList(function(data) {
			dataSourceList = data.list;
			var html = _.template($("#template_id").html(), dataSourceList);
			$("#list_id").html(html);
			
			
			var $sList = $('#list_id .scroll-item'),
				$sInner = $('#list_id .scroll-inner'),
				$sBtns = $('#list_id .scroll-btn'),
				itemNum = $sList.length,
				index = 0,
				bodyWidth;
			
				init();
			
			function init(){
				setWidth();
				createButton();
				active(index);
			}
			
			//设置宽度
			function setWidth(){
				var width = bodyWidth = $('body').width();
				$sInner.width(width * itemNum).children('ul').width(width - 8);
			}
			
			//生成button
			function createButton(){
				var html = [];
				for(var i = 0; i < itemNum; i ++){
					html.push(
						'<a hidefocus="true" href="#" data-index="', i,'"></a>'		
					);
				}
				$sBtns.html(html.join(''));
				$sBtns.on('click.slide', function(e){
					var $t = $(e.target);
					if($t[0].nodeName === 'A'){
						active($t.data('index') - 0);
					}
					return false;
				});
			}
			
			//激活
			function active(i){
				index = i;
				$sBtns.children('a').removeClass('cur').eq(i).addClass('cur');
				animate(i);
			}
			
			//动画
			function animate(i){
				$sInner.animate({
					"left": - (bodyWidth * i)
				}, "slow");    
			}
			
			$(".scroll-inner,.left-button,.right-button").mouseover(function(){
				$(".left-button").css("display","block");
				$(".right-button").css("display","block");
			});
			
			$(".scroll-inner,.left-button,.right-button").mouseout(function(){
				$(".left-button").css("display","none");
				$(".right-button").css("display","none");
			});
		
			$('#list_id .left-button').on('click', function(e){
				index= index-1 < 0 ? 0 : index-1;
				active(index);
			});
			
			$('#list_id .right-button').on('click', function(e){
				index=index+1  > itemNum-1 ? itemNum-1 : index+1;
				active(index);
			});
			
			//重新计算宽度
			$(window).on('resize.slide', function(){
				setWidth();
				$sInner.css({
					left: -(bodyWidth* index)
				});
			});
		});
	});
</script>	
</body>
</html>












