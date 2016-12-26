var angularUtils = angular.module("utils", []);

angularUtils.factory('utils', [function($rootScope) {
    return {
    	safeApply : function($scope, fn) {
	        var phase = $scope.$root.$$phase;
	        if(phase == '$apply' || phase == '$digest') {
	            if (fn) {
	                $scope.$eval(fn);
	            }
	        } else {
	            if (fn) {
	                $scope.$apply(fn);
	            } else {
	                $scope.$apply();
	            }
	        }
	    }
    }
}]);