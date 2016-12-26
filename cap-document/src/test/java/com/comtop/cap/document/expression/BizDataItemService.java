/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.RandomUtils;

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.util.ObjectUtils;

/**
 * 业务数据项服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
@DocumentService(name = "BizDataItem", dataType = BizDataItemVO.class)
public class BizDataItemService {
    
    /** 业务对象 */
    static List<BizDataItemVO> items;
    
    static {
        items = new ArrayList<BizDataItemVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vo
     */
    public List<BizDataItemVO> loadBizDataItemList(BizDataItemVO param) {
        List<BizDataItemVO> result = new ArrayList<BizDataItemVO>();
        if (param != null && StringUtils.isNotBlank(param.getBizObjId())) {
            for (BizDataItemVO biz : items) {
                if (ObjectUtils.nullSafeEquals(biz.getBizObjId(), param.getBizObjId())) {
                    result.add(biz);
                }
            }
        }
        return result;
    }
    
    /**
     * 根据条件加载VO
     *
     * @param vos 数据
     */
    public void saveBizDataItemList(List<BizDataItemVO> vos) {
        for (BizDataItemVO biz : vos) {
            int index = getIndex(biz);
            if (index == -1) {
                biz.setId(RandomStringUtils.randomAlphabetic(5).toUpperCase());
                items.add(biz);
            } else {
                items.add(index, biz);
            }
        }
        System.out.println(Arrays.toString(items.toArray()));
    }
    
    /**
     * @param biz 数据
     * @return 索引
     */
    private static int getIndex(BizDataItemVO biz) {
        for (int index = 0; index < items.size(); index++) {
            BizDataItemVO vo = items.get(index);
            if (ObjectUtils.nullSafeEquals(vo.getCode(), biz.getCode())) {
                biz.setId(vo.getId());
                return index;
            }
        }
        return -1;
    }
    
    /**
     * @param id 业务对象ID
     * @return 根据业务对象ID获取数据线
     */
    public static List<BizDataItemVO> loadBizDataItemListByBizObjectId(String id) {
        List<BizDataItemVO> arrays = new ArrayList<BizDataItemVO>();
        for (BizDataItemVO item : items) {
            if (ObjectUtils.nullSafeEquals(item.getBizObjId(), id)) {
                arrays.add(item);
            }
        }
        return arrays;
    }
    
    /**
     * @param id 业务对象ID
     * @param arrays 业务对象集合
     */
    public static void saveBizDataItemList(String id, List<BizDataItemVO> arrays) {
        if (arrays == null) {
            return;
        }
        
        for (BizDataItemVO item : arrays) {
            item.setBizObjId(id);
            int index = getIndex(item);
            if (index == -1) {
                item.setId(RandomStringUtils.randomAlphabetic(5).toUpperCase());
                items.add(item);
            } else {
                items.set(index, item);
            }
        }
        System.out.println(Arrays.toString(arrays.toArray()));
    }
    
    /**
     * 生成数据
     */
    private static void generateData() {
        BizDataItemVO biz;
        String bizId;
        for (int i = 0; i < 10; i++) {
            bizId = "bizObject_0" + i;
            int len = RandomUtils.nextInt(10);
            for (int j = 0; j < len; j++) {
                biz = new BizDataItemVO();
                biz.setId(RandomStringUtils.randomAlphabetic(5).toUpperCase());
                biz.setBizObjId(bizId);
                biz.setCode(RandomStringUtils.randomAlphanumeric(4));
                biz.setCodeNote(RandomStringUtils.randomAlphabetic(5));
                biz.setDescription(RandomStringUtils.randomAlphabetic(10));
                biz.setName(RandomStringUtils.randomAlphabetic(10));
                biz.setRemark(RandomStringUtils.randomAlphabetic(5));
                biz.setSortNo(j);
                items.add(biz);
            }
        }
    }
}
