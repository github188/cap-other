/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import java.util.Map;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 执行数据
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月11日 lizhongwen
 */
@DataTransferObject
public class InvokeData extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 最佳实践或者动态步骤的ModelId */
    private String modelId;
    
    /** 测试用例，只有在调用最佳实践的接口时才需要设置该参数 */
    private TestCase testcase;
    
    /** 参数 */
    private Map<String, String> datas;
    
    /**
     * @return 获取 modelId属性值
     */
    public String getModelId() {
        return modelId;
    }
    
    /**
     * @param modelId 设置 modelId 属性值为参数值 modelId
     */
    public void setModelId(String modelId) {
        this.modelId = modelId;
    }
    
    /**
     * @return 获取 testcase属性值
     */
    public TestCase getTestcase() {
        return testcase;
    }
    
    /**
     * @param testcase 设置 testcase 属性值为参数值 testcase
     */
    public void setTestcase(TestCase testcase) {
        this.testcase = testcase;
    }
    
    /**
     * @return 获取 datas属性值
     */
    public Map<String, String> getDatas() {
        return datas;
    }
    
    /**
     * @param datas 设置 datas 属性值为参数值 datas
     */
    public void setDatas(Map<String, String> datas) {
        this.datas = datas;
    }
}
