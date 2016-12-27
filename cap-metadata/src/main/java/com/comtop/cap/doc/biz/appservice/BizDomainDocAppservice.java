/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.biz.domain.dao.BizDomainDAO;
import com.comtop.cap.doc.biz.model.BizDomainDTO;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.DataIndexManager;
import com.comtop.cap.doc.service.IIndexBuilder;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务域 文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-3 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizDomainDTO.class)
public class BizDomainDocAppservice implements IIndexBuilder {
    
    /** 注入DAO **/
    @PetiteInject
    protected BizDomainDAO damainDAO;
    
    /**
     * 查询业务域链,查询当前id及其子级
     *
     * @param domainId 业务域id
     * @return 业务域链 domainId为最上级
     */
    public List<BizDomainDTO> queryDomainChildChainById(String domainId) {
        return damainDAO.queryList("com.comtop.cap.bm.biz.domain.model.queryDomainChildChainById", domainId);
    }
    
    /**
     * 查询业务域链，从当前id到顶层
     *
     * @param domainId 业务域id
     * @return 业务域链 domainId为最上级
     */
    public List<BizDomainDTO> queryDomainParentChainById(String domainId) {
        return damainDAO.queryList("com.comtop.cap.bm.biz.domain.model.queryDomainParentChainById", domainId);
    }
    
    /**
     * 获得持久化的id
     * 本方法提供给当前对象的服务判断自己是否已经存在使用
     * 
     * @param uri 对象
     * @return 持久化的id，未找到返回null。
     */
    final public String findId(String uri) {
        DataIndexManager dataIndexManager = CommonDataManager.getCurrentDataIndexManager();
        WordDocument document = CommonDataManager.getCurrentWordDocument();
        String packageId = document.getDomainId();
        return dataIndexManager.getStoreId(BizDomainDTO.class, uri, packageId);
    }
    
    @Override
    public Map<String, String> fixIndexMap(String packageId) {
        List<BizDomainDTO> domainList = queryDomainChildChainById(packageId);
        Map<String, String> bizDomainMap = new HashMap<String, String>();
        for (BizDomainDTO bizDomainDTO : domainList) {
            if (StringUtils.isBlank(bizDomainDTO.getParentName())) {
                bizDomainMap.put(bizDomainDTO.getName(), bizDomainDTO.getId());
            } else {
                bizDomainMap.put(bizDomainDTO.getParentName() + "/" + bizDomainDTO.getName(), bizDomainDTO.getId());
            }
            bizDomainMap.put(bizDomainDTO.getId(), bizDomainDTO.getId());
        }
        return bizDomainMap;
    }
}
