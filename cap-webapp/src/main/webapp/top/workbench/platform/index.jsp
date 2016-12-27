<%@ include file="/top/component/common/Taglibs.jsp" %>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <title>首页-中国南方电网</title>
	<style type="text/css">
		::-webkit-scrollbar{width:9px;height:9px;box-sizing:border-box}::-webkit-scrollbar-button{width:9px;height:12px;background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAUCAYAAADRA14pAAADr0lEQVRYR71Yy04iQRQtE10IRiSBOLbOUvZmfkIlLHXjI+jCDzAm8w8TJKxZyENdqEui8BPuDVtsHCNGQcFEWUzdSt/KtbqqqZ44U0kn1V2n69xz63W6x5h9iXFoNADe521dftnibJlt+7PCjdmycpzz9vbmmvCTk5PzvK0NuNvbWyNuYWEBcbbUX8obSvBgMDAKiUQiUrDLi0nNPC9eYqwFfyWvTvAPHsm1JhqHEl9dXbHV1VUJo4Lv7u6k4JOTE7a5uSlxc3Nz/0ww5VXjR15VMIjFoop2+v2+EAJisaDoaDQqR/j+/l7gjo+PJW5ra0vUZ2dnqWDko1zqM+fi4kL0RxOMMaytrUneXC4ncMhFYzg4OBA4KpiK1Yl2Xl9fXSqWip6ampLEDw8PbrVa9U2S7e1tlkwmdYIBC6J1CXfOz8/ljAHRNIbFxcXs0tJShb/rHB4eShxw0RgymczPVCr1CwWrRCOJeQesVqtJUevr61JwPp+XxHt7e6xYLErc/v6+OqVHJvrl5cWt1+u+BEIMNzc3UvDj46NbqYD2zwViaLfbWsGBU+vs7EwIASIow+GQYSA8e5K4UCgIHBBBeX9/Z+VyWdT5CAliJabApdTr9UR/VDTGQPeO5+dngUMuGgPiQu3S3W7XHR8fl2IxaHjWbDalYAhwYmJCNH98fEht8KzVaukEA8a4WQIvdgKiacJjsZicWZgYwJZKJZlwiGF6etq3hpWk+24dzKAOODMzI4lhrZs6I2t9FB+2+3ghcZjIIF4YCJiFUJA31AjbCrY8N/9aMH2RCrbhDSP4OydKBETZ4W09fn3jV8SAG/Dnv/kFFtS22PC2eGdWOJNg3fnos3iXl5ci6HQ6zTxryVRbeXp6KjAbGxvMYCt1XDQZgpdy0UbV0lI+ikNuk9NCLN21fU4LQXA2ersgbP+fXBZiwG05jqNzWUE7NLwueHVmBxrpLg3c4OwoJ9aR+6udFgvhsugA/DeHZ3JaWi+tOi1q9bxdkHU6nU8uCxwPlkQiEeSjTaKFw8M+1JGmDg+4EUddFsSA3KFGWGcAVlZWBId3zrGnpyff4Z/NZgUmHo+bBIc2Hgqv+Cy14Q61hlUDgNkEcs8AMPXwR8zOzo48/Olc5vWRaxh4qctCsdCPajzAcFBOrI8yHtpdWj2HG42G6G95eZl55yHDLyokOjo6EtXd3V1Gvqh061e3jAAnjAfloi/Tcxi4KR/FIXeYc9jmFwpw2PwGUgY58NaG1/rX0h9d1DUzJEP0JgAAAABJRU5ErkJggg==);background-color:transparent;background-repeat:no-repeat}::-webkit-scrollbar-button:vertical:start{background-position:0px 0px}::-webkit-scrollbar-button:vertical:start:hover{background-position:-10px 0}::-webkit-scrollbar-button:vertical:start:active{background-position:-20px 0}::-webkit-scrollbar-button:vertical:end{background-position:-30px 0}::-webkit-scrollbar-button:vertical:end:hover{background-position:-40px 0}::-webkit-scrollbar-button:vertical:end:active{background-position:-50px 0}::-webkit-scrollbar-button:horizontal:start{background-position:0 -11px}::-webkit-scrollbar-button:horizontal:start:hover{background-position:-10px -11px}::-webkit-scrollbar-button:horizontal:start:active{background-position:-19px -11px}::-webkit-scrollbar-button:horizontal:end{background-position:-30px -11px}::-webkit-scrollbar-button:horizontal:end:hover{background-position:-40px -11px}::-webkit-scrollbar-button:horizontal:end:active{background-position:-50px -11px}::-webkit-scrollbar-track-piece{background-color:rgba(0,0,0,0.15);-webkit-border-radius:5px}::-webkit-scrollbar-thumb{background-color:#E7E7E7;border:1px solid rgba(0,0,0,0.21);-webkit-border-radius:5px}::-webkit-scrollbar-thumb:hover{background-color:#F6F6F6;border:1px solid rgba(0,0,0,0.21)}::-webkit-scrollbar-thumb:active{background:-webkit-gradient(linear, left top, left bottom, from(#e4e4e4), to(#f4f4f4))}::-webkit-scrollbar-corner{background-color:#f1f1f1;-webkit-border-radius:1px}
		#columns {padding:0 10px 55px 10px}
	</style>
</head>
<body>
<%@ include file="/top/workbench/base/MainNav.jsp" %>
<script type="text/javascript"
        src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/PlatFormAction.js"></script>
<div id="columns" class="column-wrap"></div>

<div class="task-portlet-tip">当前工作台为空，是否<a href="#">添加微件</a>？</div>
<div class="task-portlet-load-tip load-tip">正在加载桌面，请稍候</div>

<div id="taskBar" class="task-wrap task-out-hover">
    <div class="task-bar">
        <ul class="tools">
            <li class="tools-item"><a href="#" data-action="addPortlet" class="add-portlet"><span>添加微件</span></a></li>
            <li class="tools-item">
                <a href="#" data-action="editDesktop" class="add-desktop"><span>编辑桌面</span></a>
                <ul class="tools-menu" tabindex="-1">
                    <li><a href="#" data-action="setDesktop" data-default="true">设置当前桌面</a></li>
                    <li><a href="#" data-action="resetDesktop">重置当前桌面</a></li>
                    <li><a href="#" data-action="removeTask" data-default="true">删除当前桌面</a></li>
                </ul>
            </li>
        </ul>
        <div class="task">
            <ul></ul>
            <a href="#" class="add-task" data-action="addTask"><span title="点击添加桌面"></span></a>
        </div>
    </div>
</div>

<div id="taskDialog" class="task-dialog">
    <div class="desktop-form">
        <span style="color: red">*</span>桌面名称：<span id="txtTaskName" uitype="Input" maxlength="8" byte="false"></span>&nbsp;限8个字以内
    </div>
    <div class="desktop-template">
        <p>请选择要使用的模板</p>

        <div>
            <ul></ul>
        </div>
    </div>
</div>
<div id="portletDialog" class="portlet-dialog">
    <div class="class-list-wrap">
        <ul class="class-list">
        </ul>
    </div>
    <div class="portlet-list-wrap">
        <div class="portlet-list">
        </div>
    </div>
</div>

<%--静态模板文件、该模板用于将json数据转换静态的微件html文件--%>
<script type="text/template" id="portlet-tmpl">
    <@ if(portletAry.length>0){@>
    <@ _.each(portletAry,function(portlet){ @>
    <li class="widget" data-id="<@= portlet.portletId @>" editable="<@= portlet.editAble @>">
        <div class="widget-head">
            <h3>
                <@ if(portlet.selfName!=null){@>
                <@= portlet.selfName @>
                <@ }else{@>
                <@= portlet.portletName @>
                <@ }@>
            </h3>
        </div>
        <div class="widget-content">

            <iframe class="widget-iframe" frameborder="0" src="<@= Workbench.formatUrl(portlet.portletUrl) @>"></iframe>
        </div>
    </li>
    <@ })}@>
</script>

<%--静态模板文件、该模板用于将json数据转换静态的微件html文件--%>
<script type="text/template" id="single-portlet-tmpl">
    <li class="widget" data-id="<@= portlet.portletId @>" editable="<@= portlet.editAble @>">
        <div class="widget-head">
            <h3><@= portlet.portletName @></h3>
        </div>
        <div class="widget-content">
            <iframe class="widget-iframe" frameborder="0" src="<@= Workbench.formatUrl(portlet.portletUrl) @>"></iframe>
        </div>
    </li>
</script>


<script>
    require(["json2", "underscore", "cui", "workbench/platform/js/task"], function (json2, _, cui, Task) {
        var data = ${dragJson};
        var task = new Task({
            platformData: data,
            taskData: data.listPlatform,
            currentTaskIndex: data.intCurrentPlatformIndex
        });
    });
</script>
</body>
</html>