/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.top.core.base.model.CoreVO;

/**
 * 抽象的word数据访问器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月11日 lizhiyong
 * @param <T> 类型参数
 * @param <DTO> DTO
 */
public abstract class AbstractWordDataAccessor<T extends CoreVO, DTO extends BaseDTO> implements
    IWordDataAccessor<DTO>, IIndexBuilder {
    
    /** 日志对象 */
    protected final Logger LOGGER = LoggerFactory.getLogger(getClass());
    
    /** 导入数据检验日志对象 */
    protected DataCheckLogger importDataCheckLogger;
    
    /**
     * 根据ID获取文档DTO
     * 
     * @param id ID
     * @return 文档DTO
     */
    public final DTO readById(String id) {
        T vo = getBaseAppservice().readById(id);
        DTO dto = vo2DTO(vo);
        dto.setNewData(false);
        return dto;
    }
    
    /**
     * 根据id和属性名读取属性
     *
     * @param id 对象id
     * @param propertyName 属性名
     * @return 值
     */
    public final Object readPropertyByID(String id, String propertyName) {
        return getBaseAppservice().readPropertyById(id, propertyName);
    }
    
    /**
     * 根据id和属性名更新属性
     *
     * @param id 对象id
     * @param property 属性名
     * @param value 值
     */
    @Override
    public final void updatePropertyByID(String id, String property, Object value) {
        getBaseAppservice().updatePropertyById(id, property, value);
    }
    
    /**
     * 获得appservice
     *
     * @return appservice
     */
    protected abstract MDBaseAppservice<T> getBaseAppservice();
    
    @Override
    public final void saveData(List<DTO> collection) {
        if (collection == null || collection.size() == 0) {
            return;
        }
        WordDocument doc = CommonDataManager.getCurrentWordDocument();
        if (importDataCheckLogger == null) {
            importDataCheckLogger = new DataCheckLogger(doc.getOptions().getLogRecorder());
        }
        saveBizData(collection);
    }
    
    @Override
    public Map<String, String> fixIndexMap(String packageId) {
        return null;
    }
    
    /**
     * 保存业务数据
     *
     * @param collection 业务数据集
     */
    protected abstract void saveBizData(List<DTO> collection);
    
    /**
     * 更新保存已经存在的数据
     *
     * @param data 数据集
     * @return VO
     */
    protected abstract T dto2VO(DTO data);
    
    /**
     * VO转换为DTO .一般情况下，子类应该重写本方法
     *
     * @param vo vo
     * @return DTO
     */
    protected abstract DTO vo2DTO(T vo);
}
