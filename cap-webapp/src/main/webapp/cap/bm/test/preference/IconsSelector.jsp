<%
/**********************************************************************
* 图标选择界面
* 2016-6-23 lizhongwen 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>图标选择</title>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:link href="/cap/bm/test/css/icons.css"></top:link>
    <style>
	    html,
	    body {
	        background-color: #fff;
	        margin: 2px;
	    }
	    #icons-container:after{
	       	content: "."; 
	    	display: block;
	    	height: 0; 
	    	clear: both; 
	    	visibility: hidden; 
	    }
	    #icons-container{
	    	margin-left: 62px
	    }
	    .icon {
	        *display: inline;
	        *zoom: 1;
	        text-align: center;
	        cursor: pointer;
	        padding: 15px;
	        position: relative;
	        border: 1px #ccc solid;
	        margin: 5px 0 0 5px ;
	        float: left;
	    }
	    .icon .icon-img {
	        width: 36px;
	        height: 36px;
	        color: blue;
	        text-align: center;
	        background-size: 100% 100% !important;
	    }
	    .icon .icon-name {
	        font-family: 微软雅黑;
	        font-size: 10px
	    }
	    .icon:hover{
	        background-color: #aaa;
	    }
	    ul{
	    	position: fixed;
		    z-index: 1;
		    top: 0;
		    bottom: 0;
		    left: 0;
		    margin: auto;
		    padding: 0;
		    text-align: center;
	    }
	    
	    ul li{
	    	display: block;
		    height: 3.5em;
		    width: 4em;
		    line-height: 3.5em;
		    text-align: center;
		    position: relative;
		    border-bottom: 1px solid rgba(0,0,0,0.05);
		    -webkit-transition: background 0.1s ease-in-out;
		    -moz-transition: background 0.1s ease-in-out;
		    transition: background 0.1s ease-in-out;
		    cursor: pointer;
	    }
		.selected {
		    background: #47a3da;
		    color: #fff;
		}
    </style>
</head>

<body>
	<ul>
		<li onclick="filter('all')" class="selected">全部</li>
		<li onclick="filter('arrow')">箭头</li>
		<li onclick="filter('configure')">配置</li>
		<li onclick="filter('equipment')">设备</li>
		<li onclick="filter('gesture')">手势</li>
		<li onclick="filter('other')">其他</li>
	</ul>
    <section id="icons-container">
        <div class="icon" id="icon-add-square-button" data-img="add-square-button.png" type="configure">
            <div class="icon-img icon-add-square-button"></div>
            <!-- <div class="icon-name">add-square-button</div> -->
        </div>
        <div class="icon" id="icon-adjust-contrast" data-img="adjust-contrast.png" type="configure">
            <div class="icon-img icon-adjust-contrast"></div>
            <!-- <div class="icon-name">adjust-contrast</div> -->
        </div>
        <div class="icon" id="icon-align-justify" data-img="align-justify.png" type="configure">
            <div class="icon-img icon-align-justify"></div>
            <!-- <div class="icon-name">align-justify</div> -->
        </div>
        <div class="icon" id="icon-align-to-left" data-img="align-to-left.png" type="configure">
            <div class="icon-img icon-align-to-left"></div>
            <!-- <div class="icon-name">align-to-left</div> -->
        </div>
        <div class="icon" id="icon-align-to-right" data-img="align-to-right.png" type="configure">
            <div class="icon-img icon-align-to-right"></div>
            <!-- <div class="icon-name">align-to-right</div> -->
        </div>
        <div class="icon" id="icon-ambulance" data-img="ambulance.png">
            <div class="icon-img icon-ambulance"></div>
            <!-- <div class="icon-name">ambulance</div> -->
        </div>
        <div class="icon" id="icon-anchor-shape" data-img="anchor-shape.png">
            <div class="icon-img icon-anchor-shape"></div>
            <!-- <div class="icon-name">anchor-shape</div> -->
        </div>
        <div class="icon" id="icon-android-character-symbol" data-img="android-character-symbol.png" type="equipment">
            <div class="icon-img icon-android-character-symbol"></div>
            <!-- <div class="icon-name">android-character-symbol</div> -->
        </div>
        <div class="icon" id="icon-angle-arrow-down" data-img="angle-arrow-down.png" type="arrow">
            <div class="icon-img icon-angle-arrow-down"></div>
            <!-- <div class="icon-name">angle-arrow-down</div> -->
        </div>
        <div class="icon" id="icon-angle-arrow-pointing-to-right" data-img="angle-arrow-pointing-to-right.png" type="arrow">
            <div class="icon-img icon-angle-arrow-pointing-to-right"></div>
            <!-- <div class="icon-name">angle-arrow-pointing-to-right</div> -->
        </div>
        <div class="icon" id="icon-angle-pointing-to-left" data-img="angle-pointing-to-left.png" type="arrow">
            <div class="icon-img icon-angle-pointing-to-left"></div>
            <!-- <div class="icon-name">angle-pointing-to-left</div> -->
        </div>
        <div class="icon" id="icon-apple-logo" data-img="apple-logo.png" type="equipment">
            <div class="icon-img icon-apple-logo"></div>
            <!-- <div class="icon-name">apple-logo</div> -->
        </div>
        <div class="icon" id="icon-archive-black-box" data-img="archive-black-box.png">
            <div class="icon-img icon-archive-black-box"></div>
            <!-- <div class="icon-name">archive-black-box</div> -->
        </div>
        <div class="icon" id="icon-arrow-angle-pointing-down" data-img="arrow-angle-pointing-down.png" type="arrow">
            <div class="icon-img icon-arrow-angle-pointing-down"></div>
            <!-- <div class="icon-name">arrow-angle-pointing-down</div> -->
        </div>
        <div class="icon" id="icon-arrow-down-on-black-circular-background" data-img="arrow-down-on-black-circular-background.png" type="arrow">
            <div class="icon-img icon-arrow-down-on-black-circular-background"></div>
            <!-- <div class="icon-name">arrow-down-on-black-circular-background</div> -->
        </div>
        <div class="icon" id="icon-arrow-pointing-down" data-img="arrow-pointing-down.png" type="arrow">
            <div class="icon-img icon-arrow-pointing-down"></div>
            <!-- <div class="icon-name">arrow-pointing-down</div> -->
        </div>
        <div class="icon" id="icon-arrow-pointing-right-in-a-circle" data-img="arrow-pointing-right-in-a-circle.png" type="arrow">
            <div class="icon-img icon-arrow-pointing-right-in-a-circle"></div>
            <!-- <div class="icon-name">arrow-pointing-right-in-a-circle</div> -->
        </div>
        <div class="icon" id="icon-arrow-pointing-to-left" data-img="arrow-pointing-to-left.png" type="arrow">
            <div class="icon-img icon-arrow-pointing-to-left"></div>
            <!-- <div class="icon-name">arrow-pointing-to-left</div> -->
        </div>
        <div class="icon" id="icon-arrow-pointing-to-right" data-img="arrow-pointing-to-right.png" type="arrow">
            <div class="icon-img icon-arrow-pointing-to-right"></div>
            <!-- <div class="icon-name">arrow-pointing-to-right</div> -->
        </div>
        <div class="icon" id="icon-arrow-up-on-a-black-circle-background" data-img="arrow-up-on-a-black-circle-background.png" type="arrow">
            <div class="icon-img icon-arrow-up-on-a-black-circle-background"></div>
            <!-- <div class="icon-name">arrow-up-on-a-black-circle-background</div> -->
        </div>
        <div class="icon" id="icon-arrow-up" data-img="arrow-up.png" type="arrow">
            <div class="icon-img icon-arrow-up"></div>
            <!-- <div class="icon-name">arrow-up</div> -->
        </div>
        <div class="icon" id="icon-arrowhead-pointing-to-the-right" data-img="arrowhead-pointing-to-the-right.png" type="arrow">
            <div class="icon-img icon-arrowhead-pointing-to-the-right"></div>
            <!-- <div class="icon-name">arrowhead-pointing-to-the-right</div> -->
        </div>
        <div class="icon" id="icon-arrowhead-pointing-up-inside-a-square-box-outline" data-img="arrowhead-pointing-up-inside-a-square-box-outline.png" type="arrow">
            <div class="icon-img icon-arrowhead-pointing-up-inside-a-square-box-outline"></div>
            <!-- <div class="icon-name">arrowhead-pointing-up-inside-a-square-box-outline</div> -->
        </div>
        <div class="icon" id="icon-arrowheads-pointing-to-the-left" data-img="arrowheads-pointing-to-the-left.png" type="arrow">
            <div class="icon-img icon-arrowheads-pointing-to-the-left"></div>
            <!-- <div class="icon-name">arrowheads-pointing-to-the-left</div> -->
        </div>
        <div class="icon" id="icon-asterisk" data-img="asterisk.png" type="configure">
            <div class="icon-img icon-asterisk"></div>
            <!-- <div class="icon-name">asterisk</div> -->
        </div>
        <div class="icon" id="icon-ban-circle-symbol" data-img="ban-circle-symbol.png" type="configure">
            <div class="icon-img icon-ban-circle-symbol"></div>
            <!-- <div class="icon-name">ban-circle-symbol</div> -->
        </div>
        <div class="icon" id="icon-bar-graph-on-a-rectangle" data-img="bar-graph-on-a-rectangle.png" type="configure">
            <div class="icon-img icon-bar-graph-on-a-rectangle"></div>
            <!-- <div class="icon-name">bar-graph-on-a-rectangle</div> -->
        </div>
        <div class="icon" id="icon-barcode" data-img="barcode.png">
            <div class="icon-img icon-barcode"></div>
            <!-- <div class="icon-name">barcode</div> -->
        </div>
        <div class="icon" id="icon-beaker" data-img="beaker.png" type="equipment">
            <div class="icon-img icon-beaker"></div>
            <!-- <div class="icon-name">beaker</div> -->
        </div>
        <div class="icon" id="icon-beer-jar-black-silhouette" data-img="beer-jar-black-silhouette.png" type="equipment">
            <div class="icon-img icon-beer-jar-black-silhouette"></div>
            <!-- <div class="icon-name">beer-jar-black-silhouette</div> -->
        </div>
        <div class="icon" id="icon-bell-musical-tool" data-img="bell-musical-tool.png" type="equipment">
            <div class="icon-img icon-bell-musical-tool"></div>
            <!-- <div class="icon-name">bell-musical-tool</div> -->
        </div>
        <div class="icon" id="icon-bitbucket-logotype-camera-lens-in-perspective" data-img="bitbucket-logotype-camera-lens-in-perspective.png" type="equipment">
            <div class="icon-img icon-bitbucket-logotype-camera-lens-in-perspective"></div>
            <!-- <div class="icon-name">bitbucket-logotype-camera-lens-in-perspective</div> -->
        </div>
        <div class="icon" id="icon-bitbucket-sign" data-img="bitbucket-sign.png" type="equipment">
            <div class="icon-img icon-bitbucket-sign"></div>
            <!-- <div class="icon-name">bitbucket-sign</div> -->
        </div>
        <div class="icon" id="icon-bitcoin-logo" data-img="bitcoin-logo.png">
            <div class="icon-img icon-bitcoin-logo"></div>
            <!-- <div class="icon-name">bitcoin-logo</div> -->
        </div>
        <div class="icon" id="icon-blank-file" data-img="blank-file.png">
            <div class="icon-img icon-blank-file"></div>
            <!-- <div class="icon-name">blank-file</div> -->
        </div>
        <div class="icon" id="icon-bold-text-option" data-img="bold-text-option.png">
            <div class="icon-img icon-bold-text-option"></div>
            <!-- <div class="icon-name">bold-text-option</div> -->
        </div>
        <div class="icon" id="icon-book" data-img="book.png">
            <div class="icon-img icon-book"></div>
            <!-- <div class="icon-name">book</div> -->
        </div>
        <div class="icon" id="icon-bookmark-black-shape" data-img="bookmark-black-shape.png">
            <div class="icon-img icon-bookmark-black-shape"></div>
            <!-- <div class="icon-name">bookmark-black-shape</div> -->
        </div>
        <div class="icon" id="icon-bookmark-white" data-img="bookmark-white.png">
            <div class="icon-img icon-bookmark-white"></div>
            <!-- <div class="icon-name">bookmark-white</div> -->
        </div>
        <div class="icon" id="icon-branch-with-leaves-black-shape" data-img="branch-with-leaves-black-shape.png">
            <div class="icon-img icon-branch-with-leaves-black-shape"></div>
            <!-- <div class="icon-name">branch-with-leaves-black-shape</div> -->
        </div>
        <div class="icon" id="icon-briefcase" data-img="briefcase.png">
            <div class="icon-img icon-briefcase"></div>
            <!-- <div class="icon-name">briefcase</div> -->
        </div>
        <div class="icon" id="icon-bug" data-img="bug.png">
            <div class="icon-img icon-bug"></div>
            <!-- <div class="icon-name">bug</div> -->
        </div>
        <div class="icon" id="icon-building-front" data-img="building-front.png">
            <div class="icon-img icon-building-front"></div>
            <!-- <div class="icon-name">building-front</div> -->
        </div>
        <div class="icon" id="icon-bull-horn-announcer" data-img="bull-horn-announcer.png" type="equipment">
            <div class="icon-img icon-bull-horn-announcer"></div>
            <!-- <div class="icon-name">bull-horn-announcer</div> -->
        </div>
        <div class="icon" id="icon-bullseye" data-img="bullseye.png">
            <div class="icon-img icon-bullseye"></div>
            <!-- <div class="icon-name">bullseye</div> -->
        </div>
        <div class="icon" id="icon-calendar-page-empty" data-img="calendar-page-empty.png">
            <div class="icon-img icon-calendar-page-empty"></div>
            <!-- <div class="icon-name">calendar-page-empty</div> -->
        </div>
        <div class="icon" id="icon-calendar-with-spring-binder-and-date-blocks" data-img="calendar-with-spring-binder-and-date-blocks.png">
            <div class="icon-img icon-calendar-with-spring-binder-and-date-blocks"></div>
            <!-- <div class="icon-name">calendar-with-spring-binder-and-date-blocks</div> -->
        </div>
        <div class="icon" id="icon-camera-retro" data-img="camera-retro.png" type="equipment">
            <div class="icon-img icon-camera-retro"></div>
            <!-- <div class="icon-name">camera-retro</div> -->
        </div>
        <div class="icon" id="icon-caret-arrow-up" data-img="caret-arrow-up.png" type="arrow">
            <div class="icon-img icon-caret-arrow-up"></div>
            <!-- <div class="icon-name">caret-arrow-up</div> -->
        </div>
        <div class="icon" id="icon-caret-down" data-img="caret-down.png" type="arrow">
            <div class="icon-img icon-caret-down"></div>
            <!-- <div class="icon-name">caret-down</div> -->
        </div>
        <div class="icon" id="icon-center-text-alignment" data-img="center-text-alignment.png" type="configure">
            <div class="icon-img icon-center-text-alignment"></div>
            <!-- <div class="icon-name">center-text-alignment</div> -->
        </div>
        <div class="icon" id="icon-certificate-shape" data-img="certificate-shape.png">
            <div class="icon-img icon-certificate-shape"></div>
            <!-- <div class="icon-name">certificate-shape</div> -->
        </div>
        <div class="icon" id="icon-check-box-empty" data-img="check-box-empty.png" type="configure">
            <div class="icon-img icon-check-box-empty"></div>
            <!-- <div class="icon-name">check-box-empty</div> -->
        </div>
        <div class="icon" id="icon-check-mark" data-img="check-mark.png" type="configure">
            <div class="icon-img icon-check-mark"></div>
            <!-- <div class="icon-name">check-mark</div> -->
        </div>
        <div class="icon" id="icon-check-sign-in-a-rounded-black-square" data-img="check-sign-in-a-rounded-black-square.png" type="configure">
            <div class="icon-img icon-check-sign-in-a-rounded-black-square"></div>
            <!-- <div class="icon-name">check-sign-in-a-rounded-black-square</div> -->
        </div>
        <div class="icon" id="icon-check" data-img="check.png" type="configure">
            <div class="icon-img icon-check"></div>
            <!-- <div class="icon-name">check</div> -->
        </div>
        <div class="icon" id="icon-checked-symbol" data-img="checked-symbol.png" type="configure">
            <div class="icon-img icon-checked-symbol"></div>
            <!-- <div class="icon-name">checked-symbol</div> -->
        </div>
        <div class="icon" id="icon-checkered-raised-flag" data-img="checkered-raised-flag.png">
            <div class="icon-img icon-checkered-raised-flag"></div>
            <!-- <div class="icon-name">checkered-raised-flag</div> -->
        </div>
        <div class="icon" id="icon-chevron-arrow-down" data-img="chevron-arrow-down.png" type="arrow">
            <div class="icon-img icon-chevron-arrow-down"></div>
            <!-- <div class="icon-name">chevron-arrow-down</div> -->
        </div>
        <div class="icon" id="icon-chevron-arrow-up" data-img="chevron-arrow-up.png" type="arrow">
            <div class="icon-img icon-chevron-arrow-up"></div>
            <!-- <div class="icon-name">chevron-arrow-up</div> -->
        </div>
        <div class="icon" id="icon-chevron-pointing-to-the-left" data-img="chevron-pointing-to-the-left.png" type="arrow">
            <div class="icon-img icon-chevron-pointing-to-the-left"></div>
            <!-- <div class="icon-name">chevron-pointing-to-the-left</div> -->
        </div>
        <div class="icon" id="icon-chevron-sign-down" data-img="chevron-sign-down.png" type="arrow">
            <div class="icon-img icon-chevron-sign-down"></div>
            <!-- <div class="icon-name">chevron-sign-down</div> -->
        </div>
        <div class="icon" id="icon-chevron-sign-left" data-img="chevron-sign-left.png" type="arrow">
            <div class="icon-img icon-chevron-sign-left"></div>
            <!-- <div class="icon-name">chevron-sign-left</div> -->
        </div>
        <div class="icon" id="icon-chevron-sign-to-right" data-img="chevron-sign-to-right.png" type="arrow">
            <div class="icon-img icon-chevron-sign-to-right"></div>
            <!-- <div class="icon-name">chevron-sign-to-right</div> -->
        </div>
        <div class="icon" id="icon-chevron-up" data-img="chevron-up.png" type="arrow">
            <div class="icon-img icon-chevron-up"></div>
            <!-- <div class="icon-name">chevron-up</div> -->
        </div>
        <div class="icon" id="icon-circle-shape-outline" data-img="circle-shape-outline.png" type="configure">
            <div class="icon-img icon-circle-shape-outline"></div>
            <!-- <div class="icon-name">circle-shape-outline</div> -->
        </div>
        <div class="icon" id="icon-circle-with-an-arrow-pointing-to-left" data-img="circle-with-an-arrow-pointing-to-left.png" type="arrow">
            <div class="icon-img icon-circle-with-an-arrow-pointing-to-left"></div>
            <!-- <div class="icon-name">circle-with-an-arrow-pointing-to-left</div> -->
        </div>
        <div class="icon" id="icon-circular-shape-silhouette" data-img="circular-shape-silhouette.png" type="configure">
            <div class="icon-img icon-circular-shape-silhouette"></div>
            <!-- <div class="icon-name">circular-shape-silhouette</div> -->
        </div>
        <div class="icon" id="icon-cloud-storage-download" data-img="cloud-storage-download.png" type="arrow,configure">
            <div class="icon-img icon-cloud-storage-download"></div>
            <!-- <div class="icon-name">cloud-storage-download</div> -->
        </div>
        <div class="icon" id="icon-cloud-storage-uploading-option" data-img="cloud-storage-uploading-option.png" type="arrow,configure">
            <div class="icon-img icon-cloud-storage-uploading-option"></div>
            <!-- <div class="icon-name">cloud-storage-uploading-option</div> -->
        </div>
        <div class="icon" id="icon-cocktail-glass" data-img="cocktail-glass.png">
            <div class="icon-img icon-cocktail-glass"></div>
            <!-- <div class="icon-name">cocktail-glass</div> -->
        </div>
        <div class="icon" id="icon-code-fork-symbol" data-img="code-fork-symbol.png">
            <div class="icon-img icon-code-fork-symbol"></div>
            <!-- <div class="icon-name">code-fork-symbol</div> -->
        </div>
        <div class="icon" id="icon-code" data-img="code.png">
            <div class="icon-img icon-code"></div>
            <!-- <div class="icon-name">code</div> -->
        </div>
        <div class="icon" id="icon-coffee-cup-on-a-plate-black-silhouettes" data-img="coffee-cup-on-a-plate-black-silhouettes.png">
            <div class="icon-img icon-coffee-cup-on-a-plate-black-silhouettes"></div>
            <!-- <div class="icon-name">coffee-cup-on-a-plate-black-silhouettes</div> -->
        </div>
        <div class="icon" id="icon-cog-wheel-silhouette" data-img="cog-wheel-silhouette.png" type="configure">
            <div class="icon-img icon-cog-wheel-silhouette"></div>
            <!-- <div class="icon-name">cog-wheel-silhouette</div> -->
        </div>
        <div class="icon" id="icon-collapse-window-option" data-img="collapse-window-option.png" type="arrow">
            <div class="icon-img icon-collapse-window-option"></div>
            <!-- <div class="icon-name">collapse-window-option</div> -->
        </div>
        <div class="icon" id="icon-comment-black-oval-bubble-shape" data-img="comment-black-oval-bubble-shape.png">
            <div class="icon-img icon-comment-black-oval-bubble-shape"></div>
            <!-- <div class="icon-name">comment-black-oval-bubble-shape</div> -->
        </div>
        <div class="icon" id="icon-comment-white-oval-bubble" data-img="comment-white-oval-bubble.png">
            <div class="icon-img icon-comment-white-oval-bubble"></div>
            <!-- <div class="icon-name">comment-white-oval-bubble</div> -->
        </div>
        <div class="icon" id="icon-comments" data-img="comments.png">
            <div class="icon-img icon-comments"></div>
            <!-- <div class="icon-name">comments</div> -->
        </div>
        <div class="icon" id="icon-compass-circular-variant" data-img="compass-circular-variant.png">
            <div class="icon-img icon-compass-circular-variant"></div>
            <!-- <div class="icon-name">compass-circular-variant</div> -->
        </div>
        <div class="icon" id="icon-computer-tablet" data-img="computer-tablet.png" type="equipment">
            <div class="icon-img icon-computer-tablet"></div>
            <!-- <div class="icon-name">computer-tablet</div> -->
        </div>
        <div class="icon" id="icon-copy-document" data-img="copy-document.png">
            <div class="icon-img icon-copy-document"></div>
            <!-- <div class="icon-name">copy-document</div> -->
        </div>
        <div class="icon" id="icon-correct-symbol" data-img="correct-symbol.png" type="configure">
            <div class="icon-img icon-correct-symbol"></div>
            <!-- <div class="icon-name">correct-symbol</div> -->
        </div>
        <div class="icon" id="icon-couple-of-arrows-changing-places" data-img="couple-of-arrows-changing-places.png">
            <div class="icon-img icon-couple-of-arrows-changing-places"></div>
            <!-- <div class="icon-name">couple-of-arrows-changing-places</div> -->
        </div>
        <div class="icon" id="icon-credit-card" data-img="credit-card.png" type="equipment">
            <div class="icon-img icon-credit-card"></div>
            <!-- <div class="icon-name">credit-card</div> -->
        </div>
        <div class="icon" id="icon-crop-symbol" data-img="crop-symbol.png">
            <div class="icon-img icon-crop-symbol"></div>
            <!-- <div class="icon-name">crop-symbol</div> -->
        </div>
        <div class="icon" id="icon-cross-mark-on-a-black-circle-background" data-img="cross-mark-on-a-black-circle-background.png" type="configure">
            <div class="icon-img icon-cross-mark-on-a-black-circle-background"></div>
            <!-- <div class="icon-name">cross-mark-on-a-black-circle-background</div> -->
        </div>
        <div class="icon" id="icon-css-3-logo" data-img="css-3-logo.png">
            <div class="icon-img icon-css-3-logo"></div>
            <!-- <div class="icon-name">css-3-logo</div> -->
        </div>
        <div class="icon" id="icon-cursor" data-img="cursor.png" type="configure">
            <div class="icon-img icon-cursor"></div>
            <!-- <div class="icon-name">cursor</div> -->
        </div>
        <div class="icon" id="icon-cut" data-img="cut.png" type="equipment">
            <div class="icon-img icon-cut"></div>
            <!-- <div class="icon-name">cut</div> -->
        </div>
        <div class="icon" id="icon-dashboard" data-img="dashboard.png" type="equipment">
            <div class="icon-img icon-dashboard"></div>
            <!-- <div class="icon-name">dashboard</div> -->
        </div>
        <div class="icon" id="icon-delivery-truck-silhouette" data-img="delivery-truck-silhouette.png" type="equipment">
            <div class="icon-img icon-delivery-truck-silhouette"></div>
            <!-- <div class="icon-name">delivery-truck-silhouette</div> -->
        </div>
        <div class="icon" id="icon-desktop-monitor" data-img="desktop-monitor.png" type="equipment">
            <div class="icon-img icon-desktop-monitor"></div>
            <!-- <div class="icon-name">desktop-monitor</div> -->
        </div>
        <div class="icon" id="icon-dollar-symbol" data-img="dollar-symbol.png">
            <div class="icon-img icon-dollar-symbol"></div>
            <!-- <div class="icon-name">dollar-symbol</div> -->
        </div>
        <div class="icon" id="icon-dot-and-circle" data-img="dot-and-circle.png">
            <div class="icon-img icon-dot-and-circle"></div>
            <!-- <div class="icon-name">dot-and-circle</div> -->
        </div>
        <div class="icon" id="icon-double-angle-pointing-to-right" data-img="double-angle-pointing-to-right.png" type="arrow">
            <div class="icon-img icon-double-angle-pointing-to-right"></div>
            <!-- <div class="icon-name">double-angle-pointing-to-right</div> -->
        </div>
        <div class="icon" id="icon-double-left-chevron" data-img="double-left-chevron.png" type="arrow">
            <div class="icon-img icon-double-left-chevron"></div>
            <!-- <div class="icon-name">double-left-chevron</div> -->
        </div>
        <div class="icon" id="icon-double-sided-eraser" data-img="double-sided-eraser.png">
            <div class="icon-img icon-double-sided-eraser"></div>
            <!-- <div class="icon-name">double-sided-eraser</div> -->
        </div>
        <div class="icon" id="icon-double-strikethrough-option" data-img="double-strikethrough-option.png">
            <div class="icon-img icon-double-strikethrough-option"></div>
            <!-- <div class="icon-name">double-strikethrough-option</div> -->
        </div>
        <div class="icon" id="icon-down-arrow" data-img="down-arrow.png" type="arrow">
            <div class="icon-img icon-down-arrow"></div>
            <!-- <div class="icon-name">down-arrow</div> -->
        </div>
        <div class="icon" id="icon-download-symbol" data-img="download-symbol.png" type="arrow">
            <div class="icon-img icon-download-symbol"></div>
            <!-- <div class="icon-name">download-symbol</div> -->
        </div>
        <div class="icon" id="icon-download-to-storage-drive" data-img="download-to-storage-drive.png" type="arrow">
            <div class="icon-img icon-download-to-storage-drive"></div>
            <!-- <div class="icon-name">download-to-storage-drive</div> -->
        </div>
        <div class="icon" id="icon-dribbble-logo" data-img="dribbble-logo.png" type="equipment">
            <div class="icon-img icon-dribbble-logo"></div>
            <!-- <div class="icon-name">dribbble-logo</div> -->
        </div>
        <div class="icon" id="icon-dropbox-logo" data-img="dropbox-logo.png" type="equipment">
            <div class="icon-img icon-dropbox-logo"></div>
            <!-- <div class="icon-name">dropbox-logo</div> -->
        </div>
        <div class="icon" id="icon-earth-globe" data-img="earth-globe.png">
            <div class="icon-img icon-earth-globe"></div>
            <!-- <div class="icon-name">earth-globe</div> -->
        </div>
        <div class="icon" id="icon-edit-interface-sign" data-img="edit-interface-sign.png" type="configure">
            <div class="icon-img icon-edit-interface-sign"></div>
            <!-- <div class="icon-name">edit-interface-sign</div> -->
        </div>
        <div class="icon" id="icon-eject-symbol" data-img="eject-symbol.png" type="arrow">
            <div class="icon-img icon-eject-symbol"></div>
            <!-- <div class="icon-name">eject-symbol</div> -->
        </div>
        <div class="icon" id="icon-envelope-of-white-paper" data-img="envelope-of-white-paper.png" type="equipment">
            <div class="icon-img icon-envelope-of-white-paper"></div>
            <!-- <div class="icon-name">envelope-of-white-paper</div> -->
        </div>
        <div class="icon" id="icon-envelope" data-img="envelope.png" type="equipment">
            <div class="icon-img icon-envelope"></div>
            <!-- <div class="icon-name">envelope</div> -->
        </div>
        <div class="icon" id="icon-euro-currency-symbol" data-img="euro-currency-symbol.png">
            <div class="icon-img icon-euro-currency-symbol"></div>
            <!-- <div class="icon-name">euro-currency-symbol</div> -->
        </div>
        <div class="icon" id="icon-exchange-arrows" data-img="exchange-arrows.png" type="arrow">
            <div class="icon-img icon-exchange-arrows"></div>
            <!-- <div class="icon-name">exchange-arrows</div> -->
        </div>
        <div class="icon" id="icon-exclamation-sign" data-img="exclamation-sign.png" type="configure">
            <div class="icon-img icon-exclamation-sign"></div>
            <!-- <div class="icon-name">exclamation-sign</div> -->
        </div>
        <div class="icon" id="icon-exclamation" data-img="exclamation.png" type="configure">
            <div class="icon-img icon-exclamation"></div>
            <!-- <div class="icon-name">exclamation</div> -->
        </div>
        <div class="icon" id="icon-external-link-square-with-an-arrow-in-right-diagonal" data-img="external-link-square-with-an-arrow-in-right-diagonal.png" type="arrow">
            <div class="icon-img icon-external-link-square-with-an-arrow-in-right-diagonal"></div>
            <!-- <div class="icon-name">external-link-square-with-an-arrow-in-right-diagonal</div> -->
        </div>
        <div class="icon" id="icon-external-link-symbol" data-img="external-link-symbol.png" type="arrow">
            <div class="icon-img icon-external-link-symbol"></div>
            <!-- <div class="icon-name">external-link-symbol</div> -->
        </div>
        <div class="icon" id="icon-eye-open" data-img="eye-open.png" type="configure">
            <div class="icon-img icon-eye-open"></div>
            <!-- <div class="icon-name">eye-open</div> -->
        </div>
        <div class="icon" id="icon-eye-with-a-diagonal-line-interface-symbol-for-invisibility" data-img="eye-with-a-diagonal-line-interface-symbol-for-invisibility.png" type="configure">
            <div class="icon-img icon-eye-with-a-diagonal-line-interface-symbol-for-invisibility"></div>
            <!-- <div class="icon-name">eye-with-a-diagonal-line-interface-symbol-for-invisibility</div> -->
        </div>
        <div class="icon" id="icon-facebook-logo-1" data-img="facebook-logo-1.png" type="configure">
            <div class="icon-img icon-facebook-logo-1"></div>
            <!-- <div class="icon-name">facebook-logo-1</div> -->
        </div>
        <div class="icon" id="icon-facebook-logo" data-img="facebook-logo.png" type="configure">
            <div class="icon-img icon-facebook-logo"></div>
            <!-- <div class="icon-name">facebook-logo</div> -->
        </div>
        <div class="icon" id="icon-facetime-button" data-img="facetime-button.png" type="equipment">
            <div class="icon-img icon-facetime-button"></div>
            <!-- <div class="icon-name">facetime-button</div> -->
        </div>
        <div class="icon" id="icon-fast-forward-arrows" data-img="fast-forward-arrows.png">
            <div class="icon-img icon-fast-forward-arrows"></div>
            <!-- <div class="icon-name">fast-forward-arrows</div> -->
        </div>
        <div class="icon" id="icon-female-silhouette" data-img="female-silhouette.png">
            <div class="icon-img icon-female-silhouette"></div>
            <!-- <div class="icon-name">female-silhouette</div> -->
        </div>
        <div class="icon" id="icon-fighter-jet-silhouette" data-img="fighter-jet-silhouette.png">
            <div class="icon-img icon-fighter-jet-silhouette"></div>
            <!-- <div class="icon-name">fighter-jet-silhouette</div> -->
        </div>
        <div class="icon" id="icon-file" data-img="file.png">
            <div class="icon-img icon-file"></div>
            <!-- <div class="icon-name">file</div> -->
        </div>
        <div class="icon" id="icon-film-strip-with-two-photograms" data-img="film-strip-with-two-photograms.png" type="equipment">
            <div class="icon-img icon-film-strip-with-two-photograms"></div>
            <!-- <div class="icon-name">film-strip-with-two-photograms</div> -->
        </div>
        <div class="icon" id="icon-filter-tool-black-shape" data-img="filter-tool-black-shape.png" type="equipment">
            <div class="icon-img icon-filter-tool-black-shape"></div>
            <!-- <div class="icon-name">filter-tool-black-shape</div> -->
        </div>
        <div class="icon" id="icon-finger-of-a-hand-pointing-to-right-direction" data-img="finger-of-a-hand-pointing-to-right-direction.png" type="arrow,gesture">
            <div class="icon-img icon-finger-of-a-hand-pointing-to-right-direction"></div>
            <!-- <div class="icon-name">finger-of-a-hand-pointing-to-right-direction</div> -->
        </div>
        <div class="icon" id="icon-fire-extinguisher" data-img="fire-extinguisher.png" type="equipment">
            <div class="icon-img icon-fire-extinguisher"></div>
            <!-- <div class="icon-name">fire-extinguisher</div> -->
        </div>
        <div class="icon" id="icon-fire-symbol" data-img="fire-symbol.png">
            <div class="icon-img icon-fire-symbol"></div>
            <!-- <div class="icon-name">fire-symbol</div> -->
        </div>
        <div class="icon" id="icon-flag-black-shape" data-img="flag-black-shape.png">
            <div class="icon-img icon-flag-black-shape"></div>
            <!-- <div class="icon-name">flag-black-shape</div> -->
        </div>
        <div class="icon" id="icon-flickr-website-logo-silhouette" data-img="flickr-website-logo-silhouette.png" type="equipment,configure">
            <div class="icon-img icon-flickr-website-logo-silhouette"></div>
            <!-- <div class="icon-name">flickr-website-logo-silhouette</div> -->
        </div>
        <div class="icon" id="icon-fluffy-cloud-silhouette" data-img="fluffy-cloud-silhouette.png" type="configure">
            <div class="icon-img icon-fluffy-cloud-silhouette"></div>
            <!-- <div class="icon-name">fluffy-cloud-silhouette</div> -->
        </div>
        <div class="icon" id="icon-folder-closed-black-shape" data-img="folder-closed-black-shape.png" type="configure">
            <div class="icon-img icon-folder-closed-black-shape"></div>
            <!-- <div class="icon-name">folder-closed-black-shape</div> -->
        </div>
        <div class="icon" id="icon-folder-white-shape" data-img="folder-white-shape.png" type="configure">
            <div class="icon-img icon-folder-white-shape"></div>
            <!-- <div class="icon-name">folder-white-shape</div> -->
        </div>
        <div class="icon" id="icon-font-selection-editor" data-img="font-selection-editor.png" type="configure">
            <div class="icon-img icon-font-selection-editor"></div>
            <!-- <div class="icon-name">font-selection-editor</div> -->
        </div>
        <div class="icon" id="icon-font-symbol-of-letter-a" data-img="font-symbol-of-letter-a.png">
            <div class="icon-img icon-font-symbol-of-letter-a"></div>
            <!-- <div class="icon-name">font-symbol-of-letter-a</div> -->
        </div>
        <div class="icon" id="icon-fork-and-knife-silhouette" data-img="fork-and-knife-silhouette.png">
            <div class="icon-img icon-fork-and-knife-silhouette"></div>
            <!-- <div class="icon-name">fork-and-knife-silhouette</div> -->
        </div>
        <div class="icon" id="icon-forward-button" data-img="forward-button.png" type="arrow">
            <div class="icon-img icon-forward-button"></div>
            <!-- <div class="icon-name">forward-button</div> -->
        </div>
        <div class="icon" id="icon-four-black-squares" data-img="four-black-squares.png" type="configure">
            <div class="icon-img icon-four-black-squares"></div>
            <!-- <div class="icon-name">four-black-squares</div> -->
        </div>
        <div class="icon" id="icon-foursquare-button" data-img="foursquare-button.png" type="configure">
            <div class="icon-img icon-foursquare-button"></div>
            <!-- <div class="icon-name">foursquare-button</div> -->
        </div>
        <div class="icon" id="icon-frown" data-img="frown.png">
            <div class="icon-img icon-frown"></div>
            <!-- <div class="icon-name">frown</div> -->
        </div>
        <div class="icon" id="icon-fullscreen-symbol" data-img="fullscreen-symbol.png" type="arrow">
            <div class="icon-img icon-fullscreen-symbol"></div>
            <!-- <div class="icon-name">fullscreen-symbol</div> -->
        </div>
        <div class="icon" id="icon-gamepad-console" data-img="gamepad-console.png" type="equipment">
            <div class="icon-img icon-gamepad-console"></div>
            <!-- <div class="icon-name">gamepad-console</div> -->
        </div>
        <div class="icon" id="icon-gift-box" data-img="gift-box.png">
            <div class="icon-img icon-gift-box"></div>
            <!-- <div class="icon-name">gift-box</div> -->
        </div>
        <div class="icon" id="icon-github-character" data-img="github-character.png">
            <div class="icon-img icon-github-character"></div>
            <!-- <div class="icon-name">github-character</div> -->
        </div>
        <div class="icon" id="icon-github-logo" data-img="github-logo.png" type="equipment">
            <div class="icon-img icon-github-logo"></div>
            <!-- <div class="icon-name">github-logo</div> -->
        </div>
        <div class="icon" id="icon-github-sign" data-img="github-sign.png">
            <div class="icon-img icon-github-sign"></div>
            <!-- <div class="icon-name">github-sign</div> -->
        </div>
        <div class="icon" id="icon-gittip-website-logo" data-img="gittip-website-logo.png" type="equipment">
            <div class="icon-img icon-gittip-website-logo"></div>
            <!-- <div class="icon-name">gittip-website-logo</div> -->
        </div>
        <div class="icon" id="icon-google-plus-symbol-1" data-img="google-plus-symbol-1.png">
            <div class="icon-img icon-google-plus-symbol-1"></div>
            <!-- <div class="icon-name">google-plus-symbol-1</div> -->
        </div>
        <div class="icon" id="icon-google-plus-symbol" data-img="google-plus-symbol.png">
            <div class="icon-img icon-google-plus-symbol"></div>
            <!-- <div class="icon-name">google-plus-symbol</div> -->
        </div>
        <div class="icon" id="icon-great-britain-pound" data-img="great-britain-pound.png">
            <div class="icon-img icon-great-britain-pound"></div>
            <!-- <div class="icon-name">great-britain-pound</div> -->
        </div>
        <div class="icon" id="icon-group-profile-users" data-img="group-profile-users.png">
            <div class="icon-img icon-group-profile-users"></div>
            <!-- <div class="icon-name">group-profile-users</div> -->
        </div>
        <div class="icon" id="icon-half-star-shape" data-img="half-star-shape.png">
            <div class="icon-img icon-half-star-shape"></div>
            <!-- <div class="icon-name">half-star-shape</div> -->
        </div>
        <div class="icon" id="icon-hand-finger-pointing-down" data-img="hand-finger-pointing-down.png" type="arrow">
            <div class="icon-img icon-hand-finger-pointing-down"></div>
            <!-- <div class="icon-name">hand-finger-pointing-down</div> -->
        </div>
        <div class="icon" id="icon-hand-pointing-to-left-direction" data-img="hand-pointing-to-left-direction.png" type="arrow,gesture">
            <div class="icon-img icon-hand-pointing-to-left-direction"></div>
            <!-- <div class="icon-name">hand-pointing-to-left-direction</div> -->
        </div>
        <div class="icon" id="icon-hand-pointing-upward" data-img="hand-pointing-upward.png" type="arrow,gesture">
            <div class="icon-img icon-hand-pointing-upward"></div>
            <!-- <div class="icon-name">hand-pointing-upward</div> -->
        </div>
        <div class="icon" id="icon-hard-drive" data-img="hard-drive.png" type="equipment">
            <div class="icon-img icon-hard-drive"></div>
            <!-- <div class="icon-name">hard-drive</div> -->
        </div>
        <div class="icon" id="icon-heart-shape-outline" data-img="heart-shape-outline.png" type="configure">
            <div class="icon-img icon-heart-shape-outline"></div>
            <!-- <div class="icon-name">heart-shape-outline</div> -->
        </div>
        <div class="icon" id="icon-heart-shape-silhouette" data-img="heart-shape-silhouette.png" type="configure">
            <div class="icon-img icon-heart-shape-silhouette"></div>
            <!-- <div class="icon-name">heart-shape-silhouette</div> -->
        </div>
        <div class="icon" id="icon-home" data-img="home.png" type="configure">
            <div class="icon-img icon-home"></div>
            <!-- <div class="icon-name">home</div> -->
        </div>
        <div class="icon" id="icon-horizontal-resize-option" data-img="horizontal-resize-option.png" type="arrow">
            <div class="icon-img icon-horizontal-resize-option"></div>
            <!-- <div class="icon-name">horizontal-resize-option</div> -->
        </div>
        <div class="icon" id="icon-hostpital-building" data-img="hostpital-building.png">
            <div class="icon-img icon-hostpital-building"></div>
            <!-- <div class="icon-name">hostpital-building</div> -->
        </div>
        <div class="icon" id="icon-hotel-letter-h-sign-inside-a-black-rounded-square" data-img="hotel-letter-h-sign-inside-a-black-rounded-square.png">
            <div class="icon-img icon-hotel-letter-h-sign-inside-a-black-rounded-square"></div>
            <!-- <div class="icon-name">hotel-letter-h-sign-inside-a-black-rounded-square</div> -->
        </div>
        <div class="icon" id="icon-html-5-logo" data-img="html-5-logo.png" type="equipment">
            <div class="icon-img icon-html-5-logo"></div>
            <!-- <div class="icon-name">html-5-logo</div> -->
        </div>
        <div class="icon" id="icon-inbox" data-img="inbox.png" type="equipment">
            <div class="icon-img icon-inbox"></div>
            <!-- <div class="icon-name">inbox</div> -->
        </div>
        <div class="icon" id="icon-increase-size-option" data-img="increase-size-option.png" type="arrow">
            <div class="icon-img icon-increase-size-option"></div>
            <!-- <div class="icon-name">increase-size-option</div> -->
        </div>
        <div class="icon" id="icon-indent-right" data-img="indent-right.png" type="configure">
            <div class="icon-img icon-indent-right"></div>
            <!-- <div class="icon-name">indent-right</div> -->
        </div>
        <div class="icon" id="icon-information-button" data-img="information-button.png" type="configure">
            <div class="icon-img icon-information-button"></div>
            <!-- <div class="icon-name">information-button</div> -->
        </div>
        <div class="icon" id="icon-information-symbol" data-img="information-symbol.png" type="configure">
            <div class="icon-img icon-information-symbol"></div>
            <!-- <div class="icon-name">information-symbol</div> -->
        </div>
        <div class="icon" id="icon-instagram-symbol" data-img="instagram-symbol.png">
            <div class="icon-img icon-instagram-symbol"></div>
            <!-- <div class="icon-name">instagram-symbol</div> -->
        </div>
        <div class="icon" id="icon-italicize-text" data-img="italicize-text.png">
            <div class="icon-img icon-italicize-text"></div>
            <!-- <div class="icon-name">italicize-text</div> -->
        </div>
        <div class="icon" id="icon-keyboard" data-img="keyboard.png" type="equipment">
            <div class="icon-img icon-keyboard"></div>
            <!-- <div class="icon-name">keyboard</div> -->
        </div>
        <div class="icon" id="icon-left-arrow-1" data-img="left-arrow-1.png" type="arrow">
            <div class="icon-img icon-left-arrow-1"></div>
            <!-- <div class="icon-name">left-arrow-1</div> -->
        </div>
        <div class="icon" id="icon-left-arrow" data-img="left-arrow.png" type="arrow">
            <div class="icon-img icon-left-arrow"></div>
            <!-- <div class="icon-name">left-arrow</div> -->
        </div>
        <div class="icon" id="icon-left-indentation-option" data-img="left-indentation-option.png" type="configure">
            <div class="icon-img icon-left-indentation-option"></div>
            <!-- <div class="icon-name">left-indentation-option</div> -->
        </div>
        <div class="icon" id="icon-legal-hammer" data-img="legal-hammer.png">
            <div class="icon-img icon-legal-hammer"></div>
            <!-- <div class="icon-name">legal-hammer</div> -->
        </div>
        <div class="icon" id="icon-lemon" data-img="lemon.png">
            <div class="icon-img icon-lemon"></div>
            <!-- <div class="icon-name">lemon</div> -->
        </div>
        <div class="icon" id="icon-leter-a-inside-a-black-circle" data-img="leter-a-inside-a-black-circle.png">
            <div class="icon-img icon-leter-a-inside-a-black-circle"></div>
            <!-- <div class="icon-name">leter-a-inside-a-black-circle</div> -->
        </div>
        <div class="icon" id="icon-letter-p-symbol" data-img="letter-p-symbol.png">
            <div class="icon-img icon-letter-p-symbol"></div>
            <!-- <div class="icon-name">letter-p-symbol</div> -->
        </div>
        <div class="icon" id="icon-level-up" data-img="level-up.png" type="arrow">
            <div class="icon-img icon-level-up"></div>
            <!-- <div class="icon-name">level-up</div> -->
        </div>
        <div class="icon" id="icon-light-bulb" data-img="light-bulb.png">
            <div class="icon-img icon-light-bulb"></div>
            <!-- <div class="icon-name">light-bulb</div> -->
        </div>
        <div class="icon" id="icon-lightning-bolt-shadow" data-img="lightning-bolt-shadow.png">
            <div class="icon-img icon-lightning-bolt-shadow"></div>
            <!-- <div class="icon-name">lightning-bolt-shadow</div> -->
        </div>
        <div class="icon" id="icon-link-symbol" data-img="link-symbol.png">
            <div class="icon-img icon-link-symbol"></div>
            <!-- <div class="icon-name">link-symbol</div> -->
        </div>
        <div class="icon" id="icon-linkedin-letters" data-img="linkedin-letters.png">
            <div class="icon-img icon-linkedin-letters"></div>
            <!-- <div class="icon-name">linkedin-letters</div> -->
        </div>
        <div class="icon" id="icon-linkedin-sign" data-img="linkedin-sign.png">
            <div class="icon-img icon-linkedin-sign"></div>
            <!-- <div class="icon-name">linkedin-sign</div> -->
        </div>
        <div class="icon" id="icon-linux-logo" data-img="linux-logo.png" type="equipment">
            <div class="icon-img icon-linux-logo"></div>
            <!-- <div class="icon-name">linux-logo</div> -->
        </div>
        <div class="icon" id="icon-list-on-window" data-img="list-on-window.png" type="configure">
            <div class="icon-img icon-list-on-window"></div>
            <!-- <div class="icon-name">list-on-window</div> -->
        </div>
        <div class="icon" id="icon-list-with-dots" data-img="list-with-dots.png" type="configure">
            <div class="icon-img icon-list-with-dots"></div>
            <!-- <div class="icon-name">list-with-dots</div> -->
        </div>
        <div class="icon" id="icon-list" data-img="list.png" type="configure">
            <div class="icon-img icon-list"></div>
            <!-- <div class="icon-name">list</div> -->
        </div>
        <div class="icon" id="icon-listing-option" data-img="listing-option.png" type="configure">
            <div class="icon-img icon-listing-option"></div>
            <!-- <div class="icon-name">listing-option</div> -->
        </div>
        <div class="icon" id="icon-long-arrow-pointing-to-left" data-img="long-arrow-pointing-to-left.png" type="arrow">
            <div class="icon-img icon-long-arrow-pointing-to-left"></div>
            <!-- <div class="icon-name">long-arrow-pointing-to-left</div> -->
        </div>
        <div class="icon" id="icon-long-arrow-pointing-to-the-right" data-img="long-arrow-pointing-to-the-right.png" type="arrow">
            <div class="icon-img icon-long-arrow-pointing-to-the-right"></div>
            <!-- <div class="icon-name">long-arrow-pointing-to-the-right</div> -->
        </div>
        <div class="icon" id="icon-long-arrow-pointing-up" data-img="long-arrow-pointing-up.png" type="arrow">
            <div class="icon-img icon-long-arrow-pointing-up"></div>
            <!-- <div class="icon-name">long-arrow-pointing-up</div> -->
        </div>
        <div class="icon" id="icon-magic-wand" data-img="magic-wand.png" type="configure">
            <div class="icon-img icon-magic-wand"></div>
            <!-- <div class="icon-name">magic-wand</div> -->
        </div>
        <div class="icon" id="icon-magnifying-glass" data-img="magnifying-glass.png" type="configure">
            <div class="icon-img icon-magnifying-glass"></div>
            <!-- <div class="icon-name">magnifying-glass</div> -->
        </div>
        <div class="icon" id="icon-man" data-img="man.png">
            <div class="icon-img icon-man"></div>
            <!-- <div class="icon-name">man</div> -->
        </div>
        <div class="icon" id="icon-map-marker" data-img="map-marker.png" type="configure">
            <div class="icon-img icon-map-marker"></div>
            <!-- <div class="icon-name">map-marker</div> -->
        </div>
        <div class="icon" id="icon-maxcdn-website-logo" data-img="maxcdn-website-logo.png" type="equipment">
            <div class="icon-img icon-maxcdn-website-logo"></div>
            <!-- <div class="icon-name">maxcdn-website-logo</div> -->
        </div>
        <div class="icon" id="icon-medical-kit" data-img="medical-kit.png">
            <div class="icon-img icon-medical-kit"></div>
            <!-- <div class="icon-name">medical-kit</div> -->
        </div>
        <div class="icon" id="icon-meh-face-emoticon" data-img="meh-face-emoticon.png">
            <div class="icon-img icon-meh-face-emoticon"></div>
            <!-- <div class="icon-name">meh-face-emoticon</div> -->
        </div>
        <div class="icon" id="icon-microphone-black-shape" data-img="microphone-black-shape.png">
            <div class="icon-img icon-microphone-black-shape"></div>
            <!-- <div class="icon-name">microphone-black-shape</div> -->
        </div>
        <div class="icon" id="icon-microphone-off" data-img="microphone-off.png">
            <div class="icon-img icon-microphone-off"></div>
            <!-- <div class="icon-name">microphone-off</div> -->
        </div>
        <div class="icon" id="icon-minus-button" data-img="minus-button.png" type="configure">
            <div class="icon-img icon-minus-button"></div>
            <!-- <div class="icon-name">minus-button</div> -->
        </div>
        <div class="icon" id="icon-minus-sign-inside-a-black-circle" data-img="minus-sign-inside-a-black-circle.png" type="configure">
            <div class="icon-img icon-minus-sign-inside-a-black-circle"></div>
            <!-- <div class="icon-name">minus-sign-inside-a-black-circle</div> -->
        </div>
        <div class="icon" id="icon-minus-sign-inside-a-black-rounded-square-shape" data-img="minus-sign-inside-a-black-rounded-square-shape.png" type="configure">
            <div class="icon-img icon-minus-sign-inside-a-black-rounded-square-shape"></div>
            <!-- <div class="icon-name">minus-sign-inside-a-black-rounded-square-shape</div> -->
        </div>
        <div class="icon" id="icon-minus-sign-on-a-square-outline" data-img="minus-sign-on-a-square-outline.png" type="configure">
            <div class="icon-img icon-minus-sign-on-a-square-outline"></div>
            <!-- <div class="icon-name">minus-sign-on-a-square-outline</div> -->
        </div>
        <div class="icon" id="icon-minus-symbol" data-img="minus-symbol.png" type="configure">
            <div class="icon-img icon-minus-symbol"></div>
            <!-- <div class="icon-name">minus-symbol</div> -->
        </div>
        <div class="icon" id="icon-mobile-phone" data-img="mobile-phone.png" type="equipment">
            <div class="icon-img icon-mobile-phone"></div>
            <!-- <div class="icon-name">mobile-phone</div> -->
        </div>
        <div class="icon" id="icon-moon-phase-outline" data-img="moon-phase-outline.png">
            <div class="icon-img icon-moon-phase-outline"></div>
            <!-- <div class="icon-name">moon-phase-outline</div> -->
        </div>
        <div class="icon" id="icon-move-option" data-img="move-option.png">
            <div class="icon-img icon-move-option"></div>
            <!-- <div class="icon-name">move-option</div> -->
        </div>
        <div class="icon" id="icon-music-headphones" data-img="music-headphones.png">
            <div class="icon-img icon-music-headphones"></div>
            <!-- <div class="icon-name">music-headphones</div> -->
        </div>
        <div class="icon" id="icon-music-note-black-symbol" data-img="music-note-black-symbol.png">
            <div class="icon-img icon-music-note-black-symbol"></div>
            <!-- <div class="icon-name">music-note-black-symbol</div> -->
        </div>
        <div class="icon" id="icon-musical-bell-outline" data-img="musical-bell-outline.png">
            <div class="icon-img icon-musical-bell-outline"></div>
            <!-- <div class="icon-name">musical-bell-outline</div> -->
        </div>
        <div class="icon" id="icon-nine-black-tiles" data-img="nine-black-tiles.png" type="configure">
            <div class="icon-img icon-nine-black-tiles"></div>
            <!-- <div class="icon-name">nine-black-tiles</div> -->
        </div>
        <div class="icon" id="icon-numbered-list" data-img="numbered-list.png" type="configure">
            <div class="icon-img icon-numbered-list"></div>
            <!-- <div class="icon-name">numbered-list</div> -->
        </div>
        <div class="icon" id="icon-open-folder-outline" data-img="open-folder-outline.png" type="configure">
            <div class="icon-img icon-open-folder-outline"></div>
            <!-- <div class="icon-name">open-folder-outline</div> -->
        </div>
        <div class="icon" id="icon-open-folder" data-img="open-folder.png" type="configure">
            <div class="icon-img icon-open-folder"></div>
            <!-- <div class="icon-name">open-folder</div> -->
        </div>
        <div class="icon" id="icon-open-laptop-computer" data-img="open-laptop-computer.png" type="equipment">
            <div class="icon-img icon-open-laptop-computer"></div>
            <!-- <div class="icon-name">open-laptop-computer</div> -->
        </div>
        <div class="icon" id="icon-open-padlock-silhouette" data-img="open-padlock-silhouette.png" type="configure">
            <div class="icon-img icon-open-padlock-silhouette"></div>
            <!-- <div class="icon-name">open-padlock-silhouette</div> -->
        </div>
        <div class="icon" id="icon-open-wrench-tool-silhouette" data-img="open-wrench-tool-silhouette.png" type="configure">
            <div class="icon-img icon-open-wrench-tool-silhouette"></div>
            <!-- <div class="icon-name">open-wrench-tool-silhouette</div> -->
        </div>
        <div class="icon" id="icon-padlock-unlock" data-img="padlock-unlock.png" type="configure">
            <div class="icon-img icon-padlock-unlock"></div>
            <!-- <div class="icon-name">padlock-unlock</div> -->
        </div>
        <div class="icon" id="icon-padlock" data-img="padlock.png" type="configure">
            <div class="icon-img icon-padlock"></div>
            <!-- <div class="icon-name">padlock</div> -->
        </div>
        <div class="icon" id="icon-paper-bill" data-img="paper-bill.png">
            <div class="icon-img icon-paper-bill"></div>
            <!-- <div class="icon-name">paper-bill</div> -->
        </div>
        <div class="icon" id="icon-paper-clip-outline" data-img="paper-clip-outline.png">
            <div class="icon-img icon-paper-clip-outline"></div>
            <!-- <div class="icon-name">paper-clip-outline</div> -->
        </div>
        <div class="icon" id="icon-paper-push-pin" data-img="paper-push-pin.png">
            <div class="icon-img icon-paper-push-pin"></div>
            <!-- <div class="icon-name">paper-push-pin</div> -->
        </div>
        <div class="icon" id="icon-paste-from-clipboard" data-img="paste-from-clipboard.png">
            <div class="icon-img icon-paste-from-clipboard"></div>
            <!-- <div class="icon-name">paste-from-clipboard</div> -->
        </div>
        <div class="icon" id="icon-pause-symbol" data-img="pause-symbol.png">
            <div class="icon-img icon-pause-symbol"></div>
            <!-- <div class="icon-name">pause-symbol</div> -->
        </div>
        <div class="icon" id="icon-pencil" data-img="pencil.png" type="configure">
            <div class="icon-img icon-pencil"></div>
            <!-- <div class="icon-name">pencil</div> -->
        </div>
        <div class="icon" id="icon-photo-camera" data-img="photo-camera.png" type="equipment">
            <div class="icon-img icon-photo-camera"></div>
            <!-- <div class="icon-name">photo-camera</div> -->
        </div>
        <div class="icon" id="icon-picture" data-img="picture.png">
            <div class="icon-img icon-picture"></div>
            <!-- <div class="icon-name">picture</div> -->
        </div>
        <div class="icon" id="icon-pinterest-logo" data-img="pinterest-logo.png" type="equipment">
            <div class="icon-img icon-pinterest-logo"></div>
            <!-- <div class="icon-name">pinterest-logo</div> -->
        </div>
        <div class="icon" id="icon-pinterest-sign" data-img="pinterest-sign.png">
            <div class="icon-img icon-pinterest-sign"></div>
            <!-- <div class="icon-name">pinterest-sign</div> -->
        </div>
        <div class="icon" id="icon-plane" data-img="plane.png">
            <div class="icon-img icon-plane"></div>
            <!-- <div class="icon-name">plane</div> -->
        </div>
        <div class="icon" id="icon-plant-leaf-with-white-details" data-img="plant-leaf-with-white-details.png">
            <div class="icon-img icon-plant-leaf-with-white-details"></div>
            <!-- <div class="icon-name">plant-leaf-with-white-details</div> -->
        </div>
        <div class="icon" id="icon-play-button" data-img="play-button.png" type="arrow">
            <div class="icon-img icon-play-button"></div>
            <!-- <div class="icon-name">play-button</div> -->
        </div>
        <div class="icon" id="icon-play-circle" data-img="play-circle.png" type="arrow">
            <div class="icon-img icon-play-circle"></div>
            <!-- <div class="icon-name">play-circle</div> -->
        </div>
        <div class="icon" id="icon-play-sign" data-img="play-sign.png" type="arrow">
            <div class="icon-img icon-play-sign"></div>
            <!-- <div class="icon-name">play-sign</div> -->
        </div>
        <div class="icon" id="icon-play-video-button" data-img="play-video-button.png">
            <div class="icon-img icon-play-video-button"></div>
            <!-- <div class="icon-name">play-video-button</div> -->
        </div>
        <div class="icon" id="icon-plus-black-symbol" data-img="plus-black-symbol.png" type="configure">
            <div class="icon-img icon-plus-black-symbol"></div>
            <!-- <div class="icon-name">plus-black-symbol</div> -->
        </div>
        <div class="icon" id="icon-plus-sign-in-a-black-circle" data-img="plus-sign-in-a-black-circle.png" type="configure">
            <div class="icon-img icon-plus-sign-in-a-black-circle"></div>
            <!-- <div class="icon-name">plus-sign-in-a-black-circle</div> -->
        </div>
        <div class="icon" id="icon-plus-symbol-in-a-rounded-black-square" data-img="plus-symbol-in-a-rounded-black-square.png" type="configure">
            <div class="icon-img icon-plus-symbol-in-a-rounded-black-square"></div>
            <!-- <div class="icon-name">plus-symbol-in-a-rounded-black-square</div> -->
        </div>
        <div class="icon" id="icon-power-button-off" data-img="power-button-off.png" type="equipment">
            <div class="icon-img icon-power-button-off"></div>
            <!-- <div class="icon-name">power-button-off</div> -->
        </div>
        <div class="icon" id="icon-printing-tool" data-img="printing-tool.png" type="equipment">
            <div class="icon-img icon-printing-tool"></div>
            <!-- <div class="icon-name">printing-tool</div> -->
        </div>
        <div class="icon" id="icon-puzzle-piece-silhouette" data-img="puzzle-piece-silhouette.png">
            <div class="icon-img icon-puzzle-piece-silhouette"></div>
            <!-- <div class="icon-name">puzzle-piece-silhouette</div> -->
        </div>
        <div class="icon" id="icon-qr-code" data-img="qr-code.png">
            <div class="icon-img icon-qr-code"></div>
            <!-- <div class="icon-name">qr-code</div> -->
        </div>
        <div class="icon" id="icon-question-mark-on-a-circular-black-background" data-img="question-mark-on-a-circular-black-background.png" type="configure">
            <div class="icon-img icon-question-mark-on-a-circular-black-background"></div>
            <!-- <div class="icon-name">question-mark-on-a-circular-black-background</div> -->
        </div>
        <div class="icon" id="icon-question-sign" data-img="question-sign.png" type="configure">
            <div class="icon-img icon-question-sign"></div>
            <!-- <div class="icon-name">question-sign</div> -->
        </div>
        <div class="icon" id="icon-quote-left" data-img="quote-left.png">
            <div class="icon-img icon-quote-left"></div>
            <!-- <div class="icon-name">quote-left</div> -->
        </div>
        <div class="icon" id="icon-reduced-volume" data-img="reduced-volume.png">
            <div class="icon-img icon-reduced-volume"></div>
            <!-- <div class="icon-name">reduced-volume</div> -->
        </div>
        <div class="icon" id="icon-refresh-arrow" data-img="refresh-arrow.png" type="arrow,configure">
            <div class="icon-img icon-refresh-arrow"></div>
            <!-- <div class="icon-name">refresh-arrow</div> -->
        </div>
        <div class="icon" id="icon-refresh-page-option" data-img="refresh-page-option.png" type="arrow,configure">
            <div class="icon-img icon-refresh-page-option"></div>
            <!-- <div class="icon-name">refresh-page-option</div> -->
        </div>
        <div class="icon" id="icon-remove-button" data-img="remove-button.png" type="configure">
            <div class="icon-img icon-remove-button"></div>
            <!-- <div class="icon-name">remove-button</div> -->
        </div>
        <div class="icon" id="icon-remove-symbol" data-img="remove-symbol.png" type="configure">
            <div class="icon-img icon-remove-symbol"></div>
            <!-- <div class="icon-name">remove-symbol</div> -->
        </div>
        <div class="icon" id="icon-renren-social-network-of-china-logotype" data-img="renren-social-network-of-china-logotype.png" type="equipment,configure">
            <div class="icon-img icon-renren-social-network-of-china-logotype"></div>
            <!-- <div class="icon-name">renren-social-network-of-china-logotype</div> -->
        </div>
        <div class="icon" id="icon-reorder-option" data-img="reorder-option.png" type="configure">
            <div class="icon-img icon-reorder-option"></div>
            <!-- <div class="icon-name">reorder-option</div> -->
        </div>
        <div class="icon" id="icon-reply-arrow" data-img="reply-arrow.png" type="arrow,configure">
            <div class="icon-img icon-reply-arrow"></div>
            <!-- <div class="icon-name">reply-arrow</div> -->
        </div>
        <div class="icon" id="icon-reply" data-img="reply.png" type="arrow,configure">
            <div class="icon-img icon-reply"></div>
            <!-- <div class="icon-name">reply</div> -->
        </div>
        <div class="icon" id="icon-resize-option" data-img="resize-option.png" type="arrow,configure">
            <div class="icon-img icon-resize-option"></div>
            <!-- <div class="icon-name">resize-option</div> -->
        </div>
        <div class="icon" id="icon-retweet-arrows-symbol" data-img="retweet-arrows-symbol.png" type="arrow,configure">
            <div class="icon-img icon-retweet-arrows-symbol"></div>
            <!-- <div class="icon-name">retweet-arrows-symbol</div> -->
        </div>
        <div class="icon" id="icon-rewind-button" data-img="rewind-button.png" type="arrow">
            <div class="icon-img icon-rewind-button"></div>
            <!-- <div class="icon-name">rewind-button</div> -->
        </div>
        <div class="icon" id="icon-right-arrow-in-a-circle" data-img="right-arrow-in-a-circle.png" type="arrow">
            <div class="icon-img icon-right-arrow-in-a-circle"></div>
            <!-- <div class="icon-name">right-arrow-in-a-circle</div> -->
        </div>
        <div class="icon" id="icon-right-chevron" data-img="right-chevron.png" type="arrow">
            <div class="icon-img icon-right-chevron"></div>
            <!-- <div class="icon-name">right-chevron</div> -->
        </div>
        <div class="icon" id="icon-right-quotation-mark" data-img="right-quotation-mark.png">
            <div class="icon-img icon-right-quotation-mark"></div>
            <!-- <div class="icon-name">right-quotation-mark</div> -->
        </div>
        <div class="icon" id="icon-road-perspective" data-img="road-perspective.png">
            <div class="icon-img icon-road-perspective"></div>
            <!-- <div class="icon-name">road-perspective</div> -->
        </div>
        <div class="icon" id="icon-rounded-black-square-shape" data-img="rounded-black-square-shape.png">
            <div class="icon-img icon-rounded-black-square-shape"></div>
            <!-- <div class="icon-name">rounded-black-square-shape</div> -->
        </div>
        <div class="icon" id="icon-rss-feed-button" data-img="rss-feed-button.png">
            <div class="icon-img icon-rss-feed-button"></div>
            <!-- <div class="icon-name">rss-feed-button</div> -->
        </div>
        <div class="icon" id="icon-rss-symbol" data-img="rss-symbol.png">
            <div class="icon-img icon-rss-symbol"></div>
            <!-- <div class="icon-name">rss-symbol</div> -->
        </div>
        <div class="icon" id="icon-rupee-indian" data-img="rupee-indian.png">
            <div class="icon-img icon-rupee-indian"></div>
            <!-- <div class="icon-name">rupee-indian</div> -->
        </div>
        <div class="icon" id="icon-save-file-option" data-img="save-file-option.png" type="equipment">
            <div class="icon-img icon-save-file-option"></div>
            <!-- <div class="icon-name">save-file-option</div> -->
        </div>
        <div class="icon" id="icon-screenshot" data-img="screenshot.png" type="configure">
            <div class="icon-img icon-screenshot"></div>
            <!-- <div class="icon-name">screenshot</div> -->
        </div>
        <div class="icon" id="icon-settings" data-img="settings.png" type="configure">
            <div class="icon-img icon-settings"></div>
            <!-- <div class="icon-name">settings</div> -->
        </div>
        <div class="icon" id="icon-share-option" data-img="share-option.png" type="arrow,configure">
            <div class="icon-img icon-share-option"></div>
            <!-- <div class="icon-name">share-option</div> -->
        </div>
        <div class="icon" id="icon-share-post-symbol" data-img="share-post-symbol.png" type="arrow,configure">
            <div class="icon-img icon-share-post-symbol"></div>
            <!-- <div class="icon-name">share-post-symbol</div> -->
        </div>
        <div class="icon" id="icon-share-symbol" data-img="share-symbol.png" type="arrow,configure">
            <div class="icon-img icon-share-symbol"></div>
            <!-- <div class="icon-name">share-symbol</div> -->
        </div>
        <div class="icon" id="icon-shield" data-img="shield.png" type="configure">
            <div class="icon-img icon-shield"></div>
            <!-- <div class="icon-name">shield</div> -->
        </div>
        <div class="icon" id="icon-shopping-cart-black-shape" data-img="shopping-cart-black-shape.png" type="equipment">
            <div class="icon-img icon-shopping-cart-black-shape"></div>
            <!-- <div class="icon-name">shopping-cart-black-shape</div> -->
        </div>
        <div class="icon" id="icon-sign-in" data-img="sign-in.png" type="arrow">
            <div class="icon-img icon-sign-in"></div>
            <!-- <div class="icon-name">sign-in</div> -->
        </div>
        <div class="icon" id="icon-sign-out-option" data-img="sign-out-option.png" type="arrow">
            <div class="icon-img icon-sign-out-option"></div>
            <!-- <div class="icon-name">sign-out-option</div> -->
        </div>
        <div class="icon" id="icon-signal-bars" data-img="signal-bars.png" type="configure">
            <div class="icon-img icon-signal-bars"></div>
            <!-- <div class="icon-name">signal-bars</div> -->
        </div>
        <div class="icon" id="icon-sitemap" data-img="sitemap.png" type="configure">
            <div class="icon-img icon-sitemap"></div>
            <!-- <div class="icon-name">sitemap</div> -->
        </div>
        <div class="icon" id="icon-skype-logo" data-img="skype-logo.png">
            <div class="icon-img icon-skype-logo"></div>
            <!-- <div class="icon-name">skype-logo</div> -->
        </div>
        <div class="icon" id="icon-small-rocket-ship-silhouette" data-img="small-rocket-ship-silhouette.png">
            <div class="icon-img icon-small-rocket-ship-silhouette"></div>
            <!-- <div class="icon-name">small-rocket-ship-silhouette</div> -->
        </div>
        <div class="icon" id="icon-smile" data-img="smile.png">
            <div class="icon-img icon-smile"></div>
            <!-- <div class="icon-name">smile</div> -->
        </div>
        <div class="icon" id="icon-sort-arrows-couple-pointing-up-and-down" data-img="sort-arrows-couple-pointing-up-and-down.png" type="arrow,configure">
            <div class="icon-img icon-sort-arrows-couple-pointing-up-and-down"></div>
            <!-- <div class="icon-name">sort-arrows-couple-pointing-up-and-down</div> -->
        </div>
        <div class="icon" id="icon-sort-by-alphabet" data-img="sort-by-alphabet.png" type="arrow">
            <div class="icon-img icon-sort-by-alphabet"></div>
            <!-- <div class="icon-name">sort-by-alphabet</div> -->
        </div>
        <div class="icon" id="icon-sort-by-attributes-interface-button-option" data-img="sort-by-attributes-interface-button-option.png" type="arrow">
            <div class="icon-img icon-sort-by-attributes-interface-button-option"></div>
            <!-- <div class="icon-name">sort-by-attributes-interface-button-option</div> -->
        </div>
        <div class="icon" id="icon-sort-by-attributes" data-img="sort-by-attributes.png" type="arrow">
            <div class="icon-img icon-sort-by-attributes"></div>
            <!-- <div class="icon-name">sort-by-attributes</div> -->
        </div>
        <div class="icon" id="icon-sort-by-numeric-order" data-img="sort-by-numeric-order.png" type="arrow">
            <div class="icon-img icon-sort-by-numeric-order"></div>
            <!-- <div class="icon-name">sort-by-numeric-order</div> -->
        </div>
        <div class="icon" id="icon-sort-by-order" data-img="sort-by-order.png" type="arrow">
            <div class="icon-img icon-sort-by-order"></div>
            <!-- <div class="icon-name">sort-by-order</div> -->
        </div>
        <div class="icon" id="icon-sort-down" data-img="sort-down.png" type="arrow,configure">
            <div class="icon-img icon-sort-down"></div>
            <!-- <div class="icon-name">sort-down</div> -->
        </div>
        <div class="icon" id="icon-sort-reverse-alphabetical-order" data-img="sort-reverse-alphabetical-order.png" type="arrow">
            <div class="icon-img icon-sort-reverse-alphabetical-order"></div>
            <!-- <div class="icon-name">sort-reverse-alphabetical-order</div> -->
        </div>
        <div class="icon" id="icon-sort-up" data-img="sort-up.png" type="arrow,configure">
            <div class="icon-img icon-sort-up"></div>
            <!-- <div class="icon-name">sort-up</div> -->
        </div>
        <div class="icon" id="icon-speech-bubbles-comment-option" data-img="speech-bubbles-comment-option.png" type="configure">
            <div class="icon-img icon-speech-bubbles-comment-option"></div>
            <!-- <div class="icon-name">speech-bubbles-comment-option</div> -->
        </div>
        <div class="icon" id="icon-spinner-of-dots" data-img="spinner-of-dots.png" type="configure">
            <div class="icon-img icon-spinner-of-dots"></div>
            <!-- <div class="icon-name">spinner-of-dots</div> -->
        </div>
        <div class="icon" id="icon-square-shape-shadow" data-img="square-shape-shadow.png" type="configure">
            <div class="icon-img icon-square-shape-shadow"></div>
            <!-- <div class="icon-name">square-shape-shadow</div> -->
        </div>
        <div class="icon" id="icon-stack-exchange-logo" data-img="stack-exchange-logo.png" type="equipment,configure">
            <div class="icon-img icon-stack-exchange-logo"></div>
            <!-- <div class="icon-name">stack-exchange-logo</div> -->
        </div>
        <div class="icon" id="icon-stack-exchange-symbol" data-img="stack-exchange-symbol.png">
            <div class="icon-img icon-stack-exchange-symbol"></div>
            <!-- <div class="icon-name">stack-exchange-symbol</div> -->
        </div>
        <div class="icon" id="icon-star-1" data-img="star-1.png">
            <div class="icon-img icon-star-1"></div>
            <!-- <div class="icon-name">star-1</div> -->
        </div>
        <div class="icon" id="icon-star-half-empty" data-img="star-half-empty.png">
            <div class="icon-img icon-star-half-empty"></div>
            <!-- <div class="icon-name">star-half-empty</div> -->
        </div>
        <div class="icon" id="icon-star" data-img="star.png">
            <div class="icon-img icon-star"></div>
            <!-- <div class="icon-name">star</div> -->
        </div>
        <div class="icon" id="icon-step-backward" data-img="step-backward.png" type="arrow">
            <div class="icon-img icon-step-backward"></div>
            <!-- <div class="icon-name">step-backward</div> -->
        </div>
        <div class="icon" id="icon-step-forward" data-img="step-forward.png" type="arrow">
            <div class="icon-img icon-step-forward"></div>
            <!-- <div class="icon-name">step-forward</div> -->
        </div>
        <div class="icon" id="icon-stethoscope" data-img="stethoscope.png" type="equipment">
            <div class="icon-img icon-stethoscope"></div>
            <!-- <div class="icon-name">stethoscope</div> -->
        </div>
        <div class="icon" id="icon-strikethrough" data-img="strikethrough.png">
            <div class="icon-img icon-strikethrough"></div>
            <!-- <div class="icon-name">strikethrough</div> -->
        </div>
        <div class="icon" id="icon-suitcase-with-white-details" data-img="suitcase-with-white-details.png" type="equipment">
            <div class="icon-img icon-suitcase-with-white-details"></div>
            <!-- <div class="icon-name">suitcase-with-white-details</div> -->
        </div>
        <div class="icon" id="icon-sun" data-img="sun.png">
            <div class="icon-img icon-sun"></div>
            <!-- <div class="icon-name">sun</div> -->
        </div>
        <div class="icon" id="icon-superscript-text-formatting" data-img="superscript-text-formatting.png">
            <div class="icon-img icon-superscript-text-formatting"></div>
            <!-- <div class="icon-name">superscript-text-formatting</div> -->
        </div>
        <div class="icon" id="icon-table-grid" data-img="table-grid.png">
            <div class="icon-img icon-table-grid"></div>
            <!-- <div class="icon-name">table-grid</div> -->
        </div>
        <div class="icon" id="icon-tag-black-shape" data-img="tag-black-shape.png">
            <div class="icon-img icon-tag-black-shape"></div>
            <!-- <div class="icon-name">tag-black-shape</div> -->
        </div>
        <div class="icon" id="icon-tags" data-img="tags.png">
            <div class="icon-img icon-tags"></div>
            <!-- <div class="icon-name">tags</div> -->
        </div>
        <div class="icon" id="icon-tasks-list" data-img="tasks-list.png">
            <div class="icon-img icon-tasks-list"></div>
            <!-- <div class="icon-name">tasks-list</div> -->
        </div>
        <div class="icon" id="icon-telephone-handle-silhouette" data-img="telephone-handle-silhouette.png" type="equipment">
            <div class="icon-img icon-telephone-handle-silhouette"></div>
            <!-- <div class="icon-name">telephone-handle-silhouette</div> -->
        </div>
        <div class="icon" id="icon-telephone-symbol-button" data-img="telephone-symbol-button.png" type="equipment">
            <div class="icon-img icon-telephone-symbol-button"></div>
            <!-- <div class="icon-name">telephone-symbol-button</div> -->
        </div>
        <div class="icon" id="icon-terminal" data-img="terminal.png">
            <div class="icon-img icon-terminal"></div>
            <!-- <div class="icon-name">terminal</div> -->
        </div>
        <div class="icon" id="icon-text-file-1" data-img="text-file-1.png">
            <div class="icon-img icon-text-file-1"></div>
            <!-- <div class="icon-name">text-file-1</div> -->
        </div>
        <div class="icon" id="icon-text-file" data-img="text-file.png">
            <div class="icon-img icon-text-file"></div>
            <!-- <div class="icon-name">text-file</div> -->
        </div>
        <div class="icon" id="icon-text-height-adjustment" data-img="text-height-adjustment.png">
            <div class="icon-img icon-text-height-adjustment"></div>
            <!-- <div class="icon-name">text-height-adjustment</div> -->
        </div>
        <div class="icon" id="icon-text-width" data-img="text-width.png">
            <div class="icon-img icon-text-width"></div>
            <!-- <div class="icon-name">text-width</div> -->
        </div>
        <div class="icon" id="icon-thin-arrowheads-pointing-down" data-img="thin-arrowheads-pointing-down.png" type="arrow">
            <div class="icon-img icon-thin-arrowheads-pointing-down"></div>
            <!-- <div class="icon-name">thin-arrowheads-pointing-down</div> -->
        </div>
        <div class="icon" id="icon-three-small-square-shapes" data-img="three-small-square-shapes.png" type="configure">
            <div class="icon-img icon-three-small-square-shapes"></div>
            <!-- <div class="icon-name">three-small-square-shapes</div> -->
        </div>
        <div class="icon" id="icon-thumb-down" data-img="thumb-down.png" type="arrow,gesture">
            <div class="icon-img icon-thumb-down"></div>
            <!-- <div class="icon-name">thumb-down</div> -->
        </div>
        <div class="icon" id="icon-thumbs-down-silhouette" data-img="thumbs-down-silhouette.png" type="arrow,gesture">
            <div class="icon-img icon-thumbs-down-silhouette"></div>
            <!-- <div class="icon-name">thumbs-down-silhouette</div> -->
        </div>
        <div class="icon" id="icon-thumbs-up-hand-symbol" data-img="thumbs-up-hand-symbol.png" type="arrow,gesture">
            <div class="icon-img icon-thumbs-up-hand-symbol"></div>
            <!-- <div class="icon-name">thumbs-up-hand-symbol</div> -->
        </div>
        <div class="icon" id="icon-thumbs-up" data-img="thumbs-up.png" type="arrow,gesture">
            <div class="icon-img icon-thumbs-up"></div>
            <!-- <div class="icon-name">thumbs-up</div> -->
        </div>
        <div class="icon" id="icon-ticket" data-img="ticket.png">
            <div class="icon-img icon-ticket"></div>
            <!-- <div class="icon-name">ticket</div> -->
        </div>
        <div class="icon" id="icon-time" data-img="time.png">
            <div class="icon-img icon-time"></div>
            <!-- <div class="icon-name">time</div> -->
        </div>
        <div class="icon" id="icon-tint-drop" data-img="tint-drop.png">
            <div class="icon-img icon-tint-drop"></div>
            <!-- <div class="icon-name">tint-drop</div> -->
        </div>
        <div class="icon" id="icon-trash" data-img="trash.png" type="equipment,configure">
            <div class="icon-img icon-trash"></div>
            <!-- <div class="icon-name">trash</div> -->
        </div>
        <div class="icon" id="icon-trello-website-logo" data-img="trello-website-logo.png" type="equipment">
            <div class="icon-img icon-trello-website-logo"></div>
            <!-- <div class="icon-name">trello-website-logo</div> -->
        </div>
        <div class="icon" id="icon-trophy" data-img="trophy.png" type="equipment">
            <div class="icon-img icon-trophy"></div>
            <!-- <div class="icon-name">trophy</div> -->
        </div>
        <div class="icon" id="icon-tumblr-logo-1" data-img="tumblr-logo-1.png">
            <div class="icon-img icon-tumblr-logo-1"></div>
            <!-- <div class="icon-name">tumblr-logo-1</div> -->
        </div>
        <div class="icon" id="icon-tumblr-logo" data-img="tumblr-logo.png">
            <div class="icon-img icon-tumblr-logo"></div>
            <!-- <div class="icon-name">tumblr-logo</div> -->
        </div>
        <div class="icon" id="icon-turkish-lire-symbol" data-img="turkish-lire-symbol.png">
            <div class="icon-img icon-turkish-lire-symbol"></div>
            <!-- <div class="icon-name">turkish-lire-symbol</div> -->
        </div>
        <div class="icon" id="icon-twitter-black-shape" data-img="twitter-black-shape.png">
            <div class="icon-img icon-twitter-black-shape"></div>
            <!-- <div class="icon-name">twitter-black-shape</div> -->
        </div>
        <div class="icon" id="icon-twitter-sign" data-img="twitter-sign.png">
            <div class="icon-img icon-twitter-sign"></div>
            <!-- <div class="icon-name">twitter-sign</div> -->
        </div>
        <div class="icon" id="icon-two-columns-layout" data-img="two-columns-layout.png">
            <div class="icon-img icon-two-columns-layout"></div>
            <!-- <div class="icon-name">two-columns-layout</div> -->
        </div>
        <div class="icon" id="icon-u-shaped-thick-magnet" data-img="u-shaped-thick-magnet.png">
            <div class="icon-img icon-u-shaped-thick-magnet"></div>
            <!-- <div class="icon-name">u-shaped-thick-magnet</div> -->
        </div>
        <div class="icon" id="icon-umbrella-black-silhouette" data-img="umbrella-black-silhouette.png">
            <div class="icon-img icon-umbrella-black-silhouette"></div>
            <!-- <div class="icon-name">umbrella-black-silhouette</div> -->
        </div>
        <div class="icon" id="icon-underline-text-option" data-img="underline-text-option.png">
            <div class="icon-img icon-underline-text-option"></div>
            <!-- <div class="icon-name">underline-text-option</div> -->
        </div>
        <div class="icon" id="icon-undo-arrow" data-img="undo-arrow.png" type="arrow,configure">
            <div class="icon-img icon-undo-arrow"></div>
            <!-- <div class="icon-name">undo-arrow</div> -->
        </div>
        <div class="icon" id="icon-unlink-symbol" data-img="unlink-symbol.png">
            <div class="icon-img icon-unlink-symbol"></div>
            <!-- <div class="icon-name">unlink-symbol</div> -->
        </div>
        <div class="icon" id="icon-up-arrow" data-img="up-arrow.png" type="arrow">
            <div class="icon-img icon-up-arrow"></div>
            <!-- <div class="icon-name">up-arrow</div> -->
        </div>
        <div class="icon" id="icon-up-chevron-button" data-img="up-chevron-button.png" type="arrow">
            <div class="icon-img icon-up-chevron-button"></div>
            <!-- <div class="icon-name">up-chevron-button</div> -->
        </div>
        <div class="icon" id="icon-upload-button" data-img="upload-button.png" type="arrow">
            <div class="icon-img icon-upload-button"></div>
            <!-- <div class="icon-name">upload-button</div> -->
        </div>
        <div class="icon" id="icon-upload" data-img="upload.png" type="arrow">
            <div class="icon-img icon-upload"></div>
            <!-- <div class="icon-name">upload</div> -->
        </div>
        <div class="icon" id="icon-user-md-symbol" data-img="user-md-symbol.png">
            <div class="icon-img icon-user-md-symbol"></div>
            <!-- <div class="icon-name">user-md-symbol</div> -->
        </div>
        <div class="icon" id="icon-user-shape" data-img="user-shape.png">
            <div class="icon-img icon-user-shape"></div>
            <!-- <div class="icon-name">user-shape</div> -->
        </div>
        <div class="icon" id="icon-vertical-ellipsis" data-img="vertical-ellipsis.png" type="configure">
            <div class="icon-img icon-vertical-ellipsis"></div>
            <!-- <div class="icon-name">vertical-ellipsis</div> -->
        </div>
        <div class="icon" id="icon-vertical-resizing-option" data-img="vertical-resizing-option.png" type="arrow">
            <div class="icon-img icon-vertical-resizing-option"></div>
            <!-- <div class="icon-name">vertical-resizing-option</div> -->
        </div>
        <div class="icon" id="icon-video-play-square-button" data-img="video-play-square-button.png" type="arrow">
            <div class="icon-img icon-video-play-square-button"></div>
            <!-- <div class="icon-name">video-play-square-button</div> -->
        </div>
        <div class="icon" id="icon-vimeo-square-logo" data-img="vimeo-square-logo.png">
            <div class="icon-img icon-vimeo-square-logo"></div>
            <!-- <div class="icon-name">vimeo-square-logo</div> -->
        </div>
        <div class="icon" id="icon-vintage-key-outline" data-img="vintage-key-outline.png" type="configure">
            <div class="icon-img icon-vintage-key-outline"></div>
            <!-- <div class="icon-name">vintage-key-outline</div> -->
        </div>
        <div class="icon" id="icon-vk-social-network-logo" data-img="vk-social-network-logo.png">
            <div class="icon-img icon-vk-social-network-logo"></div>
            <!-- <div class="icon-name">vk-social-network-logo</div> -->
        </div>
        <div class="icon" id="icon-volume-off" data-img="volume-off.png" type="equipment">
            <div class="icon-img icon-volume-off"></div>
            <!-- <div class="icon-name">volume-off</div> -->
        </div>
        <div class="icon" id="icon-volume-up-interface-symbol" data-img="volume-up-interface-symbol.png" type="equipment">
            <div class="icon-img icon-volume-up-interface-symbol"></div>
            <!-- <div class="icon-name">volume-up-interface-symbol</div> -->
        </div>
        <div class="icon" id="icon-warning-sign-on-a-triangular-background" data-img="warning-sign-on-a-triangular-background.png" type="configure">
            <div class="icon-img icon-warning-sign-on-a-triangular-background"></div>
            <!-- <div class="icon-name">warning-sign-on-a-triangular-background</div> -->
        </div>
        <div class="icon" id="icon-weibo-website-logo" data-img="weibo-website-logo.png" type="equipment">
            <div class="icon-img icon-weibo-website-logo"></div>
            <!-- <div class="icon-name">weibo-website-logo</div> -->
        </div>
        <div class="icon" id="icon-wheelchair" data-img="wheelchair.png">
            <div class="icon-img icon-wheelchair"></div>
            <!-- <div class="icon-name">wheelchair</div> -->
        </div>
        <div class="icon" id="icon-white-flag-symbol" data-img="white-flag-symbol.png">
            <div class="icon-img icon-white-flag-symbol"></div>
            <!-- <div class="icon-name">white-flag-symbol</div> -->
        </div>
        <div class="icon" id="icon-windows-logo-silhouette" data-img="windows-logo-silhouette.png" type="equipment">
            <div class="icon-img icon-windows-logo-silhouette"></div>
            <!-- <div class="icon-name">windows-logo-silhouette</div> -->
        </div>
        <div class="icon" id="icon-x2-symbol-of-a-letter-and-a-number-subscript" data-img="x2-symbol-of-a-letter-and-a-number-subscript.png">
            <div class="icon-img icon-x2-symbol-of-a-letter-and-a-number-subscript"></div>
            <!-- <div class="icon-name">x2-symbol-of-a-letter-and-a-number-subscript</div> -->
        </div>
        <div class="icon" id="icon-xing-logo" data-img="xing-logo.png" type="equipment">
            <div class="icon-img icon-xing-logo"></div>
            <!-- <div class="icon-name">xing-logo</div> -->
        </div>
        <div class="icon" id="icon-xing-logotype" data-img="xing-logotype.png" type="equipment">
            <div class="icon-img icon-xing-logotype"></div>
            <!-- <div class="icon-name">xing-logotype</div> -->
        </div>
        <div class="icon" id="icon-yen-symbol" data-img="yen-symbol.png">
            <div class="icon-img icon-yen-symbol"></div>
            <!-- <div class="icon-name">yen-symbol</div> -->
        </div>
        <div class="icon" id="icon-youtube-logo-1" data-img="youtube-logo-1.png" type="equipment">
            <div class="icon-img icon-youtube-logo-1"></div>
            <!-- <div class="icon-name">youtube-logo-1</div> -->
        </div>
        <div class="icon" id="icon-youtube-logo-2" data-img="youtube-logo-2.png" type="equipment">
            <div class="icon-img icon-youtube-logo-2"></div>
            <!-- <div class="icon-name">youtube-logo-2</div> -->
        </div>
        <div class="icon" id="icon-youtube-logo" data-img="youtube-logo.png" type="arrow">
            <div class="icon-img icon-youtube-logo"></div>
            <!-- <div class="icon-name">youtube-logo</div> -->
        </div>
        <div class="icon" id="icon-zoom-in" data-img="zoom-in.png" type="configure">
            <div class="icon-img icon-zoom-in"></div>
            <!-- <div class="icon-name">zoom-in</div> -->
        </div>
        <div class="icon" id="icon-zoom-out" data-img="zoom-out.png" type="configure">
            <div class="icon-img icon-zoom-out"></div>
            <!-- <div class="icon-name">zoom-out</div> -->
        </div>
    </section>
</body>
<script type="text/javascript">
	$('.icon').on('click',  function(e) {
	    e.preventDefault();
	    e.stopPropagation();
	    var id = $(this).attr("id");
	    window.parent.updateIcon(id);
	    window.parent.closeWindow();
	});
	
	//过滤图标
	function filter(flat) {
		$("ul li").removeClass("selected");
		$(event.target).addClass("selected");
		if(flat === 'all'){
			$(".icon").show();
			return;
		} else if(flat === 'other'){
			var selected = "div[type*='arrow'],div[type*='configure'],div[type*='equipment'],div[type*='gesture']";
			$(selected).hide();
			$("div[class='icon']:not("+ selected +")").show();
		} else {
			var ary = flat.split(","), selected = "";
			for(var i in ary){
				selected += "div[type*='" + ary[i] + "'],";
			}
			selected = selected.substring(0, selected.length - 1);
			$("div[class='icon']:not("+ selected +")").hide();
			var showDom = $(selected);
			if(showDom.length > 0){
				showDom.show();
			}
		}
	}
</script>
</html>
