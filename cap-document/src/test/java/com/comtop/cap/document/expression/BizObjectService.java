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

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.util.ObjectUtils;

/**
 * 业务对象服务
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
@DocumentService(name = "BizObject", dataType = BizObjectVO.class)
public class BizObjectService {
    
    /** 业务对象 */
    static List<BizObjectVO> bizObjects;
    
    static {
        bizObjects = new ArrayList<BizObjectVO>();
        generateData();
    }
    
    /**
     * 根据条件加载VO
     *
     * @param param 条件
     * @return vo
     */
    public List<BizObjectVO> loadBizObjectList(BizObjectVO param) {
        List<BizObjectVO> result = new ArrayList<BizObjectVO>();
        if (param != null && StringUtils.isNotBlank(param.getDomainId())) {
            for (BizObjectVO biz : bizObjects) {
                if (ObjectUtils.nullSafeEquals(biz.getDomainId(), param.getDomainId())) {
                    biz.setDataItems(BizDataItemService.loadBizDataItemListByBizObjectId(biz.getId()));
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
    public void saveBizObjectList(List<BizObjectVO> vos) {
        for (BizObjectVO biz : vos) {
            int index = getIndex(biz);
            if (index == -1) {
                String id = "bizObject_0" + RandomStringUtils.randomNumeric(2);
                biz.setId(id);
                bizObjects.add(biz);
            } else {
                bizObjects.set(index, biz);
            }
            BizDataItemService.saveBizDataItemList(biz.getId(), biz.getDataItems());
        }
        System.out.println(Arrays.toString(bizObjects.toArray()));
    }
    
    /**
     * @param biz 数据
     * @return 索引
     */
    private int getIndex(BizObjectVO biz) {
        for (int index = 0; index < bizObjects.size(); index++) {
            BizObjectVO vo = bizObjects.get(index);
            if (ObjectUtils.nullSafeEquals(vo.getId(), biz.getId())) {
                biz.setId(vo.getId());
                return index;
            }
        }
        return -1;
    }
    
    /**
     * 生成数据
     */
    private static void generateData() {
        String domainId = "domain_1";
        BizObjectVO biz;
        for (int i = 0; i < 10; i++) {
            biz = new BizObjectVO();
            if (i == 5) {
                domainId = "domain_2";
            }
            biz.setDomainId(domainId);
            biz.setId("bizObject_0" + i);
            biz.setCode(RandomStringUtils.randomNumeric(5));
            biz.setName(RandomStringUtils.randomAlphabetic(5));
            biz.setSortNo(i);
            bizObjects.add(biz);
        }
    }
}
