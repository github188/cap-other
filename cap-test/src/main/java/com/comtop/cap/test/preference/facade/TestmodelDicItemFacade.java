/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.facade;

import java.util.List;

import com.comtop.cap.test.preference.appservice.TestmodelDicItemAppService;
import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.component.app.session.HttpSessionUtil;
import com.comtop.top.component.common.systeminit.UniTimeInfo;

/**
 * 测试建模字典项管理
 *
 * <pre>
 * [调用关系:
 * 实现接口及父类:
 * 子类:
 * 内部类列表:
 * ]
 * </pre>
 *
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年6月24日 章尊志
 */
@PetiteBean
public class TestmodelDicItemFacade {
    
    /** Service */
    @PetiteInject
    protected TestmodelDicItemAppService testmodelDicItemAppService;
    
    /**
     * <pre>
     * 根据字典分类获取字典集合
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 字典分类集合
     */
    public List<TestmodelDicItemVO> queryDicListByClassifyId(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemAppService.queryDicListByClassifyId(testmodelDicItemVO);
    }
    
    /**
     * 获取字典集合
     * 
     * @return 字典分类集合
     */
    public List<TestmodelDicItemVO> queryDicList() {
        return testmodelDicItemAppService.queryDicList();
    }
    
    /**
     * <pre>
     * 根据字典ID获取字典
     * </pre>
     * 
     * @param id 字典分类ID
     * @return 字典分类集合
     */
    public TestmodelDicItemVO readDicItemVOById(String id) {
        return testmodelDicItemAppService.readDicItemVOById(id);
    }
    
    /**
     * <pre>
     * 根据字典code获取字典
     * </pre>
     * 
     * @param dictionaryCode 字典分类dictionaryCode
     * @return 字典分类集合
     */
    public TestmodelDicItemVO readDicItemVOByCode(String dictionaryCode) {
        return testmodelDicItemAppService.readDicItemVOByCode(dictionaryCode);
    }
    
    /**
     * <pre>
     * 更新字典对象
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 成功或失败信息
     */
    public boolean updateDicItemVO(TestmodelDicItemVO testmodelDicItemVO) {
        testmodelDicItemVO.setModifierId(HttpSessionUtil.getCurUserId());
        testmodelDicItemVO.setUpdateTime(UniTimeInfo.currentTimestamp());
        return testmodelDicItemAppService.updateDicItemVO(testmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 新增字典
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 新增后的ID
     */
    public String insertDicItemVO(TestmodelDicItemVO testmodelDicItemVO) {
        testmodelDicItemVO.setCreatorId(HttpSessionUtil.getCurUserId());
        testmodelDicItemVO.setCreateTime(UniTimeInfo.currentTimestamp());
        return testmodelDicItemAppService.insertDicItemVO(testmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 删除字典分类
     * </pre>
     * 
     * @param lstTestmodelDicItemVO 字典集合
     * @return 成功或失败信息
     */
    public boolean deleteDicItemVOById(List<TestmodelDicItemVO> lstTestmodelDicItemVO) {
        return testmodelDicItemAppService.deleteDicItemVOById(lstTestmodelDicItemVO);
    }
    
    /**
     * 根据ID和分类名称判断是否存在相同的编码
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicItemVO 字典VO
     * @return 分类集合
     */
    public boolean isExitDicItemCode(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemAppService.isExitDicItemCode(testmodelDicItemVO);
    }
}
