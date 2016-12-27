/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.model.MetadataCuiTreeVO;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 行为分类模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@DataTransferObject
public class ActionTypeVO extends MetadataCuiTreeVO {
    
    /** 标识 */
    private static final long serialVersionUID = 6969959504922530864L;
    
    /**
     * 自定义行为类型模板分类前缀名称
     */
    private static final String CUSTOM_PREFIX = "custom";
    
    /**
     * 默认行为类型模板分类前缀名称
     */
    private static final String DEFAULT_PREFIX = "default";
    
    /**
     * 构造函数
     */
    public ActionTypeVO() {
        this.setModelType("actionType");
        this.setModelPackage("actionlibrary");
    }

    /**
     * 获取自定义modelId
     * @return 字符
     */
    public static String getCustomBaseModelId(){
        return "actionlibrary.actionlibrary.customBase";
    }
    
    /**
     * 获取自定义modelId
     * @param modelId 行为类型模型Id
     * @return 返回行为类型对象
     * @throws ValidateException 校验异常
     */
    public static ActionTypeVO createMetaDataFile(String modelId) throws ValidateException{
        ActionTypeVO objActionTypeVO = null;
        String strModelName = modelId.substring(modelId.lastIndexOf(".") + 1, modelId.length());
        String[] strTemp = strModelName.split(CUSTOM_PREFIX);
        if(strTemp.length == 2){
            String strExtendModelId = modelId.substring(0, modelId.lastIndexOf(".")+1) + DEFAULT_PREFIX  + strTemp[1];
            ActionTypeVO objExtendVO = ActionTypeVO.loadModel(strExtendModelId);
            if(objExtendVO != null){
                objActionTypeVO = new ActionTypeVO();
                objActionTypeVO.setModelId(modelId);
                objActionTypeVO.setExtend(strExtendModelId);
                objActionTypeVO.setModelName(strModelName);
                boolean bResult = objActionTypeVO.saveModel();
                if(bResult){
                    objActionTypeVO = ActionTypeVO.loadModel(modelId);
                }
            }
        }
        return objActionTypeVO;
    }

    /**
	 * 在树中搜索对应关键字，关键字匹配的是tree中的title
	 * @param modelId modelId
	 * @param keyword keyword
	 * @return x
	 * @throws OperateException x
	 */
	public static List<CuiTreeNodeVO> search(String modelId, String keyword) throws OperateException {
    	// 查询所有符合条件的行为模板
    	ActionTypeVO objActionTypeVO = ActionTypeVO.loadModel(modelId);
    	if(StringUtils.isBlank(keyword)) {
    		return objActionTypeVO.getDatasource();
    	}
    	List<CuiTreeNodeVO> lstNodeVO = objActionTypeVO.queryList("datasource//children[contains(title, '" + keyword + "')] | datasource[isFolder=false and contains(title, '" + keyword + "')]", CuiTreeNodeVO.class);
    	Map<String, String> mapKey = new HashMap<String, String>();
    	for(CuiTreeNodeVO nodeVO : lstNodeVO) {
    		mapKey.put(nodeVO.getKey(), nodeVO.getKey());
    	}
        return objActionTypeVO.filterNodeByKey(mapKey);
    }
    
    public static ActionTypeVO loadModel(String modelId) {
    	return (ActionTypeVO) BaseModel.loadModel(modelId);
    }
}
