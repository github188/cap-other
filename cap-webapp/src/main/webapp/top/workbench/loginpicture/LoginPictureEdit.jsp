<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>图片管理-中国南方电网</title>
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
                    <td style="width:70px;"><span class="require">*</span>生效时间：</td>
                    <td>
                        <span uitype="Calender" id="startDate" name="pictureVO.startDate" maxdate="#endDate" format="yyyy-MM-dd hh:mm:ss" validate="开始时间不能为空"></span>
                        &nbsp;至：&nbsp;<span uitype="Calender" id="endDate" name="pictureVO.endDate" mindate="#startDate" format="yyyy-MM-dd hh:mm:ss" validate="结束时间不能为空"></span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td >
                        <span id="isYearLoop" uitype="CheckboxGroup" name="pictureVO.isYearLoop" value="['Y']">
                            <input type="checkbox" name="pictureVO.isYearLoop" value="Y"/>按年循环
                        </span>
                        <span style="color:red">(取消该选择时在同一时间段中会优先生效)</span>
                    </td>
                </tr>
                <tr>
                    <td align="right"><span class="require">*</span>图片：</td>
                    <td >
                      <div style="margin-bottom:5px;">  注：<span style="color:red;">图片格式必须后缀名为[.jpeg,.jpg,.gif,.png,.bmp]；尽量使用大图，比如1920*1080</span></div>
                        <span uitype="input" id="filePath" width="400" readonly="true" validate="图片不能为空"></span>
                        <div class="file-wrap">
                            <span uitype="Button" label="请选择" ></span>
                            <input type="file" id="picture" name="picture" class="file-input"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right"><span class="require">*</span>备注：</td>
                    <td >
                        <span uitype="textarea" name="pictureVO.remark" maxlength="2000" height="120" width="400" validate="备注不能为空"></span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td >
                        <span uitype="Button" label="保存" id="saveBtn" button_type="blue-button"></span>
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
                       top.cui.error('只能上传后缀名为[' +　imgType + ']的图片');
                       this.value = null;
                       cui('#filePath').setValue(null);
                       return; 
                    }
                    cui('#filePath').setValue(this.value);
                });
                
                $('#saveBtn').click(function(){
                    //验证表单
                    if(!window.validater.validAllElement()[2]){
                        return;
                    }
					var pictureVO = {
                        isYearLoop:cui('#isYearLoop').getValueString('')=='Y'?'YES':'NO',
                        startDate:cui('#startDate').getValue('date'),
                        endDate:cui('#endDate').getValue('date')
                    };
                    //验证生效时间是否冲突,返回冲突的记录列表
                    LoginPictureAction.validateDate(pictureVO,function(list){
                        if(!list||list.length==0){
                            $('form').submit();
                        }else{
                            var nameList = [];
                            for(var i=0;i<list.length;i++){
                                nameList.push(list[i].name);
                            }
                            top.cui.error('生效时间和以下文件有冲突：<br/>' + nameList.join('<br/>'));
                        }
                    });
                });
                if(result == 'success'){
                    top.cui.message('上传成功。');
                    window.top.cuiEMDialog.wins['LoginPictureDialog'].refresh();
                    window.top.cuiEMDialog.dialogs['LoginPictureDialog'].hide();
                }else if(result){
                    top.cui.error(result);
                }
            });
            /**
             *设置时间可选范围为当年之内 
             */
            function setDateRange(){
                var minDate = new Date(), maxDate = new Date(),startDate = cui('#startDate'),endDate = cui('#endDate');
                minDate.setMonth(0);
                minDate.setDate(1);
                minDate.setHours(0);
                minDate.setMinutes(0);
                minDate.setSeconds(0);
                //设置默认时间
                startDate.setValue(minDate);
                //设置最小时间
                startDate.setMinDate(minDate);
                
                maxDate.setMonth(11);
                maxDate.setDate(31);
                maxDate.setHours(23);
                maxDate.setMinutes(59);
                maxDate.setSeconds(59);
                //设置默认时间
                endDate.setValue(maxDate);
                //设置最大时间
                endDate.setMaxDate(maxDate);
            }
        </script>
    </body>
</html>