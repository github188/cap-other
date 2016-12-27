/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.appservice;

import java.util.List;

import com.comtop.cap.doc.content.dao.DocCommAttributeDAO;
import com.comtop.cap.doc.content.model.DocCommAttributeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.appservice.BaseAppService;

/**
 * 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 业务逻辑处理类
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-11 李小芬
 */
@PetiteBean
public class DocCommAttributeAppService extends BaseAppService {
    
    /** 注入DAO **/
    @PetiteInject
    protected DocCommAttributeDAO docCommAttributeDAO;
    
    /**
     * 新增 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttribute 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中Id
     */
    public Object insertDocCommAttribute(DocCommAttributeVO docCommAttribute) {
        return docCommAttributeDAO.insertDocCommAttribute(docCommAttribute);
    }
    
    /**
     * 更新 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttribute 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 更新成功与否
     */
    public boolean updateDocCommAttribute(DocCommAttributeVO docCommAttribute) {
        return docCommAttributeDAO.updateDocCommAttribute(docCommAttribute);
    }
    
    /**
     * 删除 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttribute 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 删除成功与否
     */
    public boolean deleteDocCommAttribute(DocCommAttributeVO docCommAttribute) {
        return docCommAttributeDAO.deleteDocCommAttribute(docCommAttribute);
    }
    
    /**
     * 删除 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中集合
     * 
     * @param docCommAttributeList 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 删除成功与否
     */
    public boolean deleteDocCommAttributeList(List<DocCommAttributeVO> docCommAttributeList) {
        if (docCommAttributeList == null) {
            return true;
        }
        for (DocCommAttributeVO docCommAttribute : docCommAttributeList) {
            this.deleteDocCommAttribute(docCommAttribute);
        }
        return true;
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttribute 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     */
    public DocCommAttributeVO loadDocCommAttribute(DocCommAttributeVO docCommAttribute) {
        return docCommAttributeDAO.loadDocCommAttribute(docCommAttribute);
    }
    
    /**
     * 根据模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中主键读取
     * 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param id 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中主键
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     */
    public DocCommAttributeVO loadDocCommAttributeById(String id) {
        return docCommAttributeDAO.loadDocCommAttributeById(id);
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 列表
     * 
     * @param condition 查询条件
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中列表
     */
    public List<DocCommAttributeVO> queryDocCommAttributeList(DocCommAttributeVO condition) {
        return docCommAttributeDAO.queryDocCommAttributeList(condition);
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 数据条数
     * 
     * @param condition 查询条件
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中数据条数
     */
    public int queryDocCommAttributeCount(DocCommAttributeVO condition) {
        return docCommAttributeDAO.queryDocCommAttributeCount(condition);
    }
    
}
