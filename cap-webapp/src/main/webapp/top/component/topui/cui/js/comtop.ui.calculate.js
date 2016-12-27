;(function($, C){
	/*C.UI.Calculate = C.UI.Base.extend({
		options: {
			uitype: 'Calculate'
		},
		setAutoCalculate: function(el, func, dependEls) {
			for (var i = 0; i < dependEls.length; i++) {
				var dependEl = dependEls[i];
				cui(dependEl).bind('change', function() {
					var result = func();
					cui(el).setValue(result);
				});
			}
		}
	});
    cui.calculate = cui('').calculate();*/
    cui.calculate = cui.calculate || {};
    cui.calculate.setAutoCalculate = function(el, func, dependEls){
        for (var i = 0; i < dependEls.length; i++) {
            var dependEl = dependEls[i];
            cui(dependEl).bind('change', function() {
                var result = func();
                cui(el).setValue(result);
            });
        }
    };
})(window.comtop.cQuery, window.comtop);