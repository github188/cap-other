/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.api;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.math.RandomUtils;

import com.comtop.cap.bm.metadata.entity.model.AttributeType;
import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cap.test.definition.model.VirtualStep;
import com.comtop.cap.test.design.model.Line;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.robot.RequestData;
import com.comtop.top.core.util.JsonUtil;

/**
 * 抽象的方法用例生成器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月14日 lizhongwen
 */
public abstract class AbstractMethodTestcaseGenerater implements APITestcaseGenerater {
    
    /** 可检查的类型 */
    private static final Set<String> checkedType = new HashSet<String>();
    
    static {
        checkedType.add(AttributeType.DOUBLE.getFullName());
        checkedType.add(AttributeType.FLOAT.getFullName());
        checkedType.add(AttributeType.INT.getFullName());
        checkedType.add(AttributeType.INTEGER.getFullName());
        checkedType.add(AttributeType.JAVA_MATH_BIGDECIMAL.getFullName());
        checkedType.add(AttributeType.LONG.getFullName());
        checkedType.add(AttributeType.SHOT.getFullName());
        checkedType.add(AttributeType.STRING.getFullName());
    }
    
    /**
     * 
     * @see com.comtop.cap.test.design.practice.api.APITestcaseGenerater#genTestcase(com.comtop.cap.test.definition.model.Practice,
     *      com.comtop.cap.test.design.model.TestCase, com.comtop.cap.bm.metadata.entity.model.EntityVO)
     */
    @Override
    public void genTestcase(Practice practice, TestCase testcase, EntityVO entity) {
        if (practice.getSteps() == null || practice.getSteps().isEmpty()) {
            return;
        }
        Map<String, Object> args = this.wrapperArgs(entity);
        this.fixedTestcase(practice, testcase, args);
    }
    
    /**
     * 包装参数
     *
     * @param entity 实体
     * @return 参数
     */
    public abstract Map<String, Object> wrapperArgs(EntityVO entity);
    
    /**
     * 根据参数完善测试用例
     *
     * @param practice 最佳实践
     * @param testcase 测试用例
     * @param args 参数
     */
    public void fixedTestcase(Practice practice, TestCase testcase, Map<String, Object> args) {
        Step step;
        String preStepId = null;
        String currentStepId;
        for (VirtualStep virtual : practice.getSteps()) {
            if (!(virtual instanceof StepReference)) {
                continue;
            }
            StepReference reference = (StepReference) virtual;
            step = new Step();
            currentStepId = RandomStringUtils.randomAlphabetic(12);
            step.setId(currentStepId);
            step.setType(StepType.BASIC);
            step.setName(reference.getName());
            step.setDescription(reference.getDescription());
            step.setReference(reference);
            testcase.addStep(step);
            if (preStepId != null) {
                Line line = new Line();
                line.setForm(preStepId);
                line.setTo(currentStepId);
                testcase.addLine(line);
            }
            preStepId = currentStepId;
            List<Argument> arguments = reference.getArguments();
            if (arguments == null) {
                continue;
            }
            for (Argument argument : arguments) {
                String value = argument.getValue();
                if (value.startsWith("${") && value.endsWith("}")) {
                    String key = value.substring(2, value.length() - 1);
                    if (args.containsKey(key)) {
                        argument.setValue(String.valueOf(args.get(key)));
                    }
                }
            }
        }
    }
    
    /**
     * 生成请求数据的Json字符串
     *
     * @param facadeName 接口类名称
     * @param voName VO名称
     * @param methodName 方法名称
     * @param data 数据
     * @return Json串
     */
    protected String requestDataJson(String facadeName, String voName, String methodName, Map<String, Object> data) {
        RequestData requestData = new RequestData();
        requestData.setClazz(facadeName);
        requestData.setMethodName(methodName);
        requestData.addParam(voName);
        requestData.addData(data);
        return JsonUtil.objectToJson(requestData).replace('"', '\'');
    }
    
    /**
     * 查找实体中的Id属性
     *
     * @param attributes 属性集合
     * @return 返回值
     */
    protected String findIdAttrName(List<EntityAttributeVO> attributes) {
        for (EntityAttributeVO attr : attributes) {
            if (attr.isPrimaryKey()) {
                return attr.getEngName();
            }
        }
        return null;
    }
    
    /**
     * 查找字符串类型的属性
     *
     * @param attributes 属性集合
     * @return 属性名称
     */
    protected String findCheckAttrName(List<EntityAttributeVO> attributes) {
        for (EntityAttributeVO attr : attributes) {
            if (attr.isPrimaryKey()) {
                continue;
            }
            DataTypeVO type = attr.getAttributeType();
            if (type != null && checkedType.contains(type.readDataTypeFullName())) {
                return attr.getEngName();
            }
        }
        return null;
    }
    
    /**
     * 根据实体生成数据
     *
     * @param entity 实体
     * @return 数据
     */
    protected Map<String, Object> genData(EntityVO entity) {
        List<EntityAttributeVO> attributes = entity.getAttributes();
        Map<String, Object> data = new HashMap<String, Object>();
        Object value;
        for (EntityAttributeVO attr : attributes) {
            value = genDataValue(attr.getAttributeType(), attr.getAttributeLength());
            data.put(attr.getEngName(), value);
        }
        return data;
    }
    
    /**
     * 根据数据类型生成测试数据
     *
     * @param dataType 数据类型
     * @param length 字段长度
     * @return 数据
     */
    private Object genDataValue(DataTypeVO dataType, int length) {
        String typeName = dataType.readDataTypeFullName();
        Object data = null;
        if (AttributeType.BOOLEAN.getFullName().equals(typeName)) {
            data = Boolean.TRUE;
        } else if (AttributeType.BYTE.getFullName().equals(typeName)) {
            data = 0;
        } else if (AttributeType.CHAR.getFullName().equals(typeName)) {
            data = ' ';
        } else if (AttributeType.DOUBLE.getFullName().equals(typeName)) {
            data = RandomUtils.nextDouble();
        } else if (AttributeType.FLOAT.getFullName().equals(typeName)) {
            data = RandomUtils.nextFloat();
        } else if (AttributeType.INT.getFullName().equals(typeName)) {
            data = RandomUtils.nextInt();
        } else if (AttributeType.INTEGER.getFullName().equals(typeName)) {
            data = RandomUtils.nextInt();
        } else if (AttributeType.JAVA_MATH_BIGDECIMAL.getFullName().equals(typeName)) {
            data = new BigDecimal(RandomUtils.nextFloat());
        } else if (AttributeType.LONG.getFullName().equals(typeName)) {
            data = RandomUtils.nextLong();
        } else if (AttributeType.SHOT.getFullName().equals(typeName)) {
            data = RandomUtils.nextInt(100);
        } else if (AttributeType.STRING.getFullName().equals(typeName)) {
            int len = length;
            if (len < 0 || len > 12) {
                len = 12;
            }
            data = RandomStringUtils.randomAlphabetic(len);
        } else if (AttributeType.JAVA_SQL_DATE.getFullName().equals(typeName)) {
            data = new Date(System.currentTimeMillis());
        } else if (AttributeType.JAVA_SQL_TIMESTAMP.getFullName().equals(typeName)) {
            data = new Timestamp(System.currentTimeMillis());
        } else if (AttributeType.JAVA_LANG_OBJECT.equals(typeName)) {
            data = null; // TODO
        }
        return data;
    }
    
}
