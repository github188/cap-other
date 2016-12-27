/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.content.dao.DefaultContentSegDAO;
import com.comtop.cap.doc.content.model.DefaultContentSegDTO;
import com.comtop.cap.doc.content.model.DefaultContentSegVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 缺省内容服务
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-24 李志勇
 */
@PetiteBean
public class DefaultContentSegDocAppService extends MDBaseAppservice<DefaultContentSegVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected DefaultContentSegDAO defaultContentSegDAO;
    
    @Override
    protected MDBaseDAO<DefaultContentSegVO> getDAO() {
        return defaultContentSegDAO;
    }
    
    /**
     * 查询DTO数据集
     *
     * @param condition 查询条件
     * @return DTO对象集
     */
    public List<DefaultContentSegDTO> queryDTOList(DefaultContentSegDTO condition) {
        return defaultContentSegDAO.queryList("com.comtop.cap.doc.content.model.queryDefaultContentSegDTOList",
            condition);
    }
}
