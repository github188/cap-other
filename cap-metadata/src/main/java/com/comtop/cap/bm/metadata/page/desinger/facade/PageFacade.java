/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.facade;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.converter.page.PageConverterUtil;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.PageUtil;
import com.comtop.cap.bm.metadata.page.actionlibrary.facade.ActionDefineFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageAttributeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageComponentExpressionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageComponentStateVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.desinger.model.RightVO;
import com.comtop.cap.bm.metadata.page.preference.facade.IncludeFilePreferenceFacade;
import com.comtop.cap.bm.metadata.page.preference.facade.PageAttributePreferenceFacade;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import com.comtop.cap.bm.metadata.page.uilibrary.facade.ComponentFacade;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.sqlfile.GenerateSqlFileFactory;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.req.prototype.design.facade.PrototypeFacade;
import com.comtop.cap.bm.req.prototype.design.model.PrototypeVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.JSONObject;
import com.comtop.cip.validator.javax.validation.ConstraintViolation;
import com.comtop.cip.validator.org.hibernate.validator.engine.ConstraintViolationImpl;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.DateTimeUtil;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.sys.accesscontrol.func.FuncConstants;
import com.comtop.top.sys.accesscontrol.func.facade.FuncFacade;
import com.comtop.top.sys.accesscontrol.func.facade.IFuncFacade;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 页面元数据facade类
 * 
 * @author 郑重
 * @since jdk1.6
 * @version 2015-6-9 郑重
 */
