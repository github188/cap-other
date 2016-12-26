/**
 * 操作测试用例对象的工具类型
 * Created by zhuhuanhui on 2016-07-13.
 */
(function (pageSession) {
	tools = {
		//测试用例对象
		testCaseVO: pageSession.get("testCase"),
		//步骤集合
		toolsData: pageSession.get("toolsData"),
		//存储步骤对象（测试步骤下的步骤格式testCaseVO.steps）
		stepMap: {},
		/**
	     * 创建步骤对象
	     * @param type 步骤类型
	     * @param modelId 步骤模型Id
	     * @param newStepId 新增步骤Id
	     * @param width 宽度
	     * @param height 高度
	     * @param x 横向坐标
	     * @param y 纵向坐标
	     */
		createStep: function(type, modelId, newStepId, width, height, x, y) {
			var that = this;
        	var newStep = null;
        	if(that.stepMap[modelId]){
        		newStep = jQuery.extend(true, {}, that.stepMap[modelId]);
        		newStep.id = newStepId;
        		newStep.reference.id = newStepId;
        	} else {
        		var stepDefinitions = jQuery.extend(true, {}, this.queryTestStepDefinitions(type, modelId));
        		stepDefinitions.arguments = stepDefinitions.arguments != null ? stepDefinitions.arguments : [];
        		// value赋默认值
        		_.forEach(stepDefinitions.arguments, function(arg, key) {
        			arg.value = arg.defaultValue;
        		});
        		var newStep = {
        				id: newStepId, 
        				type: type, 
        				name: stepDefinitions.name, 
        				description: stepDefinitions.description, 
        				width: width, 
        				height: height, 
        				x: x, 
        				y: y, 
        				reference: {
        					arguments: stepDefinitions.arguments,
        					id: newStepId,
        					type: stepDefinitions.modelId,
        					name: stepDefinitions.name, 
        					icon: stepDefinitions.icon,
        					description: stepDefinitions.description,
        					steps: stepDefinitions.steps
        				}
        		};
        		if(type === 'FIXED'){//固定组合步骤
        			//遍历子步骤（子步骤参数对象赋值、引用对象赋默认值）
        			_.forEach(newStep.reference.steps, function(step, key) {
        				if(step.arguments == null || step.arguments.length == 0){
        					//获取子步骤参数
        					var basicStep = that.loadBasicStep(step.type);
        					step.arguments = basicStep.arguments;
        					that.setArgReferenceValue(newStep.reference.arguments, step.arguments);
        				} else {
        					that.setArgReferenceValue(newStep.reference.arguments, step.arguments);
        				}
        			});
        		} else if(type === 'DYNAMIC'){//动态组合步骤
        			_.forEach(newStep.reference.steps, function(step, key) {
        				if(step.arguments == null || step.arguments.length == 0){
        					that.setArgReferenceValue(newStep.reference.steps.arguments, step.arguments);
        				}
        			});
        		}
        		that.stepMap[modelId] = jQuery.extend(true, {}, newStep);
        	}
        	return newStep;
        },
        /**
	     * 设置参数引用值
	     * @param parentArgs 父步骤参数集合对象
	     * @param referenceArgs 子步骤参数集合对象
	     */
        setArgReferenceValue:function(parentArgs, referenceArgs){
        	//引用值处理
			_.forEach(referenceArgs, function(argObj, argKey) {
				//先判断参数是否有reference属性的引用变量（即：不同变量名称），如果没用，则判断变量名称是否一致
				var referenceArg = _.find(parentArgs, {name: argObj.reference != null ? argObj.reference : argObj.name});
				if(referenceArg){
					if(referenceArg.value != null && referenceArg.value != ""){
						argObj.value = referenceArg.value;
					} else {
						referenceArg.value = argObj.value;
					}
				}
			});
        },
        /**
	     * 新增步骤对象，往testCaseVO.steps中新增（测试用例对象）
	     * @param step 新增步骤对象
	     */
        insertStep:function(step){
        	if(this.testCaseVO.steps == null){
        		this.testCaseVO.steps = [];
        	}
        	this.testCaseVO.steps.push(step);
        	$("#testStepsPropertiesEdit")[0].contentWindow.postMessage({type: "pageDesigner"}, "*");
        },
        /**
	     * 根据步骤分类以及步骤模型Id，获取步骤信息
	     * @param type 步骤类型
	     * @param modelId 步骤模型Id
	     */
        queryTestStepDefinitions:function(type, modelId){
        	var ret = null;
        	var groups = this.toolsData[type];
        	for (var i in groups) {
        		var stepDefinition = _.find(groups[i].steps, {
        			modelId : modelId
        		});
        		if (stepDefinition) {
        			ret = stepDefinition;
        			break;
        		}
        	}
        	return ret;
        },
        /**
	     * 根据基本步骤的模型Id，获取步骤信息
	     * @param modelId 步骤模型Id
	     */
        loadBasicStep:function(modelId){
        	var ret = null;
    		dwr.TOPEngine.setAsync(false);
	    	StepFacade.loadBasicStepById(modelId, function(_data){
	    		ret = _data;
		   	});
	    	dwr.TOPEngine.setAsync(true);
	    	return ret;
        },
        /**
	     * 删除步骤（testCase.steps）
	     * @param stepId 步骤Id
	     */
        deleteStep:function(stepId){
        	var steps = this.testCaseVO.steps != null ? this.testCaseVO.steps : [];
        	var lines = this.testCaseVO.lines != null ? this.testCaseVO.lines : [];
        	//删除步骤
        	_.remove(steps, {id: stepId});
        	//删除连线
        	_.remove(lines, function(line){ return line.form === stepId || line.to === stepId});
        },
        /**
	     * 新增连接线
	     * @param line 连线对象
	     */
        insertLines:function(line){
        	this.testCaseVO.lines = this.testCaseVO.lines != null && this.testCaseVO.lines.length > 0 ? this.testCaseVO.lines : [];
        	this.testCaseVO.lines.push(line);
        	//重新排序连线
        	this.reSortingLines(this.testCaseVO.lines);
        	//重新排序步骤
        	this.reSortingSteps(this.testCaseVO.lines, this.testCaseVO.steps);
        	sendMessage('testStepsPropertiesEdit', {type: "pageDesigner", reSort: true});
        },
        /**
	     * 删除连接线
	     * @param line 连线对象
	     */
        deleteLine:function(obj){
        	_.remove(this.testCaseVO.lines, function(line){ return line.form === obj.form && line.to === obj.to});
        },
        /**
	     * 查询连接线链接的对象
	     * @param line 连线对象
	     */
        queryConnStepObjectByLine:function(line){
        	var sourceStep = _.find(this.testCaseVO.steps, {id: line.form});
        	var targetStep = _.find(this.testCaseVO.steps, {id: line.to});
        	return {source: sourceStep, target: targetStep};
        },
        /**
	     * 根据连线排序步骤（未连线的步骤默认存在数组最后端）
	     */
        reSortingSteps:function(lines, steps){
        	var stepsMap = {};
        	_.forEach(lines, function(line, key) {
        		_.forEach([line.form, line.to], function(value, key) {
        			if(stepsMap[value] == null){
        				var step = _.find(steps, function(n){return n.id === value});
        				if(step && stepsMap[step.id] == null){
        					stepsMap[step.id] = step;
        				}
        			}
        		});
			});
        	var newSteps = _.map(stepsMap);
        	//未链接步骤或多流程步骤
        	if(steps.length > newSteps.length){
        		_.forEach(steps, function(step, key) {
        			if(stepsMap[step.id] == null){
        				newSteps.push(step);
        			}
        		});
        	}
        	steps.splice(0, steps.length);
        	Array.prototype.push.apply(steps, newSteps);
        },
        /**
	     * 重新排序连接线
	     */
        reSortingLines:function(lines){
        	var that = this;
        	var newLines = [], startLines = [], endLines = [];
        	_.forEach(lines, function (line, key) {
        		if(!_.find(lines, function(n){ return n.to == line.form})){
        			startLines.push(line);
        		}
        		if(!_.find(lines, function(n){ return n.form == line.to})){
        			endLines.push(line);
        		}
			});
        	_.forEach(startLines, function(line, key) {
        		newLines.push(line);
        		that.lineSort(lines, line, newLines, endLines);
			});
        	lines.splice(0, lines.length);
        	Array.prototype.push.apply(lines, newLines);
        },
        /**
	     * 连线排序
	     * @param lines 连线源
	     * @param currLine 当前比较的连线对象
	     * @param newLines 排序后的连线集
	     * @param endLines 最后的连线集
	     */
        lineSort:function(lines, currLine, newLines, endLines){
        	for(var i in lines){
    			var nextLine = lines[i];
    			if(currLine.to === nextLine.form){
    				newLines.push(nextLine);
    				if(!_.find(endLines, function(n){return n.to === nextLine.to})){
    					this.lineSort(lines, nextLine, newLines);
    				}
    			}
    		}
        },
        /**
	     * 根据步骤Id，获取链接在该步骤上的连接线
	     * @param stepId 步骤Id
	     */
        getStepConnLines:function(stepId){
        	var leftLine = _.find(this.testCaseVO.lines, {to: stepId});
        	var rightLine = _.find(this.testCaseVO.lines, {form: stepId});
        	return {left: leftLine, right: rightLine};
        },
        /**
	     * 判断步骤是否有连接线
	     * @param stepId 步骤Id
	     */
        hasStepConnLine:function(stepId){
        	var line = _.find(this.testCaseVO.lines, function(n){return n.form === stepId || n.to === stepId});
        	return line != null;
        },
        /**
	     * 根据步骤Id，获取步骤信息
	     * @param stepId 步骤Id
	     */
        getStep:function(stepId){
        	return _.find(this.testCaseVO.steps, {id: stepId});
        }
    }
})(pageSession || new cap.PageStorage(modelId) || {});