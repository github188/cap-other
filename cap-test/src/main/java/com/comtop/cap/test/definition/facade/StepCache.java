/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.facade;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.SerializationUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.CombineStep;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.FixedStep;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.PracticeType;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepGroup;
import com.comtop.cap.test.definition.model.StepGroups;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;

/**
 * 步骤缓存
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月29日 lizhongwen
 */
public final class StepCache {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(StepCache.class);
    
    /** 最佳实践缓存 */
    private final Map<PracticeType, Map<String, Practice>> practiceCache;
    
    /** 步骤分组ID */
    private static final String GROUP_ID = "testStepDefinitions.group.step_groups";
    
    /** 步骤缓存 */
    private final Map<StepType, List<StepGroup>> stepCache;
    
    /** 步骤分组缓存 */
    private StepGroups groupsCache;
    
    /** 缓存实例 */
    private static StepCache instance;
    
    /**
     * 构造函数
     */
    private StepCache() {
        this.stepCache = new HashMap<StepType, List<StepGroup>>();
        this.groupsCache = (StepGroups) CacheOperator.readById(GROUP_ID);
        this.practiceCache = new HashMap<PracticeType, Map<String, Practice>>();
        initStepCache();
        initPracticeCache();
    }
    
    /**
     * 初始化
     * 
     */
    private void initStepCache() {
        try {
            // 添加基本类型步骤
            List<BasicStep> basics = CacheOperator.queryList(StepType.BASIC.getType(), BasicStep.class);
            if (basics != null) {
                for (BasicStep basic : basics) {
                    this.updateStepDefinition(basic);
                }
            }
            // 添加固定组合步骤
            List<FixedStep> fixeds = CacheOperator.queryList(StepType.FIXED.getType(), FixedStep.class);
            if (fixeds != null) {
                for (FixedStep fixed : fixeds) {
                    this.updateStepReference(fixed);
                    this.updateStepDefinition(fixed);
                }
            }
            // 添加动态组合步骤
            List<DynamicStep> dynamics = CacheOperator.queryList(StepType.DYNAMIC.getType(), DynamicStep.class);
            if (dynamics != null) {
                for (DynamicStep dynamic : dynamics) {
                    this.updateStepReference(dynamic);
                    this.updateStepDefinition(dynamic);
                }
            }
        } catch (OperateException e) {
            logger.error("测试步骤缓存初始化失败", e);
        }
    }
    
    /**
     * 初始化最佳实践缓存
     */
    private void initPracticeCache() {
        try {
            // 添加基本类型步骤
            List<Practice> practices = CacheOperator.queryList(StepType.PRACTICE.getType(), Practice.class);
            if (practices != null) {
                for (Practice practice : practices) {
                    this.cachePractice(practice);
                }
            }
        } catch (OperateException e) {
            logger.error("最佳实践缓存初始化失败", e);
        }
    }
    
    /**
     * 更新组合步骤中的引用
     *
     * @param combine 组合步骤
     */
    private void updateStepReference(CombineStep combine) {
        if (combine == null) {
            return;
        }
        if (combine.getSteps() == null || combine.getSteps().isEmpty()) {
            return;
        }
        List<StepReference> refs = combine.getSteps();
        for (StepReference ref : refs) {
            String type = ref.getType();
            StepDefinition step = (StepDefinition) CacheOperator.readById(type);
            if (step == null) {
                continue;
            }
            ref.setName(step.getName());
            ref.setIcon(step.getIcon());
        }
    }
    
    /**
     * @return 获取缓存实例
     */
    public static StepCache getInstance() {
        if (instance == null) {
            synchronized (StepCache.class) {
                instance = new StepCache();
            }
        }
        return instance;
    }
    
    /**
     * 缓存最佳实践
     *
     * @param practice 最佳实践
     */
    private void cachePractice(Practice practice) {
        PracticeType type = practice.getPracticeType();
        Map<String, Practice> practices = practiceCache.get(type);
        if (practices == null) {
            practices = new HashMap<String, Practice>();
            practiceCache.put(type, practices);
        }
        practices.put(practice.getModelId(), practice);
    }
    
    /**
     * 根据Id获取最佳实践
     *
     * @param id 最佳实践Id
     * @return 最佳实践
     */
    public Practice loadPracticeById(String id) {
        Practice ret = null;
        for (Map<String, Practice> practices : practiceCache.values()) {
            if (practices != null) {
                ret = practices.get(id);
                if (ret != null) {
                    Practice clone = null;
                    try {
                        clone = (Practice) SerializationUtils.clone(ret);
                    } catch (Exception e) {
                        logger.debug("元数据复制失败", e);
                    }
                    return clone;
                }
            }
        }
        return ret;
    }
    
    /**
     * 根据类型获取最佳实践集合
     *
     * @param type 最佳实践类型
     * @return 最佳实践集合
     */
    public Collection<Practice> loadPracticeByType(PracticeType type) {
        Map<String, Practice> practices = practiceCache.get(type);
        return practices == null ? null : practices.values();
    }
    
