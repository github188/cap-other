/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeAppService;
import com.comtop.cap.bm.biz.flow.appservice.BizProcessNodeRoleAppService;
import com.comtop.cap.bm.biz.flow.dao.BizProcessNodeDAO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeRoleVO;
import com.comtop.cap.bm.biz.flow.model.BizProcessNodeVO;
import com.comtop.cap.doc.biz.convert.BizProcessNodeConverter;
import com.comtop.cap.doc.biz.convert.BizRoleConverter;
import com.comtop.cap.doc.biz.model.BizProcessDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.DataIndexManager;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务流程节点 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-16 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizProcessNodeDTO.class)
public class BizProcessNodeDocAppservice extends BizAbstractWordDataAccessor<BizProcessNodeVO, BizProcessNodeDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessNodeAppService bizProcessNodeAppService;
    
    /** 注入流程节点DAO **/
    @PetiteInject
    protected BizProcessNodeDAO bizProcessNodeDAO;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelDocAppservice bizFormNodeRelDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRelationDocAppservice bizRelationDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleDocAppservice bizRoleDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizNodeConstraintDocAppservice bizNodeConstraintDocAppservice;
    
    /** 业务流程 */
    @PetiteInject
    protected BizProcessInfoDocAppservice bizProcessInfoDocAppservice;
    
    /** 节点角色关联 */
    @PetiteInject
    protected BizProcessNodeRoleAppService bizProcessNodeRoleAppService;
    
    /** 同组节点的匹配样式 */
    public static final Pattern GROUP_NODE_PATTERN = Pattern.compile("(.*)[（（\\(](.*)[））\\)]");
    
    @Override
    protected MDBaseAppservice<BizProcessNodeVO> getBaseAppservice() {
        return this.bizProcessNodeAppService;
    }
    
    @Override
    protected void saveBizData(List<BizProcessNodeDTO> collection) {
        if (collection == null || collection.size() == 0) {
            return;
        }
        
        for (BizProcessNodeDTO bizDTO : collection) {
            fillRelationObjectIds(bizDTO);
            saveData(bizDTO);
        }
    }
    
    /**
     * 查找当前对象的ID。
     * 如果能够找到，则直接返回。如果不能够找到，根据参加创建对象再返回id。
     * 本方法提供给关联当前对象的其它对象操作时调用
     * 
     * @param dto 当前对象
     * @return 对象的ID
     */
    @Override
    public String findIdFromRelation(BizProcessNodeDTO dto, DataIndexManager dataIndexManager, String packageId) {
        Matcher matcher = GROUP_NODE_PATTERN.matcher(dto.getName());
        if (matcher.find()) {
            return saveWithGroupFromRelation(matcher, dto);
        }
        return super.findIdFromRelation(dto, dataIndexManager, packageId);
    }
    
    @Override
    protected void fillRelationObjectIds(BizProcessNodeDTO bizDTO) {
        if (bizDTO.isNewData()) {
            String processId = null;
            processId = bizDTO.getProcessId();
            if (StringUtils.isBlank(bizDTO.getProcessName())) {
                importDataCheckLogger.errorBizProcessNodeDTO(bizDTO, "节点既没有上级id也没有上级的uri，数据有误，丢弃。");
            } else {
                BizProcessDTO processDTO = BizProcessNodeConverter.convert2BizProcess(bizDTO, null);
                processId = bizProcessInfoDocAppservice.findIdFromRelation(processDTO);
                bizDTO.setProcessId(processId);
            }
        }
    }
    
    @Override
    public List<BizProcessNodeDTO> loadData(BizProcessNodeDTO condition) {
        if (StringUtils.isBlank(condition.getId())) {
            List<BizProcessNodeDTO> alRet = null;
            // 如果流程id不为空，则以流程id为主要条件进行查询
            if (StringUtils.isNotBlank(condition.getProcessId())) {
                alRet = queryNodeDTOListWithProcessCondition(condition);
            } else {
                alRet = queryDTOList(condition);
            }
            int i = 0;
            for (BizProcessNodeDTO nodeDTO : alRet) {
                // 设置节点关联的角色
                nodeDTO.setSortIndex(++i);
                nodeDTO.setRoles(getNodeRoles(nodeDTO.getId()));
                // 设置节点的标志
                nodeDTO.setNodeFlagMap(BizProcessNodeConverter.convertToNodeFlagMap(nodeDTO.getNodeFlag()));
                // 设置中文的管理层级
                nodeDTO.setCnManageLevel(BizProcessNodeConverter.convertToCnManageLevel(nodeDTO.getManageLevel()));
            }
            return alRet;
        }
        List<BizProcessNodeDTO> alRet = new ArrayList<BizProcessNodeDTO>(1);
        BizProcessNodeVO nodeVO = bizProcessNodeAppService.readById(condition.getId());
        BizProcessNodeDTO nodeDTO = vo2DTO(nodeVO);
        alRet.add(nodeDTO);
        return alRet;
    }
    
    @Override
    protected String saveData(BizProcessNodeDTO dto) {
        Matcher matcher = GROUP_NODE_PATTERN.matcher(dto.getName());
        if (matcher.find()) {
            return saveWithGroup(matcher, dto);
        }
        String id = super.saveData(dto);
        saveRoles(dto.getRoles(), dto.getCnManageLevel(), id);
        return id;
    }
    
    /**
     * 保存组形式的新数据
     *
     * @param matcher 组匹配器
     * @param newDTO 组节点
     * @return groupid
     */
    private String saveWithGroupFromRelation(Matcher matcher, BizProcessNodeDTO newDTO) {
        // 转换为节点集
        List<BizProcessNodeDTO> nodes = BizProcessNodeConverter.convertNodeToNodeList(matcher, newDTO);
        String groupId = null;
        for (BizProcessNodeDTO newOneNodeDTO : nodes) {
            String id = findId(newOneNodeDTO);
            if (StringUtils.isBlank(id)) {
                id = saveNewData(newOneNodeDTO);
                newOneNodeDTO.setId(id);
                addDataIndex(newOneNodeDTO);
            } else {
                newOneNodeDTO.setId(id);
                if (StringUtils.isBlank(groupId)) {
                    groupId = CommonDataManager.getGroupIdByNodeId(id);
                }
            }
        }
        return updateGroupId(nodes, groupId);
    }
    
    /**
     * 保存组形式的新数据
     *
     * @param matcher 组匹配器
     * @param newDTO 组节点
     * @return groupid
     */
    private String saveWithGroup(Matcher matcher, BizProcessNodeDTO newDTO) {
        // 转换为节点集
        List<BizProcessNodeDTO> nodes = BizProcessNodeConverter.convertNodeToNodeList(matcher, newDTO);
        String groupId = null;
        for (BizProcessNodeDTO newOneNodeDTO : nodes) {
            String id = findId(newOneNodeDTO);
            if (StringUtils.isBlank(id)) {
                id = saveNewData(newOneNodeDTO);
                newOneNodeDTO.setId(id);
                addDataIndex(newOneNodeDTO);
            } else {
                newOneNodeDTO.setId(id);
                if (StringUtils.isBlank(groupId)) {
                    groupId = CommonDataManager.getGroupIdByNodeId(id);
                }
                updateData(newOneNodeDTO);
                saveRoles(newOneNodeDTO.getRoles(), newOneNodeDTO.getCnManageLevel(), newOneNodeDTO.getId());
            }
        }
        groupId = updateGroupId(nodes, groupId);
        CommonDataManager.addIdMapping(newDTO.getId(), groupId);
        return groupId;
    }
    
    /**
     * 更新组id
     *
     * @param nodes 节点组
     * @param groupId groupId
     * @return groupId
     */
    private String updateGroupId(List<BizProcessNodeDTO> nodes, String groupId) {
        // 如果所有节点处理完仍然没有找到groupId，则将第一个节点的id作为groupId。
        String strGroupId = groupId;
        if (StringUtils.isBlank(strGroupId)) {
            strGroupId = nodes.get(0).getId();
        }
        // 更新组 groupId
        for (BizProcessNodeDTO bizProcessNodeDTO : nodes) {
            bizProcessNodeAppService.updatePropertyById(bizProcessNodeDTO.getId(), "groupId", strGroupId);
            CommonDataManager.addGroupMapping(bizProcessNodeDTO.getId(), strGroupId);
        }
        return strGroupId;
    }
    
    /**
     * 添加数据索引
     *
     * @param newOneNodeDTO DTO
     */
    private void addDataIndex(BizProcessNodeDTO newOneNodeDTO) {
        DataIndexManager dataIndexManager = CommonDataManager.getCurrentDataIndexManager();
        String dataUri = getUri(newOneNodeDTO);
        dataIndexManager.addDataIndex(BizProcessNodeDTO.class, dataUri, newOneNodeDTO.getId());
    }
    
    /**
     * 保存非group类型的节点数据
     *
     * @param newData 新数据
     * @return 数据id
     */
    @Override
    public String saveNewData(BizProcessNodeDTO newData) {
        newData.setSortNo(generateSortNo("BizProcessNode-SortNo"));
        BizProcessNodeVO vo = dto2VO(newData);
        String id = this.bizProcessNodeAppService.save(vo);
        newData.setId(id);
        // 保存角色及与节点的关联
        saveRoles(newData.getRoles(), newData.getCnManageLevel(), id);
        return id;
    }
    
    @Override
    protected String getUri(BizProcessNodeDTO data) {
        return data.getProcessId() + "-" + StringUtils.trim(data.getName()) + "-"
            + StringUtils.trim(data.getSerialNo());
    }
    
    @Override
    protected BizProcessNodeVO dto2VO(BizProcessNodeDTO data) {
        BizProcessNodeVO bizProcessNodeVO = DocDataUtil.dto2VO(data, BizProcessNodeVO.class);
        // 将节点标识转为字符串形式 参见 setNodeFlagMap方法的注释说明
        Map<String, String> nodeFlagMap = data.getNodeFlagMap();
        String nodeFlag = BizProcessNodeConverter.convertToNodeFlag(nodeFlagMap);
        bizProcessNodeVO.setNodeFlag(nodeFlag);
        // 将中文的管理层级转为code表示的层级
        String manageLevel = BizProcessNodeConverter.convertToManageLevel(data.getManageLevel());
        bizProcessNodeVO.setManageLevel(manageLevel);
        bizProcessNodeVO.setProcessId(data.getProcessId());
        bizProcessNodeVO.setRoleNames(data.getRoles());
        return bizProcessNodeVO;
    }
    
    @Override
    protected BizProcessNodeDTO vo2DTO(BizProcessNodeVO vo) {
        BizProcessNodeDTO nodeDTO = DocDataUtil.vo2DTO(vo, BizProcessNodeDTO.class);
        // 设置节点关联的角色
        nodeDTO.setRoles(getNodeRoles(nodeDTO.getId()));
        // 设置节点的标志
        nodeDTO.setNodeFlagMap(BizProcessNodeConverter.convertToNodeFlagMap(nodeDTO.getNodeFlag()));
        // 设置中文的管理层级
        nodeDTO.setCnManageLevel(BizProcessNodeConverter.convertToCnManageLevel(nodeDTO.getManageLevel()));
        return nodeDTO;
    }
    
    /**
     * 保存节点关联的角色
     *
     * @param rolesInput 角色字符串集合
     * @param bizLevel 业务层级
     * @param nodeId 节点id
     */
    private void saveRoles(String rolesInput, String bizLevel, String nodeId) {
        if (StringUtils.isNotBlank(rolesInput)) {
            WordDocument document = CommonDataManager.getCurrentWordDocument();
            List<BizRoleDTO> roleCollection = BizRoleConverter.convertToRoleList(rolesInput, bizLevel, document);
            // 保存角色数据
            bizRoleDocAppservice.saveData(roleCollection);
            // 组装角色和节点的关联数据
            List<BizProcessNodeRoleVO> nodeRoles = new ArrayList<BizProcessNodeRoleVO>();
            for (BizRoleDTO bizRoleDTO : roleCollection) {
                BizProcessNodeRoleVO bizProcessNodeRoleVO = new BizProcessNodeRoleVO();
                bizProcessNodeRoleVO.setNodeId(nodeId);
                bizProcessNodeRoleVO.setRoleId(bizRoleDTO.getId());
                bizProcessNodeRoleVO.setSortNo(generateSortNo("bizProcessNodeRole-SortNo"));
                nodeRoles.add(bizProcessNodeRoleVO);
            }
            // 保存角色与节点的关联（ 删除已有的关联，建立新的关联）
            bizProcessNodeRoleAppService.updateBizProcessNodeRoleList(nodeRoles, nodeId);
        }
    }
    
    /**
     * 获得节点关联的角色
     *
     * @param nodeId 节点id
     * @return 节点关联的角色字符串
     */
    private String getNodeRoles(String nodeId) {
        List<BizProcessNodeRoleVO> roles = bizProcessNodeRoleAppService.queryBizProcessNodeRolesByNodeId(nodeId);
        return BizRoleConverter.convertToRoles(roles);
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizProcessNodeVO> alData = loadBizProcessNodeNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizProcessNodeVO data : alData) {
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizProcessNode-SortNo", data.getProcessId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizProcessNodeAppService.updatePropertyById(data.getId(), "sortNo", code);
            }
        }
    }
    
    /**
     * 根据条件加载 节点数据
     * 
     * @param bizProcessNodeDTO 业务节点DTO
     *
     * @return 节点数据集 包含 节点名称 、id 所属流程名称 id、业务事项 名称、id等
     */
    public List<BizProcessNodeDTO> queryNodeDTOListWithProcessCondition(BizProcessNodeDTO bizProcessNodeDTO) {
        return bizProcessNodeDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryNodeDTOListWithProcessCondition",
            bizProcessNodeDTO);
    }
    
    /**
     * 根据条件加载 节点数据
     * 
     * @param packageId 包id
     *
     * @return 节点数据集 包含 节点名称 、id 所属流程名称 id、业务事项 名称、id等
     */
    public Map<String, String> queryNodeGroupMap(String packageId) {
        List<BizProcessNodeDTO> nodes = loadDataByPackageId(packageId);
        Map<String, String> groupIndexMap = new HashMap<String, String>();
        for (BizProcessNodeDTO bizProcessNodeDTO : nodes) {
            if (StringUtils.isNotBlank(bizProcessNodeDTO.getGroupId())) {
                groupIndexMap.put(bizProcessNodeDTO.getId(), bizProcessNodeDTO.getGroupId());
            }
        }
        return groupIndexMap;
    }
    
    /**
     * 根据条件加载 节点数据
     * 
     * @param bizProcessNodeDTO 业务节点DTO
     *
     * @return 节点数据集 包含 节点名称 、id 所属流程名称 id、业务事项 名称、id等
     */
    @Override
    public List<BizProcessNodeDTO> queryDTOList(BizProcessNodeDTO bizProcessNodeDTO) {
        return bizProcessNodeDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryNodeDTOListWithProcess",
            bizProcessNodeDTO);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     *
     * @return 数据集
     */
    public List<BizProcessNodeVO> loadBizProcessNodeNotExistCodeOrSortNo() {
        return bizProcessNodeDAO.queryList("com.comtop.cap.bm.biz.flow.model.loadBizProcessNodeNotExistCodeOrSortNo",
            null);
    }
    
    /**
     * 更新流程节点的业务域
     *
     */
    public void updateProcessNodeDomainId() {
        bizProcessNodeDAO.update("com.comtop.cap.bm.biz.flow.model.updateProcessNodeDomainId", null);
    }
    
}
