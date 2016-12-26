;(function($, C) {
    C.UI.Capattachment = C.UI.Base.extend({
    	/**
    	 * 相关配置
    	 */
    	config: {
    		//web应用名字
         	webPath : '/' + window.location.pathname.split('/')[1],
        	//上传下载action dwr文件引入路径
         	dwrActionPath :  webPath + '/cap/dwr/interface/FileLoaderAction.js'

    	},

        options: {
            uitype: 'Capattachment',        //组件类型
            mode: 'Single',
            uploadKey: '',
            fileName:'',
            accept:""
        },

        /**
         * 获取文件ico路径
         */
        getFileIcon: function(fileName){
            var ext = fileName.substr(fileName.lastIndexOf('.') + 1).toLowerCase(),
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
            return this.config.webPath + '/cap/bm/common/cui/js/uedit/dialogs/capattachment/fileTypeImages/' + (maps[ext] ? maps[ext] : maps['txt']);
        },

        _init: function() {
        	var me = this;

            this.$elem = $(me.options.el);
            this.fileNum = 0;
            // this.uploadId = 'JZC2NG2HYBMJCEZG';
        
            if(this.options.uploadKey !== null || this.options.uploadKey !== undefined || this.options.uploadKey !== '') {
            	//加载dwr FileLoaderAction.js文件
	            $.getScript(this.config.dwrActionPath, function(data, textStatus) {
	                me.dwrAction = window.FileLoaderAction;
	                if($.isEmptyObject(me.dwrAction)) {
	                    throw new Error('未引入FileLoaderAction.js文件出错,请检查引入路径：' + this.config.dwrActionPath);
	                }
	                me.create();
	            });
            }else {
                throw new Error('未指定uploadKey.');
            }
        },

        /**
         * 初始化方法
         * @private
         */
        create: function() {
            var me = this;
            var $listUi = me.$listUi = $("<ui/>");
            $listUi.wrap('<div class=""></div>');
            //使用dwr查询对应数据
            if(!me._isBlankValue()) {
            	this.dwrAction.getFileNames(me.options.uploadKey, me.uploadId, function (fileNameArray) {
                if(fileNameArray && fileNameArray.length > 0) {
                    // me.fileNum = fileNameArray.length;
                	if(me.options.fileName && window[me.options.fileName] && Object.prototype.toString.call(window[me.options.fileName]) === "[object Array]"){ 
                		//用于记录页面上指定的文件在服务器上不存在的文件名
                		var _arr =[]; 
                		//遍历页面指定的文件名集合
                		for(var k = 0; k < window[me.options.fileName].length; k++){
                			var hasMatch = false;
                			//遍历服务器上的文件名集合
                			for (var i = 0; i < fileNameArray.length; i++) {
                				//若有匹配
                				if(window[me.options.fileName][k] == fileNameArray[i]){
                					hasMatch = true;
                					//显示在页面上
                					me.appendAttachmentHtml({'fileName': fileNameArray[i]});
                				}
                			}
                			//没有匹配，记录下来
                			if(!hasMatch){
                				_arr.push(window[me.options.fileName][k]);
                			}
                		}
                		//遍历不匹配的集合，从页面指定的文件名集合中把不匹配的删除
                		if(_arr.length > 0){
                			for(var n = 0; n < _arr.length; n++){
                				for(var m = 0; m < window[me.options.fileName].length; m++){
                					if(_arr[n] == window[me.options.fileName][m]){
                						window[me.options.fileName].splice(m, 1);
                						break;
                					}
                				}
                			}
                		}
                	} else {
                        for (var i = 0; i < fileNameArray.length; i++) {
                            me.appendAttachmentHtml({'fileName': fileNameArray[i]});
                        }
                    }
                }
            });
            }
            
            me.$elem.append($listUi);
            var fileHTML = "";
            if(me.options.accept){
            	fileHTML = '<input type="file"  accept="' + me.options.accept + '"/>';
            }else{
            	fileHTML = '<input type="file"/>'
            }
            me.$elem.append(fileHTML);

            //文件列表绑定下载、删除事件
            $listUi.on('click', 'li', function(event) {
                event.preventDefault();
                if($(event.target).data('action-type') === 'download') {        //点击名字就下载
                    me.downloadAttachment(event.currentTarget);
                }else if($(event.target).data('action-type') === 'delete'){     //点击删除
                    me.removeAttachment(event.currentTarget);
                }
            });
            
            //绑定上传事件
            me.$elem.on('change', 'input[type="file"]', function(event) {
                event.preventDefault();
                me.uploadAttachment(event.currentTarget);
            });
        },

        /**
         * 上传附件
         * @param  fileElem 附件元素
         */
        uploadAttachment: function (fileElem) {
            var $fileElem = fileElem instanceof jQuery ? fileElem : $(fileElem);
            var me = this;
            //dwr调用
            var attachmentAttr = {'uploadKey':this.options.uploadKey};
            if(!this._isBlankValue()) {
            	attachmentAttr.uploadId = this.uploadId;
            }
            window.dwr.TOPEngine.setAttributes(attachmentAttr);
            this.dwrAction.uploadFile(fileElem, function (loadFile) {
                if(loadFile) {
                    //第一次上传需要保存uploadId
                    if(me._isBlankValue()) {  
                        me.setValue(loadFile.uploadId);
                        me.$elem.attr('uploadId', me.uploadId);
                    }
                    me.appendAttachmentHtml({'fileName': loadFile.fileName});
                    //往页面的文件名称数组中写数据
                    if(me.options.fileName && Object.prototype.toString.call(window[me.options.fileName]) === "[object Array]"){
                   	 window[me.options.fileName].push(loadFile.fileName);
                   }
                }
                
            });
            window.dwr.TOPEngine.setAttributes(null);
           
            
           

        }, 

        /**
         * 增加附件信息到列表        
         * @param attachment 附件信息
         */
        appendAttachmentHtml: function (attachment) {
            if(attachment) {
                var $li = $('<li style="list-style-type: none;"></li>');
                $li.append('<image style="vertical-align: middle; margin-right: 2px;" src="' + this.getFileIcon(attachment.fileName) + '"><a href="###" data-action-type="download">' + attachment.fileName + '</a>&nbsp;&nbsp;<a href="###" style="color: hsla(13, 100%, 50%, 0.77);" data-action-type="delete">删除</a>');
                $li.data('attachment', attachment);
                this.$listUi.append($li);
                this.fileNum++;
                this._checkMode();
            }
        },

        _checkMode: function () {
            if(this.options.mode === "Single") {
                var $inputFile = this.$elem.find('input[type="file"]');
                this.fileNum === 1 ? $inputFile.hide(): $inputFile.show();
            }
        },

        /**
         * 删除附件
         */
        removeAttachment: function (elemLi) {
            var $elemLi = elemLi instanceof jQuery ? elemLi : $(elemLi);
            var attachment = $elemLi.data('attachment');
            if(attachment) {
                var me = this;
                this.dwrAction.deleteFile(this.options.uploadKey,this.uploadId,attachment.fileName, function (result) {
                    if(result) {
                        elemLi.remove();
                        me.fileNum--;
                        me._checkMode();
                      //删除页面的文件名称数组中对应的数据
                       if(me.options.fileName && Object.prototype.toString.call(window[me.options.fileName]) === "[object Array]"){
                    	   for(var i = 0, len = window[me.options.fileName].length; i < len; i++){
                    		   if(window[me.options.fileName][i] == attachment.fileName){
                    			   window[me.options.fileName].splice(i,1);
                    		   }
                    	   }
                       }
                    }else {
                        throw new Error('error delete file');
                    }
                });
            }
        },

        /**
         * uploadId 是否是空值
         * @return {Boolean} true 是 false 否
         */
        _isBlankValue: function () {
        	return (!this.uploadId || $.trim(this.uploadId) === "");
        },

        getValue: function () {
        	return this.uploadId;
        },

        setValue: function (uploadId) {
        	this.uploadId = uploadId;
            this._triggerHandler('change');
        },

        /**
         * 附件下载
         */
        downloadAttachment: function (elemLi) {
            var $elemLi = elemLi instanceof jQuery ? elemLi : $(elemLi);
            var attachment = $elemLi.data('attachment');
            if(attachment) {
                this.dwrAction.downloadFile(this.options.uploadKey,this.uploadId,attachment.fileName, function (data) {
                    window.dwr.TOPEngine.openInDownload(data);
                });
            }
        }
    });

})(window.comtop.cQuery, window.comtop);