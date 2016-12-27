/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.sysmodel.model.FunctionItemVO;
import com.comtop.cap.bm.metadata.sysmodel.utils.CapModuleConstants;
import com.comtop.cap.bm.req.func.facade.ReqFunctionItemFacade;
import com.comtop.cap.bm.req.func.model.ReqFunctionItemVO;
import com.comtop.cap.bm.req.subfunc.facade.ReqFunctionSubitemFacade;
import com.comtop.cap.bm.req.subfunc.model.ReqFunctionSubitemVO;
import com.comtop.cap.doc.hld.model.AppModuleDTO;
import com.comtop.cap.doc.hld.model.PackageDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 应用模块导出门面
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
@PetiteBean
@DocumentService(name = "AppModule", dataType = AppModuleDTO.class)
public class AppModuleFacade extends AbstractExportFacade<AppModuleDTO> {
    
    /** 空的P元素，用于分段 */
    private static final String NULL_P_ELEMENT = "<p/>";
    
    /** 功能项 */
    protected ReqFunctionItemFacade reqFunctionItemFacade = AppBeanUtil.getBean(ReqFunctionItemFacade.class);
    
    /** 功能项 */
    protected ReqFunctionSubitemFacade reqFunctionSubitemFacade = AppBeanUtil.getBean(ReqFunctionSubitemFacade.class);
    
    /** 业务对象缓存 */
    protected final Map<String, ReqFunctionItemVO> funcItemsMap = new HashMap<String, ReqFunctionItemVO>();
    
    /** 业务对象数据项缓存 */
    protected final Map<String, ReqFunctionSubitemVO> funcSubItemsMap = new HashMap<String, ReqFunctionSubitemVO>();
    
    @Override
    public List<AppModuleDTO> loadData(AppModuleDTO condition) {
        funcItemsMap.clear();
        funcSubItemsMap.clear();
        PackageDTO rootPackage = fixPackageTree(condition.getPackageId());
        if (rootPackage == null || rootPackage.getChilds() == null || rootPackage.getChilds().size() == 0) {
            return null;
        }
        // 处理级联的功能（子）项
        setFunctionItem(rootPackage, rootPackage.getChilds());
        List<AppModuleDTO> list = new ArrayList<AppModuleDTO>();
        for (PackageDTO tempPackage : rootPackage.getChilds()) {
            convertAppModule(rootPackage, tempPackage, list);
        }
        return list;
    }
    
    /**
     * 从根节点设置功能项或功能子项
     *
     * @param parentPackage 父节点
     * @param childs 子节点
     */
    private void setFunctionItem(PackageDTO parentPackage, List<PackageDTO> childs) {
        int iCollSize = childs.size();
        for (int i = 0; i < iCollSize; i++) {
            PackageDTO packageDTO = childs.get(i);
            List<FunctionItemVO> lstFunctionItem = packageDTO.getLstFunctionItem();
            lstFunctionItem.addAll(parentPackage.getLstFunctionItem());
            packageDTO.setLstFunctionItem(lstFunctionItem);
            if (CAPCollectionUtils.isNotEmpty(packageDTO.getChilds())) {
                setFunctionItem(packageDTO, packageDTO.getChilds());
            }
        }
    }
    
    /**
     * 获得业务对象
     *
     * @param id id
     * @return 功能项
     */
    protected ReqFunctionItemVO getFuncItem(String id) {
        ReqFunctionItemVO funcItem = funcItemsMap.get(id);
        if (funcItem != null) {
            return funcItem;
        }
        if (funcItemsMap.containsKey(id)) {
            return null;
        }
        try {
            funcItem = reqFunctionItemFacade.queryReqFunctionItemById(id);
            funcItemsMap.put(id, funcItem);
            return funcItem;
        } catch (Throwable e) {
            LOGGER.error("查询功能项时发生异常。当前功能项id=" + id, e);
            return null;
        }
    }
    
