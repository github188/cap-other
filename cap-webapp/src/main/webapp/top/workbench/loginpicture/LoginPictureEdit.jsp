<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>ͼƬ����-�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            .require{
                color:red;
            }
            table{
                border:0;
                margin: 0 auto;
            }
            .file-wrap{
                overflow:hidden;
                position:relative;
                display:inline-block;
                vertical-align: middle;
            }
            .file-input{
                position:absolute;
                top:-2px;
                right:0;
                font-size:100px;
                filter: alpha(opacity=0);
                opacity: 0;
                cursor:pointer;
            }
        </style>
    </head>
    <body>
        <div class="workbench-container">
            <form action="${pageScope.cuiWebRoot}/top/workbench/loginpicture/upload.ac" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td style="width:70px;"><span class="require">*</span>��Чʱ�䣺</td>
                    <td>
                        <span uitype="Calender" id="startDate" name="pictureVO.startDate" maxdate="#endDate" format="yyyy-MM-dd hh:mm:ss" validate="��ʼʱ�䲻��Ϊ��"></span>
                        &nbsp;����&nbsp;<span uitype="Calender" id="endDate" name="pictureVO.endDate" mindate="#startDate" format="yyyy-MM-dd hh:mm:ss" validate="����ʱ�䲻��Ϊ��"></span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td >
                        <span id="isYearLoop" uitype="CheckboxGroup" name="pictureVO.isYearLoop" value="['Y']">
                            <input type="checkbox" name="pictureVO.isYearLoop" value="Y"/>����ѭ��
                        </span>
                        <span style="color:red">(ȡ����ѡ��ʱ��ͬһʱ����л�������Ч)</span>
                    </td>
                </tr>
                <tr>
                    <td align="right"><span class="require">*</span>ͼƬ��</td>
                    <td >
                      <div style="margin-bottom:5px;">  ע��<span style="color:red;">ͼƬ��ʽ�����׺��Ϊ[.jpeg,.jpg,.gif,.png,.bmp]������ʹ�ô�ͼ������1920*1080</span></div>
                        <span uitype="input" id="filePath" width="400" readonly="true" validate="ͼƬ����Ϊ��"></span>
                        <div class="file-wrap">
                            <span uitype="Button" label="��ѡ��" ></span>
                            <input type="file" id="picture" name="picture" class="file-input"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right"><span class="require">*</span>��ע��</td>
                    <td >
                        <span uitype="textarea" name="pictureVO.remark" maxlength="2000" height="120" width="400" validate="��ע����Ϊ��"></span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td >
                        <span uitype="Button" label="����" id="saveBtn" button_type="blue-button"></span>
                    </td>
                </tr>
            </table>
            </form>
        </div>
        <script>
            var result = '${requestScope.result}';
            require(['cui','workbench/dwr/interface/LoginPictureAction'],function(){
                comtop.UI.scan();
                setDateRange();
                var imgType = '.jpeg,.jpg,.gif,.png,.bmp';
                $('#picture').change(function(){
                    var path=this.value,fileName = path.substring(path.lastIndexOf('/')),
                        ext = fileName.substring(fileName.lastIndexOf('.'))
                    if(imgType.search(new RegExp(ext,'i'))==-1){
                       top.cui.error('ֻ���ϴ���׺��Ϊ[' +��imgType + ']��ͼƬ');
                       this.value = null;
                       cui('#filePath').setValue(null);
                       return; 
                    }
                    cui('#filePath').setValue(this.value);
                });
                
                $('#saveBtn').click(function(){
                    //��֤��
                    if(!window.validater.validAllElement()[2]){
                        return;
                    }
					var pictureVO = {
                        isYearLoop:cui('#isYearLoop').getValueString('')=='Y'?'YES':'NO',
                        startDate:cui('#startDate').getValue('date'),
                        endDate:cui('#endDate').getValue('date')
                    };
                    //��֤��Чʱ���Ƿ��ͻ,���س�ͻ�ļ�¼�б�
                    LoginPictureAction.validateDate(pictureVO,function(list){
                        if(!list||list.length==0){
                            $('form').submit();
                        }else{
                            var nameList = [];
                            for(var i=0;i<list.length;i++){
                                nameList.push(list[i].name);
                            }
                            top.cui.error('��Чʱ��������ļ��г�ͻ��<br/>' + nameList.join('<br/>'));
                        }
                    });
                });
                if(result == 'success'){
                    top.cui.message('�ϴ��ɹ���');
                    window.top.cuiEMDialog.wins['LoginPictureDialog'].refresh();
                    window.top.cuiEMDialog.dialogs['LoginPictureDialog'].hide();
                }else if(result){
                    top.cui.error(result);
                }
            });
            /**
             *����ʱ���ѡ��ΧΪ����֮�� 
             */
            function setDateRange(){
                var minDate = new Date(), maxDate = new Date(),startDate = cui('#startDate'),endDate = cui('#endDate');
                minDate.setMonth(0);
                minDate.setDate(1);
                minDate.setHours(0);
                minDate.setMinutes(0);
                minDate.setSeconds(0);
                //����Ĭ��ʱ��
                startDate.setValue(minDate);
                //������Сʱ��
                startDate.setMinDate(minDate);
                
                maxDate.setMonth(11);
                maxDate.setDate(31);
                maxDate.setHours(23);
                maxDate.setMinutes(59);
                maxDate.setSeconds(59);
                //����Ĭ��ʱ��
                endDate.setValue(maxDate);
                //�������ʱ��
                endDate.setMaxDate(maxDate);
            }
        </script>
    </body>
</html>