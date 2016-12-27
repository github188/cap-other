<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>图片管理-中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            .label{
                display: inline-block;
                padding: 2px 4px;
                font-size: 10.152px;
                font-weight: bold;
                line-height: 14px;
                color: #fff;
                vertical-align: baseline;
                white-space: nowrap;
                text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
                background-color: #999;
                border-radius: 3px;
                cursor:pointer;
            }
            .used{
                background-color:#468847;
            }
        </style>
    </head>
    <body>
        <div id="gridWrap" style="background:#fff;padding:10px">
            <div style="text-align:right;margin-bottom:10px">
                <span class="pull-left" style="color:red">启用之前请尽量在高分辨率(1920*1080)和低分辨率(1024*768)下预览效果！！！</span>
                <span uitype="button" id="addBtn">新增</span>&nbsp;<span uitype="button" id="deleteBtn">删除</span>
            </div>
            <table id="picTable" class="cui_grid_list">
                <thead>
                    <tr>
                        <th width="40px" ><input type="checkbox" /></th>
                        <th width="120px"  bindName="name">图片名称</th>
                        <th width="120px"  bindName="startDate" format="yyyy-MM-dd hh:mm:ss">生效开始时间</th>
                        <th width="120px"  bindName="endDate" format="yyyy-MM-dd hh:mm:ss">生效结束时间</th>
                        <th width="60px"  bindName="isYearLoop" renderStyle="text-align: center;" render="renderLoop">按年循环</th>
                        <th width="100px"  bindName="id" render="renderImage" renderStyle="text-align: center;">图片</th>
                        <th width="200px"  bindName="remark">备注</th>
                        <th width="120px"  bindName="createDate" format="yyyy-MM-dd hh:mm:ss">创建时间</th>
                        <th width="40px"  bindName="isUsed" renderStyle="text-align: center;" render="renderUsed">操作</th>
                    </tr>
                </thead>
            </table>
        </div>
        <script>
            var result = '${requestScope.result}';
            var grid;
            window.onload=function(){
    			$('#gridWrap').height(function(){
    				return (document.documentElement.clientHeight || document.body.clientHeight) - 60;		
    			});  
      	 	}
            
            function renderImage(rd, index, col) {
                var src = webPath + '/top/workbench/loginpicture/display.ac?id=' + rd.id ;
                return '<a href="javascript:void(0)" onclick="preview(\''+rd.id+'\');return false" target="_blank"><img title="预览" style="width:80px;height:80px;" src="'+ src +'"/></a>';
            }
            /**
             *预览 
             */
            function preview(id){
                window.open(webPath + '/top/workbench/loginpicture/Preview.jsp?loginPictureId=' + id);
            }
            
            function renderLoop(rd, index, col){
                return rd.isYearLoop=='Y'?'是':'否';
            }
            
            function renderUsed(rd, index, col){
                return '<label class="label '+(rd.isUsed=='Y'?'un-used':'used')+'" data-id="'+rd.id+'">'+(rd.isUsed=='Y'?'停用':'启用')+'</lable>';
            }
            
            require(['cui','workbench/dwr/interface/LoginPictureAction'],function(){
                comtop.UI.scan();
                grid = cui('#picTable').grid({
                    primarykey:'id',
                    gridheight:'auto',
                    pagination:false,
                    colhidden:false,
                    datasource:function(gridObj,query){
                        LoginPictureAction.queryPictureList({},function(picList){
                            gridObj.setDatasource(picList);
                        });
                    },
                    resizewidth:function(){
                        return $(window).width()-20;
                    }
                });
                    
                $('#deleteBtn').click(function(){
                    var idList = cui('#picTable').getSelectedPrimaryKey();
                    if(!idList||idList.length==0){
                        top.cui.alert('请选择需要删除的记录。');
                        return;
                    }
                    cui.confirm('确定删除选中的记录吗？',{
                        onYes: function(){
                            LoginPictureAction.deletePictures(idList,function(result){
                                if(result>0){
                                    top.cui.message('删除成功。','success');
                                }else{
                                    top.cui.error('删除失败。','success');
                                }
                                refresh();
                            });
                        }
                    });
                });
                
                $('#picTable').on('click','.used',function(){
                    var $this= $(this),id=$this.data('id'),
                        rowData = grid.getRowsDataByPK(id)[0];
                    rowData.isUsed = 'Y';
                    rowData.picture = null;
                    //mybatis bug ,用于if判断的字符长度不能为1
                    rowData.isYearLoop = rowData.isYearLoop=='Y'?'YES':'NO';
                    //验证生效时间是否冲突,返回冲突的记录列表
                    LoginPictureAction.validateDate(rowData,function(list){
                        if(!list||list.length==0){
                            rowData.isYearLoop = rowData.isYearLoop=='YES'?'Y':'N';
                            LoginPictureAction.update(rowData,function(result){
                                if(result>0){
                                    top.cui.message('启用成功','success');
                                    $this.html('停用').removeClass('used').addClass('un-used');
                                    grid.changeData(rowData);
                                }else{
                                    top.cui.error('启用失败');
                                }
                            });
                        }else{
                            var nameList = [];
                            for(var i=0;i<list.length;i++){
                                nameList.push(list[i].name);
                            }
                            top.cui.error('生效时间和以下文件有冲突：<br/>' + nameList.join('<br/>'));
                        }
                    });
                }).on('click','.un-used',function(){
                    var $this= $(this),id=$this.data('id'),
                        rowData = grid.getRowsDataByPK(id);
                        rowData.picture = null;
                    LoginPictureAction.update({id:id,isUsed:'N'},function(result){
                        if(result>0){
                            top.cui.message('停用成功','success');
                            $this.html('启用').removeClass('un-used').addClass('used');
                            rowData.isUsed = 'N';
                            grid.changeData(rowData);
                        }else{
                            top.cui.error('停用失败');
                        }
                    });
                });
            });
            
            require(['cui.emDialog'],function(){
                $('#addBtn').click(function(){
                    cui.extend.emDialog({
                        id: 'LoginPictureDialog',
                        title: '新增',
                        src: webPath + '/top/workbench/loginpicture/LoginPictureEdit.jsp',
                        width: 600,
                        height: 400,
                        refresh:true,
                        onClose: function(){
                        }
                    }).show();
                });
            });
            
            function refresh(){
                cui('#picTable').loadData();
            }
            
        </script>
    </body>
</html>