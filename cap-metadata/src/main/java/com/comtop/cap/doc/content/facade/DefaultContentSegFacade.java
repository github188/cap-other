
package com.comtop.cap.doc.content.facade;

/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

import java.util.List;

import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.doc.content.appservice.DefaultContentSegDocAppService;
import com.comtop.cap.doc.content.model.DefaultContentSegDTO;
import com.comtop.cap.doc.content.model.DefaultContentSegVO;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 默认内容片段处理器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
@PetiteBean
@DocumentService(name = "DefaultContentSeg", dataType = DefaultContentSegDTO.class, description = "默认的内容片段，用于在导出文档时提供默认值。也用于导入时将某些内容指定为默认值供其它文档共享")
public class DefaultContentSegFacade extends BaseFacade implements IWordDataAccessor<DefaultContentSegDTO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected DefaultContentSegDocAppService defaultContentSegDocAppService;
    
    @Override
    public void saveData(List<DefaultContentSegDTO> wordData) {
        if (wordData == null || wordData.size() == 0) {
            return;
        }
        DefaultContentSegVO contentSegVO = null;
        for (DefaultContentSegDTO defaultContentSegDTO : wordData) {
            contentSegVO = new DefaultContentSegVO();
            DocDataUtil.copyProperties(contentSegVO, defaultContentSegDTO);
            defaultContentSegDocAppService.save(contentSegVO);
        }
    }
    
    @Override
    public List<DefaultContentSegDTO> loadData(DefaultContentSegDTO condition) {
        List<DefaultContentSegDTO> alRet = defaultContentSegDocAppService.queryDTOList(condition);
        int i = 0;
        for (DefaultContentSegDTO contentSegDTO : alRet) {
            contentSegDTO.setNewData(false);
            contentSegDTO.setSortIndex(++i);
        }
        return alRet;
    }
    
    @Override
    public void updatePropertyByID(String id, String propertyName, Object value) {
        throw new DocServiceException("不支持对默认内容片段进行更新操作");
    }
}
