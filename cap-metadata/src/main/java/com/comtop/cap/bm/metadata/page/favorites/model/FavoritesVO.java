/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.favorites.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.model.MetadataCuiTreeVO;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 收藏夹模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@XmlRootElement(name = "favoriteType")
@DataTransferObject
public class FavoritesVO extends MetadataCuiTreeVO {
    
    /** 标识 */
    private static final long serialVersionUID = 6969959504922530866L;
    
    /**
     * 构造函数
     */
    public FavoritesVO() {
        this.setModelType("favoriteType");
        this.setModelPackage("favorites");
    }
    
    /**
	 * 在树中搜索对应关键字，关键字匹配的是tree中的title
	 * @param modelId modelId
	 * @param keyword keyword
	 * @return x
	 * @throws OperateException x
	 */
	public static List<CuiTreeNodeVO> searchAction(String modelId, String keyword) throws OperateException {
    	// 查询所有符合条件的行为模板
		FavoritesVO objFavoritesVO = FavoritesVO.loadModel(modelId);
    	if(StringUtils.isBlank(keyword)) {
    		return objFavoritesVO.getDatasource();
    	}
    	List<CuiTreeNodeVO> lstNodeVO = objFavoritesVO.queryList("datasource//children[contains(title, '" + keyword + "')] | datasource[contains(title, '" + keyword + "')]", CuiTreeNodeVO.class);
    	Map<String, String> mapKey = new HashMap<String, String>();
    	for(CuiTreeNodeVO nodeVO : lstNodeVO) {
    		mapKey.put(nodeVO.getKey(), nodeVO.getKey());
    	}
        return objFavoritesVO.filterNodeByKey(mapKey);
    }
	
	public static FavoritesVO loadModel(String modelId) {
    	return (FavoritesVO) BaseModel.loadModel(modelId);
    }
}
