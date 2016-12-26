// entity server
angular.module('metadata', []).factory('EntityServer', function($http) {
  	var EntityDwrFacade = EntityFacade;  
  	var service = {
  			/**
  			 * 获取entity
  			 * @param  {String} entityId 实体id
  			 * @return {Object}          实体对象
  			 */
		    getEntityById: function (entityId) {
		    	var entity;
		    	EntityFacade.loadEntity(entityId, {
		    		callback:function (result) {
		    			entity = result;
		    		},
		    		async:false
		    	});
		    	return entity;
		    },

		    /**
  			 * 保存实体
  			 * @param  {Object} entity 实体
  			 * @return {Object}          实体对象
  			 */
		    saveEntity: function (entity) {
		    	var result;
		    	EntityFacade.saveEntity(entity, {
		    		callback:function (result) {
		    			result = result;
		    		},
		    		async:false
		    	});
		    	return result;
		    }
	    };
  	return service;
});

// component server
angular.module('metadata').factory('ComponentServer', function($http, $window) {
  	// if(MetadataGenerateFacade == null) {
  	// 	$window.document.write('<script type="text/javascript" src="/web/cap/dwr/interface/MetadataGenerateFacade.js"><\/script>')
  	// 	console.log(MetadataGenerateFacade);
  	// }
  	var ComponentDwrFacade = ComponentFacade;
  	var MetadataGenerateDwrFacade = MetadataGenerateFacade;
  	var service = {
  			/**
  			 * 根据布局类型，获取所有控件名称
  			 * @return {List}          控件
  			 */
		    queryComponentList: function (layoutType) {
		    	var componentList = null;
		    	ComponentDwrFacade.queryComponentList(layoutType, ['dev'], {
		    		callback:function (result) {
		    			componentList = result;
		    		},
		    		async:false
		    	});
		    	return componentList;
		    },
		    /**
  			 * 根据布局类型，获取所有控件名称
  			 * @return {List}          控件
  			 */
		    saveModel: function (metadataGenerateVO) {
		    	var result = null;
		    	MetadataGenerateDwrFacade.saveModel(metadataGenerateVO,{
		    		callback:function (data) {
		    			result = data;
		    		},
		    		async:false
		    	});
		    	return result;
		    },
		    
		    queryMenuByPackageId: function (packageId) {
		    	var result = null;
		    	MetadataGenerateDwrFacade.queryMenuByPackageId(packageId,{
		    		callback:function (funcDTO) {
		    			result = funcDTO;
		    		},
		    		async:false
		    	});
		    	return result;
		    }
	    };
  	return service;
});