<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>已办中心</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            table{
                border-collapse: collapse;
            }
            table td{
                padding: 0;
                margin: 0;
            }
            .isDone_css input{
            	width: 17px;
            	height: 17px;
            }
			.isDone_css label{
				font-size:14px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp"%>
        <div class="app-nav">
            <img src="${pageScope.cuiWebRoot}/top/workbench/done/img/done.png" class="app-logo">
            <span class="app-name">已办中心</span>
        </div>
        <div class="workbench-container">
       		    <br>
       			&nbsp;时间: &nbsp; <span uitype="Calender" isrange="true" id="transdate" panel="2" mindate="-365d" maxdate="-0d" validate="[{ 'type':'custom','rule':{'against':'rule_function', 'm':'时间范围最多只能跨1个月份！'}}]"  width="220px"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核内容:  &nbsp; 
       			<span  id="workTitle" uitype="Input" on_keydown="keydown" width="150px"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;来源: &nbsp;
       			<span id="processId" uitype="PullDown" mode="Single" value_field="processId" label_field="processName"  empty_text='全部'  auto_complete="true"></span>
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       			<span id="isDone" uitype="CheckboxGroup" class="isDone_css">
			        <input type="checkbox" value="-1" text="流程未结束" />
			    </span>
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="searchButtonId" uitype="Button" label="查询" on_click="searchButton"></span>
       			<br>
       			<br>
            <div id="message-container" class="message-container">
                <div id="message-list-container"> </div>
                <div id="more-btn" class="more-btn" style="display:none;">加载更多</div>
                <div id="no-more" class="no-more" style="display:none;">已经没有更多内容了</div>
            </div>
            <div class="goto-top" title="回到顶部"> </div>
        </div>
        <script type="text/template" id="message-tmpl">
            <@if(!messages || messages.length ==0){@>
                <div style="position:absolute;top:50%;left:50%;text-align: center;">
                     <div style="position:relative;left:-50%;" class="no-data">暂无数据</div>
                </div>
            <@}@>
            <@  var preDate;
                _.each(messages,function(message,index){
                  var nextDate;
                  if(messages[index+1]){
                      nextDate = messages[index+1].transdate;
                  }
                  var curDate = message.transdate;
                  var year = curDate.getFullYear();
                  var month = curDate.getMonth() + 1;
                  var date = curDate.getDate();
            @>
            <@if(!DateUtil.isSameMonth(preDate,curDate)){@>
                <div class="message-header" data-month="<@=year@>-<@=month@>">
                    <span class="month"><@=year@>年<@=month@>月</span>
                    <div  style="position:absolute;top:0;left:88px;right: 8px;">
                    <table>
                        <thead>
                            <tr>
								<td style="width:7%"></td>
								<td style="width:15%">来源</td>
								<td style="width:63%">审核内容</td>
								<td style="width:15%">当前节点</td>
							</tr>
                        </thead>
                    </table>
                    </div>
                </div>
            <@}@>   
                <@if(!DateUtil.isSameDay(preDate,curDate)){preDate = curDate;@>
                <div class="message-body" data-date="<@=year@>-<@=month@>-<@=date@>">
                    <div class="time-point" ><@=date@>日</div>
                    <div class="message-list" >
                        <table class="message-table">
                <@}@>
                            <tr>
                                <td style="width:7%;" ><@=DateUtil.formatTime(curDate)@></td>
                                <td style="width:15%;" title="<@=message.processName@>">
									<div style="width: 140px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden">
									<@=message.processName@>
									</div>
								</td>
								<td title="<@= message.workOperate @><@= replaceSpecialSymbols(message.workTitle) @>" >
									<div style="width:550px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden">
									<@  if(message.doneUrl != null && message.isDisplay !='N' )  {@>
										<@= message.workOperate @>
        								<a target="_blank" href="javascript:void(0)" data-url="<@= replaceSpecialSymbolsInUrl(message.doneUrl) @>" data-appcode="<@=message.appId@>" data-shownav="false">								
											<@=replaceSpecialSymbols(message.workTitle)@>
										</a>
        							<@  }else{ @>
											<@= message.workOperate @>
											<@=replaceSpecialSymbols(message.workTitle)@>
									<@  } @>	
									</div>
								</td>
	                            <td style="width:15%;"><@=message.lastNodeName@></td>
							</tr>
                <@if(!DateUtil.isSameDay(nextDate,curDate)){@>
                        </table>
                    </div>
                </div>
                <@}@>
            <@})@>
        </script>
        <script type="text/javascript">
			var condition = {};
	        condition.pageNo = 0;
	        condition.pageSize = 30;
    		condition.isDone=null;
      		//单号回车事件
	        function keydown(){
	        	if(event.keyCode==13) { 
	        		condition.pageNo = 0;
			        condition.pageSize = 30;
	                condition.workTitle = jQuery.trim(cui("#workTitle").getValue());
	                var transdate = cui("#transdate").getValue();
	                condition.startTransdate = transdate[0];
	                condition.endTransdate = transdate[1];
	                condition.processId= cui("#processId").getValue();
	                condition.isDone=cui("#isDone").getValue() != null ? cui("#isDone").getValue()[0] : null;
	                $('#message-list-container').html("");
	                $('#more-btn').click();
	        	}
	    	}
	    	
      		//查询按钮
	    	function searchButton(){
		        condition.pageNo = 0;
		        condition.pageSize = 30;
                condition.workTitle = cui("#workTitle").getValue();
                var transdate = cui("#transdate").getValue();
                condition.startTransdate = transdate[0];
                condition.endTransdate = transdate[1];
                condition.processId= cui("#processId").getValue();
                condition.isDone=cui("#isDone").getValue() != null ? cui("#isDone").getValue()[0] : null;
                $('#message-list-container').html("");
                cui('#searchButtonId').disable(true);
                $('#more-btn').click();
	    	}

	    	
	    	$('#more-btn').click(function(){
	    		ajaxSearch();  
            })
            
            function ajaxSearch(){
	    		window.validater.disValid('transdate', false);
	    		var valids = window.validater.validAllElement();
	    		if(valids[0].length != 0){//验证未通过
	    			cui.alert("时间范围最多只能跨1个月份！");
	    			cui('#searchButtonId').disable(false);
	    	        return ;
	    		}
	    		condition.pageNo++;
                DoneCenterAction.queryDoneList(condition,function(messages) {
                	//$('#message-list-container').empty();
                    if(messages.count<=condition.pageNo*condition.pageSize){	
                        $('#more-btn').hide();
                    }else{
                        $('#more-btn').show();
                    }
                    var $temp = $(_.template($('#message-tmpl').html(), {
                        messages : messages.list,
                        DateUtil : DateUtil
                    }));
                    var lastHeader = $('.message-header:last');
                    var firstHeader = $temp.filter('.message-header:first');
                    if(lastHeader.data('month') == firstHeader.data('month')){
                        var firstBodys = $temp.filter('.message-body[data-date^='+firstHeader.data('month')+']');
                        //排除相同月份数据,不可移动调用位置
                        $temp = $temp.not(firstHeader).not(firstBodys);
                        var lastBody = $('.message-body:last');
                        var fBody = $(firstBodys[0]);
                        if(fBody.data('date') == lastBody.data('date')){
                            lastBody.find('tbody').append(fBody.find('tr'));
                            //排除同一天数据
                            firstBodys = firstBodys.not(fBody);
                        }
                        lastBody.after(firstBodys);
                    }
                    $('#message-list-container').append($temp);
                    $(window).resize();
                    cui('#searchButtonId').disable(false);
                });  
	    	}
	    	//初始化页面最小高度
            $(window).resize(function(){
                $('#message-container').setMinHeight($(window).height()-185);
            });
            require(['underscore', 'cui','workbench/dwr/interface/DoneCenterAction','workbench/message/js/message'], function(_) {
            	comtop.UI.scan();   
	    		cui("#processId").setDatasource(${processJson});
                $('#more-btn').click();
            });
            
            /**
             * 时间范围最大只能跨1个月份！
             */
            function rule_function(timeStr){
            	var strStart=cui("#transdate").getValue()[0];
            	var strEnd=cui("#transdate").getValue()[1];
        	  //为空时，默认查询当前时间1-2个月的数据
                if(strStart==""&&strEnd==""){
               	 return true;	 
                }
                if(strEnd==""){
                    var now = new Date();
                    strEnd = now.getFullYear()+"-"+(now.getMonth() + 1)+"-"+now.getDate();
                 }
             	 var aStart=strStart.split('-'); //转成成数组，分别为年，月，日，下同
            	 var aEnd=strEnd.split('-');
            	 var num=aEnd[1]-aStart[1];
            	 //同年，开始月份和结束月份相隔应小于2个月
             	 if(aStart[0]==aEnd[0]&&num<2){
             		 return true;
             	 }
             	 //跨年特殊处理，考虑开始为12月及结束为1月的处理
             	if((aEnd[0]-aStart[0]==1)&&aStart[1]==12&&aEnd[1]==1){
            		 return true;
            	 }
              	return false;
            }
        </script>
    </body>
</html>