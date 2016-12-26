/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.appservice;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.runtime.base.appservice.BaseAppService;
import com.comtop.cip.graph.entity.dao.GraphDAO;
import com.comtop.cip.graph.entity.model.GraphModuleVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.sys.module.appservice.ModuleAppService;

/**
 * 模型实体服务
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-17 陈志伟
 */
@PetiteBean
public class GraphAppService extends BaseAppService {
    
    /** 模型实体DAO */
    @PetiteInject
    protected GraphDAO graphDAO;
    
    /** 模块服务类 */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /**
     * 
     * 读取根模块
     *
     * @return 图形模块实体
     */
    public GraphModuleVO readRootGraphModuleVO() {
        return graphDAO.readRootGraphModuleVO();
    }
    
    /**
     * 
     * 读取图形模块实体
     *
     * @param moduleId 模块ID
     * @return 图形模块实体
     */
    public GraphModuleVO readGraphModuleVO(final String moduleId) {
        return graphDAO.readGraphModuleVO(moduleId);
    }
    
    /**
     * 
     * 查询第三层子模块列表
     *
     * @param moduleId 图形模块实体id
     * @return 图形模块实体
     */
    public GraphModuleVO queryThreeChildrenModuleVOList(final String moduleId) {
        List<GraphModuleVO> lisGraphModuleVO = graphDAO.queryThreeChildrenModuleVOList(moduleId);
        GraphModuleVO objGraphModuleVO = new GraphModuleVO();
        if (lisGraphModuleVO != null && lisGraphModuleVO.size() > 0) {
            // 将第一级的应用放进去
            objGraphModuleVO = lisGraphModuleVO.get(0);
            int inerIndex = 1;
            List<GraphModuleVO> lisInner = new ArrayList<GraphModuleVO>();
            // 将第二级的应用放进去
            for (int i = 1; i < lisGraphModuleVO.size(); i++) {
                GraphModuleVO obj2GraphModuleVO = lisGraphModuleVO.get(i);
                if (objGraphModuleVO.getFullPathIdLength() == (obj2GraphModuleVO.getFullPathIdLength() - 33)) {
                    lisInner.add(obj2GraphModuleVO);
                } else {
                    inerIndex = i;
                    break;
                }
            }
            // 将第三级的应用放进去
            if (lisInner != null && lisInner.size() > 0) {
                for (int i = inerIndex; i < lisGraphModuleVO.size(); i++) {
                    GraphModuleVO obj3GraphModuleVO = lisGraphModuleVO.get(i);
                    for (int j = 0; j < lisInner.size(); j++) {
                        GraphModuleVO obj2GraphModuleVO = lisInner.get(j);
                        if (obj2GraphModuleVO.getInnerModuleVOList() == null) {
                            obj2GraphModuleVO.setInnerModuleVOList(new ArrayList<GraphModuleVO>());
                        }
                        if (obj2GraphModuleVO.getModuleId().equals(obj3GraphModuleVO.getParentModuleId())) {
                            obj2GraphModuleVO.getInnerModuleVOList().add(obj3GraphModuleVO);
                        }
                    }
                    if (obj3GraphModuleVO.getFullPathIdLength() > (lisInner.get(0).getFullPathIdLength() + 33)) {
                        break;
                    }
                }
                
                // 冒泡排序，将最多的放在最前面
                GraphModuleVO temp = lisInner.get(0);
                for (int i = lisInner.size() - 1; i > 0; --i) {
                    for (int j = 0; j < i; ++j) {
                        if (lisInner.get(j + 1).getInnerModuleVOList().size() > lisInner.get(j).getInnerModuleVOList()
                            .size()) {
                            temp = lisInner.get(j);
                            lisInner.set(j, lisInner.get(j + 1));
                            lisInner.set(j + 1, temp);
                        }
                    }
                }
            }
            objGraphModuleVO.setInnerModuleVOList(lisInner);
        } else {
            return null;
        }
        return objGraphModuleVO;
    }
    
}
