<%
  /**********************************************************************
   * CAP自定义行为帮助-图例
   *
   * 2016-10-31 肖威 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html >
<head>
<title>自定义行为帮助</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/bootstrap/css/bootstrap.css" >
<script src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/jquery-3.1.0.min.js" ></script>
<script src="${pageScope.cuiWebRoot}/cap/bm/common/bootstrap/js/bootstrap.min.js" ></script>
<style type="text/css">
.carousel-control.left-nobackimage {
	top:50%;
}
.carousel-control.right-nobackimage {
  right: 0;
  left: auto;
  top:50%;
}

.carousel-indicators {
  position: absolute;
  bottom: 10px;
  left: 50%;
  z-index: 15;
  width: 60%;
  padding-left: 0;
  margin-left: -30%;
  text-align: center;
  list-style: none;
}
.carousel-indicators li {
  display: inline-block;
  width: 10px;
  height: 10px;
  margin: 5px;
  text-indent: -999px;
  cursor: pointer;
  background-color: #bcbcbc \9;
  background-color: rgba(188, 188, 1888, 100);
  border: 1px solid #bcbcbc;
  border-radius: 10px;
}

/* 鼠标悬浮在指示器上*/
.carousel-indicators li:hover {
  width: 12px;
  height: 12px;
  background-color: rgba(3,11,209,100,80);
}
/* 指示器获取焦点 */
.carousel-indicators .active {
  width: 12px;
  height: 12px;
  margin: 0;
  background-color: #036ed1;
}

</style>
</head>
<body>
	<!-- data-ride="carousel" 页面加载时就开始动画播放 -->
		<div id="myCarousel" class="carousel slide" data-ride="carousel" data-interval="false" >
			<!-- 轮播（Carousel）指标 -->
			<!-- 
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active" ></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
				<li data-target="#myCarousel" data-slide-to="3"></li>
			</ol>
			 -->
			<!-- 轮播（Carousel）项目 -->
			<div class="carousel-inner " >
				<div class="item active" >
					<img src="images/customComponentInfo1.png"  class="img-responsive center-block">
					<div class="carousel-caption"><font color="red" style="font-size: 20px;font-weight: bold;">第一步：填写自定义控件基础信息</font></div>
				</div>
				<div class="item" >
					<img src="images/customComponentInfo2.png"  class="img-responsive center-block">
					<div class="carousel-caption"><font color="red" style="font-size: 20px;font-weight: bold;">第二步：编辑自定义控件属性信息。其中labelType、width、height为固定属性。</font></div>
				</div>
				<div class="item" >
					<img src="images/customComponentInfo3.png" class="img-responsive center-block">
					<div class="carousel-caption"><font color="red" style="font-size: 20px;font-weight: bold;">第三步：编辑自定义控件行为</font></div>
				</div>
				<div class="item" >
					<img src="images/customComponentInfo4.png" class="img-responsive center-block">
					<div class="carousel-caption"><font color="red" style="font-size: 20px;font-weight: bold;">第四步：引入自定义控件依赖js、css</font></div>
				</div>
				<div class="item" >
					<img src="images/customComponentInfo5.png" class="img-responsive center-block">
					<div class="carousel-caption"><font color="red" style="font-size: 20px;font-weight: bold;">第五步：编辑自定义控件依赖js、css。自定义控件中必须添加初始化函数，初始化函数在页面渲染中使用。</font></div>
				</div>
			</div>
			<!-- 轮播（Carousel）导航  -nobackimage   style="background-color: rgba(123, 123, 123, .5); -->
			<a class="carousel-control left" href="#myCarousel" data-slide="prev" ">
				<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
	            <span class="sr-only">Previous</span>
			</a>
			<a class="carousel-control right" href="#myCarousel" data-slide="next" >
				<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
	            <span class="sr-only">Next</span>
            </a>
</body>
</html>