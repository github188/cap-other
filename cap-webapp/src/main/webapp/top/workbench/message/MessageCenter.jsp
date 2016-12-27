<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>消息中心-中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            .isRead_css input{
            	width: 17px;
            	height: 17px;
            }
			.isRead_css label{
				font-size:14px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp"%>
        <div class="app-nav">
            <img src="${pageScope.cuiWebRoot}/top/workbench/message/img/app-message.png" class="app-logo">
            <span class="app-name">消息中心</span>
        </div>
        <div class="workbench-container">
       		    <br>
       			&nbsp;&nbsp;时间: &nbsp; <span uitype="Calender" isrange="true" id="sendDate" panel="2" mindate="-365d" maxdate="-0d" width="220px" validate="[{ 'type':'custom','rule':{'against':'rule_function', 'm':'时间范围最多只能跨1个年份！'}}]"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;消息内容:  &nbsp; 
       			<span  id="messageBody" uitype="Input" on_keydown="keydown" width="150px"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;来源: &nbsp;
       			<span id="messageTitle" uitype="PullDown" mode="Single" value_field="messageTitle" label_field="messageTitle"  empty_text='全部'></span>
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       			<span id="isRead" uitype="CheckboxGroup" class="isRead_css">
			        <input type="checkbox" value="N" text="消息未读" />
			    </span>
       			&nbsp;&nbsp;&nbsp;&nbsp;
       			<span id="searchButtonId" uitype="Button" label="查询" on_click="searchButton"></span>
       			&nbsp;&nbsp;&nbsp;&nbsp;<span uitype="Button" label="全部设为已读" on_click="updateAllMessage"></span>
       			<br>
       			<br>
            <div id="message-container" class="message-container">
                <div id="message-list-container"> </div>
                <div id="more-btn" class="more-btn" style="display:none;">加载更多</div>
            </div>
            <div class="goto-top" title="回到顶部" > </div>
        </div>
        <script type="text/template" id="message-tmpl">
            <@if(!messages || messages.length ==0){@>
                <div style="position:absolute;top:50%;left:50%;">
                     <div style="position:relative;left:-50%;" class="no-data">暂无消息</div>
                </div>
            <@}@>
            <@  var preDate;
                _.each(messages,function(message,index){
                  var nextDate;
                  if(messages[index+1]){
                      nextDate = messages[index+1].sendDate;
                  }
				  var messageId = message.messageId;
                  var curDate = message.sendDate;
                  var year = curDate.getFullYear();
                  var month = curDate.getMonth() + 1;
                  var date = curDate.getDate();


				  if(message.messageUrl){
                    if(message.messageUrl.indexOf('?')>-1){
                      message.messageUrl += '&messageId='+ message.messageId;
                    }else{
                      message.messageUrl += '?messageId='+ message.messageId;
                    }
					message.messageUrl = encodeURIComponent(message.messageUrl);
                  }
            @>
            <@if(!DateUtil.isSameMonth(preDate,curDate)){@>
                <div class="message-header" data-month="<@=year@>-<@=month@>">
					<span class="month"><@=year@>年<@=month@>月</span>
					<div  style="position:absolute;top:0;left:88px;right: 8px;">
                    <table style="width:100%">
                        <thead>
                            <tr>
								<td style="width:5%;">&nbsp;</td>
								<td style="width:3%;">&nbsp;</td>
								<td style="width:15%;">来源</td>
								<td style="">内容</td>
								<td style="width:5%;align:right">&nbsp;</td>
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
                                <td style="width:5%;"><@=DateUtil.formatTime(curDate)@></td>
								<td style="width:3%;" >
									<div id="new-<@=message.messageId@>"
										<@if(message.isRead && message.isRead.toUpperCase() == 'N'){@>
											class="message-new" 
										<@}@>
									></div>	
								</td>
                                <td style="width:15%;" title="<@=message.messageTitle@>">
									<div style="width: 90px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden">
										<@=message.messageTitle@>
									</div>
								</td>
                                <td title="<@=replaceSpecialSymbols(message.messageBody)@>">
									<div style="width:650px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden">
									<@  if(message.messageUrl != null)  {@>
										<a target="_blank" onclick="updateMessage('<@=message.messageId@>','Y')" href="javascript:void(0)" data-url="<@=message.messageUrl@>" data-appcode="<@=message.appId@>" data-shownav="false"><@=replaceSpecialSymbols(message.messageBody)@></a>
									<@  }else{ @>
										<@=replaceSpecialSymbols(message.messageBody)@>
									<@  } @>
									</div>
								</td>
								<td style="width:5%;">
									<div class="button_read" id="button-<@=message.messageId@>">
										<@if(message.isRead && message.isRead.toUpperCase() == 'N'){@>
											<input type="button" class="set-read" value="设为已读" onclick="updateMessage('<@=message.messageId@>','Y')">
										<@}@>
									</div>	
								</td>
                            </tr>
                <@if(!DateUtil.isSameDay(nextDate,curDate)){@>
                        </table>
                    </div>
                </div>
                <@}@>
            <@})@>
        </script>
        <script>
			var condition = {};
	        condition.pageNo = 0;
	        condition.pageSize = 30;
	        
	  		//单号回车事件
	        function keydown(){
	        	if(event.keyCode==13) { 
	        		condition.pageNo = 0;
			        condition.pageSize = 30;
		            condition.messageBody = cui("#messageBody").getValue();
		            condition.isRead=cui("#isRead").getValue() != null ? cui("#isRead").getValue()[0] : null;
		            var sendDate = cui("#sendDate").getValue();
		            condition.startSendDate = sendDate[0];
		            condition.endSendDate = sendDate[1];
		            condition.messageTitle= cui("#messageTitle").getValue();
		            $('#message-list-container').html("");
		            $('#more-btn').click();
	        	}
	    	}
	    	
	  		//查询按钮
	    	function searchButton(){
		        condition.pageNo = 0;
		        condition.pageSize = 30;
	            condition.messageBody = cui("#messageBody").getValue();
	            condition.isRead=cui("#isRead").getValue() != null ? cui("#isRead").getValue()[0] : null;
	            var sendDate = cui("#sendDate").getValue();
	            condition.startSendDate = sendDate[0];
	            condition.endSendDate = sendDate[1];
	            condition.messageTitle= cui("#messageTitle").getValue();
	            $('#message-list-container').html("");
	            cui('#searchButtonId').disable(true);
	            $('#more-btn').click();
	    	}
	  		

	  		//全部置读
	  		function updateAllMessage(){
	  			MessageCenterAction.updateAllUnreadMessage(function(count) {
	  				if(count>0){
	  					window.location.reload();
	  				}
	  			 });  
	  		}
	  		
	  		function updateMessage(messageId,isRead){
	  			var params = {};
	  			params.messageId = messageId;
	  			params.isRead = isRead;
	  			MessageCenterAction.readAndUpdateMessage(params,function(count) {
	  				if(count>0){
	  					if(isRead=='Y'){
	  						$("#new-"+messageId).removeClass("message-new");
	  						$("#button-"+messageId).css("display","none");
	  					}
	  					window.parent.parent.queryUnreadMessageCount();
	  				}
	  			}); 
	  		}
	  		
	  		
            //初始化页面最小高度
            $(window).resize(function(){
                $('#message-container').setMinHeight($(window).height()-185);
            }).resize();
            
            $('#more-btn').click(function(){
	    		ajaxSearch();  
            });
            
            function ajaxSearch(){
	    		window.validater.disValid('sendDate', false);
	    		var valids = window.validater.validAllElement();
	    		if(valids[0].length != 0){//验证未通过
	    			cui.alert("时间范围最多只能跨1个年份！");
	    			cui('#searchButtonId').disable(false);
	    	        return ;
	    		}
            	condition.pageNo++;
                MessageCenterAction.queryMessageList(condition,function(messages) {
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
                    cui('#searchButtonId').disable(false);
                });  
            }
        
            require(['underscore', 'cui','workbench/dwr/interface/MessageCenterAction','workbench/message/js/message'], function(_) {
            	comtop.UI.scan();   
            	cui("#messageTitle").setDatasource(${sourceJson});          	
            	$('#more-btn').click();
            });

            /**
             * 时间范围最大只能跨1个年份
             */
            function rule_function(timeStr){
            	var strStart=cui("#sendDate").getValue()[0];
            	var strEnd=cui("#sendDate").getValue()[1];
        	  //为空时，默认查询当前时间1-2个年的数据
                if(strStart==""&&strEnd==""){
               	 return true;	 
                }
            	 var aStart=strStart.split('-')[0]; //转成成数组，分别为年，月，日，下同
            	 var aEnd=0;
                if(strEnd==""){
                    aEnd = new Date().getFullYear();
                 }else{
                	aEnd=strEnd.split('-')[0];
                 }
             	 //时间范围最大只能跨1个年份
             	if(aEnd-aStart<=1){
            		 return true;
            	 }
              	return false;
            }
        </script>
    </body>
</html>