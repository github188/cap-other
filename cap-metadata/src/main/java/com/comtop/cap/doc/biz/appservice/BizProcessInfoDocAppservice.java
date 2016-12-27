/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessInfoAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeAppService;
import com.comtop.cap.bm.biz.flow.dao.BizProcessInfoDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessInfoVO;
import com.comtop.cap.doc.biz.convert.BizProcessConverter;
import com.comtop.cap.doc.biz.model.BizItemDTO;
import com.comtop.cap.doc.biz.model.BizProcessDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.DataIndexManager;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务流程 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-12 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizProcessDTO.class)
public class BizProcessInfoDocAppservice extends BizAbstractWordDataAccessor<BizProcessInfoVO, BizProcessDTO> {
    
    /** 注入业务流程AppService **/
    @PetiteInject
    protected BizProcessInfoAppService bizProcessInfoAppService;
    
    /** 注入业务流程DAO */
    @PetiteInject
    protected BizProcessInfoDAO bizProcessInfoDAO;
    
    /** 注入业务流程节点 文档操作服务 */
    @PetiteInject
    protected BizProcessNodeDocAppservice bizProcessNodeDocAppservice;
    
    /** 注入业务流程节点服务 */
    @PetiteInject
    protected BizProcessNodeAppService bizProcessNodeAppService;
    
    /** 注入业务事项文档操作服务 */
    @PetiteInject
    protected BizItemsDocAppservice bizItemsDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizProcessInfoVO> getBaseAppservice() {
        return bizProcessInfoAppService;
    }
    
    /**
     * 保存数据
     *
     * @param collection 数据集
     */
    @Override
    protected void saveBizData(List<BizProcessDTO> collection) {
        if (collection == null || collection.size() == 0) {
            return;
        }
        for (BizProcessDTO bizProcessDTO : collection) {
            fillRelationObjectIds(bizProcessDTO);
            saveData(bizProcessDTO);
        }
    }
    
    /**
     * 新增数据
     *
     * @param dto DTO
     * @return id
     */
    @Override
    protected String insertData(BizProcessDTO dto, DataIndexManager dataIndexManager) {
        String id = super.insertData(dto, dataIndexManager);
        if (StringUtils.isNotBlank(dto.getBizItemName())) {
            dataIndexManager.addDataIndex(BizProcessDTO.class, "null-" + dto.getProcessName(), id);
        }
        return id;
    }
    
    @Override
    protected String findIdFromRelation(BizProcessDTO dto, DataIndexManager dataIndexManager, String packageId) {
        String id = super.findIdFromRelation(dto, dataIndexManager, packageId);
        if (StringUtils.isNotBlank(dto.getBizItemName())) {
            dataIndexManager.addDataIndex(BizProcessDTO.class, "null-" + dto.getProcessName(), id);
        }
        return id;
    }
    
    @Override
    protected void fillRelationObjectIds(BizProcessDTO bizProcessDTO) {
        if (bizProcessDTO.isNewData()) {
            if (StringUtils.isNotBlank(bizProcessDTO.getBizItemName())) {
                BizItemDTO bizItemDTO = BizProcessConverter.convert2BizItem(bizProcessDTO, null);
                String bizItemId = bizItemsDocAppservice.findIdFromRelation(bizItemDTO);
                bizProcessDTO.setBizItemId(bizItemId);
            } else {
                importDataCheckLogger.warnBizProcessDTO(bizProcessDTO, "未找到业务流程对应的业务事项");
            }
        }
    }
    
    @Override
    public List<BizProcessDTO> loadData(BizProcessDTO condition) {
        // 如果没有id，则根据条件查询
        if (StringUtils.isBlank(condition.getId())) {
            List<BizProcessDTO> alRet = queryDTOList(condition);
            int i = 0;
            for (BizProcessDTO bizProcessDTO : alRet) {
                bizProcessDTO.setSortIndex(++i);
                // 设置业务域
                setBizDomain(bizProcessDTO);
                // 设置流程分布
                Map<String, String> distributionMap = BizProcessConverter.convertToDistributionMap(bizProcessDTO
                    .getProcessLevel());
                bizProcessDTO.setDistributionMap(distributionMap);
            }
            return alRet;
        }
        
        // 如果有id，则根据id查询
        List<BizProcessDTO> alRet = new ArrayList<BizProcessDTO>();
        BizProcessInfoVO bizProcessInfoVO = bizProcessInfoAppService.readById(condition.getId());
        BizProcessDTO bizProcessDTO = vo2DTO(bizProcessInfoVO);
        alRet.add(bizProcessDTO);
        return alRet;
    }
    
    /**
     * 设置流程业务域
     *
     * @param bizProcessDTO 业务流程
     */
    private void setBizDomain(BizProcessDTO bizProcessDTO) {
        String domainId = bizProcessDTO.getBizItemDomainId();
        BizDomainVO bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
        if (bizDomainVO != null) {
            bizProcessDTO.setSecondLevelBiz(bizDomainVO.getName());
            domainId = bizDomainVO.getPaterId();
            if (StringUtils.isNotBlank(domainId)) {
                bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
                if (bizDomainVO != null) {
                    bizProcessDTO.setFirstLevelBiz(bizDomainVO.getName());
                }
            } else {
                bizProcessDTO.setFirstLevelBiz(bizDomainVO.getName());
            }
        }
    }
    
