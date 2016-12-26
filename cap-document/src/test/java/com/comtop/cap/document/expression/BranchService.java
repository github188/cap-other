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
 * 分科服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
@DocumentService(name = "Branch", dataType = BranchVO.class)
public class BranchService {
    
    /** 业务对象 */
    static List<BranchVO> items;
    
    static {
        items = new ArrayList<BranchVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vo
     */
    public List<BranchVO> loadBranchList(BranchVO param) {
        return items;
    }
    
    /**
     * 生成数据
     *
     */
    private static void generateData() {
        BranchVO liberal = new BranchVO("文科", "liberal");
        BranchVO science = new BranchVO("理科", "science");
        items.add(liberal);
        items.add(science);
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveBranchList(List<BranchVO> vos) {
        System.out.println(Arrays.toString(items.toArray()));
    }
}