    /**
     * 获得业务对象
     *
     * @param id 业务对象id
     * @return 功能子项
     */
    protected ReqFunctionSubitemVO getFuncSubItem(String id) {
        ReqFunctionSubitemVO funcSubItem = funcSubItemsMap.get(id);
        if (funcSubItem != null) {
            return funcSubItem;
        }
        if (funcSubItemsMap.containsKey(id)) {
            return null;
        }
        try {
            funcSubItem = reqFunctionSubitemFacade.loadReqFunctionSubitemById(id);
            funcSubItemsMap.put(id, funcSubItem);
            return funcSubItem;
        } catch (Throwable e) {
            LOGGER.error("查询功能子项时发生异常。当前功能子项id=" + id, e);
            return null;
        }
    }
    
    /**
     * 转换包为AppModule
     * 
     * @param rootPackage 根节点
     *
     * @param packageDTO 包
     * @param list 集合
     */
    private void convertAppModule(final PackageDTO rootPackage, PackageDTO packageDTO, final List<AppModuleDTO> list) {
        List<PackageDTO> childs = packageDTO.getChilds();
        if (packageDTO.getType() == CapModuleConstants.APPLICATION_MODULE_TYPE) {
            // 找到第一个类型层次<=2的上级对象，设置应用模块
            PackageDTO moduleDTO = findPackageLevelLessEqualsThan(packageDTO.getParent(), 2);
            PackageDTO level1Module = null;
            PackageDTO level2Module = null;
            if (moduleDTO != null) {
                if (moduleDTO.getTypeLevel() == 2) {
                    level2Module = moduleDTO;
                    level1Module = moduleDTO.getParent();
                } else {
                    level1Module = moduleDTO;
                }
            }
            
            if (childs == null || childs.size() == 0) {
                // 没有下级应用，只创建一级应用
                AppModuleDTO appModule = createAppModuleDTO(rootPackage, level1Module, level2Module, packageDTO, null);
                list.add(appModule);
            } else {
                // 有下级 ，则以其直接下级为二级应用进行创建
                for (PackageDTO secondLevelAppPackageDTO : childs) {
                    AppModuleDTO appModuleDTO = createAppModuleDTO(rootPackage, level1Module, level2Module, packageDTO,
                        secondLevelAppPackageDTO);
                    list.add(appModuleDTO);
                }
            }
        } else if (childs == null || childs.size() == 0) {
            // 没有下级，表明当前对象是一个模块
            // 找到第一个类型层次<=2的上级对象，设置应用模块
            PackageDTO moduleDTO = findPackageLevelLessEqualsThan(packageDTO, 2);
            PackageDTO level1Module = null;
            PackageDTO level2Module = null;
            if (moduleDTO != null) {
                if (moduleDTO.getTypeLevel() == 2) {
                    level2Module = moduleDTO;
                    level1Module = moduleDTO.getParent();
                } else {
                    level1Module = moduleDTO;
                }
            }
            // 找到二级模块 判断list中是否已经存在该 模块，不存在则 创建 AppModuleDTO 并加入到list中 。
            AppModuleDTO appModuleDTO = createAppModuleDTO(rootPackage, level1Module, level2Module, null, null);
            if (!list.contains(appModuleDTO)) {
                // 添加之前先去重 TODO
                list.add(appModuleDTO);
            }
        } else {
            for (PackageDTO packageDTO2 : childs) {
                convertAppModule(rootPackage, packageDTO2, list);
            }
        }
    }
    