@DwrProxy
@PetiteBean
public class PageFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * PrototypeFacade
     */
    private final PrototypeFacade prototypeFacade = AppContext.getBean(PrototypeFacade.class);
    
    /** 控件Facade */
    private final ComponentFacade componentFacade = AppContext.getBean(ComponentFacade.class);
    
    /**
     * 页面/菜单 facade
     */
    protected IFuncFacade funcFacade = AppContext.getBean(FuncFacade.class);
    
    /** 实体 Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /** 控件Facade */
    private final ActionDefineFacade actionDefineFacade = AppContext.getBean(ActionDefineFacade.class);
    
    /** 引入文件Facade */
    private final IncludeFilePreferenceFacade includeFilePreferenceFacade = AppContext
        .getBean(IncludeFilePreferenceFacade.class);
    
    /** 页面参数Facade */
    private final PageAttributePreferenceFacade pageAttributePreferenceFacade = AppContext
        .getBean(PageAttributePreferenceFacade.class);
    
    /**
     * 加载模型文件
     * 
     * @param modelId 控件模型ID
     * @param packageId 当前模块PackageVO 主键
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public PageVO loadModel(String modelId, String packageId) throws OperateException {
        PageVO objPageVO;
        // 如果modelId为空则构造空pageVO到新增页面
        if (StringUtil.isNotBlank(modelId)) {
            objPageVO = (PageVO) CacheOperator.readById(modelId);
            // 页面初始化时，拿当前页面元数据中存储的parentId去查询。（主要解决页面在另外一个模块下（包路径一样）加载取不到FuncDTO而导致的问题，如生成sql、增加页面权限等。）
            if (StringUtil.isNotBlank(objPageVO.getParentId())) {
                List<FuncDTO> lstFunc = getParentFun(objPageVO.getParentId());
                // 如果存在，则不做处理。如果不存在，则默认取当前页面所在的模块
                if (CollectionUtils.isEmpty(lstFunc) && StringUtil.isNotBlank(packageId)) {
                    lstFunc = getParentFun(packageId);
                    setPageParentId(objPageVO, lstFunc);
                }
            }
            
        } else {
            objPageVO = createNewPage(packageId);
        }
        // 初始化默认引入文件
        initIncludeFileList(objPageVO);
        // 初始化默认页面参数
        initpageParameterList(objPageVO);
        // 初始化数据集
        initDataStore(objPageVO);
        if (objPageVO.getLayoutVO() != null) {
            objPageVO.setLayoutVO(this.initJsonKeyList(objPageVO.getLayoutVO()));
        }
        // 生成代码时，重新读取了缓存数据，此时packageId为空
        if (packageId != null) {
            setPageMinWidth(objPageVO, Boolean.TRUE);
        }
        setPageComponentStateVO(objPageVO);
        setDataStoreVO(objPageVO, objPageVO.getModelPackageId());
        actionDefineFacade.perfectPageAction(objPageVO.getPageActionVOList());
        return objPageVO;
    }
    
    /**
     * 以需求建模中的原型页面元数据创建开发建模页面元数据
     * 
     * @param packageId 当前模块PackageVO 主键
     * @param prototypeId 需求建模中原型页面元数据
     * @return 操作结果
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public PageVO createPageVO(String packageId, String prototypeId) throws OperateException {
        PageVO objPageVO = createNewPage(packageId);
        
        // 初始化默认引入文件
        initIncludeFileList(objPageVO);
        // 初始化默认页面参数
        initpageParameterList(objPageVO);
        // 初始化数据集
        initDataStore(objPageVO);
        if (objPageVO.getLayoutVO() != null) {
            objPageVO.setLayoutVO(this.initJsonKeyList(objPageVO.getLayoutVO()));
        }
        // 生成代码时，重新读取了缓存数据，此时packageId为空
        if (packageId != null) {
            setPageMinWidth(objPageVO, Boolean.TRUE);
        }
        // 将原型设计页面转换为pageVO元数据
        PageConverterUtil.convertPrototype(objPageVO, prototypeId);
        setPageComponentStateVO(objPageVO);
        setDataStoreVO(objPageVO, objPageVO.getModelPackageId());
        actionDefineFacade.perfectPageAction(objPageVO.getPageActionVOList());
        return objPageVO;
    }
    
    /**
     * 根据modelid集合获取页面元数据集合
     * 
     * @param modelIds modelIds
     * @return lstPageVO
     */
    @RemoteMethod
    public List<PageVO> loadModelByModelId(String[] modelIds) {
        List<PageVO> lstPageVO = new ArrayList<PageVO>();
        for (int i = 0; i < modelIds.length; i++) {
            PageVO objPageVO = (PageVO) CacheOperator.readById(modelIds[i]);
            lstPageVO.add(objPageVO);
        }
        return lstPageVO;
    }
    
    /**
     * 根据modelid集合获取页面元数据集合
     * 
     * @param lstPageVO lstPageVO
     * @return iRet
     */
    @RemoteMethod
    public int savePage(List<PageVO> lstPageVO) {
        int iRet = 0;
        for (PageVO objPageVO : lstPageVO) {
            try {
                if (objPageVO.saveModel()) {
                    iRet++;
                }
            } catch (ValidateException e) {
                LOG.error("保存模型文件失败", e);
            }
        }
        return iRet;
    }
    
    /**
     * 获取页面url的截取前缀
     * 
     * @return 字符串
     */
    @RemoteMethod
    public String getPageUrlPrefix() {
        return PreferenceConfigQueryUtil.getPageUrlPrefix();
    }
    
    /**
     * 获取页面url的后缀
     * 
     * @return 字符串
     */
    @RemoteMethod
    public String getPageUrlSuffix() {
        return PageUtil.getPageUrlSuffix();
    }
    
    /**
     * 设置页面最小分辨率
     * 
     * @param pageVO 页面对象
     * @param flag true: 读取操作， false：保存操作
     */
    private void setPageMinWidth(PageVO pageVO, boolean flag) {
        String strMinWidth = pageVO.getMinWidth();
        if (StringUtil.isNotBlank(strMinWidth)) {
            if (flag) {
                Pattern objPattern = Pattern.compile("^100%|1024px|1280px$");
                Matcher objIsNum = objPattern.matcher(strMinWidth);
                pageVO.setMinWidth(objIsNum.matches() ? strMinWidth
                    : strMinWidth.substring(0, strMinWidth.length() - 2));
            } else {
                Pattern objPattern = Pattern.compile("^[0-9]*$");
                Matcher objIsNum = objPattern.matcher(strMinWidth);
                pageVO.setMinWidth(objIsNum.matches() ? strMinWidth + "px" : strMinWidth);
            }
        }
        
        String strPageMinWidth = pageVO.getPageMinWidth();
        if (StringUtil.isNotBlank(strPageMinWidth)) {
            if (flag) {
                Pattern objPattern = Pattern.compile("^100%|600px|800px|1024px$");
                Matcher objIsNum = objPattern.matcher(strPageMinWidth);
                pageVO.setPageMinWidth(objIsNum.matches() ? strPageMinWidth : strPageMinWidth.substring(0,
                    strPageMinWidth.length() - 2));
            } else {
                Pattern objPattern = Pattern.compile("^[0-9]*$");
                Matcher objIsNum = objPattern.matcher(strPageMinWidth);
                pageVO.setPageMinWidth(objIsNum.matches() ? strPageMinWidth + "px" : strPageMinWidth);
            }
        }
        
    }
    
    /**
     * 
     * @param packageId 当前模块PackageVO 主键
     * @return pageVo
     */
    private PageVO createNewPage(String packageId) {
        PageVO objPageVO = new PageVO();
        CapPackageVO objPackageVO = getPackageVO(packageId);
        objPageVO.setModelPackage(objPackageVO.getFullPath());
        objPageVO.setModelPackageId(packageId);
        List<FuncDTO> lstFunc = getParentFun(packageId);
        if (lstFunc == null || lstFunc.size() == 0) {
            return objPageVO;
        }
        setPageParentId(objPageVO, lstFunc);
        return objPageVO;
    }
    
    /**
     * 设置PageVO中的parentId
     * 
     * @param objPageVO pageVO
     * @param lstFunc 父Func的VO的集合
     */
    private void setPageParentId(PageVO objPageVO, List<FuncDTO> lstFunc) {
        if (!CollectionUtils.isEmpty(lstFunc) && objPageVO != null) {
            objPageVO.setParentId(lstFunc.get(0).getFuncId());
            objPageVO.setParentName(lstFunc.get(0).getFuncName());
        }
    }
    
    /**
     * 设置默认上级目录
     * 
     * @param packageId 模块Id
     * @return 父菜单/页面
     */
    private List<FuncDTO> getParentFun(String packageId) {
        FuncDTO objQueryFuncDTO = new FuncDTO();
        objQueryFuncDTO.setParentFuncId(packageId);
        objQueryFuncDTO.setParentFuncType("MODULE");
        List<FuncDTO> lstFunc = funcFacade.queryFuncChild(objQueryFuncDTO);
        return lstFunc;
    }
    
    /**
     * 
     * @param packageId 包对象Id
     * @return 包对象
     */
    private CapPackageVO getPackageVO(String packageId) {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        return objPackageVO;
    }
    
    /**
     * 
     * 根据包路径初始化页面
     * 
     * @param modelPackage 模型包路径
     * @return 初始化后的PageVO
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public PageVO initModelByModelPackage(String modelPackage) throws OperateException {
        PageVO objPageVO = new PageVO();
        objPageVO.setModelPackage(modelPackage);
        initIncludeFileList(objPageVO);
        initDataStore(objPageVO);
        if (objPageVO.getLayoutVO() != null) {
            objPageVO.setLayoutVO(this.initJsonKeyList(objPageVO.getLayoutVO()));
        }
        
        setPageComponentStateVO(objPageVO);
        setDataStoreVO(objPageVO, null);
        actionDefineFacade.perfectPageAction(objPageVO.getPageActionVOList());
        return objPageVO;
    }
    
    /**
     * 初始化数据集
     * 
     * @param pageVO 页面对象
     */
    private void initDataStore(PageVO pageVO) {
        // 如果PageVO中DataStore为空，则新增固定参数
        if (pageVO.getDataStoreVOList() == null || pageVO.getDataStoreVOList().size() == 0) {
            List<DataStoreVO> lstDataStoreVOs = new ArrayList<DataStoreVO>(3);
            
            DataStoreVO objGlobInfo = new DataStoreVO();
            objGlobInfo.setCname("页面全局参数");
            objGlobInfo.setEname("environmentVariable");
            objGlobInfo.setEntityId("");
            objGlobInfo.setModelType("environmentVariable");
            lstDataStoreVOs.add(objGlobInfo);
            
            DataStoreVO objPageUrlParam = new DataStoreVO();
            objPageUrlParam.setCname("页面传入参数");
            objPageUrlParam.setEname("pageParam");
            objPageUrlParam.setEntityId("");
            objPageUrlParam.setModelType("pageParam");
            lstDataStoreVOs.add(objPageUrlParam);
            
            DataStoreVO objUserPageRight = new DataStoreVO();
            objUserPageRight.setCname("页面用户权限");
            objUserPageRight.setEname("rightsVariable");
            objUserPageRight.setEntityId("");
            objUserPageRight.setModelType("rightsVariable");
            objUserPageRight.setVerifyIdList(new ArrayList<RightVO>());
            lstDataStoreVOs.add(objUserPageRight);
            
            DataStoreVO objPageConstant = new DataStoreVO();
            objPageConstant.setCname("页面常量");
            objPageConstant.setEname("pageConstantList");
            objPageConstant.setEntityId("");
            objPageConstant.setModelType("pageConstant");
            objPageConstant.setPageConstantList(new ArrayList<PageConstantVO>());
            lstDataStoreVOs.add(objPageConstant);
            
            pageVO.setDataStoreVOList(lstDataStoreVOs);
        }
    }
    
    /**
     * 根据默认引入文件配置初始化引入文件集合
     * 
     * @param pageVO 页面对象
     * @throws OperateException 异常
     */
    private void initIncludeFileList(PageVO pageVO) throws OperateException {
        List<IncludeFileVO> lstDefaultIncludeFileVO = includeFilePreferenceFacade.queryDefaultReferenceFiles();
        List<IncludeFileVO> lstIncludeFileVO = pageVO.getIncludeFileList();
        for (IncludeFileVO objIncludeFileVO : lstIncludeFileVO) {
            if (!lstDefaultIncludeFileVO.contains(objIncludeFileVO) && objIncludeFileVO.getDefaultReference() != true) {
                lstDefaultIncludeFileVO.add(objIncludeFileVO);
            }
        }
        pageVO.setIncludeFileList(lstDefaultIncludeFileVO);
    }
    
    /**
     * 根据默认页面参数配置初始化默认页面参数
     * 
     * @param pageVO 页面对象
     * @throws OperateException 异常
     */
    private void initpageParameterList(PageVO pageVO) throws OperateException {
        List<PageAttributeVO> lstDefaultPageAttributeVO = pageAttributePreferenceFacade
            .queryDefaultReferenceParameters();
        List<PageAttributeVO> lstPageAttributeVO = pageVO.getPageAttributeVOList();
        for (PageAttributeVO objPageAttributeVO : lstPageAttributeVO) {
            if (!lstDefaultPageAttributeVO.contains(objPageAttributeVO) && !objPageAttributeVO.isDefaultReference()) {
                lstDefaultPageAttributeVO.add(objPageAttributeVO);
            }
        }
        pageVO.setPageAttributeVOList(lstDefaultPageAttributeVO);
    }
    
    /**
     * 页面一致性校验
     * 
     * @param pageVO
     *            页面对象
     * @return Map map
     */
    @RemoteMethod
    public Map<String, Object> pageConsistencyCheck(PageVO pageVO) {
        Map<String, Object> map = this.checkConsistency(pageVO);
        return map;
    }
    
    /**
     * 页面被依赖一致性校验
     * 
     * @param lstPageVOs
     *            页面对象
     * @return Map map
     */
    @RemoteMethod
    public Map<String, Object> pageConsistency4BeingDependOn(List<PageVO> lstPageVOs) {
        Map<String, Object> objReult = this.checkConsistency4BeingDependOnBySwatch(lstPageVOs);
        return objReult;
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
     * 递归处理layout对象转换为Map
     * 
     * @param lstLayout 布局对象集合
     * @param pageLayoutVOMap 布局layout的Map集合
     */
    private void wrapperLayout(List<LayoutVO> lstLayout, Map<String, LayoutVO> pageLayoutVOMap) {
        for (int i = 0; i < lstLayout.size(); i++) {
            LayoutVO objLayoutVO = lstLayout.get(i);
            pageLayoutVOMap.put(objLayoutVO.getId(), objLayoutVO);
            if ("layout".equals(objLayoutVO.getType())) {
                wrapperLayout(objLayoutVO.getChildren(), pageLayoutVOMap);
            }
        }
    }
    
    /**
     * 设置页面控件状态VO中的控件名称
     * 
     * @param pageVO 页面对象
     */
    private void setPageComponentStateVO(PageVO pageVO) {
        Map<String, LayoutVO> pageLayoutVOMap = new HashMap<String, LayoutVO>();
        wrapperLayout(pageVO.getLayoutVO().getChildren(), pageLayoutVOMap);
        List<PageComponentExpressionVO> lstPageComponentExpressionVO = pageVO.getPageComponentExpressionVOList();
        for (int i = 0; i < lstPageComponentExpressionVO.size(); i++) {
            List<PageComponentStateVO> lstPageComponentStateVO = lstPageComponentExpressionVO.get(i)
                .getPageComponentStateList();
            List<PageComponentStateVO> lstNewPageComponentStateVO = new ArrayList<PageComponentStateVO>();
            for (int j = 0; j < lstPageComponentStateVO.size(); j++) {
                PageComponentStateVO objPageComponentStateVO = lstPageComponentStateVO.get(j);
                LayoutVO objLayoutVO = pageLayoutVOMap.get(objPageComponentStateVO.getComponentId());
                // 如果objLayoutVO为空则表示页面控件已经被删除
                if (objLayoutVO != null) {
                    objPageComponentStateVO.setCname((String) (objLayoutVO.getOptions().get("label")));
                    // 如果name取出来为null，则ename读取uitype
                    objPageComponentStateVO.setEname((String) (objLayoutVO.getOptions().get("name") == null
                        ? objLayoutVO.getOptions().get("uitype") : objLayoutVO.getOptions().get("name")));
                    lstNewPageComponentStateVO.add(objPageComponentStateVO);
                }
            }
            lstPageComponentExpressionVO.get(i).setPageComponentStateList(lstNewPageComponentStateVO);
        }
    }
    
    /**
     * 验证VO对象
     * 
     * @param pageVO 被校验对象
     * @return 结果集
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public ValidateResult<PageVO> validate(PageVO pageVO) throws OperateException {
        ValidateResult<PageVO> objValidateResult = null;
        // 新增
        if (pageVO.getPageId() == null) {
            boolean bResult = this.isExistNewModelName(pageVO.getModelName());
            if (bResult) {
                Set<ConstraintViolation<PageVO>> objConstraintViolations = new HashSet<ConstraintViolation<PageVO>>();
                ConstraintViolation<PageVO> objConstraintViolation = new ConstraintViolationImpl<PageVO>(null,
                    "页面文件名称重复！", null, null, null, null, null, null, null);
                objConstraintViolations.add(objConstraintViolation);
                objValidateResult = new ValidateResult<PageVO>(objConstraintViolations);
            }
        }
        if (objValidateResult != null) {
            Set<ConstraintViolation<PageVO>> objConstraintViolations = ValidatorUtil.validate(pageVO)
                .getConstraintViolation();
            objValidateResult.getConstraintViolation().addAll(objConstraintViolations);
        } else {
            objValidateResult = ValidatorUtil.validate(pageVO);
        }
        return objValidateResult;
    }
    
    /**
     * 保存
     * 
     * @param pageVO 被保存的对象
     * @return 页面对象
     * @throws ValidateException 校验失败异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public PageVO saveModel(PageVO pageVO) throws ValidateException, OperateException {
        // Map<String,String> map = checkConsistency(pageVO);
        boolean bResult = false;
        if (validate(pageVO).isOK()) {
            setPageMinWidth(pageVO, Boolean.FALSE);
            saveTopPage(pageVO);
            bResult = pageVO.saveModel();
        }
        return bResult ? pageVO : null;
    }
    
    /**
     * 验证VO对象(只检查页面文件名称是否重复)
     * 
     * @param pageVO 被校验对象
     * @return 结果集
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public ValidateResult<PageVO> validateTemp(PageVO pageVO) throws OperateException {
        ValidateResult<PageVO> objValidateResult = null;
        // 新增
        if (pageVO.getPageId() == null) {
            boolean bResult = this.isExistNewModelName(pageVO.getModelName());
            if (bResult) {
                Set<ConstraintViolation<PageVO>> objConstraintViolations = new HashSet<ConstraintViolation<PageVO>>();
                ConstraintViolation<PageVO> objConstraintViolation = new ConstraintViolationImpl<PageVO>(null,
                    "页面文件名称重复！", null, null, null, null, null, null, null);
                objConstraintViolations.add(objConstraintViolation);
                objValidateResult = new ValidateResult<PageVO>(objConstraintViolations);
            }
        }
        return objValidateResult;
    }
    
    /**
     * 保存
     * 
     * @param pageVO 被保存的对象
     * @return 页面对象
     * @throws ValidateException 校验失败异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public PageVO saveTempModel(PageVO pageVO) throws ValidateException, OperateException {
        boolean bResult = false;
        if (validateTemp(pageVO) == null) {
            pageVO.setModelType("pageTemp");
            String strModelId = pageVO.getModelPackage() + "." + pageVO.getModelType() + "." + pageVO.getModelName();
            pageVO.setModelId(strModelId);
            saveTopPage(pageVO);
            bResult = pageVO.saveModel();
        }
        return bResult ? pageVO : null;
    }
    
    /**
     * 新增或更新TOP的fun
     * 
     * @param pageVO 页面对象
     */
    @RemoteMethod
    public void saveTopPage(PageVO pageVO) {
        if (StringUtil.isNotEmpty(pageVO.getParentId())) {
            FuncDTO objParentFuncDTO = funcFacade.getFuncVO(pageVO.getParentId());
            FuncDTO objFuncDTO = new FuncDTO();
            objFuncDTO.setParentFuncId(objParentFuncDTO.getFuncId());
            objFuncDTO.setParentFuncName(objParentFuncDTO.getFuncName());
            objFuncDTO.setParentFuncCode(objParentFuncDTO.getFuncCode());
            objFuncDTO.setFuncNodeType(pageVO.isHasMenu() ? FuncConstants.FUNC_MENU : FuncConstants.FUNC_PAGE);
            objFuncDTO.setPermissionType(objParentFuncDTO.getPermissionType());
            if (pageVO.isHasMenu()) {
                objFuncDTO.setFuncTag(pageVO.getMenuType());
                objFuncDTO.setFuncName(pageVO.getMenuName());
            } else {
                objFuncDTO.setFuncName(pageVO.getCname());
            }
            objFuncDTO.setPermissionType(pageVO.isHasPermission() ? FuncConstants.NEED_ASSIGN_PERMISSTION
                : FuncConstants.OPEN_PERMISSION);
            objFuncDTO.setFuncCode(pageVO.getCode());
            objFuncDTO.setFuncUrl(pageVO.getUrl());
            objFuncDTO.setDescription(pageVO.getDescription());
            objFuncDTO.setStatus(1);
            
            if (StringUtil.isNotEmpty(pageVO.getPageId())) {
                objFuncDTO.setFuncId(pageVO.getPageId());
                FuncDTO objOldFuncVO = funcFacade.getFuncVO(pageVO.getPageId());
                if (objOldFuncVO == null) {
                    funcFacade.saveFuncVO(objFuncDTO);
                } else {
                    funcFacade.updateFuncVO(objFuncDTO);
                }
            } else {
                objFuncDTO.setCreateTime(DateTimeUtil.formatDateTime(new Date()));
                objFuncDTO.setCreatorId(pageVO.getCreaterId());
                String strPageId = funcFacade.saveFuncVO(objFuncDTO);
                pageVO.setPageId(strPageId);
            }
        }
    }
    
    /**
     * 生成SQL脚本文件
     * 
     * @param pageVO
     *            PageVO
     *            生成代码路径
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public void saveTopPageSQL(PageVO pageVO) throws OperateException {
        String codePath = PreferenceConfigQueryUtil.getCodePath();
        
        if (validate(pageVO).isOK()) {
            // 生成当前页面模块的sql脚本
            GenerateSqlFileFactory.getTopFuncSqlFileBestWay().createDataOptSQLfile(pageVO, codePath);
        }
    }
    
    /**
     * 删除模型
     * 
     * @param pageVO 被删除的对象
     * @return 是否删除成功
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean deleteModel(PageVO pageVO) throws OperateException {
        funcFacade.deleteFuncVO(pageVO.getPageId());
        return pageVO.deleteModel();
    }
    
    /**
     * 删除模型
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean deleteModels(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                PageVO objPageVO = (PageVO) PageVO.loadModel(models[i]);
                funcFacade.deleteFuncVO(objPageVO.getPageId());
                PageVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除模型文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 查询当前模块下的页面
     * 
     * @param modelId 模块Id
     * @return 页面对象集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<PageVO> queryPageList(String modelId) throws OperateException {
        CapPackageVO objPackageVO = getPackageVO(modelId);
        String strPackageName = objPackageVO.getFullPath();
        List<PageVO> lstPageVO = CacheOperator.queryList(strPackageName + "/page", PageVO.class);
        return lstPageVO;
    }
    
    /**
     * 查询当前模块下的页面
     * 
     * @param modelId 模块Id
     * @param pageNo pageNo
     * @param pageSize pageSize
     * @return 页面对象集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<PageVO> queryPageList(String modelId, int pageNo, int pageSize) throws OperateException {
        CapPackageVO objPackageVO = getPackageVO(modelId);
        String strPackageName = objPackageVO.getFullPath();
        List<PageVO> lstPageVO = CacheOperator.queryList(strPackageName + "/page", PageVO.class, pageNo, pageSize);
        return lstPageVO;
    }
    
    /**
     * 
     * 测试用例查询界面行为--页面ForTree
     * 
     * @param packageId 包ID
     * @return 查询结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<Map<String, Object>> queryPageListForNode(String packageId) throws OperateException {
        List<Map<String, Object>> lstReturn = new ArrayList<Map<String, Object>>();
        List<PageVO> lstPage = this.queryPageList(packageId);
        for (PageVO pageVO : lstPage) {
            Map<String, Object> objMapPage = new HashMap<String, Object>();
            objMapPage.put("title", pageVO.getCname());
            objMapPage.put("key", pageVO.getModelId());
            objMapPage.put("data", pageVO);
            lstReturn.add(objMapPage);
        }
        return lstReturn;
    }
    
    /**
     * 查询页面集合和依赖的所有对象（只获取可生成代码的页面，非暂存页面）
     * 
     * @param modelPackage 查询当前模块下的页面
     * @return 页面对象集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<PageVO> queryPageListAndAllDepend(String modelPackage) throws OperateException {
        List<PageVO> lstPageVO = CacheOperator.queryList(modelPackage + "/page[state='true']", PageVO.class);
        for (int i = 0; i < lstPageVO.size(); i++) {
            PageVO objPageVO = lstPageVO.get(i);
            lstPageVO.set(i, loadModel(objPageVO.getModelId(), null));
        }
        return lstPageVO;
    }
    
    /**
     * 查询页面集合和依赖的数据集对象
     * 
     * @param packageId 当前模块Id
     * @param modelId 当前页面的modelId
     * @return 页面对象集合
     * @throws OperateException xml操作异常
     */
    @RemoteMethod
    public List<PageVO> queryPageListAndDataStoreVO(String packageId, String modelId) throws OperateException {
        CapPackageVO objPackageVO = getPackageVO(packageId);
        String strPackageName = objPackageVO.getFullPath();
        // 查出本模块下的所有页面
        List<PageVO> lstPageVO = CacheOperator.queryList(strPackageName + "/page", PageVO.class);
        if (lstPageVO == null) {
            return null;
        }
        List<PageVO> lstReturnPageVO = null;
        // 遍历本模块下的所有页面
        for (int i = 0; i < lstPageVO.size(); i++) {
            // 排除自身页面
            if (!lstPageVO.get(i).getModelId().equals(modelId)) {
                setDataStoreVO(lstPageVO.get(i), packageId);
                if (lstReturnPageVO == null) {
                    lstReturnPageVO = new ArrayList<PageVO>();
                }
                lstReturnPageVO.add(lstPageVO.get(i));
            }
        }
        return lstReturnPageVO;
    }
    
    /**
     * 通过包名获取页面模板列表
     * 
     * 
     * @param modelPackage 包名
     * @return 模板列表集合
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<PageVO> queryPageTemplateList(String modelPackage) throws OperateException {
        List<PageVO> lstPageVO = CacheOperator.queryList(modelPackage + "/pageTemp", PageVO.class);
        return lstPageVO;
    }
    
    /**
     * 查询页面权限
     * 
     * @param funcId 父节点ID
     * @return 权限集合
     */
    @RemoteMethod
    public List<FuncDTO> queryRightsVariableList(String funcId) {
        FuncDTO objFuncDTO = new FuncDTO();
        objFuncDTO.setParentFuncId(funcId);
        List<FuncDTO> lstFuncDTO = funcFacade.queryFuncChildByAppId(objFuncDTO);
        return lstFuncDTO;
    }
    
    /**
     * 设置数据集的权限和实体信息
     * 
     * @param pageVO 页面对象
     * @param packageId 包ID
     * @throws OperateException 异常
     */
    private void setDataStoreVO(PageVO pageVO, String packageId) throws OperateException {
        try {
            List<DataStoreVO> lstDataStoreVO = pageVO.getDataStoreVOList();
            for (int i = 0; i < lstDataStoreVO.size(); i++) {
                if ("rightsVariable".equals(lstDataStoreVO.get(i).getModelType())) {
                    iniRight(packageId, lstDataStoreVO.get(i));
                } else if ("list".equals(lstDataStoreVO.get(i).getModelType())
                    || "object".equals(lstDataStoreVO.get(i).getModelType())) {
                    initEntity(lstDataStoreVO.get(i));
                } else if ("pageConstant".equals(lstDataStoreVO.get(i).getModelType())) {
                    iniConstantList(lstDataStoreVO.get(i));
                }
            }
        } catch (Exception e) {
            LOG.error("设置数据集的权限和实体信息错误", e);
            throw new OperateException("设置数据集的权限和实体信息错误", e);
        }
    }
    
    /**
     * 初始化权限集合
     * 
     * @param packageId 包ID
     * @param dataStoreVO 数据集对象
     * @throws IllegalAccessException 异常
     * @throws InvocationTargetException 异常
     */
    private void iniRight(String packageId, DataStoreVO dataStoreVO) throws IllegalAccessException,
        InvocationTargetException {
        
        // if (packageId != null) {
        // FuncDTO objModelFuncDTO = funcFacade.readFuncInModule(packageId);
        // List<RightVO> lstRightVO = dataStoreVO.getVerifyIdList();
        // List<FuncDTO> lstFuncDTO = queryRightsVariableList(objModelFuncDTO.getFuncId());
        // for (int j = 0; j < lstRightVO.size(); j++) {
        // for (int i = 0; i < lstFuncDTO.size(); i++) {
        // if (lstRightVO.get(j).getFuncId().equals(lstFuncDTO.get(i).getFuncId())) {
        // BeanUtils.copyProperties(lstRightVO.get(j), lstFuncDTO.get(i));
        // }
        // }
        // }
        // }
        // 由于系统建模和业务建模冲突，权限需要支持跨模块选择，所以根据functionId去读取
        FuncDTO funcDTO = null;
        Iterator<RightVO> iter = dataStoreVO.getVerifyIdList().iterator();
        while (iter.hasNext()) {
            RightVO rightVO = iter.next();
            funcDTO = funcFacade.readFuncVO(rightVO.getFuncId());
            if (funcDTO != null) {
                BeanUtils.copyProperties(rightVO, funcDTO);
            } else {
                iter.remove();
            }
        }
    }
    
    /**
     * 初始化实体对象
     * 
     * @param dataStoreVO 数据集对象
     */
    private void initEntity(DataStoreVO dataStoreVO) {
        EntityVO objEntityVO = entityFacade.loadEntity(dataStoreVO.getEntityId(), null);
        if (objEntityVO == null) {
            return;
        }
        objEntityVO.setAttributes(entityFacade.getSelfAndParentAttributes(objEntityVO.getModelId()));
        dataStoreVO.setEntityVO(objEntityVO);
        dataStoreVO.setSubEntity(dealRelationEntity(objEntityVO));
    }
    
    /**
     * 处理实体关联属性
     * 
     * @param objEntityVO 实体对象
     * @return 返回实体的所有级联的实体集合
     */
    @RemoteMethod
    public List<EntityVO> dealRelationEntity(EntityVO objEntityVO) {
        List<EntityVO> lstEntityVO = null;
        if (objEntityVO != null) {
            List<EntityAttributeVO> lstEntityAttributeVO = objEntityVO.getAttributes();
            if (!CollectionUtils.isEmpty(lstEntityAttributeVO)) {
                // 遍历所有属性
                for (int i = 0; i < lstEntityAttributeVO.size(); i++) {
                    String relationId = lstEntityAttributeVO.get(i).getRelationId();
                    // 如果属性的关系ID不为空,表示是级联属性
                    if (StringUtil.isNotBlank(relationId)) {
                        // 获取级联属性的终极类型的实体对象
                        String targetEntityId = entityFacade.getEntityCascadeAttrFinalType(lstEntityAttributeVO.get(i));
                        EntityVO _entityVO = entityFacade.loadEntity(targetEntityId, null);
                        if (_entityVO != null) {
                            if (lstEntityVO == null) {
                                lstEntityVO = new ArrayList<EntityVO>();
                            }
                            lstEntityVO.add(_entityVO);
                        }
                    }
                }
            }
        }
        return lstEntityVO;
    }
    
    /**
     * 处理实体关联属性，并封装成map对象
     * 
     * @param objEntityVO 实体对象
     * @return 返回实体的所有级联的实体，并封装成map对象
     */
    @RemoteMethod
    public Map<String, EntityVO> dealRelationEntityToMap(EntityVO objEntityVO) {
        Map<String, EntityVO> objMap = null;
        if (objEntityVO != null) {
            List<EntityAttributeVO> lstEntityAttributeVO = objEntityVO.getAttributes();
            if (!CollectionUtils.isEmpty(lstEntityAttributeVO)) {
                // 遍历所有属性
                for (int i = 0; i < lstEntityAttributeVO.size(); i++) {
                    String relationId = lstEntityAttributeVO.get(i).getRelationId();
                    // 如果属性的关系ID不为空,表示是级联属性
                    if (StringUtil.isNotBlank(relationId)) {
                        // 获取级联属性的终极类型的实体对象
                        String targetEntityId = entityFacade.getEntityCascadeAttrFinalType(lstEntityAttributeVO.get(i));
                        EntityVO _entityVO = entityFacade.loadEntity(targetEntityId, null);
                        if (_entityVO != null) {
                            if (objMap == null) {
                                objMap = new HashMap<String, EntityVO>();
                            }
                            objMap.put(lstEntityAttributeVO.get(i).getEngName(), _entityVO);
                        }
                    }
                }
            }
        }
        return objMap;
    }
    
    /**
     * 初始化常量集合
     * 
     * @param dataStoreVO 数据集对象
     */
    @SuppressWarnings("unchecked")
    private void iniConstantList(DataStoreVO dataStoreVO) {
        List<PageConstantVO> lstPageConstantVO = dataStoreVO.getPageConstantList();
        for (int i = 0; i < lstPageConstantVO.size(); i++) {
            PageConstantVO objPageConstantVO = lstPageConstantVO.get(i);
            // 如果常量为URL类型则更新页面最新数据重新加载
            if ("url".equals(objPageConstantVO.getConstantType())) {
                String strPageModelId = (String) objPageConstantVO.getConstantOption().get("pageModelId");
                PageVO objPageVO = (PageVO) CacheOperator.readById(strPageModelId);
                if (objPageVO != null) {
                    objPageConstantVO.getConstantOption().put("url", objPageVO.getUrl());
                    List<PageAttributeVO> lstPageAttributeVO = objPageVO.getPageAttributeVOList();
                    String strJSON = (String) objPageConstantVO.getConstantOption().get("pageAttributeVOList");
                    List<JSONObject> lstConstantAttributeVO = JSON.parseObject(strJSON, List.class);
                    for (int j = 0; j < lstPageAttributeVO.size(); j++) {
                        PageAttributeVO objPageAttributeVO = lstPageAttributeVO.get(j);
                        for (int k = 0; k < lstConstantAttributeVO.size(); k++) {
                            JSONObject objJSONObject = lstConstantAttributeVO.get(k);
                            PageAttributeVO objConstantAttributeVO = JSON.parseObject(objJSONObject.toJSONString(),
                                PageAttributeVO.class);
                            if (objPageAttributeVO.getAttributeName().equals(objConstantAttributeVO.getAttributeName())) {
                                objPageAttributeVO.setAttributeValue(objConstantAttributeVO.getAttributeValue());
                            }
                        }
                    }
                    objPageConstantVO.setConstantValue("'" + objPageVO.getUrl() + "'"
                        + buildPageAttrString(lstPageAttributeVO));
                    objPageConstantVO.getConstantOption().put("pageAttributeVOList",
                        JSON.toJSONString(lstPageAttributeVO));
                } else {
                    // 如果页面获取不到则情况常量值
                    objPageConstantVO.setConstantValue("");
                    objPageConstantVO.setConstantOption(new CapMap());
                }
            }
        }
    }
    
    /**
     * 根据页面参数生成URL字符串
     * 
     * @param lstPageAttributeVO 页面参数集合
     * @return 页面URL字符串
     */
    private String buildPageAttrString(List<PageAttributeVO> lstPageAttributeVO) {
        String strResult = "";
        for (int i = 0; i < lstPageAttributeVO.size(); i++) {
            String strAttributeValue = lstPageAttributeVO.get(i).getAttributeValue();
            String strAttributeName = lstPageAttributeVO.get(i).getAttributeName();
            if (StringUtil.isNotBlank(strAttributeValue) && StringUtil.isNotBlank(strAttributeName)) {
                if (strAttributeValue.indexOf("@{") != -1) {
                    strAttributeValue = strAttributeValue.replace("@{", "");
                    strAttributeValue = strAttributeValue.replace("}", "");
                    strResult += "+'&" + strAttributeName + "='" + "+" + strAttributeValue;
                } else {
                    strResult += "+'&" + strAttributeName + "=" + strAttributeValue + "'";
                }
            }
        }
        if (!"".equals(strResult)) {
            strResult = "+'?" + strResult.substring(3);
        }
        return strResult;
    }
    
    /**
     * 检查页面文件名称是否已存在（注：只有新增，没有更新操作）
     * 检查所有系统所有应用中是否存在此页面。
     * 
     * @param modelName 文件名称
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistNewModelName(String modelName) throws OperateException {
        return !CollectionUtils.isEmpty(CacheOperator.queryList("/page[modelName='" + modelName + "']", PageVO.class));
    }
    
    /**
     * 
     * 获取本实体及所有父实体的所有属性。
     * 
     * @param modelId 本实体的modelId
     * @return 所有属性的集合（有序的，先放本实体的属性，再放父实体的属性，父实体是从一级父实体往后顺序放置）
     */
    @RemoteMethod
    public List<EntityAttributeVO> getSelfAndParentAttributes(String modelId) {
        return entityFacade.getSelfAndParentAttributes(modelId);
        
    }
    
    /**
     * 读取实体VO
     * 
     * @param entityId 实体ID
     * @return 实体VO
     */
    @RemoteMethod
    public EntityVO readEntity(String entityId) {
        EntityVO objEntityVO = entityFacade.loadEntity(entityId, null);
        objEntityVO.setAttributes(entityFacade.getSelfAndParentAttributes(objEntityVO.getModelId()));
        return objEntityVO;
    }
    
    /**
     * 获取所有引用了实体ID的页面元数据
     * 
     * @param entityId 实体ID
     * @return 页面VO集合
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<PageVO> queryPageListByEntityId(String entityId) throws OperateException {
        List<PageVO> lstPageVO = CacheOperator.queryList("page[dataStoreVOList[entityId='" + entityId + "']]",
            PageVO.class);
        return lstPageVO;
    }
    
    /**
     * 批量复制页面信息并生成sql脚本
     * 
     * @param lstPages 被保存的对象
     * @param codePath 代码路径
     * @return 保存成功记录数
     * @throws OperateException 操作异常
     * @throws ValidateException 校验异常
     */
    @RemoteMethod
    public int saveModelList(List<PageVO> lstPages, String codePath) throws OperateException, ValidateException {
        int iRS = 0;
        for (Iterator<PageVO> iterator = lstPages.iterator(); iterator.hasNext();) {
            PageVO objPageVO = iterator.next();
            String strModelName = objPageVO.getModelName();
            // 封装页面数据
            objPageVO.setPageId(null);
            String strModelId = objPageVO.getModelPackage() + ".page." + strModelName;
            objPageVO.setModelId(strModelId);
            // url的路径
            // String strUrlPath = PageUtil.getPageFilePath(objPageVO.getModelPackage());
            String strPageModelName = strModelName.substring(0, 1).toLowerCase() + strModelName.substring(1);
            // String strURL = strUrlPath + strPageModelName + ".ac";
            // String strURL = PageUtil.getPageURL(objPageVO.getModelPackage(), strModelName);
            // objPageVO.setUrl(strURL);
            String strCurrModel = objPageVO.getModelPackage().replace("com.comtop.", "");
            objPageVO.setCode(strCurrModel.replace(".", "_") + "_" + strPageModelName);
            boolean bResult = false;
            if (validate(objPageVO).isOK()) {
                setPageMinWidth(objPageVO, Boolean.FALSE);
                saveTopPage(objPageVO);
                bResult = objPageVO.saveModel();
            }
            if (bResult) {
                iRS++;
            }
        }
        return iRS;
    }
    
    /**
     * 根据modelId，检测文件是否存在
     * 
     * @param modelId 模型ID
     * @return 是否存在（false： 不存在、true：存在）
     */
    @RemoteMethod
    public boolean isExistPageMetaFile(String modelId) {
        return CacheOperator.readById(modelId) != null ? true : false;
    }
    
    /**
     * 返回值为集合的查询
     * 
     * @param <T> Class
     * @param expression 查询表达式
     * @param clazz 查询结果的类型
     * @return 查询的结果
     * @throws OperateException 操作异常
     */
    public <T extends BaseMetadata> List<T> queryList(String expression, Class<T> clazz) throws OperateException {
        return CacheOperator.queryList(expression, clazz);
    }
    
    /**
     * 通过原型元数据，生成开发建模中的页面元数据
     * 
     * @param ids 原型界面moduleId集合
     * @param pageInfo 需要转换成的页面元数据部分信息
     * @return 处理结果
     * @throws OperateException 原型页面元数据操作异常
     */
    @RemoteMethod
    public String generateDevMeta(List<String> ids, PageVO pageInfo) throws OperateException {
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        
        List<String> failMessage = new ArrayList<String>(ids.size());
        
        for (String id : ids) {
            PrototypeVO prototypeVO = prototypeFacade.loadModel(id, null);
            boolean result = this.generateMetaByPrototype(prototypeVO, pageInfo);
            if (!result && prototypeVO != null) {
                failMessage.add(prototypeVO.getCname() + "生成开发页面元数据失败");
            }
        }
        
        JSONObject jObject = new JSONObject();
        if (failMessage.isEmpty()) {
            jObject.put("result", true);
            jObject.put("msg", "生成成功");
        } else {
            jObject.put("result", false);
            jObject.put("msg", "生成完成，错误信息：");
            jObject.put("details", failMessage);
        }
        
        return jObject.toJSONString();
    }
    
    /**
     * 通过原型元数据，生成开发建模中的页面元数据
     * 
     * @param prototypeVO 原型页面元数据
     * @param pageInfo 需要转换成的页面元数据部分信息
     * @return true 生成成功 false 生成失败
     */
    public boolean generateMetaByPrototype(PrototypeVO prototypeVO, PageVO pageInfo) {
        if (prototypeVO == null || pageInfo == null) {
            return false;
        }
        return true;
    }
}
