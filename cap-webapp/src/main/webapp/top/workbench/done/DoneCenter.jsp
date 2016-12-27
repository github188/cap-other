<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>�Ѱ�����</title>
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
            <span class="app-name">�Ѱ�����</span>
        </div>
        <div class="workbench-container">
       		    <br>
       			&nbsp;ʱ��: &nbsp; <span uitype="Calender" isrange="true" id="transdate" panel="2" mindate="-365d" maxdate="-0d" validate="[{ 'type':'custom','rule':{'against':'rule_function', 'm':'ʱ�䷶Χ���ֻ�ܿ�1���·ݣ�'}}]"  width="220px"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�������:  &nbsp; 
       			<span  id="workTitle" uitype="Input" on_keydown="keydown" width="150px"></span> 
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��Դ: &nbsp;
       			<span id="processId" uitype="PullDown" mode="Single" value_field="processId" label_field="processName"  empty_text='ȫ��'  auto_complete="true"></span>
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       			<span id="isDone" uitype="CheckboxGroup" class="isDone_css">
			        <input type="checkbox" value="-1" text="����δ����" />
			    </span>
       			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="searchButtonId" uitype="Button" label="��ѯ" on_click="searchButton"></span>
       			<br>
       			<br>
            <div id="message-container" class="message-container">
                <div id="message-list-container"> </div>
                <div id="more-btn" class="more-btn" style="display:none;">���ظ���</div>
                <div id="no-more" class="no-more" style="display:none;">�Ѿ�û�и���������</div>
            </div>
            <div class="goto-top" title="�ص�����"> </div>
        </div>
        <script type="text/template" id="message-tmpl">
            <@if(!messages || messages.length ==0){@>
                <div style="position:absolute;top:50%;left:50%;text-align: center;">
                     <div style="position:relative;left:-50%;" class="no-data">��������</div>
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
                    <span class="month"><@=year@>��<@=month@>��</span>
                    <div  style="position:absolute;top:0;left:88px;right: 8px;">
                    <table>
                        <thead>
                            <tr>
								<td style="width:7%"></td>
								<td style="width:15%">��Դ</td>
								<td style="width:63%">�������</td>
								<td style="width:15%">��ǰ�ڵ�</td>
							</tr>
                        </thead>
                    </table>
                    </div>
                </div>
            <@}@>   
                <@if(!DateUtil.isSameDay(preDate,curDate)){preDate = curDate;@>
                <div class="message-body" data-date="<@=year@>-<@=month@>-<@=date@>">
                    <div class="time-point" ><@=date@>��</div>
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
      		//���Żس��¼�
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
	    	
      		//��ѯ��ť
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
	    		if(valids[0].length != 0){//��֤δͨ��
	    			cui.alert("ʱ�䷶Χ���ֻ�ܿ�1���·ݣ�");
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
                        //�ų���ͬ�·�����,�����ƶ�����λ��
                        $temp = $temp.not(firstHeader).not(firstBodys);
                        var lastBody = $('.message-body:last');
                        var fBody = $(firstBodys[0]);
                        if(fBody.data('date') == lastBody.data('date')){
                            lastBody.find('tbody').append(fBody.find('tr'));
                            //�ų�ͬһ������
                            firstBodys = firstBodys.not(fBody);
                        }
                        lastBody.after(firstBodys);
                    }
                    $('#message-list-container').append($temp);
                    $(window).resize();
                    cui('#searchButtonId').disable(false);
                });  
	    	}
	    	//��ʼ��ҳ����С�߶�
            $(window).resize(function(){
                $('#message-container').setMinHeight($(window).height()-185);
            });
            require(['underscore', 'cui','workbench/dwr/interface/DoneCenterAction','workbench/message/js/message'], function(_) {
            	comtop.UI.scan();   
	    		cui("#processId").setDatasource(${processJson});
                $('#more-btn').click();
            });
            
            /**
             * ʱ�䷶Χ���ֻ�ܿ�1���·ݣ�
             */
            function rule_function(timeStr){
            	var strStart=cui("#transdate").getValue()[0];
            	var strEnd=cui("#transdate").getValue()[1];
        	  //Ϊ��ʱ��Ĭ�ϲ�ѯ��ǰʱ��1-2���µ�����
                if(strStart==""&&strEnd==""){
               	 return true;	 
                }
                if(strEnd==""){
                    var now = new Date();
                    strEnd = now.getFullYear()+"-"+(now.getMonth() + 1)+"-"+now.getDate();
                 }
             	 var aStart=strStart.split('-'); //ת�ɳ����飬�ֱ�Ϊ�꣬�£��գ���ͬ
            	 var aEnd=strEnd.split('-');
            	 var num=aEnd[1]-aStart[1];
            	 //ͬ�꣬��ʼ�·ݺͽ����·����ӦС��2����
             	 if(aStart[0]==aEnd[0]&&num<2){
             		 return true;
             	 }
             	 //�������⴦�����ǿ�ʼΪ12�¼�����Ϊ1�µĴ���
             	if((aEnd[0]-aStart[0]==1)&&aStart[1]==12&&aEnd[1]==1){
            		 return true;
            	 }
              	return false;
            }
        </script>
    </body>
</html>