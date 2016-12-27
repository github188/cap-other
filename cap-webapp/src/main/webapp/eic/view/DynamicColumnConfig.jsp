<%@ page language="java" import="java.util.*" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link  rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/eic/cui/themes/default/css/comtop.ui.min.css"></link>
<link  rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/eic/css/eic.css"></link>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
<title><fmt:message key="DCC_Title" /></title>
<script type="text/javascript">
 var _pt = window.top.cuiEMDialog.wins.dyColumnDialog;
 var param = "";
	//关闭AJAX请求缓存
 $.ajaxSetup ({
    cache: false
 });
 var exitDataArr = new Array();
 var errorInfo = "<%=request.getAttribute("errorInfo") == null?"":request.getAttribute("errorInfo")%>"; 
 var url = "<%=request.getAttribute("taskListUrl") == null?"":request.getAttribute("taskListUrl")%>";
 if("" == errorInfo){
	 errorInfo = "<%=request.getParameter("errorInfo") == null?"":request.getParameter("errorInfo")%>"; 
 }
 if("" == url){
	 url = "<%=request.getParameter("taskListUrl") == null?"":request.getParameter("taskListUrl")%>";
 }
 var buttonId = "<%=request.getParameter("buttonId") == null?"":request.getParameter("buttonId")%>";
 var userId = "<%=request.getParameter("userId") == null?"":request.getParameter("userId")%>";
 var excelId = "<%=request.getParameter("excelId") == null?"":request.getParameter("excelId")%>";
 var subSystem = "<%=request.getParameter("subSystem") == null?"":request.getParameter("subSystem")%>";
 var exportType = "<%=request.getParameter("exportType") == null?"":request.getParameter("exportType")%>";
 var excelVersion = "<%=request.getParameter("excelVersion")==null?"":request.getParameter("excelVersion")%>";
 var asyn = "<%=request.getParameter("asyn")==null?"":request.getParameter("asyn")%>";
 var exportFileName = "<%=request.getParameter("exportFileName") == null?"":request.getParameter("exportFileName")%>";
 var templateName = "<%=request.getParameter("templateName") == null?"":request.getParameter("templateName")%>";
 var objButton = window.parent.cuiEMDialog.wins["dyColumnDialog"].document.getElementById(buttonId);
 var objEicBizBigData = window.parent.cuiEMDialog.wins["exportDialog"].document.getElementById("eicBizBigData");
 
 if($(objButton).attr("param")){
 	param = $(objButton).attr("param");
 	if(param){
 		param = encodeURIComponent(param);
     } 
 }

 if(objEicBizBigData){
	 var eicBizBigData = objEicBizBigData.value;
	 if(param != null && param != "" && param != undefined ){
		param = encodeURIComponent(param + "eicBizBigData:"+eicBizBigData);
	 }else{
	 	param = encodeURIComponent("eicBizBigData:"+eicBizBigData);
	 }
}
 
 if("" != url){
	 try{
	    _pt.openTaskMonitorList(url);
	    _pt.isDelExportDialog = true;
	    _pt.exportDialog.hide();
	 }catch(e){
	 } 
 }else if("" != errorInfo){
	 _pt.dyColumnDialog.hide();
	 _pt.isDelExportDialog = true;
	 if(null != _pt.exportDialog){
		 _pt.exportDialog.hide();
	 }
	 _pt.openErrorDialog("<%=request.getContextPath()%>/eic/view/ExcelExportError.jsp?errorInfo="+errorInfo);
 }
 var screenHeight = 768; //默认分辨率高位768
 try{
	if(typeof(window.screen.height) != "undefined"){
		screenHeight = window.screen.height;
	}
 }catch(e){}
 //按字节截取函数，不会有乱码
 function getLenStr(a,cc){
 	cc=parseInt(cc);
 	var i=0,count=0;
 	while(i<a.length){
 		if (a.charCodeAt(i)>0 && a.charCodeAt(i)<255){
 		count++;
 		}else count+=2;
 		if(count<=cc)
 		i++;
 		else break;
 	}
 	return a.substr(0,i);
  }
