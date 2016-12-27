/**
 * ????§Ò????????
 * @author wuxiaobing
 * @since 2012-09-27
 * @version 1.0
 */
;(function($, C) {
	C.UI.Float = C.UI.Base.extend({
		options: {
			uitype: 'Float',        //???????
			target: null,           //???????????????
			mode: 'right',          //??????????????'right','bottom','left','top'
	        offset: {x: 0, y: 0},   //?????
	        outer: true,            //????????????
	        tolerance: null,        //????¦Ë?¨¹?????
	        lock: ''                //????????????"top","fixed"
		},

		/**
		 * ?????
		 */
		_create: function() {
			var opts = this.options;
			this.$element = opts.el;
			var self = this;

			if (opts.target) {
				//?????????????body??????????body????
				this._move();
				//????????????????
				this._bindTarget();
			}

			if (opts.lock == 'fixed') {
				this._fixElement();
			} else if (opts.lock == 'top') {
				this.y = this.$element.offset().top;
				if (C.Browser.isIE6 || (C.Browser.isIE && C.Browser.isQM)) {
					this._setGlobal();
				}
			}

			//?widow?????
			this._bindEvent();
		},

		/**
		 * ?window?????
		 */
		_bindEvent: function() {
			var self = this;
			var opts = this.options;
			var $element = this.$element;

			if (opts.target) {
				$(window).bind('resize.float', function() {
					self._bindTarget();
					if (opts.lock == 'fixed') {
						self._fixElement();
					}
				});
			}

			if (opts.lock == 'top') {
				$(window).bind('scroll', function() {
					self._bindToTop();
				});

				$(window).bind('resize.float', function() {
					this.y = $element.offset().top;
					var timer = setTimeout(function() {
		                var copy = $element.data('clone');
		                if (copy) {
		                	$element.removeData('clone');
		                    $(copy).remove();
		                    $element.css("visibility", "visible");
		                }
		                self._bindToTop();
		            }, 10);
				});
			}
		},

		/**
	     * ???????????
	     */
	    _bindTarget: function() {
	        var opts = this.options;
	        var $element = this.$element;

	        var location = opts.tolerance ?
	            opts.tolerance($element[0], opts) :
	            this._getLocation();

            $element.css({
	            position: 'absolute',
	            top: location.y,
	            left: location.x,
	            zIndex: 5000
	        });
	    },

	    /**
	     * ??????
	     */
	    _fixElement: function() {
	        var $element = this.$element;
	        var opts = this.options;
	        var top = opts.offset.y;
	        var left = opts.offset.x;

	        if (opts.target) {
	        	top = $element.offset().top;
	        	left = $element.offset().left;
	        }

	        if (C.Browser.isIE6 || (C.Browser.isIE && C.Browser.isQM)) {
	            //?????????body????????????body??
	            this._move();
	            //??????????
	            this._setGlobal();

	            var scrollTop = 'document.' + (C.Browser.isQM ? 'body' : 'documentElement') + '.scrollTop';
	            var clientHeight = 'document.' + (C.Browser.isQM ? 'body' : 'documentElement') + '.clientHeight';
	            var scrollLeft = 'document.' + (C.Browser.isQM ? 'body' : 'documentElement') + '.scrollLeft';
	            var clientWidth = 'document.' + (C.Browser.isQM ? 'body' : 'documentElement') + '.clientWidth';

	            //??IE6?????css???????fixed§¹??
	            $element.css({
	            	position: 'absolute'
	            });
	            if (isNaN(top) && top.indexOf('%') != -1) {
	            	$element[0].style.setExpression('top', 'eval(' + scrollTop + ' +'
	            			+ parseFloat(top) + ' * ' + clientHeight + ' / 100) + "px"');
	            } else {
	            	$element[0].style.setExpression('top', 'eval(' + scrollTop + ' +'
	            			+ parseFloat(top) + ') + "px"');
	            }
	            if (isNaN(left) && left.indexOf('%') != -1) {
	            	$element[0].style.setExpression('left', 'eval(' + scrollLeft + ' +'
	            			+ parseFloat(left) + ' * ' + clientWidth + ' / 100) + "px"');
	            } else {
	            	$element[0].style.setExpression('left', 'eval(' + scrollLeft + ' +'
	            			+ parseFloat(left) + ') + "px"');
	            }
	        } else  {
	        	$element.css({
	                position: 'fixed',
	                top: top,
	                left: left
	            });
	        }
	    },

	    /**
	     * ??????????????
	     */
	    _bindToTop: function() {
	    	var $element = this.$element;

	    	var windowST = $(window).scrollTop();
	    	var copy = $element.data('clone');
	    	if (windowST > this.y) {
	    		if (!copy) {
	    			copy = this._copyElement();
	    			$element.css("visibility", "hidden");

	    			if (C.Browser.isIE6 || (C.Browser.isIE && C.Browser.isQM)) {
	    				if (C.Browser.isQM) {
	    					$(copy)[0].style.setExpression('top', 'eval(document.body.scrollTop) + "px"');
	    				} else {
	    					$(copy)[0].style.setExpression('top', 'eval(document.documentElement.scrollTop) + "px"');
	    				}
	    			} else {
	    				$(copy).css({
	    					position: 'fixed',
	    					top: '0px'
	    				});
	    			}
	    		}
	    	} else {
	    		$element.removeData("clone");
	    		$(copy).remove();
	    		$element.css("visibility", "visible");
	    	}
	    },

	    /**
	     * ???????element????body????
	     */
	    _copyElement: function() {
	    	var $element = this.$element;

	    	var copy = $element.clone();
	    	$(copy).css({
	    		position: 'absolute',
	    		width: this._getWidth(),
	    		left: $element.offset().left
	    	});

	    	$element.data('clone', copy);
	    	$(copy).appendTo(document.body);

	    	return copy;
	    },

	    /**
	     * ?????????????????¦Ë??
	     */
	    _getLocation: function() {
	        //?????????
	        var opts = this.options;
	        var target = opts.target;
	        var element = this.$element;

	        var targetLeft = ($(target)[0].tagName == 'HTML' || $(target)[0].tagName == 'html') ?
	        		0 : $(target).offset().left;
	        var targetTop = ($(target)[0].tagName == 'HTML' || $(target)[0].tagName == 'html') ?
	        		0 : $(target).offset().top;

	        var clientWidth = document.documentElement.clientWidth;
	        var clientHeight = document.documentElement.clientHeight;
	        if (C.Browser.isQM) {
	        	clientWidth = document.body.clientWidth;
	        	clientHeight = document.body.clientHeight;
	        }

	        var targetWidth = ($(target)[0].tagName == 'HTML' || $(target)[0].tagName == 'html') ?
	        		clientWidth : $(target).outerWidth();
	        var targetHeight = ($(target)[0].tagName == 'HTML' || $(target)[0].tagName == 'html') ?
	        		clientHeight : $(target).outerHeight();

	        var targetTopBorder = parseFloat($(target).css('borderTopWidth'));
	        targetTopBorder = isNaN(targetTopBorder) ? 0 : targetTopBorder;
	        var targetRightBorder = parseFloat($(target).css('borderRightWidth'));
	        targetRightBorder = isNaN(targetRightBorder) ? 0 : targetRightBorder;
	        var targetBottomBorder = parseFloat($(target).css('borderBottomWidth'));
	        targetBottomBorder = isNaN(targetBottomBorder) ? 0 : targetBottomBorder;
	        var targetLeftBorder = parseFloat($(target).css('borderLeftWidth'));
	        targetLeftBorder = isNaN(targetLeftBorder) ? 0 : targetLeftBorder;

	        var currWidth = element.outerWidth();
	        var currHeight = element.outerHeight();

	        var offsetX = parseFloat(opts.offset.x);
	            offsetX = isNaN(offsetX) ? 0 : offsetX;
	        var offsetY = parseFloat(opts.offset.y);
	            offsetY = isNaN(offsetY) ? 0 : offsetY;


	        switch (opts.mode) {
	            case 'top' :
	                var left = targetLeft + (targetWidth - currWidth) / 2;
	                var top = opts.outer ?
	                    targetTop - currHeight - offsetY :
	                    targetTop + offsetY + targetTopBorder;

	                return {x: left, y: top};
	            case 'right' :
	                var _x = opts.outer ?
	                    targetLeft + targetWidth + offsetX :
	                    targetLeft + targetWidth - currWidth - offsetX - targetRightBorder;

	                var _y = targetTop + (targetHeight - currHeight) / 2;

	                return {x: _x, y: _y};
	            case 'bottom' :
	                var left = targetLeft + (targetWidth - currWidth) / 2;
	                var top = opts.outer ?
	                    targetTop + targetHeight + offsetY :
	                    targetTop + targetHeight - currHeight - offsetY - targetBottomBorder;
	                return {x: left, y: top};
	            case 'left' :
	                var left = opts.outer ?
	                    targetLeft - currWidth - offsetX :
	                    targetLeft + offsetX + targetLeftBorder;
	                var top = targetTop + (targetHeight - currHeight) / 2;
	                return {x: left, y: top};
	        }
	    },

	    /**
		 * ????????
		 */
		_getWidth: function() {
			var elWidth = this.$element.width();
			if (!$.browser.msie && (this.$element[0].tagName == 'TABLE'
				|| this.$element[0].tagName == 'table')) {
				elWidth = this.$element.outerWidth();
			}
			return elWidth;
		},

	    /**
	     * ?????????????body??
	     */
	    _move: function() {
	        var element = this.$element;
	        //?????????????body??????????body????
	        var parentTagName = element.parent()[0].tagName;
	        if (parentTagName != 'BODY' && parentTagName != 'body') {
	            element.appendTo(document.body);
	        }
	    },

	    /**
	     * ???css????
	     * @param key ??
	     * @param value ?
	     */
	    _addCSSRule: function(key, value) {
	        //????????????????????????????????
	        if (document.styleSheets.length < 1) {
	            document.write("<style type='text/css'></style>");
	        }

	        var css = document.styleSheets[document.styleSheets.length-1];
	        css.cssRules ?
	            css.insertRule(key +"{"+ value +"}", css.cssRules.length) :
	            css.addRule(key ,value);
	    },

	    /**
	     * ???¨´???????
	     */
	    _setGlobal: function() {
	        var initCss = $.data(document, 'initCss');
	        if (!initCss) {
	            this._addCSSRule('body', 'background-image: url(about:blank);background-attachment: fixed;');

	            $.data(document, 'initCss', true);
	        }
	    },

	    /**
	     * ?§Ø?????IE6??????????????
	     */
	    _isIE6: function() {
	    	return $.browser.msie && ($.browser.version == '6.0')
            && !$.support.style || ( !!window.ActiveXObject && document.compatMode != 'CSS1Compat');
	    }
	});
})(window.comtop.cQuery, window.comtop);