    /**
     * 获取所有最佳实践
     *
     * @return 最佳实践集合
     */
    public Map<PracticeType, Map<String, List<Practice>>> loadPractices() {
        Map<PracticeType, Map<String, List<Practice>>> practiceMap = new HashMap<PracticeType, Map<String, List<Practice>>>();
        for (Entry<PracticeType, Map<String, Practice>> entry : practiceCache.entrySet()) {
            PracticeType type = entry.getKey();
            Map<String, List<Practice>> mappinged = practiceMap.get(type);
            if (mappinged == null) {
                mappinged = new HashMap<String, List<Practice>>();
                practiceMap.put(type, mappinged);
            }
            for (Practice practice : entry.getValue().values()) {
                String mapping = practice.getMapping();
                List<Practice> practices = mappinged.get(mapping);
                if (practices == null) {
                    practices = new LinkedList<Practice>();
                    mappinged.put(mapping, practices);
                }
                practices.add(practice);
            }
        }
        return practiceMap;
    }
    
    /**
     * 更新步骤分组缓存
     * 
     * @param group 更新分组
     * @return 是否更新成功
     */
    public boolean updateGroupCache(StepGroup group) {
        if (this.groupsCache == null) {
            this.groupsCache = (StepGroups) CacheOperator.readById(GROUP_ID);
        }
        if (groupsCache == null) {
            groupsCache = new StepGroups();
        }
        groupsCache.addGroup(group);
        updateStepCacheGroup(group);
        return CacheOperator.save(groupsCache);
    }
    
    /**
     * 更新步骤缓存中的步骤分组
     *
     * @param group 步骤分组
     */
    private void updateStepCacheGroup(StepGroup group) {
        if (this.stepCache == null) {
            return;
        }
        for (List<StepGroup> groups : this.stepCache.values()) {
            if (groups == null || groups.isEmpty()) {
                continue;
            }
            for (StepGroup existed : groups) {
                if (existed != null && existed.getCode().equals(group.getCode())) {
                    existed.setName(group.getName());
                    existed.setIcon(group.getIcon());
                }
            }
        }
    }
    
    /**
     * 删除步骤分组缓存
     * 
     * @param codes 分组编码
     * @return 是否更新成功
     */
    public boolean removeGroupCache(String... codes) {
        if (this.groupsCache == null) {
            this.groupsCache = (StepGroups) CacheOperator.readById(GROUP_ID);
        }
        if (groupsCache == null) {
            return true;
        }
        for (String code : codes) {
            groupsCache.removeGroup(code);
        }
        return CacheOperator.save(groupsCache);
    }
    
    /**
     * @return 获取步骤分组
     */
    public StepGroups getStepGroups() {
        return this.groupsCache;
    }
    
    /**
     * @param step 添加步骤
     */
    public void updateStepDefinition(StepDefinition step) {
        StepGroup group = findStepGroup(step);
        group.addStep(step);
    }
    
    /**
     * @param step 添加步骤
     */
    public void removeStepDefinition(StepDefinition step) {
        StepGroup group = findStepGroup(step);
        group.removeStep(step);
    }
    
    /**
     * @param code 分组编码
     * @return 是否含有步骤
     */
    public boolean isGroupHasStep(String code) {
        if (this.stepCache == null) {
            return false;
        }
        for (List<StepGroup> groups : this.stepCache.values()) {
            if (groups == null || groups.isEmpty()) {
                continue;
            }
            for (StepGroup group : groups) {
                if (group != null && code.equals(group.getCode()) && group.getSteps() != null
                    && !group.getSteps().isEmpty()) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * 查找步骤所在分组
     *
     * @param step 步骤
     * @return 分组
     */
    private StepGroup findStepGroup(StepDefinition step) {
        StepGroup group = null;
        StepType type = step.getStepType();
        List<StepGroup> groups = this.stepCache.get(type);
        if (groups == null) {
            groups = new LinkedList<StepGroup>();
            this.stepCache.put(type, groups);
        }
        String code = step.getGroup();
        for (StepGroup stepGroup : groups) {
            if (code.equals(stepGroup.getCode())) {
                group = stepGroup;
                break;
            }
        }
        if (group == null) {
            group = this.groupsCache.findGroupByCode(code);
            StepGroup clone = null;
            try {
                clone = (StepGroup) SerializationUtils.clone(group);
            } catch (Exception e) {
                logger.debug("元数据复制失败", e);
            }
            if (clone == null) {
                return null;
            }
            clone.setSteps(null);
            groups.add(clone);
            return clone;
        }
        return group;
    }
    
    /**
     * @return 获取所有测试步骤
     */
    public Map<StepType, List<StepGroup>> loadAllSteps() {
        return this.stepCache;
    }
    
    /**
     * @param type 根据类型获取测试步骤
     * @return 测试步骤集合
     */
    public List<StepGroup> loadStepsByType(StepType type) {
        return this.stepCache.get(type);
    }
    
}
