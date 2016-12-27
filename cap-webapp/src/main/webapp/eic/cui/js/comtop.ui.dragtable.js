;(function($, C) {
	C.UI.DragTable = C.UI.Base.extend({
		options: {
			uitype: 'DragTable',        //???????
			noDragClass: 'nodrag',      //?????????????????
			dragClass: 'highlight',     //????????????????
			dragPropmptClass: null,     //???????????????
			onDragStart: null,          //???????????
			onDrag: null,               //????ß÷???
			onDragEnd: null,            //????????????
			skipAccount: 5,             //??????????ß≥????
			childEL: null               //????????function
		},
		
		/**
		 * ?????
		 */
		_create: function() {
			this.$table = this.options.el;
		},
		
		/**
		 * ??????????
		 */
		doDrag: function(promptWidth, promptLeft) {
			this._dragTable(promptWidth, promptLeft);
		},
		
		/**
		 * ????????????
		 */
		unDrag: function() {
			var childs = this._getRows();
			if (childs == null) return;
			$(childs).unbind("dragstart").unbind("drag").unbind("dragend");
		},
		
		/**
		 * ????????
		 */
		_dragTable: function(promptWidth, promptLeft) {
			var self = this;
			var opts = this.options;
			
			var childs = this._getRows();
			if (childs == null) return;
			$(childs).drag("start", function(ev, dd) {
				if ($(this).hasClass(opts.noDragClass)) return;
				
				$(this).data('currRowTop', $(this).offset().top);
				$(this).data('currRowY', $(this).offset.top);
				$(this).addClass(opts.dragClass);
				
				var promptDiv = $("<div></div>");
				var pWidth = $(this).width();
				var pLeft = $(this).offset().left;
				if (promptWidth) pWidth = promptWidth;
				if (promptLeft) pLeft = promptLeft
				if (opts.dragPromptClass) {
                    promptDiv
                        .addClass(opts.dragPromptClass)
                        .css({
                            position: 'absolute',
                            width: pWidth,
                            height: $(this).height(),
                            left: pLeft
                        });
                } else {
                    promptDiv.css({
                        border: '1px dashed #ccc',
                        background: '#cdcbbc',
                        opacity: .5,
                        position: 'absolute',
                        width: pWidth,
                        height: $(this).height(),
                        left: pLeft,
                        cursor: 'move'
                    });
                }
                if ($.type(opts.onDragStart) == 'string') {
                    window[opts.onDragStart] && window[opts.onDragStart](ev, dd, this);
                } else if (opts.onDragStart) {
                    opts.onDragStart(ev, dd, this);
                }

                return promptDiv.appendTo(document.body);
			})
			.drag(function(ev, dd){

                if ($(this).hasClass(opts.noDragClass)) return;

                $( dd.proxy ).css({
                    top: dd.offsetY
                });

                //?ßÿ???????????skipAccount
                var currRowY = $(this).data('currRowY');
                var moveDistance = dd.offsetY - currRowY;
                if ((moveDistance > 0 && moveDistance < opts.skipAccount)
                    || (moveDistance < 0 && moveDistance > -opts.skipAccount)) return;

                //???????¶À??
                var currRowTop = $(this).data('currRowTop');
                //????????
                var targetRow = self._dropTargetRow(this, dd, childs, currRowTop);

                if (targetRow != null) {
                    var movingDown = dd.offsetY > currRowTop;
                    if (movingDown) {
                        $(this).insertAfter(targetRow);
                    } else {
                        $(this).insertBefore(targetRow);
                    }
                    //???onDrag???
                    if ($.type(opts.onDrag) == 'string') {
                        window[opts.onDrag] && window[opts.onDrag](ev, dd, this);
                    } else if (opts.onDrag) {
                        opts.onDrag(ev, dd, this);
                    }
                    //?ùI??????????¶À??
                    $(this).data('currRowTop', $(this).offset().top);
                    $(this).data('currRowY', $(this).offset().top);
                } else {
                    $(this).data('currRowY', dd.offsetY);
                }
            })
            .drag('end', function(ev, dd) {

                if ($(this).hasClass(opts.noDragClass)) return;
                //?õ•????????????¶À??
                $(this).removeData('currRowTop');
                $(this).removeData('currRowY');

                $( dd.proxy ).remove();
                $(this).removeClass(opts.dragClass);

                if ($.type(opts.onDragEnd) == 'string') {
                    window[opts.onDragEnd] && window[opts.onDragEnd](ev, dd, this);
                } else if (opts.onDragEnd) {
                    opts.onDragEnd(ev, dd, this);
                }
            });
		},
		
		/**
		 * ???????????????
		 */
		_getRows: function() {
			var opts = this.options;
			var $table = this.$table;
			
			if (opts.childEL) {
				return opts.childEL($table[0]);
			} else {
				return $table[0].rows;
			}
		},
		
		/**
	     * ??????????????
	     * @param currRow ??????????
	     * @param dd ?????????
	     * @param childs ????????????????
	     * @param currRowTop ?????????ß÷?top???
	     */
	    _dropTargetRow : function(currRow, dd, childs, currRowTop) {
	        for (var i = 0; i < childs.length; i++) {
	            var row = childs[i];
	            if (row != currRow) {
	                var rowTop = $(row).offset().top;
	                var rowHeight = parseInt($(row).innerHeight())/2;

	                if (((dd.offsetY < rowTop + rowHeight) && rowTop < currRowTop)
	                    || ((dd.offsetY + $(currRow).innerHeight() > rowTop + rowHeight) && rowTop > currRowTop)) {
	                    if (!$(row).hasClass('nodrag')) {
	                        return row;
	                    }
	                }
	            }
	        }
	        return null;
	    }
		
	});
})(window.comtop.cQuery, window.comtop);