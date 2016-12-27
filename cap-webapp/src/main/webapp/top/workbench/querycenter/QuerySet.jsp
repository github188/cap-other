<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>查询中心-中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <style>
            body{
                overflow:hidden;
                background-color:#fff;
                color:#000;
            }
           .main .left{
               float:left;
               margin:10px 0 10px 10px;
           }
           .main .right{
               float:right;
               margin:10px 10px 10px 0;
           }
           .main h6{
               font-size:12px;
               font-weight:normal;
               padding:0;
               margin: 0 0 -10px 10px;
               position: relative;
               background:#fff;
               width:44px;
               text-align: center;
           }
           .main .box{
               border:1px solid #f2f2f2;
           }
           .main ul{
               list-style: none;
               padding:0;
               margin:10px 0 0 0;
               width:280px;
               height:300px;
               overflow:auto;
           }
           .main ul li{
                margin-top:5px;   
           }
           .main ul a{
               display:block;
               padding:5px 10px;
               color:#333;
           }
           .main ul a:hover{
               text-decoration: none;
               background-color:#F5F5F5;
           }
           .main ul a img{
               height:20px;
               margin-right:5px;
               vertical-align: top;
           }
           .main hr{
               border:0;
               border-top:1px solid #f2f2f2;
               display:inline-block;
               width:10px;
               position:absolute;
           }
           .main .icon{
               float: right;
               font-style: normal;
               display:none;
               vertical-align:middle;
               height:20px;
               padding-left:18px;
               margin-left:5px;
               color:#0970d6;
           }
           .main .left ul a:hover .icon-remove,.main .left ul a:hover .icon-up-top{
               display:inline-block;
           }
           .main .right ul a:hover .icon-add{
               display:inline-block;
           }
           .main .icon-add{
               background:url(${pageScope.cuiWebRoot}/top/workbench/querycenter/img/add.png) top left no-repeat;
           }
           .main .icon-up-top{
               background:url(${pageScope.cuiWebRoot}/top/workbench/querycenter/img/up-top.png) top left no-repeat;
           }
           .main .icon-remove{
               background:url(${pageScope.cuiWebRoot}/top/workbench/querycenter/img/remove.png) top left no-repeat;
           }
           .footer{
               border-top:1px solid #ccc;
               line-height:55px;
               text-align:right;
               padding:0 10px;
           }
           .footer .tip{
               float:left;
               color:#797979;
           }
           .footer .round{
               font-size:16px;
               margin-right:2px;
           }
        </style>
    </head>
    <body>
        <div class="main clearfix">
            <div class="left">
                <h6>已显示</h6>
                <div class="box">
                    <ul id="show-list">
                        
                    </ul>
                </div>
            </div>
            <div class="right">
                <h6>已隐藏</h6>
                <div class="box">
                    <ul id="hidden-list">
                        
                    </ul>
                </div>
            </div>
        </div>
        <div class="footer">
            <span class="tip"><span class="round">●</span>小提示：上下拖拽模块可自定义排列顺序</span>
            <span uitype="button" id="save-btn">保存</span>
            <span uitype="button" id="cancel-btn">取消</span>
        </div>
        <script>
            var $hiddenList = $('#hidden-list'),$showList = $('#show-list');
            require(['cui'],function(){
                comtop.UI.scan();
                $('#cancel-btn').click(function(){
                    beforeClose();
                });
                $('#save-btn').click(function(){
                    var userData={},show={"display":"show"},hidden={"display":"hidden"};
                    $('>li',$showList).prop('id',function(index,id){
                        userData[id] = show;
                    });
                    $('>li',$hiddenList).prop('id',function(index,id){
                        userData[id] = hidden;
                    });
                    QueryCenter.saveUserData(userData,function(result){
                        if(result!='false'){
                            top.cui.message('保存成功','success');
                            colseWindow();
                            window.setTimeout(function(){
                                window.parent.location.reload();
                            },500);
                        }
                    });
                });
            });
            
            require(['workbench/querycenter/js/QueryCenter','jqueryui'],function(){
                QueryCenter.queryUserQueryMenu(function(userApps,hiddenApps) {
                    var i=0,j=0,app,showList=[],hiddenList=[];
                    for(;i<userApps.length;i++){
                        app = userApps[i];
                        showList.push('<li data-sortable="sortable" id="'+app.id+'"><a><img src="'+Workbench.formatUrl(app.logo)+'" />'+app.name+'<i class="icon icon-remove">移除</i><i class="icon icon-up-top">置顶</i><i class="icon icon-add">添加</i></a></li>');
                    }
                    $showList.html(showList.join(''));
                    for(;j<hiddenApps.length;j++){
                        app = hiddenApps[j];
                        hiddenList.push('<li id="'+app.id+'"><a><img src="'+Workbench.formatUrl(app.logo)+'" />'+app.name+'<i class="icon icon-remove">移除</i><i class="icon icon-up-top">置顶</i><i class="icon icon-add">添加</i></a></li>');
                    }
                    $hiddenList.html(hiddenList.join(''));
                });
            });
            require(['cui','jqueryui'], function() {
                /*拖动的核心代码*/
                $('#show-list').sortable({
                    items: 'li',
                    //handle: '',
                   // helper: 'clone',
                    revert: false,
                    delay: 100,
                    scroll : !comtop.Browser.isIE8,
                    tolerance: 'pointer',//设置当拖过多少的时候开始重新排序
                    containment: $('#show-list'),//设置拖动的范围
                    start: function (e, ui) {
                        
                    },
                    beforeStop: function (e, ui) {
                        
                    },
                    stop: function (e, ui) {
    
                    }
                });
                
            });
            
            var isChange = false;
            $(document).on('click','.icon-add',function(){
                $showList.prepend($(this).closest('li'));
                isChange = true;
            }).on('click','.icon-remove',function(){
                $hiddenList.prepend($(this).closest('li'));
                isChange = true;
            }).on('click','.icon-up-top',function(){
                $showList.prepend($(this).closest('li'));
                isChange = true;
            });
            
            function beforeClose(){
                if(isChange){
                    top.cui.confirm('放弃修改？',{
                        onYes: function(){
                           colseWindow();
                        }
                    });
                }else{
                    colseWindow();
                }
            }
            
            function colseWindow(){
                window.parent.setDialog.hide();
            }
        </script>
    </body>
</html>