
package com.comtop.cap.test.preference.action;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.test.preference.facade.TestmodelDicItemFacade;
import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 测试建模字典项Action
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
 * @version 2016年6月27日 章尊志
 */
@DwrProxy
public class TestmodelDicItemAction {
    
    /**
     * facade层 面向接口开发
     * 注入ModuleFacade
     */
    @PetiteInject
    protected TestmodelDicItemFacade testmodelDicItemFacade;
    
    /**
     * <pre>
     * 根据字典分类父获取字典集合
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 字典分类集合
     */
    @RemoteMethod
    public List<TestmodelDicItemVO> queryDicListByClassifyId(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemFacade.queryDicListByClassifyId(testmodelDicItemVO);
        
    }
    
    /**
     * <pre>
     * 根据字典ID获取字典
     * </pre>
     * 
     * @param id 字典分类ID
     * @return 字典分类集合
     */
    @RemoteMethod
    public TestmodelDicItemVO readDicItemVOById(String id) {
        return testmodelDicItemFacade.readDicItemVOById(id);
    }
    
    /**
     * <pre>
     * 根据字典编码获取字典
     * </pre>
     * 
     * @param dictionaryCode 字典分类dictionaryCode
     * @return 字典分类集合
     */
    @RemoteMethod
    public TestmodelDicItemVO readDicItemVOByCode(String dictionaryCode) {
        return testmodelDicItemFacade.readDicItemVOByCode(dictionaryCode);
    }
    
    /**
     * <pre>
     * 更新字典对象
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 成功或失败信息
     */
    @RemoteMethod
    public boolean updateDicItemVO(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemFacade.updateDicItemVO(testmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 新增字典
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 新增后的ID
     */
    @RemoteMethod
    public String insertDicItemVO(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemFacade.insertDicItemVO(testmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 删除字典分类
     * </pre>
     * 
     * @param ids 字典id集合
     * @return 成功或失败信息
     */
    @RemoteMethod
    public boolean deleteDicItemVOById(String[] ids) {
        TestmodelDicItemVO objTestmodelDicItemVO = null;
        List<TestmodelDicItemVO> lstTestmodelDicItemVO = new ArrayList<TestmodelDicItemVO>(ids.length);
        for (int i = 0; i < ids.length; i++) {
            objTestmodelDicItemVO = new TestmodelDicItemVO();
            objTestmodelDicItemVO.setId(ids[i]);
            lstTestmodelDicItemVO.add(objTestmodelDicItemVO);
        }
        return testmodelDicItemFacade.deleteDicItemVOById(lstTestmodelDicItemVO);
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
    @RemoteMethod
    public boolean isExitDicItemCode(TestmodelDicItemVO testmodelDicItemVO) {
        return testmodelDicItemFacade.isExitDicItemCode(testmodelDicItemVO);
    }
    
}
