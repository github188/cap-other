<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>ͼƬ����-�й��Ϸ�����</title>
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
                <span class="pull-left" style="color:red">����֮ǰ�뾡���ڸ߷ֱ���(1920*1080)�͵ͷֱ���(1024*768)��Ԥ��Ч��������</span>
                <span uitype="button" id="addBtn">����</span>&nbsp;<span uitype="button" id="deleteBtn">ɾ��</span>
            </div>
            <table id="picTable" class="cui_grid_list">
                <thead>
                    <tr>
                        <th width="40px" ><input type="checkbox" /></th>
                        <th width="120px"  bindName="name">ͼƬ����</th>
                        <th width="120px"  bindName="startDate" format="yyyy-MM-dd hh:mm:ss">��Ч��ʼʱ��</th>
                        <th width="120px"  bindName="endDate" format="yyyy-MM-dd hh:mm:ss">��Ч����ʱ��</th>
                        <th width="60px"  bindName="isYearLoop" renderStyle="text-align: center;" render="renderLoop">����ѭ��</th>
                        <th width="100px"  bindName="id" render="renderImage" renderStyle="text-align: center;">ͼƬ</th>
                        <th width="200px"  bindName="remark">��ע</th>
                        <th width="120px"  bindName="createDate" format="yyyy-MM-dd hh:mm:ss">����ʱ��</th>
                        <th width="40px"  bindName="isUsed" renderStyle="text-align: center;" render="renderUsed">����</th>
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
                return '<a href="javascript:void(0)" onclick="preview(\''+rd.id+'\');return false" target="_blank"><img title="Ԥ��" style="width:80px;height:80px;" src="'+ src +'"/></a>';
            }
            /**
             *Ԥ�� 
             */
            function preview(id){
                window.open(webPath + '/top/workbench/loginpicture/Preview.jsp?loginPictureId=' + id);
            }
            
            function renderLoop(rd, index, col){
                return rd.isYearLoop=='Y'?'��':'��';
            }
            
            function renderUsed(rd, index, col){
                return '<label class="label '+(rd.isUsed=='Y'?'un-used':'used')+'" data-id="'+rd.id+'">'+(rd.isUsed=='Y'?'ͣ��':'����')+'</lable>';
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
                        top.cui.alert('��ѡ����Ҫɾ���ļ�¼��');
                        return;
                    }
                    cui.confirm('ȷ��ɾ��ѡ�еļ�¼��',{
                        onYes: function(){
                            LoginPictureAction.deletePictures(idList,function(result){
                                if(result>0){
                                    top.cui.message('ɾ���ɹ���','success');
                                }else{
                                    top.cui.error('ɾ��ʧ�ܡ�','success');
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
                    //mybatis bug ,����if�жϵ��ַ����Ȳ���Ϊ1
                    rowData.isYearLoop = rowData.isYearLoop=='Y'?'YES':'NO';
                    //��֤��Чʱ���Ƿ��ͻ,���س�ͻ�ļ�¼�б�
                    LoginPictureAction.validateDate(rowData,function(list){
                        if(!list||list.length==0){
                            rowData.isYearLoop = rowData.isYearLoop=='YES'?'Y':'N';
                            LoginPictureAction.update(rowData,function(result){
                                if(result>0){
                                    top.cui.message('���óɹ�','success');
                                    $this.html('ͣ��').removeClass('used').addClass('un-used');
                                    grid.changeData(rowData);
                                }else{
                                    top.cui.error('����ʧ��');
                                }
                            });
                        }else{
                            var nameList = [];
                            for(var i=0;i<list.length;i++){
                                nameList.push(list[i].name);
                            }
                            top.cui.error('��Чʱ��������ļ��г�ͻ��<br/>' + nameList.join('<br/>'));
                        }
                    });
                }).on('click','.un-used',function(){
                    var $this= $(this),id=$this.data('id'),
                        rowData = grid.getRowsDataByPK(id);
                        rowData.picture = null;
                    LoginPictureAction.update({id:id,isUsed:'N'},function(result){
                        if(result>0){
                            top.cui.message('ͣ�óɹ�','success');
                            $this.html('����').removeClass('un-used').addClass('used');
                            rowData.isUsed = 'N';
                            grid.changeData(rowData);
                        }else{
                            top.cui.error('ͣ��ʧ��');
                        }
                    });
                });
            });
            
            require(['cui.emDialog'],function(){
                $('#addBtn').click(function(){
                    cui.extend.emDialog({
                        id: 'LoginPictureDialog',
                        title: '����',
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