<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>查询中心-中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp" %>
    </head>
    <body>
        <div style="height:112px;background:green;color:white;font-size:16px;text-align:center">
                                        内部iframe<br/>
            <button onclick="addHeight(50)">增高50px</button>
            <button onclick="addHeight(-50)">降低50px</button><br/>
            <button onclick="addAnimate(50)">动画增高50px</button>
            <button onclick="addAnimate(-50)">动画降低50px</button><br/>
            <button onclick="addResize(false)">移除resize事件</button>
            <button onclick="addResize(true)">添加resize事件</button><input id="resizeHeight" value="112" style="width:60px">
        </div>
        <div id="main" style="height:100px;background:yellow;color:black;font-size:24px;text-align:center" contenteditable="true">内容自适应
        </div>
        <script>
            var isResize = false;
            window.onresize = function(){
                //console.log('inner resize');
                if(isResize){
                    $('#main').height($(window).height()-$('#resizeHeight').val());
                }
            };
            
            $('#main').height($(window).height()-112);
            function addHeight(h){
                $('#main').height($('#main').height() + h);
            }
            function addAnimate(h){
                $('#main').animate({height:$('#main').height() + h});
            }
            function addResize(flag){
                isResize = flag;
            }
            //处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外  
            function forbidBackSpace(e) {
                var ev = e || window.event; //获取event对象   
                var obj = ev.target || ev.srcElement; //获取事件源   
                var t = obj.type || obj.getAttribute('type'); //获取事件源类型   
                //获取作为判断条件的事件类型   
                var vReadOnly = obj.readOnly;  
                var vDisabled = obj.disabled;  
                //处理undefined值情况   
                vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;  
                vDisabled = (vDisabled == undefined) ? true : vDisabled;  
                //当敲Backspace键时，事件源类型为密码或单行、多行文本的，   
                //并且readOnly属性为true或disabled属性为true的，则退格键失效   
                var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);  
                //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效   
                var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";  
                //判断   
                if (flag1 || flag2) return false;  
            }  
            //禁止后退键 作用于Firefox、Opera  
            document.onkeypress = forbidBackSpace;  
            //禁止后退键  作用于IE、Chrome  
            document.onkeydown = forbidBackSpace;
            
            document.onkeypress = function(){return true};
            document.onkeydown = function(){return true};
        </script>
    </body>
</html>