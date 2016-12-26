/**
 * 实体关联关系weacher，主要用于监听实体关联关系改变后同步修改实体属性
 * 使用方式：
 * 1. 构建RelationWatcher对象 :
 *   	RelationWatcher watcher = new RelationWatcher(entity);
 * 2. 新增关系时调用watchRelation方法： 
 * 		watcher.watchRelation(relation)
 * 3. 删除关系时调用deleteattr方法：
 * 		watcher.deleteAttr(relation)
 * 4. 保存时直接获取entity里的属性列表即可。
 * 
 * entity里的attri属性会随着关系的新增、修改、编辑而自动调整。
 */
(function (win) {
	/**
	 * RelationWatcher 构建方法
	 * @param {Object} entity 实体对象，里面包括了属性列表和关联关系列表
	 */
	function RelationWatcher(entity) {
		this.entity = null;
		this.relationMap = {};
		this.init(entity);
 	}

	// 判断关系VO相关属性值是否有值
	function isIntegrity(relationVO){
		if(relationVO.engName==""||relationVO.chName==""||relationVO.sourceField==""||relationVO.targetField==""){
			return false;
		}
		
		if(relationVO.multiple=="Many-Many"){
			if(relationVO.associateSourceField =="" || relationVO.associateTargetField == ""){
				return false;
			}
		}
		return true;
	}

	function addRelation(relationMap, attrbute) {
		if(attrbute.relationId == null || attrbute.relationId == "") {
			return;
		}
		if(relationMap[attrbute.relationId]) {	// 多对多会产生两个属性
			var array = [];
			array[0] = relationMap[attrbute.relationId];
			array[1] = attrbute;
			relationMap[attrbute.relationId] = array;
		}else {
			relationMap[attrbute.relationId] = attrbute;
		}
	}

	/**
	 * 增加新的属性
	 * @param {object} entity       实体对象
	 * @param {Object} newAttribute 需要新增的属性
	 */
	function addNewAttri(entity, newAttribute) {
		newAttribute.sortNo = entity.attributes.length + 1;
		entity.attributes.push(newAttribute);
	}
	/**
	 * 替换实体属性
	 * @param  {object} entity       实体
	 * @param  {Object} newAttribute 新属性
	 * @param  {Object} oldAttri     旧属性（将被替换）
	 */
	function changeAttri(entity, newAttribute, oldAttri) {
		newAttribute.sortNo = oldAttri.sortNo;
		entity.attributes[oldAttri.sortNo - 1] = newAttribute;
	}

	/**
	 * 重置属性的sortNo
	 */
   	function resetAttriSortNo(entity){
   		//重新维护序号
        for(var i=0;i<entity.attributes.length;i++){
        	entity.attributes[i].sortNo = i + 1;
        }
   	}

	function createAttribute(relation) {
		var newEntityAttribute;
		if(relation.multiple=="One-One"||relation.multiple=="Many-One"){
			newEntityAttribute = {relationId:relation.relationId,associateListAttr:false,sortNo:0,engName:"relation"+relation.engName.substring(0,1).toUpperCase()+relation.engName.substring(1),chName:relation.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"entity",value:relation.targetEntityId,type:"entity",generic:[{source:"",value:"",type:""}]}};
		}else if(relation.multiple=="One-Many"){
			newEntityAttribute = {relationId:relation.relationId,associateListAttr:false,sortNo:0,engName:"relation"+relation.engName.substring(0,1).toUpperCase()+relation.engName.substring(1),chName:relation.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+relation.targetEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:relation.targetEntityId}]}};
		}else if(relation.multiple=="Many-Many"){
			newEntityAttribute = [];
			newEntityAttribute[0] = {relationId:relation.relationId,associateListAttr:true,sortNo:0,engName:"relationAssociate"+relation.engName.substring(0,1).toUpperCase()+relation.engName.substring(1),chName:"中间实体"+relation.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+relation.associateEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:relation.associateEntityId}]}};
			newEntityAttribute[1] = {relationId:relation.relationId,associateListAttr:false,sortNo:0,engName:"relation"+relation.engName.substring(0,1).toUpperCase()+relation.engName.substring(1),chName:relation.chName,queryField:"false",allowNull:"false",accessLevel:"private",attributeType:{source:"collection",value:"java.util.List<"+relation.targetEntityId+">",type:"java.util.List",generic:[{type:"entity",source:"entity",value:relation.targetEntityId}]}};
		}
		return newEntityAttribute;
	}

	RelationWatcher.prototype = {
		init: function (entity) {
			if(entity) {
				this.entity = entity;
				// initRelationMap
				for (var i = 0;i <= entity.attributes.length -1; i++) {
					addRelation(this.relationMap, entity.attributes[i]);
				}
				// watchRelationList 
				if(entity.lstRelation) {
					for (var i = 0; i < entity.lstRelation.length; i++) {
						this.watchRelation(entity.lstRelation[i]);
					}
				}
			}			
		},


		relationChangeEvent: function (change) {
			this.updateAttr(change.object);
		},

		watchRelation: function (relation) {
			if(relation) {
				var me = this;
				Object.observe(relation, function (change) {
					me.relationChangeEvent.apply(me, change);
				});
			}
		},

		// unWatchRelation: function (relation) {
		// 	if(relation) {
		// 		var me = this;
		// 		Object.unobserve(relation, this.relationChangeEvent);
		// 	}
		// },

		/**
		 * 更新关系VO对应的实体属性（新增或修改）
		 * @param  {Object} relation 关系VO
		 */
		updateAttr: function (relation) {
			if(isIntegrity(relation)) {
				var relationId = relation.relationId;
				var entity = this.entity;
				// 创建attrivo
				var newAttribute = createAttribute(relation);
				if(this.relationMap[relationId]) {
					// 更新
					var oldAttri = this.relationMap[relationId];
					if(Object.prototype.toString.call(oldAttri) == Object.prototype.toString.call(newAttribute)) {	//同一类型，表示之前属性都是多对对或者都不是多对多
						if(Object.prototype.toString.call(newAttribute) == '[object Object]') {
							changeAttri(entity, newAttribute, oldAttri);
						} else{ //都为数组类型，也就是多对多
							changeAttri(entity, newAttribute[0], oldAttri[0]);
							changeAttri(entity, newAttribute[1], oldAttri[1])
						}
					}else {	
						if(Object.prototype.toString.call(newAttribute) == '[object Object]') {	// 旧属性是多对多
							entity.attributes.splice(oldAttri[0].sortNo - 1, oldAttri.length, newAttribute);
						} else{ 	// 旧属性不为多对多，新属性为多对多
							entity.attributes.splice(oldAttri.sortNo - 1, 1, newAttribute[0],newAttribute[1]);
						}
						resetAttriSortNo(entity);
					}
					
				} else {
					if(Object.prototype.toString.call(newAttribute) == '[object Object]') {
						addNewAttri(entity, newAttribute);
					} else {
						addNewAttri(entity, newAttribute[0]);
						addNewAttri(entity, newAttribute[1]);
					}
				}
				this.relationMap[relationId] = newAttribute;
			}
		},

        /**
		 * 删除关系VO对应实体属性
		 * @param  {Object} relation 关系VO
		 */
		deleteAttr: function (relation) {
			if(relation && this.relationMap[relation.relationId]) {
				var attri = this.relationMap[relation.relationId];
				var startIndex, deleteCount;
				if(Object.prototype.toString.call(attri) == '[object Object]') {
					startIndex = attri.sortNo - 1;
					deleteCount = 1;
				} else {
					startIndex = attri[0].sortNo - 1;
					deleteCount = attri.length;
				}
				this.entity.attributes.splice(startIndex, deleteCount);
				resetAttriSortNo(entity);
				delete this.relationMap[relation.relationId];
			}
		}

	};
	
	win.RelationWatcher = RelationWatcher;
})(window);