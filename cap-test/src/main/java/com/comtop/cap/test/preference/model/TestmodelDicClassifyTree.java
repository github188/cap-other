/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.model;

import com.comtop.top.component.common.systeminit.TopServletListener;
import com.comtop.top.core.util.tree.AbstractTree;

/**
 * TestmodelDicClassify
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-24 CAP超级管理员
 */
public class TestmodelDicClassifyTree extends AbstractTree<TestmodelDicClassifyVO> {
    
    @Override
    public String getKey(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyVO.getId();
    }
    
    @Override
    public String getParentKey(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyVO.getParentId();
    }
    
    @Override
    public String getTitle(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyVO.getDictionaryName();
    }
    
    @Override
    public Boolean isLazy(final TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyVO.getChildCount() > 0 ? true : false;
    }
    
    @Override
    public Boolean isFolder(final TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyVO.getChildCount() == 0 ? false : true;
    }
    
    @Override
    public String getIcon(final TestmodelDicClassifyVO testmodelDicClassifyVO) {
        StringBuilder sbIcon = new StringBuilder();
        String strContextPath = TopServletListener.getRequest().getContextPath();
        if (testmodelDicClassifyVO.getChildCount() > 0) {
            sbIcon.append(strContextPath).append("/top/sys/images/func_sys.gif");
        } else {
            sbIcon.append(strContextPath).append("/top/sys/images/func_dir.gif");
        }
        return sbIcon.toString();
    }
    
}
