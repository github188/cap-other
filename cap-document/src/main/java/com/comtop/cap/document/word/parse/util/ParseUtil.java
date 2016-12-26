/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.util;

import java.util.List;

import com.comtop.cap.document.expression.annotation.Function;
import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.document.util.ReflectionHelper;

/**
 * 解析工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月16日 lizhiyong
 */
public class ParseUtil {
    
    /**
     * 根据条件获取集合中的数据
     * 
     * @param list 过滤数据集
     * @param comparator 比较器 类名
     * @param className 元素类型
     * @param conditions 条件，条件表达式格式为：'属性名：值'
     * @return 满足条件的一条数据
     */
    @Function(name = "selectWithComparator")
    public static Object selectWithType(List<Object> list, String comparator, String className, String... conditions) {
        if (list == null) {
            return null;
        }
        IBizDataComparator comparator2;
        try {
            comparator2 = (IBizDataComparator) Class.forName(comparator).newInstance();
            for (Object obj : list) {
                if (comparator2.compare(obj, conditions) == 0) {
                    return obj;
                }
            }
        } catch (InstantiationException e1) {
            e1.printStackTrace();
        } catch (IllegalAccessException e1) {
            e1.printStackTrace();
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
        }
        
        Object template;
        if (className == null) {
            template = CollectionUtils.createElementTemplate(list);
        } else {
            Class<?> elementType;
            try {
                elementType = Class.forName(className);
                template = ReflectionHelper.instance(elementType);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                template = null;
            }
        }
        template = CollectionUtils.fillFields(template, conditions);
        if (template != null) {
            list.add(template);
        }
        return template;
    }
    
}
