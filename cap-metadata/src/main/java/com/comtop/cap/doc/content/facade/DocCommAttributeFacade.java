/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.content.appservice.DocCommAttributeAppService;
import com.comtop.cap.doc.content.model.DocCommAttributeVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 业务逻辑处理类 门面
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-11 李小芬
 */
@PetiteBean
public class DocCommAttributeFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocCommAttributeAppService docCommAttributeAppService;
    
    /**
     * 新增 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttributeVO 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     */
    public Object insertDocCommAttribute(DocCommAttributeVO docCommAttributeVO) {
        return docCommAttributeAppService.insertDocCommAttribute(docCommAttributeVO);
    }
    
    /**
     * 更新 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttributeVO 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 更新结果
     */
    public boolean updateDocCommAttribute(DocCommAttributeVO docCommAttributeVO) {
        return docCommAttributeAppService.updateDocCommAttribute(docCommAttributeVO);
    }
    
    /**
     * 保存或更新模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中，根据ID是否为空
     * 
     * @param docCommAttributeVO 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中ID
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中保存后的主键ID
     */
    public String saveDocCommAttribute(DocCommAttributeVO docCommAttributeVO) {
        if (docCommAttributeVO.getId() == null) {
            String strId = (String) this.insertDocCommAttribute(docCommAttributeVO);
            docCommAttributeVO.setId(strId);
        } else {
            this.updateDocCommAttribute(docCommAttributeVO);
        }
        return docCommAttributeVO.getId();
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中列表
     */
    public Map<String, Object> queryDocCommAttributeListByPage(DocCommAttributeVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = docCommAttributeAppService.queryDocCommAttributeCount(condition);
        List<DocCommAttributeVO> docCommAttributeVOList = null;
        if (count > 0) {
            docCommAttributeVOList = docCommAttributeAppService.queryDocCommAttributeList(condition);
        }
        ret.put("list", docCommAttributeVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttributeVO 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 删除结果
     */
    public boolean deleteDocCommAttribute(DocCommAttributeVO docCommAttributeVO) {
        return docCommAttributeAppService.deleteDocCommAttribute(docCommAttributeVO);
    }
    
    /**
     * 删除 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中集合
     * 
     * @param docCommAttributeVOList 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 删除结果
     */
    public boolean deleteDocCommAttributeList(List<DocCommAttributeVO> docCommAttributeVOList) {
        return docCommAttributeAppService.deleteDocCommAttributeList(docCommAttributeVOList);
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param docCommAttributeVO 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中对象
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     */
    public DocCommAttributeVO loadDocCommAttribute(DocCommAttributeVO docCommAttributeVO) {
        return docCommAttributeAppService.loadDocCommAttribute(docCommAttributeVO);
    }
    
    /**
     * 根据模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中主键 读取
     * 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     * 
     * @param id 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中主键
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
     */
    public DocCommAttributeVO loadDocCommAttributeById(String id) {
        return docCommAttributeAppService.loadDocCommAttributeById(id);
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 列表
     * 
     * @param condition 查询条件
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中列表
     */
    public List<DocCommAttributeVO> queryDocCommAttributeList(DocCommAttributeVO condition) {
        return docCommAttributeAppService.queryDocCommAttributeList(condition);
    }
    
    /**
     * 读取 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中 数据条数
     * 
     * @param condition 查询条件
     * @return 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中数据条数
     */
    public int queryDocCommAttributeCount(DocCommAttributeVO condition) {
        return docCommAttributeAppService.queryDocCommAttributeCount(condition);
    }
    
}
