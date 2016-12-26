
package com.comtop.cap.test.preference.appservice;

import java.util.List;

import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.dao.CoreDAO;

/**
 * 测试建模字典项appservice
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
@PetiteBean
public class TestmodelDicItemAppService {
    
    /**
     * 注入 commonDAO
     */
    @PetiteInject
    protected CoreDAO<TestmodelDicItemVO> coreDAO;
    
    /**
     * <pre>
     * 根据字典分类父获取字典集合
     * </pre>
     * 
     * @param testmodelDicItemVO 字典对象
     * @return 字典分类集合
     */
    public List<TestmodelDicItemVO> queryDicListByClassifyId(TestmodelDicItemVO testmodelDicItemVO) {
        return coreDAO.queryList("com.comtop.cap.test.preference.model.queryDicListByClassifyId", testmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 根据字典分类父获取字典集合
     * </pre>
     * 
     * @return 字典分类集合
     */
    public List<TestmodelDicItemVO> queryDicList() {
        return coreDAO.queryList("com.comtop.cap.test.preference.model.queryDicList", null);
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
        TestmodelDicItemVO objTestmodelDicItemVO = new TestmodelDicItemVO();
        objTestmodelDicItemVO.setId(id);
        return coreDAO.load(objTestmodelDicItemVO);
    }
    
    /**
     * <pre>
     * 根据字典ID获取字典
     * </pre>
     * 
     * @param dictionaryCode 字典分类dictionaryCode
     * @return 字典分类集合
     */
    public TestmodelDicItemVO readDicItemVOByCode(String dictionaryCode) {
        return (TestmodelDicItemVO) coreDAO.selectOne("com.comtop.cap.test.preference.model.readDicItemVOByCode",
            dictionaryCode);
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
        return coreDAO.update(testmodelDicItemVO);
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
        return (String) coreDAO.insert(testmodelDicItemVO);
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
        coreDAO.delete(lstTestmodelDicItemVO);
        return true;
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
        int iCount = (Integer) coreDAO.selectOne("com.comtop.cap.test.preference.model.isExitDicItemCode",
            testmodelDicItemVO);
        return iCount > 0 ? true : false;
    }
    
}
