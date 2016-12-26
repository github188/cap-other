/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * 科目服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
@DocumentService(name = "Course", dataType = CourseVO.class)
public class CourseService {
    
    /** 业务对象 */
    static List<CourseVO> items;
    
    static {
        items = new ArrayList<CourseVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vo
     */
    public List<CourseVO> loadCourseList(CourseVO param) {
        if ("liberal".equals(param.getBranch())) {
            return items.subList(0, 5);
        } else if ("science".equals(param.getBranch())) {
            return items.subList(5, 9);
        }
        return items;
    }
    
    /**
     * 生成数据
     *
     */
    private static void generateData() {
        CourseVO chinese = new CourseVO("语文", "chinese", "liberal");
        CourseVO english = new CourseVO("英语", "english", "liberal");
        CourseVO politics = new CourseVO("政治", "politics", "liberal");
        CourseVO history = new CourseVO("历史", "history", "liberal");
        CourseVO geography = new CourseVO("地理", "geography", "liberal");
        CourseVO math = new CourseVO("数学", "math", "science");
        CourseVO physics = new CourseVO("物理", "physics", "science");
        CourseVO organisms = new CourseVO("生物", "organisms", "science");
        CourseVO chemistry = new CourseVO("化学", "chemistry", "science");
        items.add(chinese);
        items.add(english);
        items.add(politics);
        items.add(history);
        items.add(geography);
        items.add(math);
        items.add(physics);
        items.add(organisms);
        items.add(chemistry);
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveCourseList(List<CourseVO> vos) {
        System.out.println(Arrays.toString(items.toArray()));
    }
}
