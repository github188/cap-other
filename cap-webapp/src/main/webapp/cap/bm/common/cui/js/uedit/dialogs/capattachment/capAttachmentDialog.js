UE.registerUI('attachment',function(editor,uiName){
    var me = this;
    //创建dialog
    var dialog = new UE.ui.Dialog({
        //指定弹出层中页面的路径，这里只能支持页面,因为跟addCustomizeDialog.js相同目录，所以无需加路径
        iframeUrl: me.options.UEDITOR_HOME_URL + '/dialogs/capattachment/capattachment.html',
        //需要指定当前的编辑器实例
        editor:editor,
        //指定dialog的名字
        name:uiName,
        //dialog的标题
        title:"附件",

        //指定dialog的外围样式
        cssRules:"width:650px;height:280px;",

        //如果给出了buttons就代表dialog有确定和取消
        buttons:[
            {
                className:'edui-okbutton',
                label:'确定',
                onclick:function () {
                    dialog.close(true);
                }
            },
            {
                className:'edui-cancelbutton',
                label:'取消',
                onclick:function () {
                    dialog.close(false);
                }
            }
        ]});

    //参考addCustomizeButton.js
    var btn = new UE.ui.Button({
        name:'附件',
        title:'附件',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -620px -40px;',
        onclick:function () {
            //渲染dialog
            dialog.render();
            dialog.open();
        }
    });

    return btn;
}/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);

// plugins/insertfile.js
/**
 * 插入附件
 */
UE.plugin.register('capinsertfile', function (){

    var me = this;

    function getFileIcon(url){
        var ext = url.substr(url.lastIndexOf('.') + 1).toLowerCase(),
            maps = {
                "rar":"icon_rar.gif",
                "zip":"icon_rar.gif",
                "tar":"icon_rar.gif",
                "gz":"icon_rar.gif",
                "bz2":"icon_rar.gif",
                "doc":"icon_doc.gif",
                "docx":"icon_doc.gif",
                "pdf":"icon_pdf.gif",
                "mp3":"icon_mp3.gif",
                "xls":"icon_xls.gif",
                "chm":"icon_chm.gif",
                "ppt":"icon_ppt.gif",
                "pptx":"icon_ppt.gif",
                "avi":"icon_mv.gif",
                "rmvb":"icon_mv.gif",
                "wmv":"icon_mv.gif",
                "flv":"icon_mv.gif",
                "swf":"icon_mv.gif",
                "rm":"icon_mv.gif",
                "exe":"icon_exe.gif",
                "psd":"icon_psd.gif",
                "txt":"icon_txt.gif",
                "jpg":"icon_jpg.gif",
                "png":"icon_jpg.gif",
                "jpeg":"icon_jpg.gif",
                "gif":"icon_jpg.gif",
                "ico":"icon_jpg.gif",
                "bmp":"icon_jpg.gif"
            };
        return maps[ext] ? maps[ext]:maps['txt'];
    }

    function isImage (url) {
        var ext = url.substr(url.lastIndexOf('.') + 1).toLowerCase(),
        maps = {
                "jpg":"icon_jpg.gif",
                "png":"icon_jpg.gif",
                "jpeg":"icon_jpg.gif",
                "gif":"icon_jpg.gif",
                "ico":"icon_jpg.gif",
                "bmp":"icon_jpg.gif"
            };
        return maps[ext];
    }
    
    function insertfile(filelist){
        var i, item, icon, title,
            html = '',
            URL = me.getOpt('UEDITOR_HOME_URL'),
            iconDir = URL + (URL.substr(URL.length - 1) == '/' ? '':'/') + 'dialogs/capattachment/fileTypeImages/';
        for (i = 0; i < filelist.length; i++) {
            item = filelist[i];
            icon = iconDir + getFileIcon(item.url);
            title = item.title || item.url.substr(item.url.lastIndexOf('/') + 1);
            html += '<p style="line-height: 16px;">' +
                '<a style="font-size:12px; color:#0066cc;" href="' + item.url +'" title="' + title + '">' + 
                '<img style="vertical-align: middle; margin-right: 2px;" src="'+ icon + '" _src="' + icon + '" />' +
                title + '</a>' +
                '</p>';
        }
        me.execCommand('insertHtml', html);
    }

    return {
        commands:{
            'capinsertfile': {
                execCommand: function (command, filelist){
                    filelist = $.isArray(filelist) ? filelist : [filelist];
                    if (!filelist.length) {
                        return;
                    }

                    var me = this,
                        range = me.selection.getRange(),
                        img = range.getClosedNode();
                    var thumbnailFile;  //缩略图
                    var attachmentFile; //附件
                    for (i = 0; i < filelist.length; i++) {
                        if(isImage(filelist[i].url)) {
                            thumbnailFile = filelist[i];
                        }else {
                            attachmentFile = filelist[i];
                        }
                    }
                    // if(me.fireEvent('beforeinsertimage', opt) === true){
                    //     return;
                    // }
                    if(thumbnailFile && attachmentFile) {
                        var html = [], str = '';
                        str = '<a style="font-size:12px; color:#0066cc;" href="'+attachmentFile.url+'" title="' + (attachmentFile.title || attachmentFile.url.substr(attachmentFile.url.lastIndexOf('/') + 1)) + '">' + 
                        '<img src="' + thumbnailFile.url + '" ' + (thumbnailFile._src ? ' _src="' + thumbnailFile._src + '" ' : '') +
                        (thumbnailFile.width ? 'width="' + thumbnailFile.width + '" ' : '') +
                        (thumbnailFile.height ? ' height="' + thumbnailFile.height + '" ' : '') +
                        (thumbnailFile['floatStyle'] == 'left' || thumbnailFile['floatStyle'] == 'right' ? ' style="float:' + thumbnailFile['floatStyle'] + ';"' : '') +
                        (thumbnailFile.title && thumbnailFile.title != "" ? ' title="' + thumbnailFile.title + '"' : '') +
                        (thumbnailFile.border && thumbnailFile.border != "0" ? ' border="' + thumbnailFile.border + '"' : '') +
                        (thumbnailFile.alt && thumbnailFile.alt != "" ? ' alt="' + thumbnailFile.alt + '"' : '') +
                        (thumbnailFile.hspace && thumbnailFile.hspace != "0" ? ' hspace = "' + thumbnailFile.hspace + '"' : '') +
                        (thumbnailFile.vspace && thumbnailFile.vspace != "0" ? ' vspace = "' + thumbnailFile.vspace + '"' : '') + '/></a>';
                        if (thumbnailFile['floatStyle'] == 'center') {
                            str = '<p style="text-align: center">' + str + '</p>';
                        }

                        html.push(str);
                        me.execCommand('insertHtml', html.join(''));
                        // me.fireEvent('afterinsertimage', opt) 
                    }else{
                    	insertfile(filelist);
                        
                    }
                }
            }
        }
    }
});