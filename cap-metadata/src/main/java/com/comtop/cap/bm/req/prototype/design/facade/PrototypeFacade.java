/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.prototype.design.facade;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.actionlibrary.facade.ActionDefineFacade;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.preference.facade.IncludeFilePreferenceFacade;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFilePreferenceVO;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;
import com.comtop.cap.doc.content.facade.DocChapterContentStructFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 需求建模-界面原型Facade
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016-10-28 诸焕辉
 */
@DwrProxy
@PetiteBean
public class PrototypeFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /** 控件Facade */
    private final ActionDefineFacade actionDefineFacade = AppContext.getBean(ActionDefineFacade.class);
    
    /** 引入文件Facade */
    private final IncludeFilePreferenceFacade includeFilePreferenceFacade = AppContext
        .getBean(IncludeFilePreferenceFacade.class);
    
    /** 控件Facade */
    private final ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /** 版本管理接口 */
    private final PrototypeVersionFacade prototypeVersionFacade = AppContext.getBean(PrototypeVersionFacade.class);
    
    /**
     * 加载界面原型模型
     *
     * @param modelId 模型modelId
     * @param packageId 模型的包路径
     * @return 加载的界面原型模型
     * @throws OperateException 元数据读取错误
     */
    @RemoteMethod
    public PrototypeVO loadModel(String modelId, String packageId) throws OperateException {
        PrototypeVO prototypeVO = null;
        if (StringUtil.isNotBlank(modelId)) {
            prototypeVO = (PrototypeVO) CacheOperator.readById(modelId);
        } else {
            prototypeVO = createPrototypeVO();
        }
        initIncludeFileList(prototypeVO);
        if (prototypeVO.getLayoutVO() != null) {
            prototypeVO.setLayoutVO(this.initJsonKeyList(prototypeVO.getLayoutVO()));
        }
        setPageMinWidth(prototypeVO, Boolean.TRUE);
        // TODO 加载页面原型模型时，后台为其重置部分数据
        actionDefineFacade.perfectPageAction(prototypeVO.getPageActionVOList());
        return prototypeVO;
    }
    
    /**
     * 
     * 记载控件属性属于Json格式的属性key,存入jsonKeys中
     * 
     * @param model 布局模型对象
     * @return 每个控件JSON属性Map清单
     */
    private LayoutVO initJsonKeyList(LayoutVO model) {
        model.setJsonKeys(componentFacade.queryListByProJsonType().get("modelId"));
        return model;
    }
    
    /**
     * 新建界面原型
     *
     * @return 界面原型实例
     */
    private PrototypeVO createPrototypeVO() {
        PrototypeVO prototypeVO = new PrototypeVO();
        // TODO 设置界面原型模型的属性
        return prototypeVO;
    }
    
    /**
     * 根据默认引入文件配置初始化引入文件集合
     * 
     * @param prototypeVO 页面对象
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    private void initIncludeFileList(PrototypeVO prototypeVO) throws OperateException {
        List<IncludeFilePreferenceVO> lstIncludeFilePreferenceVO = includeFilePreferenceFacade
            .queryList(new String[] { "req.preference.page.includeFile.includeFiles" });
        List<IncludeFileVO> lstDefaultIncludeFileVO = null;
        if (lstIncludeFilePreferenceVO.size() > 0) {
            StringBuffer sbExpression = new StringBuffer();
            sbExpression.append("cssList[defaultReference=").append(NumberConstant.ONE).append("] | ");
            sbExpression.append("jsList[defaultReference=").append(NumberConstant.ONE).append("]");
            lstDefaultIncludeFileVO = lstIncludeFilePreferenceVO.get(0).queryList(sbExpression.toString());
            List<IncludeFileVO> lstIncludeFileVO = prototypeVO.getIncludeFileList();
            for (IncludeFileVO objIncludeFileVO : lstIncludeFileVO) {
                if (!lstDefaultIncludeFileVO.contains(objIncludeFileVO)
                    && objIncludeFileVO.getDefaultReference() != true) {
                    lstDefaultIncludeFileVO.add(objIncludeFileVO);
                }
            }
            prototypeVO.setIncludeFileList(lstDefaultIncludeFileVO);
        }
    }
    
    /**
     * 保存界面原型模型
     *
     * @param prototypeVO 被保存的界面原型对象
     * @return 保存成功返回保存的界面原型对象，失败则返回null
     * @throws ValidateException 元数据校验失败抛出的异常
     */
    @RemoteMethod
    public PrototypeVO saveModel(PrototypeVO prototypeVO) throws ValidateException {
        setPageMinWidth(prototypeVO, Boolean.FALSE);
        PrototypeVO objPrototypeVO = prototypeVO.saveModel() ? prototypeVO : null;
        if(objPrototypeVO != null){
            // 更新版本信息
            prototypeVersionFacade.updateVersion(objPrototypeVO.getModelId());
        }
        return objPrototypeVO;
    }
    
    /**
     * 批量保存界面原型模型数据
     *
     * @param lstPrototypeVO 界面原型模型集合
     * @return 保存结果
     */
    @RemoteMethod
    public Map<String, Object> saveModel(List<PrototypeVO> lstPrototypeVO) {
        if (CollectionUtils.isEmpty(lstPrototypeVO)) {
            return null;
        }
        // 是否全部保存成功标识
        boolean flag = true;
        // 用于存放保存失败的数据模型
        List<PrototypeVO> lstFailSave = new ArrayList<PrototypeVO>();
        // 用于存放保存成功的数据模型
        List<PrototypeVO> lstSuccSave = new ArrayList<PrototypeVO>();
        for (int i = 0, len = lstPrototypeVO.size(); i < len; i++) {
            PrototypeVO objPrototypeVO = lstPrototypeVO.get(i);
            try {
                setPageMinWidth(objPrototypeVO, Boolean.FALSE);
                boolean result = objPrototypeVO.saveModel();
                if (!result) {
                    flag = false;
                    lstFailSave.add(objPrototypeVO);
                } else {
                    lstSuccSave.add(objPrototypeVO);
                }
            } catch (Exception e) {
                LOG.debug("save PrototypeVO error, PrototypeVO:{}", lstPrototypeVO, e);
                flag = false;
                lstFailSave.add(lstPrototypeVO.get(i));
            }
        }
        // 返回结果
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("flag", flag);
        map.put("failReuslt", lstFailSave);
        map.put("succResult", lstSuccSave);
        
        return map;
    }
    
    /**
     * 删除界面原型模型
     *
     * @param prototypeVO 待删除的界面原型模型
     * @return 操作结果
     * @throws OperateException 元数据操作异常
     */
    @RemoteMethod
    public boolean deleteModel(PrototypeVO prototypeVO) throws OperateException {
        boolean bSuecceed = prototypeVO.deleteModel();
        if(bSuecceed){
            // 删除版本信息
            prototypeVersionFacade.removeVersionByModelId(prototypeVO.getModelId());
        }
        return bSuecceed;
    }
    
    /**
     * 删除界面原型模型
     *
     * @param modelId 待删除的界面原型模型的modelId
     * @return 操作结果
     * @throws OperateException 元数据操作异常
     */
    @RemoteMethod
    public boolean deleteModel(String modelId) throws OperateException {
    	// 删除原型需要删掉文档原型设计章节内容
    	PrototypeVO prototypeVO = (PrototypeVO) PrototypeVO.loadModel(modelId);
    	saveReqFunctionPrototype(prototypeVO.getFunctionSubitemId());
    	boolean bSuecceed = PrototypeVO.deleteModel(modelId);
    	if(bSuecceed){
    	    // 删除版本信息
    	    prototypeVersionFacade.removeVersionByModelId(modelId);
    	}
        return bSuecceed;
    }
    
    /**
     * 将对应功能子项原型页面截图保存到文档对应章节内容中，保证需求文档中功能子项下的界面原型里的内容完整。
     * @param reqFunctionSubitemId 功能子项id
     * @return true 成功，false 失败
     */
    private boolean saveReqFunctionPrototype(String reqFunctionSubitemId) {
    	DocChapterContentStructFacade docChapterContentStructFacade = AppContext.getBean(DocChapterContentStructFacade.class);
    	return docChapterContentStructFacade.saveReqFunctionPrototype(reqFunctionSubitemId);
    }
    
    /**
     * 删除界面原型模型
     *
     * @param modelIds 待删除的界面原型模型的modelId集合
     * @return 操作结果
     * @throws OperateException 元数据操作异常
     */
    @RemoteMethod
    public Map<String, Object> deleteModel(String[] modelIds) throws OperateException {
        if (modelIds == null || modelIds.length == 0) {
            return null;
        }
        // 是否全部保存成功标识
        boolean flag = true;
        // 用于存放保存失败的数据模型
        List<String> lstFailSave = new ArrayList<String>();
        // 用于存放保存成功的数据模型
        List<String> lstSuccSave = new ArrayList<String>();
        for (int i = 0, len = modelIds.length; i < len; i++) {
            try {
                boolean result = deleteModel(modelIds[i]);
                if (!result) {
                    flag = false;
                    lstFailSave.add(modelIds[i]);
                } else {
                    lstSuccSave.add(modelIds[i]);
                }
            } catch (Exception e) {
                LOG.debug("delete PrototypeVO error", e);
                flag = false;
                lstFailSave.add(modelIds[i]);
            }
        }
        // 返回结果
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("flag", flag);
        map.put("failReuslt", lstFailSave);
        map.put("succResult", lstSuccSave);
        // 删除版本信息
        prototypeVersionFacade.removeVersionByModelIds(modelIds);
        return map;
    }
    
    /**
     * 通过包查询包下面的所有界面原型
     *
     * @param modelPackage 包
     * @return 界面原型集合
     * @throws OperateException 读取元数据异常
     */
    @RemoteMethod
    public List<PrototypeVO> queryPrototypesByModelPackage(String modelPackage) throws OperateException {
        return queryPrototypesByXpath(modelPackage + "/prototype");
    }
    
    /**
     * 通过xpath表达式，获取界面原型
     *
     * @param expression 表达式
     * @return 界面原型集合
     * @throws OperateException 读取元数据异常
     */
    @RemoteMethod
    public List<PrototypeVO> queryPrototypesByXpath(String expression) throws OperateException {
        List<PrototypeVO> lstPrototypeVO = CacheOperator.queryList(expression, PrototypeVO.class);
        // 按sortNo排序
        Collections.sort(lstPrototypeVO, PrototypeComparator.getInstance());
        return lstPrototypeVO;
    }

    /**
     * 查询功能子项下对应的原型设计页面集合
     * @param reqFunctionSubitemId 功能子项id
     * @return 功能子项下对应的原型设计页面集合
     * @throws OperateException 元数据读取错误
     */
    @RemoteMethod
    public List<PrototypeVO> queryPrototypesByFunctionSubitemId(String reqFunctionSubitemId) throws OperateException {
        return this.queryPrototypesByXpath("prototype[functionSubitemId='" + reqFunctionSubitemId + "']");
    }
    
    /**
     * 检查界面原型名称是否已存在（注：只有新增，没有更新操作）
     * 检查所有业务域下的所有功能项的所有子功能项中是否存在此页面。
     * 
     * @param modelName 界面原型名称
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistNewModelName(String modelName) throws OperateException {
        return !CollectionUtils.isEmpty(CacheOperator.queryList("/prototype[type=0 and modelName='" + modelName + "']", PrototypeVO.class));
    }
    
    /**
     * 
     * 获取最新的sortNo值，先获取包路径下的界面原型中最大的sortNo,在此sortNo的基础上+1进行返回。
     *
     * 
     * @param modelPackage 包
     * @return 最新的sortNo
     * @throws OperateException 异常
     */
    @RemoteMethod
    public int getLastSortNo(String modelPackage) throws OperateException {
        List<PrototypeVO> lstPrototype = this.queryPrototypesByModelPackage(modelPackage);
        if (null == lstPrototype || lstPrototype.size() <= 0) {
            return 0;
        }
        PrototypeVO prototypeVO = lstPrototype.get(lstPrototype.size() - 1);
        return prototypeVO.getSortNo() + 1;
    }
    
    /**
     * 设置页面最小分辨率
     * 
     * @param prototypeVO 页面对象
     * @param flag true: 读取操作， false：保存操作
     */
    private void setPageMinWidth(PrototypeVO prototypeVO, boolean flag) {
        String strMinWidth = prototypeVO.getMinWidth();
        if (StringUtil.isNotBlank(strMinWidth)) {
            if (flag) {
                Pattern objPattern = Pattern.compile("^100%|1024px|1280px$");
                Matcher objIsNum = objPattern.matcher(strMinWidth);
                prototypeVO.setMinWidth(objIsNum.matches() ? strMinWidth
                    : strMinWidth.substring(0, strMinWidth.length() - 2));
            } else {
                Pattern objPattern = Pattern.compile("^[0-9]*$");
                Matcher objIsNum = objPattern.matcher(strMinWidth);
                prototypeVO.setMinWidth(objIsNum.matches() ? strMinWidth + "px" : strMinWidth);
            }
        }
        
        String strPageMinWidth = prototypeVO.getPageMinWidth();
        if (StringUtil.isNotBlank(strPageMinWidth)) {
            if (flag) {
                Pattern objPattern = Pattern.compile("^100%|600px|800px|1024px$");
                Matcher objIsNum = objPattern.matcher(strPageMinWidth);
                prototypeVO.setPageMinWidth(objIsNum.matches() ? strPageMinWidth : strPageMinWidth.substring(0,
                    strPageMinWidth.length() - 2));
            } else {
                Pattern objPattern = Pattern.compile("^[0-9]*$");
                Matcher objIsNum = objPattern.matcher(strPageMinWidth);
                prototypeVO.setPageMinWidth(objIsNum.matches() ? strPageMinWidth + "px" : strPageMinWidth);
            }
        }
        
    }
}

/**
 * 界面原型排序比较器
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年11月7日 凌晨
 */
class PrototypeComparator implements Comparator<PrototypeVO> {
    
    /** 比较器单例对象 */
    private static final PrototypeComparator singleInstance = new PrototypeComparator();
    
    /**
     * 构造函数
     */
    private PrototypeComparator() {
        if (singleInstance != null) {
            throw new RuntimeException("Illegal call constructor,PrototypeComparator class is singletion.");
        }
    }
    
    /**
     * 获取单例方法
     *
     * @return 单例比较器
     */
    public static PrototypeComparator getInstance() {
        return singleInstance;
    }
    
    /**
     * 根据sortNo进行排序
     * 
     * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
     */
    @Override
    public int compare(PrototypeVO o1, PrototypeVO o2) {
        if (o1.getSortNo() > o2.getSortNo()) {
            return 1;
        } else if (o1.getSortNo() < o2.getSortNo()) {
            return -1;
        } else {
            return 0;
        }
    }
    
}
