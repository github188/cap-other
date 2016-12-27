/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.ObjectOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;

/**
 * 模型公共父类
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-22 郑重
 */
abstract public class BaseModel extends BaseMetadata {
    
    /**
	 *
	 */
    private static final long serialVersionUID = 7466518361149818280L;
    
    /**
     * 日志
     */
    protected Logger logger;
    
    /**
     * 模型ID
     */
    private String modelId;
    
    /**
     * 模型包
     */
    private String modelPackage;
    
    /**
     * 模型名称
     */
    private String modelName;
    
    /**
     * 模型类型
     */
    private String modelType;
    
    /**
     * 对象操作
     */
    private final transient ObjectOperator objectOperator;
    
    /**
     * 继承ModelId
     */
    private String extend;
    
    /**
     * 创建人Id
     */
    private String createrId;
    
    /**
     * 创建人名称
     */
    private String createrName;
    
    /**
     * 创建时间
     */
    private long createTime;
    
    /**
     * 构造函数
     */
    public BaseModel() {
        objectOperator = new ObjectOperator(this);
        logger = LoggerFactory.getLogger(this.getClass());
    }
    
    /**
     * @return the modelId
     */
    public String getModelId() {
        return modelId;
    }
    
    /**
     * @param modelId the modelId to set
     */
    public void setModelId(String modelId) {
        this.modelId = modelId;
    }
    
    /**
     * @return the modelPackage
     */
    public String getModelPackage() {
        return modelPackage;
    }
    
    /**
     * @param modelPackage the modelPackage to set
     */
    public void setModelPackage(String modelPackage) {
        this.modelPackage = modelPackage;
    }
    
    /**
     * @return the modelName
     */
    public String getModelName() {
        return modelName;
    }
    
    /**
     * @param modelName the modelName to set
     */
    public void setModelName(String modelName) {
        this.modelName = modelName;
    }
    
    /**
     * @return the modelType
     */
    public String getModelType() {
        return modelType;
    }
    
    /**
     * @param modelType the modelType to set
     */
    public void setModelType(String modelType) {
        this.modelType = modelType;
    }
    
    /**
     * @return the extend
     */
    public String getExtend() {
        return extend;
    }
    
    /**
     * @param extend the extend to set
     */
    public void setExtend(String extend) {
        this.extend = extend;
    }
    
    /**
     * @return the createrId
     */
    public String getCreaterId() {
        return createrId;
    }
    
    /**
     * @param createrId the createrId to set
     */
    public void setCreaterId(String createrId) {
        this.createrId = createrId;
    }
    
    /**
     * @return the createrName
     */
    public String getCreaterName() {
        return createrName;
    }
    
    /**
     * @param createrName the createrName to set
     */
    public void setCreaterName(String createrName) {
        this.createrName = createrName;
    }
    
    /**
     * @return the createTime
     */
    public long getCreateTime() {
        return createTime;
    }
    
    /**
     * @param createTime the createTime to set
     */
    public void setCreateTime(long createTime) {
        this.createTime = createTime;
    }
    
    /**
     * 读取属性
     *
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public Object query(final String expression) throws OperateException {
        return objectOperator.read(expression);
    }
    
    /**
     * 读取属性
     *
     * @param <T> 类型
     *
     * @param expression 表达式
     * @param c 返回结果类型
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public <T> T query(final String expression, Class<T> c) throws OperateException {
        return objectOperator.read(expression, c);
    }
    
    /**
     * 集合查询
     *
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("rawtypes")
    public List queryList(final String expression) throws OperateException {
        return objectOperator.queryList(expression);
    }
    
    /**
     * 集合查询
     * 
     * @param <T> Class
     *
     * @param expression 表达式
     * @param c 返回结果类型
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public <T> List<T> queryList(final String expression, Class<T> c) throws OperateException {
        return objectOperator.queryList(expression, c);
    }
    
    /**
     * 集合查询
     *
     * @param expression 表达式
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("rawtypes")
    public List queryList(final String expression, int pageSize) throws OperateException {
        return objectOperator.queryList(expression, pageSize);
    }
    
    /**
     * 集合查询
     * 
     * @param <T> Class
     *
     * @param expression 表达式
     * @param c 返回结果类型
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public <T> List<T> queryList(final String expression, Class<T> c, int pageSize) throws OperateException {
        return objectOperator.queryList(expression, c, pageSize);
    }
    
    /**
     * 向集合中添加对象
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     * @throws ValidateException 校验异常
     */
    public boolean add(final String expression, final Object value) throws OperateException, ValidateException {
        boolean bResult = false;
        if (objectOperator.add(expression, value)) {
            bResult = this.saveModel();
        }
        return bResult;
    }
    
    /**
     * 更新
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     * @throws ValidateException 校验异常
     */
    public boolean update(final String expression, final Object value) throws OperateException, ValidateException {
        boolean bResult = false;
        if (objectOperator.update(expression, value)) {
            bResult = this.saveModel();
        }
        return bResult;
    }
    
    /**
     * 更新
     *
     * @param expression 表达式
     * @param value 值
     * @return 是否保存成功
     * @throws OperateException 对象操作异常
     * @throws ValidateException 校验异常
     */
    public boolean createAndSave(final String expression, final Object value) throws OperateException,
        ValidateException {
        boolean bResult = false;
        if (objectOperator.createAndSave(expression, value)) {
            bResult = this.saveModel();
        }
        return bResult;
    }
    
    /**
     * 删除子对象
     *
     * @param expression 表达式
     * @return 删除数据成功
     * @throws OperateException 对象操作异常
     * @throws ValidateException 校验异常
     */
    public boolean delete(String expression) throws OperateException, ValidateException {
        boolean bResult = false;
        if (objectOperator.delete(expression)) {
            bResult = this.saveModel();
        }
        return bResult;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    public static Object loadModel(String id) {
        return CacheOperator.readById(id);
    }
    
    /**
     * 验证VO对象
     *
     * @return 结果集
     */
    @SuppressWarnings("rawtypes")
    public ValidateResult validate() {
        return ValidatorUtil.validate(this);
    }
    
    /**
     * 保存模型文件
     *
     * @return 操作结果
     * @throws ValidateException 校验异常
     */
    public boolean saveModel() throws ValidateException {
        boolean bResult = false;
        ValidateResult<?> objValidateResult = validate();
        if (objValidateResult.isOK()) {
            if (this.createTime == 0) {
                this.createTime = System.currentTimeMillis();
            }
            bResult = CacheOperator.save(this);
        } else {
            logger.error(objValidateResult.getMessageString());
            throw new ValidateException("模型对象校验失败", objValidateResult);
        }
        return bResult;
    }
    
    /**
     * 删除模型文件
     *
     * @return 操作结果
     * @throws OperateException 对象操作异常
     */
    public boolean deleteModel() throws OperateException {
        return CacheOperator.delete(this.getModelId());
    }
    
    /**
     * 删除模型文件
     *
     * @param id modelId
     *
     * @return 操作结果
     * @throws OperateException 对象操作异常
     */
    public static boolean deleteModel(String id) throws OperateException {
        return CacheOperator.delete(id);
    }
}
