/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.converter.page;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;

/**
 * LayoutVO中type有layout和ui，本类用于type为layout的元数据
 * 
 * @author yangsai
 * 
 */
public class LayoutConverter {
    
    /**
     * 页面layoutVO对象
     */
    private final LayoutVO pageLayoutVO;
    
    /**
     * @param pageLayoutVO 页面layoutVO对象
     */
    public LayoutConverter(LayoutVO pageLayoutVO) {
        this.pageLayoutVO = pageLayoutVO;
    }
    
    /**
     * 将原型设计页面的相关元数据转换成页面元数据
     * 
     * @param ptLayoutVO 原型layoutVO对象
     * @throws OperateException xml操作异常
     */
    public void convert(LayoutVO ptLayoutVO) throws OperateException {
        
        // 处理layoutVO属性
        pageLayoutVO.setId(ptLayoutVO.getId());
        pageLayoutVO.setType(ptLayoutVO.getType());
        pageLayoutVO.setUiType(ptLayoutVO.getUiType());
        convertComponentModelId(ptLayoutVO);
        // 处理option
        new OptionConverter(pageLayoutVO).convert(ptLayoutVO);
        
        // 递归处理处理子节点
        if (!ptLayoutVO.getChildren().isEmpty()) {
            for (LayoutVO childPtLayoutVO : ptLayoutVO.getChildren()) {
                LayoutVO childPageLayoutVO = new LayoutVO();
                childPageLayoutVO.setParentId(pageLayoutVO.getId());
                pageLayoutVO.getChildren().add(childPageLayoutVO);
                new LayoutConverter(childPageLayoutVO).convert(childPtLayoutVO);
            }
        }
    }
    
    /**
     * 由于原型页面与开发建模页面的控件不一样，需要转换处理
     * 
     * @param ptLayoutVO 原型layoutVO对象
     */
    private void convertComponentModelId(LayoutVO ptLayoutVO) {
        ComponentVO componentVO = null;
        // 处理控件布局层
        if (ptLayoutVO.getComponentModelId() != null) {
            componentVO = (ComponentVO) ComponentVO.loadModel(ptLayoutVO.getComponentModelId());
        }
        if (componentVO != null && StringUtils.isNotBlank(componentVO.getExtend())) {
            // 处理控件属性对象包含的设计器冗余componentModelId数据
            CapMap objOptions = ptLayoutVO.getOptions();
            if (objOptions.containsKey(PageConstant.COMPONENT_MODELID)) {
                objOptions.put(PageConstant.COMPONENT_MODELID, componentVO.getExtend());
            }
            if(objOptions.containsKey(PageConstant.EDITABELGRID_EDITTYPE)){
                Map<String, String> objMap = new HashMap<String, String>();
                String strEdittype = (String) objOptions.get(PageConstant.EDITABELGRID_EDITTYPE);
                Matcher objMatcher = Pattern.compile("\"" + PageConstant.COMPONENT_MODELID + "\":\\s*\"([\\w.]+)\"").matcher(strEdittype);
                while (objMatcher.find()) {
                    String strModelId = objMatcher.group(1);
                    String strRepModelId = null;
                    if(objMap.containsKey(strModelId)){
                        strRepModelId = objMap.get(strModelId);
                    } else {
                        ComponentVO objComponentVO = (ComponentVO) ComponentVO.loadModel(strModelId);
                        strRepModelId = objComponentVO != null ? objComponentVO.getExtend() : strModelId;
                    }
                    strEdittype = strEdittype.replaceAll(strModelId, strRepModelId);
                }
                objOptions.put(PageConstant.EDITABELGRID_EDITTYPE, strEdittype);
            }
            pageLayoutVO.setComponentModelId(componentVO.getExtend());
        }
    }
}