    /**
     * 创建应用模块对象
     *
     * @param root 根
     * @param level1Module 一级模块
     * @param level2Module 二级模块
     * @param level1App 一级应用
     * @param level2App 二级应用
     * @return 应用模块
     */
    private AppModuleDTO createAppModuleDTO(PackageDTO root, PackageDTO level1Module, PackageDTO level2Module,
        PackageDTO level1App, PackageDTO level2App) {
        AppModuleDTO appModuleDTO = new AppModuleDTO();
        appModuleDTO.setRootCode(root.getCode());
        appModuleDTO.setRootId(root.getId());
        appModuleDTO.setRootName(root.getName());
        if (level1Module != null) {
            appModuleDTO.setFirstLevelModuleCode(level1Module.getCode());
            appModuleDTO.setFirstLevelModuleId(level1Module.getId());
            appModuleDTO.setFirstLevelModuleName(level1Module.getName());
            
        }
        if (level2Module != null) {
            appModuleDTO.setSecondLevelModuleCode(level2Module.getCode());
            appModuleDTO.setSecondLevelModuleId(level2Module.getId());
            appModuleDTO.setSecondLevelModuleName(level2Module.getName());
        } else if (level1Module != null) {
            appModuleDTO.setSecondLevelModuleCode(level1Module.getCode());
            appModuleDTO.setSecondLevelModuleId(level1Module.getId());
            appModuleDTO.setSecondLevelModuleName(level1Module.getName());
        }
        if (level1App != null) {
            appModuleDTO.setFirstLevelAppCode(level1App.getCode());
            appModuleDTO.setFirstLevelAppId(level1App.getId());
            appModuleDTO.setFirstLevelAppName(level1App.getName());
        }
        if (level2App != null) {
            appModuleDTO.setSecondLevelAppCode(level2App.getCode());
            appModuleDTO.setSecondLevelAppId(level2App.getId());
            appModuleDTO.setSecondLevelAppName(level2App.getName());
            fillFuncItems(appModuleDTO, level2App.getLstFunctionItem());
        }
        
        // if (StringUtils.isBlank(appModuleDTO.getFuncItemNames())) {
        if (level1App != null) {
            fillFuncItems(appModuleDTO, level1App.getLstFunctionItem());
        } else if (level2Module != null) {
            fillFuncItems(appModuleDTO, level2Module.getLstFunctionItem());
        } else if (level1Module != null) {
            fillFuncItems(appModuleDTO, level1Module.getLstFunctionItem());
        }
        // }
        
        return appModuleDTO;
    }
    
    /**
     * 填充功能项功能了项
     *
     * @param appModuleDTO 应用模块DTO
     * @param funcItems 功能项 功能子项
     */
    private void fillFuncItems(AppModuleDTO appModuleDTO, List<FunctionItemVO> funcItems) {
        if (funcItems == null || funcItems.size() == 0) {
            return;
        }
        StringBuffer sbFuncItem = new StringBuffer();
        StringBuffer sbFuncSubItem = new StringBuffer();
        for (FunctionItemVO functionItemVO : funcItems) {
            if (StringUtils.equals(CapModuleConstants.FUNCTION_ITEM_TYPE, functionItemVO.getItemType())) {
                ReqFunctionItemVO reqFunctionItemVO = getFuncItem(functionItemVO.getItemId());
                if (reqFunctionItemVO != null && sbFuncItem.indexOf(reqFunctionItemVO.getCnName() + NULL_P_ELEMENT) < 0) {
                    sbFuncItem.append(reqFunctionItemVO.getCnName()).append(NULL_P_ELEMENT);
                }
            } else {
                ReqFunctionSubitemVO reqFunctionSubItemVO = getFuncSubItem(functionItemVO.getItemId());
                if (reqFunctionSubItemVO == null) {
                    continue;
                }
                sbFuncSubItem.append(reqFunctionSubItemVO.getCnName()).append(NULL_P_ELEMENT);
                ReqFunctionItemVO reqFunctionItemVO = getFuncItem(reqFunctionSubItemVO.getItemId());
                if (reqFunctionItemVO != null && sbFuncItem.indexOf(reqFunctionItemVO.getCnName() + NULL_P_ELEMENT) < 0) {
                    sbFuncItem.append(reqFunctionItemVO.getCnName()).append(NULL_P_ELEMENT);
                }
            }
        }
        appModuleDTO.setFuncItemNames(sbFuncItem.toString());
        appModuleDTO.setFuncSubItemNames(sbFuncSubItem.toString());
    }
    
    /**
     * 查找层次小于等于指定值的上级
     *
     * @param packageDTO 当前包
     * @param level 层次
     * @return 上级 未找到返回 null
     */
    private PackageDTO findPackageLevelLessEqualsThan(PackageDTO packageDTO, int level) {
        if (packageDTO.getTypeLevel() <= level) {
            return packageDTO;
        }
        PackageDTO parent = packageDTO.getParent();
        if (parent == null) {
            return null;
        }
        return findPackageLevelLessEqualsThan(parent, level);
    }
}
