/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.flow.appservice.BizRelDataAppService;
import com.comtop.cap.bm.biz.flow.dao.BizRelDataDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelDataVO;
import com.comtop.cap.bm.biz.info.appservice.BizObjInfoAppService;
import com.comtop.cap.doc.biz.convert.BizRelationDataItemConverter;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.BizRelationDataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务关联数据项 文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-26 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizRelationDataItemDTO.class)
public class BizRelDataDocAppservice extends BizAbstractWordDataAccessor<BizRelDataVO, BizRelationDataItemDTO> {
    
    /** 注入业务关联数据项 服务 **/
    @PetiteInject
    protected BizRelDataAppService bizRelDataAppService;
    
    /** 注入业务关联数据项DAO **/
    @PetiteInject
    protected BizRelDataDAO bizRelDataDAO;
    
    /** 业务对象服务 */
    @PetiteInject
    protected BizObjInfoAppService bizObjInfoAppService;
    
    /** 业务对象数据项文档操作服务 */
    @PetiteInject
    protected BizObjDataItemDocAppservice bizObjDataItemDocAppservice;
    
    /** 业务对象文档操作服务 */
    @PetiteInject
    protected BizObjInfoDocAppservice bizObjInfoDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizRelDataVO> getBaseAppservice() {
        return bizRelDataAppService;
    }
    
    @Override
    protected void saveBizData(List<BizRelationDataItemDTO> dataItems) {
        // 对关联数据项而言，因其上级业务关联无法进行前端过滤，故业务关联的数据项每次都是全新的值，
        // 可以直接保存。待其上级进行保存合并时，会同步合并业务数据项。故此保存方法可以写简单。
        if (dataItems != null && dataItems.size() > 0) {
            for (BizRelationDataItemDTO dataItem : dataItems) {
                
                fillRelationObjectIds(dataItem);
                // 保存新数据 业务关联每次导入的数据都是新的，故可以直接保存新数据
                // （该逻辑是根据现有业务模型的文档而设计的，文档模型和变或导入的数据结构或顺序有变化，要据实调整。）
                saveData(dataItem);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizRelationDataItemDTO dataItem) {
        
        if (dataItem.isNewData()) {
            if (StringUtils.isNotBlank(dataItem.getObjectName())) {
                // 设置业务对象id
                BizObjectDTO bizObjectDTO = BizRelationDataItemConverter.convert2BizObject(dataItem, null);
                String objectId = bizObjInfoDocAppservice.findIdFromRelation(bizObjectDTO);
                dataItem.setObjectId(objectId);
            } else {
                //
            }
            // 设置业务对象数据项id
            if (StringUtils.isNotBlank(dataItem.getDataItemName())) {
                BizObjectDataItemDTO bizObjectDataItemDTO = BizRelationDataItemConverter.convert2BizObjectDataItem(
                    dataItem, null);
                String itemId = bizObjDataItemDocAppservice.findIdFromRelation(bizObjectDataItemDTO);
                dataItem.setDataItemId(itemId);
            } else {
                //
            }
        }
    }
    
    @Override
    public List<BizRelationDataItemDTO> loadData(BizRelationDataItemDTO condition) {
        List<BizRelationDataItemDTO> alRet = queryDTOList(condition);
        setSortIndex(alRet);
        return alRet;
    }
    
    @Override
    public String saveNewData(BizRelationDataItemDTO newData) {
        newData.setSortNo(generateSortNo("BizRelData-SortNo"));
        BizRelDataVO vo = dto2VO(newData);
        String id = this.bizRelDataAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizRelationDataItemDTO data) {
        return data.getRelationId() + "-" + data.getObjectId() + "" + data.getDataItemId();
    }
    
    @Override
    protected BizRelDataVO dto2VO(BizRelationDataItemDTO data) {
        BizRelDataVO bizRelDataVO = DocDataUtil.dto2VO(data, BizRelDataVO.class);
        bizRelDataVO.setItemId(data.getDataItemId());
        bizRelDataVO.setItemName(data.getDataItemName());
        bizRelDataVO.setObjId(data.getObjectId());
        bizRelDataVO.setBizObjName(data.getObjectName());
        bizRelDataVO.setRelInfoId(data.getRelationId());
        bizRelDataVO.setItemCodeNote(data.getCodeNote());
        return bizRelDataVO;
    }
    
    @Override
    protected BizRelationDataItemDTO vo2DTO(BizRelDataVO vo) {
        BizRelationDataItemDTO bizRelationDataItemDTO = DocDataUtil.vo2DTO(vo, BizRelationDataItemDTO.class);
        bizRelationDataItemDTO.setDataItemId(vo.getItemId());
        bizRelationDataItemDTO.setDataItemName(vo.getItemName());
        bizRelationDataItemDTO.setObjectId(vo.getObjId());
        bizRelationDataItemDTO.setObjectName(vo.getBizObjName());
        bizRelationDataItemDTO.setRelationId(vo.getRelInfoId());
        bizRelationDataItemDTO.setCodeNote(vo.getItemCodeNote());
        return bizRelationDataItemDTO;
    }
    
    /**
     * 查询关联
     *
     * @param condition 条件
     * @return 关联
     */
    @Override
    public List<BizRelationDataItemDTO> queryDTOList(BizRelationDataItemDTO condition) {
        return bizRelDataDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizRelationDataItemDTOList", condition);
    }
    
}
