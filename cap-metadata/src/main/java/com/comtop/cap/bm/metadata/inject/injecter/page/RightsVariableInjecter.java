/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.List;

import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.desinger.model.RightVO;
import com.comtop.corm.resource.util.CollectionUtils;

/**
 * 页面用户权限注入实现类.清空页面权限。
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月22日 凌晨
 */
public class RightsVariableInjecter implements IMetaDataInjecter {
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter#inject(java.lang.Object, java.lang.Object)
     */
    @Override
    public void inject(Object obj, Object source) {
        PageVO page = (PageVO) source;
        // 清掉权限相关信息
        page.setModelPackageId(null);
        List<DataStoreVO> lstDataStore = page.getDataStoreVOList();
        for (DataStoreVO item : lstDataStore) {
            if ("rightsVariable".equals(item.getEname())) {
                List<PageConstantVO> lstPageConstantVO = item.getPageConstantList();
                List<RightVO> lstVerifyId = item.getVerifyIdList();
                if (!CollectionUtils.isEmpty(lstPageConstantVO)) {
                    lstPageConstantVO.clear();
                }
                if (!CollectionUtils.isEmpty(lstVerifyId)) {
                    lstVerifyId.clear();
                }
                break;
            }
        }
    }
    
}