</script>
<style type="text/css">
.text-autocut {
  overflow: hidden;
  white-space: nowrap;
  -webkit-text-overflow: ellipsis;
  -khtml-text-overflow: ellipsis;
  -icab-text-overflow: ellipsis;
  -moz-text-overflow: ellipsis;
  -o-text-overflow: ellipsis;
  text-overflow: ellipsis;
}
</style>
</head>
<body onselectstart="return false;">
   <div id="dataDivId" align="center" style="padding-top:10px;padding-bottom:0;padding-left:3px;padding-right:3px;">
		<table class="selcol">
			<tr>
				<td valign="top">
					<div class="toselect">
						<div class="toselect-title"><fmt:message key="OptionalColumn" /></div>
							<ul id="columId" class="toselect-list">
							    
							</ul>
				    </div>
				</td>
				<td align="center">
					<div class="operate">
					    <img onclick="addCol()" src="<%=request.getContextPath()%>/eic/images/add_one.png" title="<fmt:message key="add" />" >
						<img onclick="addAll()" src="<%=request.getContextPath()%>/eic/images/add_all.png" title="<fmt:message key="addAll" />" >
						<img onclick="removeCol()" src="<%=request.getContextPath()%>/eic/images/delete_one.png" title="<fmt:message key="delete" />" >
						<img onclick="removeAll()" src="<%=request.getContextPath()%>/eic/images/delete_all.png" title="<fmt:message key="deleteAll" />">
					</div>
				</td>
				<td valign="top">
					<div class="selected">
						<div class="selected-title"><fmt:message key="derivedColumn" /></div>
						<ul id="exportColumId" class="selected-list">
							
						</ul>
					<div>
				</td>
				
				

				<td align="left" valign="top" style="padding-top:15px;">
					<div id="moveColumn" style="display:none;" class="sort-icon">
						<img src="<%=request.getContextPath()%>/eic/images/toTop.gif"  title="<fmt:message key="top" />"  onclick="toTop()"/>
						<img src="<%=request.getContextPath()%>/eic/images/moveUp.gif"  title="<fmt:message key="shiftUp" />" onclick="moveUp()"/>
						<img src="<%=request.getContextPath()%>/eic/images/moveDown.gif"  title="<fmt:message key="shiftDown" />" onclick="moveDown()"/>
						<img src="<%=request.getContextPath()%>/eic/images/toBottom.gif"  title="<fmt:message key="bottom" />" onclick="toButtom()"/>
					</div>
				</td>

				
				
			</tr>
			<tr>
				<td colspan="4" valign="middle" align="center">
					
				</td>
			</tr>
			<tr>
				<td colspan="4" valign="middle" align="center">
					
				</td>
			</tr>
			<tr>
				<td colspan="4" valign="middle" align="center">
					
				</td>
			</tr>
			<tr>
				<td colspan="4" valign="middle" align="center">
					<a class="button" onclick="confirmOk()"><fmt:message key="confirm" /></a>&nbsp;&nbsp;<a class="button" onclick="cancel()"><fmt:message key="cancel" /></a>
				</td>
			</tr>
		</table>
</div>		
<!-- 做form方式提交请求 -->
	<table style="display:none;">
	 <tr>
	   <td>
	      <form method="post" action="<%=request.getContextPath()%>/eic/view/ExcelVersionOption.jsp" id="bizFormId" name="bizFormName">
	        
	      </form>
	   </td>
	 </tr>
