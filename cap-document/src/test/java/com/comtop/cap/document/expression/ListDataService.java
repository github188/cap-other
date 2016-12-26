/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * FIXME 类注释信息
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月14日 lizhongwen
 */
@DocumentService(name = "ListData", dataType = ListDataVO.class)
public class ListDataService {
    
    /**
     * 保存
     *
     * @param datas 数据
     */
    public void saveListDataList(List<ListDataVO> datas) {
        System.out.println("saveContentSegList~~~~~~~~~~~~~~~~~~~~~~~~~");
    }
    
    /**
     * 查询数据
     *
     * @param condition 查询条件
     * @return 查询结果
     */
    public List<ListDataVO> loadListDataList(final ListDataVO condition) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        InputStream input = null;
        String content = null;
        try {
            input = loader.getResourceAsStream("data/list.html");
            content = IOUtils.toString(input);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            IOUtils.closeQuietly(input);
        }
        if (StringUtils.isNotBlank(content)) {
            List<ListDataVO> lst = new ArrayList<ListDataVO>();
            lst.add(new ListDataVO(content));
            return lst;
        }
        return null;
    }
}
