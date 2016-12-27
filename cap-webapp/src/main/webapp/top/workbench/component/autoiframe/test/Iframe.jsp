<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>��ѯ����-�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp" %>
    </head>
    <body>
        <div style="height:112px;background:green;color:white;font-size:16px;text-align:center">
                                        �ڲ�iframe<br/>
            <button onclick="addHeight(50)">����50px</button>
            <button onclick="addHeight(-50)">����50px</button><br/>
            <button onclick="addAnimate(50)">��������50px</button>
            <button onclick="addAnimate(-50)">��������50px</button><br/>
            <button onclick="addResize(false)">�Ƴ�resize�¼�</button>
            <button onclick="addResize(true)">���resize�¼�</button><input id="resizeHeight" value="112" style="width:60px">
        </div>
        <div id="main" style="height:100px;background:yellow;color:black;font-size:24px;text-align:center" contenteditable="true">��������Ӧ
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
            //��������¼� ��ֹ���˼���Backspace��������С������ı������  
            function forbidBackSpace(e) {
                var ev = e || window.event; //��ȡevent����   
                var obj = ev.target || ev.srcElement; //��ȡ�¼�Դ   
                var t = obj.type || obj.getAttribute('type'); //��ȡ�¼�Դ����   
                //��ȡ��Ϊ�ж��������¼�����   
                var vReadOnly = obj.readOnly;  
                var vDisabled = obj.disabled;  
                //����undefinedֵ���   
                vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;  
                vDisabled = (vDisabled == undefined) ? true : vDisabled;  
                //����Backspace��ʱ���¼�Դ����Ϊ������С������ı��ģ�   
                //����readOnly����Ϊtrue��disabled����Ϊtrue�ģ����˸��ʧЧ   
                var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);  
                //����Backspace��ʱ���¼�Դ���ͷ�������С������ı��ģ����˸��ʧЧ   
                var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";  
                //�ж�   
                if (flag1 || flag2) return false;  
            }  
            //��ֹ���˼� ������Firefox��Opera  
            document.onkeypress = forbidBackSpace;  
            //��ֹ���˼�  ������IE��Chrome  
            document.onkeydown = forbidBackSpace;
            
            document.onkeypress = function(){return true};
            document.onkeydown = function(){return true};
        </script>
    </body>
</html>