<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>ͳ������-�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            html,body{
                background-color:#fff;
            }
            .empty-attention{
                position:absolute;
                top:50%;
                left:50%;
                text-align: center;
                color:#333;
                font-size:16px;
            }
            .empty-attention-inner{
                position:relative;
                left:-50%;
            }
            
        </style>
    </head>
    <body>
        <div id="container">
        <div class="empty-attention" id="empty-attention">
            <div class="empty-attention-inner">
                ����û�й�ע���õ�ͳ�Ʊ�������ർ������ӹ�ע��
            </div>
        </div>
        </div>
        <script type="text/javascript">
            //��ʼ��ҳ����С�߶�
            $(window).resize(function(){
                $('#container').height($(window.parent).height()-122);
            }).resize();
        </script>
    </body>
</html>