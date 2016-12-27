/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.facade;

import java.util.List;

import com.comtop.cap.bm.biz.form.appservice.BizFormDataAppService;
import com.comtop.cap.bm.biz.form.model.BizFormDataVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 业务表单数据项逻辑处理类
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@PetiteBean
public class BizFormDataFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormDataAppService bizFormDataAppService;
    
    /**
     * 通过业务表单ID查询业务表单数据
     * 
     * @param bizFormData 业务表单数据
     * @return 业务表单对象
     */
    public List<BizFormDataVO> queryFormDataListByFormId(BizFormDataVO bizFormData) {
        return bizFormDataAppService.queryFormDataListByFormId(bizFormData);
    }
    
    /**
     * 通过业务表单ID查询业务表单数据项条数
     * 
     * @param bizFormData 业务表单数据
     * @return 业务表单数据项条数
     */
    public int queryFormDataCountByFormId(BizFormDataVO bizFormData) {
        return bizFormDataAppService.queryFormDataCountByFormId(bizFormData);
    }
    
    /**
     * 更新业务表单数据项
     * 
     * @param bizFormData 业务表单数据项
     */
    public void updateFormData(BizFormDataVO bizFormData) {
        bizFormDataAppService.updateFormData(bizFormData);
    }
    
    /**
     * 新增业务表单数据项
     * 
     * @param bizFormData 业务表单数据项
     * @return 结果
     */
    public String insertFormData(BizFormDataVO bizFormData) {
        return bizFormDataAppService.insertFormData(bizFormData);
    }
    
    /**
     * 删除业务表单数据项
     * 
     * @param bizFormDataList 业务表单数据项
     */
    public void deleteFormData(List<BizFormDataVO> bizFormDataList) {
        bizFormDataAppService.deleteFormData(bizFormDataList);
    }
    
}