</table>
</body>
</html>
<script type="text/javascript">
            var shiftFlag = false;
            var ctrlFlag = false;
	        function getWidth(rate){
	        	if($.browser.msie) {
	        		if($.browser.version == 7){
	        			rate = rate - 0.01;
		        	}
        		}
	    		return $(window).width() * rate;
			}
	
		    function getHeight(rate){
		    	if($.browser.msie) {
	        		if($.browser.version == 7){
	        			rate = rate - 0.015;
		        	}else if($.browser.version == 6){
		        		rate = rate + 0.015;
			        }
        		}
		    	return $(window).height() * rate;
			}

		    var liImgClickFlag = false;
		    var selectFlags = [];
		    var toSelectFlags = [];
		    var flag = false;
		    var index = null;
            //注册被选中列表的li事件,把选中状态设置为自己
			$(document).ready(function(){
				setPageTagSize();
				getColumnDatas();
				$('.toselect-list li').click(function(event){
					if(false == liImgClickFlag){
					  var calssName =  $(this).parent().attr("class");
					  if(true == shiftFlag){
						handleShift($(this),calssName,event);
						return;
					  }else if(true == ctrlFlag){
						handleCtrl($(this),calssName,event);
                        return;
					  }
					  $('.toselect-list li').each(function(){
						  if("curr" == $(this).attr("class")){
							  $(this).removeClass('curr');
							  $(this).find("img").css("display","none");
						  }
				      });
					  $('.selected-list li').each(function(){
						  if("curr" == $(this).attr("class")){
							  $(this).removeClass('curr');
							  $(this).find("img").css("display","none");
						  }
				      });
				      if("columId" == $(this).parent().attr('id')){
					      select(this,calssName);
				      }else{
				    	  toSelect(this,calssName);
				      }
					  flag = false;
					}else{
						liImgClickFlag = false;
					}
				});
				$('.toselect-list li').dblclick(function(){
					var calssName =  $(this).parent().attr("class");
				    if("selected-list" == calssName){
				    	for(var i = 0 ; i < toSelectFlags.length ; i++){
						  	 if(toSelectFlags[i] == $(this).attr('id')){
						  		index = i;
							 }
						}
				    	toSelectFlags.splice(index,1);
				      	removeColDB($(this).attr('id'));
					}else{
						for(var i = 0 ; i < selectFlags.length ; i++){
						  	 if(selectFlags[i] == $(this).attr('id')){
						  		index = i;
							 }
						}
						selectFlags.splice(index,1);
					  	addColDB($(this).attr('id'));
					}
				});
				for(var index = 0; index < exitDataArr.length;index++){
					 $('.toselect-list li').each(function(){
						  if($.trim(exitDataArr[index]) == $.trim($(this).text())){
							  $(this).addClass('curr');
							  addCol();
						  }
				     });
				}
			});
			function select(self,calssName){
				for(var i = 0 ; i < selectFlags.length ; i++){
				  	 if(selectFlags[i] == $(self).attr('id')){
				  		flag = true;
				  		index = i;
				  		$(self).removeClass('curr');
				  		if("selected-list" == calssName){
					  		$(self).find("img").css("display","none");
					  	}
					 }
				}
				if(flag == true){
					selectFlags.splice(index,1);
				}
				if(flag == false){
					selectFlags.push($(self).attr('id'));
				    $(self).addClass('curr');
				    if("selected-list" == calssName){
				      $(self).find("img").css("display","inline");
					}else{
					  $(self).find("img").css("display","none");
					}
				}
			}
			function toSelect(self,calssName){
				for(var i = 0 ; i < toSelectFlags.length ; i++){
				  	 if(toSelectFlags[i] == $(self).attr('id')){
				  		flag = true;
				  		index = i;
				  		$(self).removeClass('curr');
				  		if("selected-list" == calssName){
					  		$(self).find("img").css("display","none");
					  	}
					 }
				}
				if(flag == true){
					toSelectFlags.splice(index,1);
				}
				if(flag == false){
					toSelectFlags.push($(self).attr('id'));
				    $(self).addClass('curr');
				    if("selected-list" == calssName){
				      $(self).find("img").css("display","inline");
					}else{
					  $(self).find("img").css("display","none");
					}
				}
			}
			function removeColDB(id){
				var $currCol = $('#exportColumId #'+id);
				if($currCol.length==0){
					return;
				}
				$currCol.find("img").css("display","none");
				$('.toselect-list').append($currCol.removeClass('curr'));
				reSetLiId();
			}
			
			function addColDB(id){
				var $currCol = $('#columId #'+id);
				if($currCol.length==0){
					return;
				}
				$currCol.find("img").css("display","none");
				$('.selected-list').append($currCol.removeClass('curr'));
				reSetLiId();
			}

			function getColumnDatas(){
			 	 var params = {};
		         params.userId = userId;
		         params.excelId = excelId;
		         params.subSystem = subSystem;
		         params.exportType = exportType;
		         params.param = param;
		         params.asyn = asyn;
		         params.exportFileName = exportFileName;
		         params.curDate = new Date();
		     	 $.ajax({    
		     		type: "post",    
		     		url: "<%=request.getContextPath()%>"+subSystem+"/eic/eic.excelExport",    
		     		dataType: "json",
		     		data: params,
		     		async:false,
		     		success: function (data) {
		     		   if(data[0] && typeof(data[0].error) != "undefined"){
		                  	$("#dataDivId").hide();   
		                  	_pt.dyColumnDialog.hide();
			               	_pt.isDelExportDialog = true;
			               	if(null != _pt.exportDialog){
			               	  _pt.exportDialog.hide();
			               	}
			               	var dyColumnErrorInfo = encodeURIComponent(data[0].error); 
		               	    _pt.openErrorDialog("<%=request.getContextPath()%>/eic/view/ExcelExportError.jsp?errorInfo="+dyColumnErrorInfo);
		                    return;
		               }	    
		     		   if(3 == data.length){
			     		  
                          if(!data[0].templateName){
                              $("#moveColumn").css("display","");
                          }
                          
		     			  if(data[1] && data[1].length > 0){
			     			 var html = "";
		     				 for(var j = 0; j < data[1].length;j++){
		     					 html = html + '<li id="liId_'+j+'" title="'+data[1][j]+'" class="text-autocut">';
		     					 html = html + getLenStr(data[1][j],40);
		     					 html = html + '<img onclick="delLiImg(this)" style="display:none;" src="<%=request.getContextPath()%>/eic/images/li_del.gif" title="<fmt:message key="delete" />" ></li>';
                             }
                             $("#columId").html("");
                             $("#columId").html(html);
			     		  }
		     			  if(data[2] && data[2].length > 0){
                             for(var i = 0; i < data[2].length;i++){
                            	 exitDataArr.push(data[2][i]);
                             }
			     	      }
		         	   }else{
		         		  //cui.alert("查询失败。");
		               }
		     		},    
		     		error: function (XMLHttpRequest, textStatus, errorThrown) {
		     			//cui.alert("查询失败。");
		     		}    
		        }); 
			}

			function reSetLiId(){
				 var index = 0;
				 $('.toselect-list li').each(function(){
					$(this).attr("id","xliId_"+index);
				    index++;
			     });
				 index = 0;
				 $('.selected-list li').each(function(){
					 $(this).attr("id","xliId_"+index);
					 index++;
			    });
			}

            //处理Ctrl事件
			function handleCtrl(self,parentCalssName,event){
				if("selected-list" == parentCalssName){
				  $('.toselect-list li').each(function(){
					  if("curr" == $(this).attr("class")){
						  $(this).removeClass('curr');
						  $(this).find("img").css("display","none");
					  }
			      });
				}else{
				  $('.selected-list li').each(function(){
					  if("curr" == $(this).attr("class")){
						  $(this).removeClass('curr');
						  $(this).find("img").css("display","none");
					  }
			      });
			   }
			   var calssName =  self.attr("class");
			   if("curr" == calssName){
				   self.removeClass('curr');
				   self.find("img").css("display","none");
			   }else{
				   self.addClass('curr');
			       if("selected-list" == parentCalssName){
			    	   self.find("img").css("display","inline");
				   }else{
					   self.find("img").css("display","none");
				   }
			   }
			   stopDefault(event);
			}

			//处理Shift事件
			function handleShift(self,parentCalssName,event){
			    var startIndex = -1;
				var endIndex =  (self.attr("id")).split("_")[1];
				var tempIndex = 0;
			    $('.toselect-list li').each(function(){
				  if("curr" == $(this).attr("class")){-
					  $(this).removeClass('curr');
					  $(this).find("img").css("display","none");
					  tempIndex = ($(this).attr("id")).split("_")[1];
					  if(-1 == startIndex || startIndex > tempIndex){
						  startIndex = tempIndex;
					  }
				  }
		        });
			    $('.selected-list li').each(function(){
				  if("curr" == $(this).attr("class")){
					  $(this).removeClass('curr');
					  $(this).find("img").css("display","none");
					  tempIndex = ($(this).attr("id")).split("_")[1];
					  if(-1 == startIndex || startIndex > tempIndex){
						  startIndex = tempIndex;
					  }
				  }
		        });
			    self.addClass('curr');
			    if("selected-list" == parentCalssName){
			    	self.find("img").css("display","inline");
				}else{
					self.find("img").css("display","none");
				} 
			   tempIndex =  parseInt(tempIndex,10);
			   startIndex =  parseInt(startIndex,10);
			   endIndex =  parseInt(endIndex,10);
			   tempIndex = startIndex;
		       if(startIndex > endIndex){
		    	  startIndex = endIndex;
		    	  endIndex = tempIndex;
			   }
			   if(-1 == startIndex){
                 return;
			   }
			   if("selected-list" == parentCalssName){
				  $('.selected-list li').each(function(){
					  tempIndex = ($(this).attr("id")).split("_")[1];
					  tempIndex =  parseInt(tempIndex,10);
					  if(tempIndex >= startIndex && tempIndex <= endIndex){
						  $(this).addClass('curr');
						  $(this).find("img").css("display","inline");
					  }
			      });
			   }else{
				  $('.toselect-list li').each(function(){
					  tempIndex = ($(this).attr("id")).split("_")[1];
					  tempIndex =  parseInt(tempIndex,10);
					  if(tempIndex >= startIndex && tempIndex <= endIndex){
						  $(this).addClass('curr');
						  $(this).find("img").css("display","none");
					  }
			      });
			   }
			   stopDefault(event);
			}

            //监听窗口变化
			$(window).resize(function(){
				setPageTagSize();
			});

			//新增列
			function addCol() {
				var $currCol = $('.toselect-list li.curr');
				if($currCol.length==0){
					return;
				}
				$currCol.find("img").css("display","none");
				$('.selected-list').append($currCol.removeClass('curr'));
				reSetLiId();
				selectFlags = [];
			}

            //移动出列
			function removeCol() {
				var $currCol = $('.selected-list li.curr');
				if($currCol.length==0){
					return;
				}
				$currCol.find("img").css("display","none");
				$('.toselect-list').append($currCol.removeClass('curr'));
				reSetLiId();
				toSelectFlags = [];
			}

            //添加全部列
			function addAll() {
				$('.toselect-list li').each(function(){
					if("text-autocut curr" == $(this).attr("class")){
						  $(this).removeClass('curr');
						  $(this).find("img").css("display","none");
					}
					$('.selected-list').append($(this));
				});
				reSetLiId();
				selectFlags = [];
			}

            //删除全部列
			function removeAll() {
				$('.selected-list li').each(function(){
					if("text-autocut curr" == $(this).attr("class")){
						  $(this).removeClass('curr');
						  $(this).find("img").css("display","none");
					}
					$('.toselect-list').append($(this));
				});
				reSetLiId();
				toSelectFlags = [];
			}

            //移动到顶部
			function toTop() {
				var $currCol = $('.selected-list li.curr');
				$('.selected-list').prepend($currCol);
				reSetLiId();
			}

            //上移
			function moveUp() {
				var $currCol = $('.selected-list li.curr');
				$($currCol[0]).prev().before($currCol);
				reSetLiId();
			}

            //下移
			function moveDown() {
				var $currCol = $('.selected-list li.curr');
				$($currCol[$currCol.length-1]).next().after($currCol);
				reSetLiId();
			}

            //移动到底部
			function toButtom() {
				var $currCol = $('.selected-list li.curr');
				$('.selected-list').append($currCol);
				reSetLiId();
			}

			//设置选中好的列
			function confirmOk() {
				if("" != errorInfo){
				   return;
				}
				var columns = new Array();  
				$('.selected-list li').each(function(){
					columns.push($.trim($(this).attr("title")));
				});
				if(0 == columns.length){
                   return;
			    }
				_pt.exportDialog.show("<%=request.getContextPath()%>/eic/view/ExcelVersionOption.jsp?exportType=dyan&sysName="+subSystem+"&asyn="+asyn+"&processDivFlag=yes&eversion="+excelVersion+"&process=yes&userId=<%=request.getParameter("userId") == null?"":request.getParameter("userId")%>");
				submit(columns);
			    _pt.dyColumnDialog.hide();
			}

			//取消
			function cancel(){
			   _pt.dyColumnDialog.hide();	
			   _pt.exportDialog.hide();
			}

			//提交数据设置请求
			function submit(columns){
                var html = "<input type=\"hidden\" name=\"exportType\" value=\"dyan\">";
                var p = "<%=request.getParameter("param") == null?"":request.getParameter("param").replaceAll("\"","'")%>";
                html = html + "<input type=\"hidden\" name=\"processDivFlag\" value=\"yes\">";
                html = html + "<input type=\"hidden\" name=\"flag\" value=\"dynamicColumnProcess\">";
                html = html + "<input type=\"hidden\" name=\"sysName\" value=\"<%=request.getParameter("subSystem") == null?"":request.getParameter("subSystem")%>\">";
                html = html + "<input type=\"hidden\" name=\"excelId\" value=\"<%=request.getParameter("excelId") == null?"":request.getParameter("excelId")%>\">";
                html = html + "<input type=\"hidden\" name=\"buttonId\" value=\"<%=request.getParameter("buttonId") == null?"":request.getParameter("buttonId")%>\">";
                html = html + "<input type=\"hidden\" name=\"userId\" value=\"<%=request.getParameter("userId") == null?"":request.getParameter("userId")%>\">";
                html = html + "<input type=\"hidden\" name=\"excelVersion\" value=\""+excelVersion+"\">";
                html = html + "<input type=\"hidden\" name=\"param\" value=\""+p.toString()+"\">";
                html = html + "<input type=\"hidden\" name=\"asyn\" value=\"<%=request.getParameter("asyn") == null?"":request.getParameter("asyn")%>\">";
                html = html + "<input type=\"hidden\" name=\"exportFileName\" value=\"<%=request.getParameter("exportFileName") == null?"":request.getParameter("exportFileName")%>\">";
                for(var i = 0; i < columns.length;i++){
                	html = html + "<input type=\"hidden\" name=\"columns\" value=\""+encodeURIComponent(columns[i])+"\">";
			    }
				$("#bizFormId").append(html);
				document.bizFormName.submit();
		    }

			function delLiImg(self){
				liImgClickFlag = true;
				$(self).parent().addClass('curr');
				$(self).parent().find("img").css("display","none");
				for(var i = 0 ; i < toSelectFlags.length ; i++){
				  	 if(toSelectFlags[i] == $(self).parent().attr('id')){
				  		index = i;
					 }
				}
				toSelectFlags.splice(index,1);
				removeColDB($(self).parent().attr('id'));
			}

			//设置页面元素的宽高
		    function setPageTagSize(){
			    //根据不同的分辨率设置不同的高度比率
			    var rateH1 = 0.65;
			    var rateH2 = 0.02;
		    	$('.toselect').css("width",getWidth(0.36));
				$('.selected').css("width",getWidth(0.36));
				$('.toselect-list').css("width",getWidth(0.36));
				$('.selected-list').css("width",getWidth(0.36));
				$('.toselect-list').css("height",getHeight(rateH1));
				$('.selected-list').css("height",getHeight(rateH1));
				$('.operate').css("height",getHeight(0.5));
				$('.operate').css("width",getWidth(0.15));
				$('.selcol').css("height",getHeight(rateH1));
				$('.select-btn').css("height",getHeight(rateH2));
			}

			//键盘按下事件
		    $(document).keydown(function(event){
		    	var varkey = (event.keyCode) || (event.which) || (event.charCode);
		    	if(16 == varkey){
		    		shiftFlag = true;
				}else if(17 == varkey){
					ctrlFlag = true;
				}
		    	stopDefault(event);
		    });

			//键盘抬起事件
		    $(document).keyup(function(event){
		    	var varkey = (event.keyCode) || (event.which) || (event.charCode);
		    	if(16 == varkey){
		    		shiftFlag = false;
			    }if(17 == varkey){
			    	ctrlFlag = false;
				}
			    stopDefault(event);
		    });

		    function stopBubble(e) {
	    	   //如果提供了事件对象，则这是一个非IE浏览器
	    	   if (e && e.stopPropagation){
	    	     //因此它支持W3C的stopPropagation()方法
	    	     e.stopPropagation();
	    	   }else{
	    	     //否则，我们需要使用IE的方式来取消事件冒泡
	    	     window.event.cancelBubble = true;
	    	   }
	    	}
	    	//阻止浏览器的默认行为
	    	function stopDefault(e) {
	    	  //阻止默认浏览器动作(W3C)
	    	  if (e && e.preventDefault){
	    	      e.preventDefault();
	    	  }else{
	    		 //IE中阻止函数器默认动作的方式
	    	     window.event.returnValue = false;
	    	  }
	    	  return false;
	    	}
      </script>