    @Override
    public String saveNewData(BizProcessDTO newBizProcessDTO) {
        if (newBizProcessDTO.isNewData()) {
            if (StringUtils.isBlank(newBizProcessDTO.getCode())) {
                newBizProcessDTO.setCode(generateCode(BizProcessInfoVO.getCodeExpr(), null));
            }
            newBizProcessDTO.setSortNo(generateSortNo("BizProcess-SortNo"));
        }
        BizProcessInfoVO vo = dto2VO(newBizProcessDTO);
        String id = bizProcessInfoAppService.save(vo);
        newBizProcessDTO.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizProcessDTO data) {
        return data.getBizItemId() + "-" + data.getProcessName();
    }
    
    /**
     * 获得上级的id
     *
     * @param data 当前对象
     * @return 上级的id
     */
    protected String getParentId(BizProcessDTO data) {
        return data.getBizItemId();
    }
    
    @Override
    protected BizProcessInfoVO dto2VO(BizProcessDTO data) {
        BizProcessInfoVO retData = DocDataUtil.dto2VO(data, BizProcessInfoVO.class);
        // 转换流程分布
        String processLevel = BizProcessConverter.convertToDistributionString(data.getDistributionMap());
        retData.setProcessLevel(processLevel);
        // 设置业务事项id
        retData.setItemsId(data.getBizItemId());
        // 设置it实现
        retData.setSysName(data.getItImpl());
        return retData;
    }
    
    @Override
    protected BizProcessDTO vo2DTO(BizProcessInfoVO vo) {
        BizProcessDTO retData = DocDataUtil.vo2DTO(vo, BizProcessDTO.class);
        retData.setBizItemId(vo.getItemsId());
        retData.setItImpl(vo.getSysName());
        Map<String, String> distributionMap = BizProcessConverter.convertToDistributionMap(vo.getProcessLevel());
        retData.setDistributionMap(distributionMap);
        setBizDomain(retData);
        return retData;
    }
    
    @Override
    public Map<String, String> fixIndexMap(String packageId) {
        List<BizProcessDTO> alExistData = loadDataByPackageId(packageId);
        Map<String, String> indexMap = new HashMap<String, String>();
        
        // 重写父类的方法，对流程进行特殊处理。首先以流程自己的uri构建索引。
        // 然后，对于有业务事项id的流程，也构建出 一个只有流程名称为Key的索引。
        for (BizProcessDTO dto : alExistData) {
            indexMap.put(getUri(dto), dto.getId());
            if (StringUtils.isNotBlank(dto.getBizItemId())) {
                indexMap.put("null-" + dto.getProcessName(), dto.getId());
            }
        }
        return indexMap;
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizProcessInfoVO> alData = loadBizProcessInfoNotExistCodeOrSortNo();
        for (BizProcessInfoVO data : alData) {
            if (StringUtils.isBlank(data.getCode())) {
                String code = generateCode(BizProcessInfoVO.getCodeExpr(), null);
                bizProcessInfoAppService.updatePropertyById(data.getId(), "code", code);
            }
            
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizProcess-SortNo", data.getItemsId());
                int code = generateSortNo(sortNoExpr);
                bizProcessInfoAppService.updatePropertyById(data.getId(), "sortNo", code);
            }
        }
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    protected List<BizProcessDTO> queryBizProcessDTOListWithNoItem(BizProcessDTO condition) {
        return bizProcessInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessDTListOWithNoItem",
            condition);
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    protected List<BizProcessDTO> queryBizProcessDTOListWithItem(BizProcessDTO condition) {
        return bizProcessInfoDAO
            .queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessDTOListWithItem", condition);
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    protected List<BizProcessDTO> queryBizProcessDTOListWithItemCondition(BizProcessDTO condition) {
        return bizProcessInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizProcessDTOListWithItemCondition",
            condition);
    }
    
    /**
     * 读取 业务流程 数据条数
     * 
     * @param condition 查询条件
     * @return 业务流程数据条数
     */
    protected List<BizProcessDTO> queryBizProcessDTOListWithNoItemCondition(BizProcessDTO condition) {
        return bizProcessInfoDAO.queryList(
            "com.comtop.cap.bm.biz.flow.model.queryBizProcessDTOListWithNoItemCondition", condition);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     *
     * @return 数据集
     */
    public List<BizProcessInfoVO> loadBizProcessInfoNotExistCodeOrSortNo() {
        return bizProcessInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.loadBizProcessInfoNotExistCodeOrSortNo",
            null);
    }
    
    /**
     * 更新流程业务域
     *
     */
    public void updateProcessDomainId() {
        bizProcessInfoDAO.update("com.comtop.cap.bm.biz.flow.model.updateProcessDomainId", null);
    }
    
    @Override
    public List<BizProcessDTO> queryDTOList(BizProcessDTO condition) {
        if (StringUtils.isNotBlank(condition.getBizItemId())) {
            return queryBizProcessDTOListWithItemCondition(condition);
        }
        return queryBizProcessDTOListWithNoItemCondition(condition);
    }
}
