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
 * 简历服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月18日 lizhongwen
 */
@DocumentService(name = "Vitae", dataType = VitaeVO.class)
public class VitaeService {
    
    /** 业务对象 */
    static List<VitaeVO> items;
    
    static {
        items = new ArrayList<VitaeVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vo
     */
    public List<VitaeVO> loadVitaeList(VitaeVO param) {
        
        return items;
    }
    
    /**
     * 生成数据
     *
     */
    private static void generateData() {
        VitaeVO vitae = new VitaeVO();
        vitae.setName("文华");
        vitae.setSchool("电子科技大学");
        vitae.setSex("男");
        vitae.setDegree("本科");
        vitae.setBirthday("1983-9-17");
        vitae.setHeight("175cm");
        vitae.setMajor("计算机科学与技术");
        vitae.setAddress("广东深圳宝安区");
        vitae.setPhone("15817433621");
        vitae.setEmail("baiyunfeiwl@163.com");
        vitae
            .setPhoto("<img src=\"http://10.10.5.223:8090/cap-ftp/UEDITOR/FKQV8ABWQSHRXDKX/BPCLYSFNUSUATMIS.jpg\" width=\"161\" height=\"181\" title=\"BPCLYSFNUSUATMIS.jpg\" alt=\"wenhua.jpg\" style=\"width: 161px; height: 181px;\"/>");
        vitae
            .setOther("<p><a style=\"font-size:12px; color:#0066cc;\" href=\"http://10.10.5.223:8090/cap-ftp/UEDITOR/HHKSK9JQLXTDFVVB/BWLUXUZURNMSJ2T1.xls\" title=\"CAP项目管理情况问卷调查表-第四季度.xls\"><img src=\"http://10.10.5.223:8090/cap-ftp/UEDITOR/S2HGGKWS0469BTKD/CNIAVVBA71M1GDIL.jpg\" width=\"662\" height=\"240\" title=\"bg2.jpg\" style=\"width: 662px; height: 240px;\"/></a></p>");
        items.add(vitae);
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveVitaeList(List<VitaeVO> vos) {
        System.out.println(Arrays.toString(items.toArray()));
    }
}
