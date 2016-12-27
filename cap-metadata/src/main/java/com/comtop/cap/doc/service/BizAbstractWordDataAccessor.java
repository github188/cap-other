/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.common.reflect.ReflectUtil;
import com.comtop.cap.doc.DocServiceException;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.common.constant.CapNumberConstant;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.core.base.model.CoreVO;

/**
 * 业务数据的word数据访问抽象类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月11日 lizhiyong
 * @param <T> 参数
 * @param <DTO> 参数
 */
public abstract class BizAbstractWordDataAccessor<T extends CoreVO, DTO extends BaseDTO> extends
    AbstractWordDataAccessor<T, DTO> {
    
    /** 编号生成器服务 */
    protected AutoGenNumberFacade genNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
    
    /** 分组关键字之新数据 */
    public static final String GROUP_KEY_NEW = "newDatas";
    
    /** 分组关键字之已存在数据 */
    public static final String GROUP_KEY_EXIST = "existDatas";
    
    /**
     * 生成编码
     *
     * @param expresion 表达式
     * @param params 参数
     * @return 编码
     */
    protected String generateCode(String expresion, Map<?, ?> params) {
        return genNumberService.genNumber(expresion, params);
    }
    
    /**
     * 生成排序号
     *
     * @param key 识别码
     * @return 排序号 以Key唯一
     */
    protected Integer generateSortNo(String key) {
        String sortNoExpr = DocDataUtil.getSortNoExpr(key, null);
        return Integer.valueOf(genNumberService.genNumber(sortNoExpr, null));
    }
    
    /**
     * 分组为新数据和老数据
     *
     * @param datas 数据
     * @return 分组后的结果
     */
    protected Map<String, DTO> listToMap(List<DTO> datas) {
        Map<String, DTO> retMap = new HashMap<String, DTO>(10);
        for (DTO data : datas) {
            String uri = getUri(data);
            retMap.put(uri, data);
        }
        return retMap;
    }
    
    /**
     * 设置排序号
     *
     * @param datas 数据集
     */
    protected void setSortIndex(List<DTO> datas) {
        if (datas != null && datas.size() > 0) {
            int sortIndex = 1;
            for (DTO t : datas) {
                t.setSortIndex(sortIndex++);
            }
        }
    }
    
    /**
     * 查找当前对象的ID。
     * 如果能够找到，则直接返回。如果不能够找到，根据参加创建对象再返回id。
     * 本方法提供给关联当前对象的其它对象操作时调用
     * 
     * @param dto 当前对象
     * @return 对象的ID
     */
    final public String findIdFromRelation(DTO dto) {
        WordDocument document = CommonDataManager.getCurrentWordDocument();
        if (importDataCheckLogger == null) {
            importDataCheckLogger = new DataCheckLogger(document.getOptions().getLogRecorder());
        }
        DataIndexManager dataIndexManager = CommonDataManager.getCurrentDataIndexManager();
        String packageId = document.getDomainId();
        fillRelationObjectIds(dto);
        return findIdFromRelation(dto, dataIndexManager, packageId);
    }
    
    /**
     * findIdFromRelation
     *
     * @param dto DTO
     * @param dataIndexManager 数据索引管理器
     * @param packageId 包id
     * @return id
     */
    protected String findIdFromRelation(DTO dto, DataIndexManager dataIndexManager, String packageId) {
        String dataUri = getUri(dto);
        String id = dataIndexManager.getStoreId(dto.getClass(), dataUri, packageId);
        if (StringUtils.isBlank(id)) {
            id = saveNewData(dto);
            dataIndexManager.addDataIndex(dto.getClass(), dataUri, id);
        } else {
            dto.setId(id);
            updateSpecialProperties(dto);
        }
        return id;
    }
    
    /**
     * 填充关联的对象的id。
     *
     * @param dto DTO对象
     */
    protected void fillRelationObjectIds(DTO dto) {
        // 子类实现
        
    }
    
    /**
     * 获得持久化的id
     * 本方法提供给当前对象的服务判断自己是否已经存在使用
     * 
     * @param dto 对象
     * @return 持久化的id，未找到返回null。
     */
    final public String findId(DTO dto) {
        DataIndexManager dataIndexManager = CommonDataManager.getCurrentDataIndexManager();
        WordDocument document = CommonDataManager.getCurrentWordDocument();
        String packageId = document.getDomainId();
        return dataIndexManager.getStoreId(dto.getClass(), getUri(dto), packageId);
    }
    
    /**
     * 保存数据
     *
     * @param dto dto
     * @return id
     */
    protected String saveData(DTO dto) {
        String id = findId(dto);
        if (StringUtils.isBlank(id)) {
            DataIndexManager dataIndexManager = CommonDataManager.getCurrentDataIndexManager();
            return insertData(dto, dataIndexManager);
        }
        if (!StringUtils.equals(id, dto.getId())) {
            if (StringUtils.isNotBlank(dto.getId())) {
                CommonDataManager.addIdMapping(dto.getId(), id);
            }
            dto.setId(id);
        }
        updateData(dto);
        return dto.getId();
    }
    
    /**
     * 新增数据
     *
     * @param dto DTO
     * @param dataIndexManager 数据索引
     * @return id
     */
    protected String insertData(DTO dto, DataIndexManager dataIndexManager) {
        String id = saveNewData(dto);
        dataIndexManager.addDataIndex(dto.getClass(), getUri(dto), id);
        return id;
    }
    
    /**
     * 更新数据
     *
     * @param dto DTO
     */
    protected void updateData(DTO dto) {
        String id = dto.getId();
        T existData = getBaseAppservice().readById(id);
        T newData = dto2VO(dto);
        DocDataUtil.copyProperties(existData, newData);
        getBaseAppservice().update(existData);
    }
    
    @Override
    public Map<String, String> fixIndexMap(String packageId) {
        List<DTO> alExistData = loadDataByPackageId(packageId);
        Map<String, String> indexMap = new HashMap<String, String>();
        for (DTO dto : alExistData) {
            indexMap.put(getUri(dto), dto.getId());
        }
        return indexMap;
    }
    
    /**
     * 根据 包id查询数据集
     *
     * @param packageId 包id
     * @return DTO对象
     */
    final protected List<DTO> loadDataByPackageId(String packageId) {
        Type[] clazzs = ReflectUtil.getParameterizedType(getClass());
        @SuppressWarnings("unchecked")
        Class<DTO> clazz = (Class<DTO>) clazzs[1];
        DTO condition;
        try {
            condition = clazz.newInstance();
            condition.setDomainId(packageId);
            return queryDTOList(condition);
        } catch (InstantiationException e) {
        	// 无须处理
        	LOGGER.debug("error but not need to do anything", e);
        } catch (IllegalAccessException e) {
            // 无须处理
        	LOGGER.debug("error but not need to do anything", e);
        }
        throw new DocServiceException("实例化对象时发生异常。当前类：" + clazz.getName());
    }
    
    @Override
    public List<DTO> loadData(DTO condition) {
        if (StringUtils.isNotBlank(condition.getId())) {
            List<DTO> alRet = new ArrayList<DTO>();
            DTO bizObjectDTO = readById(condition.getId());
            initOneData(bizObjectDTO);
            alRet.add(bizObjectDTO);
            return alRet;
        }
        int iSortIndexStart = CapNumberConstant.NUMBER_INT_ZERO;
        List<DTO> alRet = queryDTOList(condition);
        for (DTO bizFormDTO : alRet) {
            bizFormDTO.setNewData(false);
            bizFormDTO.setSortIndex(++iSortIndexStart);
            initOneData(bizFormDTO);
        }
        return alRet;
    }
    
    /**
     * 初始化一条数据
     *
     * @param dto DTO对象
     */
    protected void initOneData(DTO dto) {
        // 子类实现
    }
    
    /**
     * 更新特别属性 。此方法为专用方法,非必须。当根据对象查找id时，如果id存在，可能需要针对部分属性进行更新。
     * <p>
     * 一般情况下应该不需要。主要是针对某些对象的某些属性是在另外一个DTO保存中才会赋值的情况。
     *
     * @param dto DTO
     */
    protected void updateSpecialProperties(DTO dto) {
        // 子类实现
    }
    
    /**
     * 查询DTO数据集
     *
     * @param condition 查询条件
     * @return DTO对象集
     */
    abstract protected List<DTO> queryDTOList(DTO condition);
    
    /**
     * 保存新数据
     * 
     * @param newData 新 数据集
     * @return VO
     */
    public abstract String saveNewData(DTO newData);
    
    /**
     * 获得 DTO uri
     *
     * @param data dto
     * @return uri
     */
    protected abstract String getUri(DTO data);
    
}
