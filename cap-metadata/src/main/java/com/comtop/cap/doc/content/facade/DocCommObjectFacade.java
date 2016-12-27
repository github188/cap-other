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

import com.comtop.cap.doc.content.appservice.DocCommObjectAppService;
import com.comtop.cap.doc.content.model.DocCommObjectVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 业务逻辑处理类 门面
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-11 李小芬
 */
@PetiteBean
public class DocCommObjectFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocCommObjectAppService docCommObjectAppService;
    
    /**
     * 新增 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObjectVO 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public Object insertDocCommObject(DocCommObjectVO docCommObjectVO) {
        return docCommObjectAppService.insertDocCommObject(docCommObjectVO);
    }
    
    /**
     * 更新 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObjectVO 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 更新结果
     */
    public boolean updateDocCommObject(DocCommObjectVO docCommObjectVO) {
        return docCommObjectAppService.updateDocCommObject(docCommObjectVO);
    }
    
    /**
     * 保存或更新模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中，根据ID是否为空
     * 
     * @param docCommObjectVO 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中ID
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中保存后的主键ID
     */
    public String saveDocCommObject(DocCommObjectVO docCommObjectVO) {
        if (docCommObjectVO.getId() == null) {
            String strId = (String) this.insertDocCommObject(docCommObjectVO);
            docCommObjectVO.setId(strId);
        } else {
            this.updateDocCommObject(docCommObjectVO);
        }
        return docCommObjectVO.getId();
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中列表
     */
    public Map<String, Object> queryDocCommObjectListByPage(DocCommObjectVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = docCommObjectAppService.queryDocCommObjectCount(condition);
        List<DocCommObjectVO> docCommObjectVOList = null;
        if (count > 0) {
            docCommObjectVOList = docCommObjectAppService.queryDocCommObjectList(condition);
        }
        ret.put("list", docCommObjectVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObjectVO 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 删除结果
     */
    public boolean deleteDocCommObject(DocCommObjectVO docCommObjectVO) {
        return docCommObjectAppService.deleteDocCommObject(docCommObjectVO);
    }
    
    /**
     * 删除 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中集合
     * 
     * @param docCommObjectVOList 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 删除结果
     */
    public boolean deleteDocCommObjectList(List<DocCommObjectVO> docCommObjectVOList) {
        return docCommObjectAppService.deleteDocCommObjectList(docCommObjectVOList);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param docCommObjectVO 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中对象
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObject(DocCommObjectVO docCommObjectVO) {
        return docCommObjectAppService.loadDocCommObject(docCommObjectVO);
    }
    
    /**
     * 根据模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键 读取
     * 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     * 
     * @param id 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中主键
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中
     */
    public DocCommObjectVO loadDocCommObjectById(String id) {
        return docCommObjectAppService.loadDocCommObjectById(id);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 列表
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中列表
     */
    public List<DocCommObjectVO> queryDocCommObjectList(DocCommObjectVO condition) {
        return docCommObjectAppService.queryDocCommObjectList(condition);
    }
    
    /**
     * 读取 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中 数据条数
     * 
     * @param condition 查询条件
     * @return 模型对象实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在此表中，对象属性存储在CAP_DOC_COMM_ATTRIBUTE表中数据条数
     */
    public int queryDocCommObjectCount(DocCommObjectVO condition) {
        return docCommObjectAppService.queryDocCommObjectCount(condition);
    }
    
    /**
     * 根据对象定义URI和对象ID，查询对象实例VO及对象实例属性VO
     *
     * @param docCommObject 对象实例VO
     * @return 对象实例VO
     */
    public DocCommObjectVO readObjectInstance(DocCommObjectVO docCommObject) {
        return docCommObjectAppService.readObjectInstance(docCommObject);
    }
    
}
