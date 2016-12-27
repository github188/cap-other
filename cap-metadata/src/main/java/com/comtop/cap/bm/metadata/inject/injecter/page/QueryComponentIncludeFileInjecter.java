/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.inject.injecter.util.MetadataInjectProvider;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.model.EditAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.FormAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.QueryAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.RowFromFormAreaVO;
import com.comtop.cap.bm.metadata.page.template.model.WrapperFtlPageCommon;
import com.comtop.cip.json.JSONArray;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;

/**
 * 引入文件数据封装
 *
 * @author 肖威
 * @since jdk1.6
 * @version 2016年1月7日 肖威
 */
public class QueryComponentIncludeFileInjecter implements IMetaDataInjecter {
    
    /** 日志 */
    protected final static Logger LOG = LoggerFactory.getLogger(QueryComponentIncludeFileInjecter.class);
    
    /**
     * 左对齐
     */
    private static String LEFT_ALIGN = "left";
    
    /**
     * 右对齐
     */
    private static String RIGHT_ALIGN = "right";
    
    /**
     * 页面基础信息封装
     */
    @Override
    public void inject(Object obj, Object source) {
        MetadataGenerateVO objMetadataGenerate = (MetadataGenerateVO) obj;
        List<QueryAreaComponentVO> lstQueryAreaComponentVO;
        try {
            lstQueryAreaComponentVO = MetadataInjectProvider.queryList(objMetadataGenerate,
                "metadataValue/queryComponentList", QueryAreaComponentVO.class);
            // 循环封装查询区域
            for (Iterator<QueryAreaComponentVO> iterator = lstQueryAreaComponentVO.iterator(); iterator.hasNext();) {
                QueryAreaComponentVO queryAreaComponentVO = iterator.next();
                String strEntityId = queryAreaComponentVO.getEntityId();
                String strEntityAlias = queryAreaComponentVO.getEntityAlias();
                PageVO page = (PageVO) source;
                boolean isInclude = this.isIncludeQueryArea(page, queryAreaComponentVO, null);
                if (isInclude) {
                    this.wrapperFixedQueryArea(page, queryAreaComponentVO.getFixedQueryAreaList(), strEntityId,
                        strEntityAlias);
                    this.wrapperFixedQueryArea(page, queryAreaComponentVO.getMoreQueryAreaList(), strEntityId,
                        strEntityAlias);
                }
            }
            List<EditAreaComponentVO> lstEditAreaComponentVO = MetadataInjectProvider.queryList(objMetadataGenerate,
                "metadataValue/editComponentList", EditAreaComponentVO.class);
            for (Iterator<EditAreaComponentVO> iterator = lstEditAreaComponentVO.iterator(); iterator.hasNext();) {
                EditAreaComponentVO editAreaComponentVO = iterator.next();
                String strEntityId = editAreaComponentVO.getEntityId();
                PageVO page = (PageVO) source;
                boolean isInclude = this.isIncludeQueryArea(page, null, editAreaComponentVO);
                if (isInclude) {
                    this.wrapperFixedQueryArea(page, editAreaComponentVO.getFormAreaList(), strEntityId,
                        editAreaComponentVO.getEntityAlias());
                }
            }
        } catch (OperateException e) {
            LOG.error("封装快速表单区域异常", e);
        }
    }
    
    /**
     * 判断当前页面VO中是否包含当前查询区域
     * 
     * @param page 页面对象
     * @param queryAreaComponentVO 查询区域
     * @param editAreaComponentVO 编辑区域
     * @return 判断结果
     */
    private boolean isIncludeQueryArea(PageVO page, QueryAreaComponentVO queryAreaComponentVO,
        EditAreaComponentVO editAreaComponentVO) {
        if (page != null) {
            List<FormAreaComponentVO> lstQueryAreas = new ArrayList<FormAreaComponentVO>();
            if (queryAreaComponentVO != null) {
                List<FormAreaComponentVO> lstFixed = queryAreaComponentVO.getFixedQueryAreaList();
                List<FormAreaComponentVO> lstMore = queryAreaComponentVO.getMoreQueryAreaList();
                lstQueryAreas.addAll(lstFixed);
                lstQueryAreas.addAll(lstMore);
            }
            if (editAreaComponentVO != null) {
                List<FormAreaComponentVO> lstEdit = editAreaComponentVO.getFormAreaList();
                lstQueryAreas.addAll(lstEdit);
            }
            for (Iterator<FormAreaComponentVO> iterator = lstQueryAreas.iterator(); iterator.hasNext();) {
                FormAreaComponentVO formAreaComponentVO = iterator.next();
                String strAreaId = formAreaComponentVO.getAreaId();
                String strArea = formAreaComponentVO.getArea();
                List<LayoutVO> lstLayOuts = this.getReplaceForm(page, strArea, strAreaId);
                if (lstLayOuts != null && lstLayOuts.size() > 0) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * 获取需要替换的快速表单区域
     * 
     * @param page 页面
     * @param area 区域code
     * @param areaId 区域ID
     * @return List<LayoutVO> 表单区域集合
     */
    private List<LayoutVO> getReplaceForm(PageVO page, String area, String areaId) {
        // 获取快速表单
        List<LayoutVO> lstLayOutIncludeAreas = new ArrayList<LayoutVO>();
        try {
            String expression = "./layoutVO//children[options[@area='" + area + "']]";
            List<LayoutVO> lstLayOuts = page.queryList(expression, LayoutVO.class);
            lstLayOutIncludeAreas.addAll(lstLayOuts);
            for (Iterator<LayoutVO> iterator = lstLayOuts.iterator(); iterator.hasNext();) {
                LayoutVO layoutVO = iterator.next();
                String strAreaId = (String) layoutVO.getOptions().get("areaId");
                if (StringUtil.isNotBlank(areaId)) {
                    if (!StringUtil.equals(strAreaId, areaId)) {
                        lstLayOutIncludeAreas.remove(layoutVO);
                    }
                } else {
                    if (StringUtil.isNotBlank(strAreaId)) {
                        lstLayOutIncludeAreas.remove(layoutVO);
                    }
                }
            }
        } catch (OperateException e) {
            // 报异常
            LOG.error("获取待封装快速表单异常", e);
        }
        return lstLayOutIncludeAreas;
    }
    
    /**
     * 封装固定查询区域信息
     * 
     * @param page 页面对象
     * @param lstFixedQueryArea 固定查询区域列表
     * @param entityId 绑定实体Id
     * @param entityAlias 实体别名
     * @return 封装操作结果
     */
    private boolean wrapperFixedQueryArea(PageVO page, List<FormAreaComponentVO> lstFixedQueryArea, String entityId,
        String entityAlias) {
        if (lstFixedQueryArea == null) {
            return true;
        }
        for (Iterator<FormAreaComponentVO> iterator = lstFixedQueryArea.iterator(); iterator.hasNext();) {
            FormAreaComponentVO formAreaComponentVO = iterator.next();
            String strAreaId = formAreaComponentVO.getAreaId();
            String strArea = formAreaComponentVO.getArea();
            // 获取快速表单
            List<LayoutVO> lstLayOuts = this.getReplaceForm(page, strArea, strAreaId);
            if (lstLayOuts == null) {
                return true;
            }
            for (int i = 0; i < lstLayOuts.size(); i++) {
                LayoutVO layoutVO = lstLayOuts.get(i);
                layoutVO = this.wrapperFormLayout(page, layoutVO, formAreaComponentVO, entityId, entityAlias);
            }
            
        }
        return false;
    }
    
    /**
     * 封装快速表单
     * 
     * @param page 页面对象
     * @param layoutVO 当前快速表单布局对象
     * @param formAreaComponentVO 表单区域更新信息
     * @param entityId 绑定实体Id
     * @param entityAlias 实体别名
     * @return layoutVO 返回快速表单布局对象
     */
    private LayoutVO wrapperFormLayout(PageVO page, LayoutVO layoutVO, FormAreaComponentVO formAreaComponentVO,
        String entityId, String entityAlias) {
        int intCol = formAreaComponentVO.getCol() != null ? formAreaComponentVO.getCol() : NumberConstant.ONE;
        List<RowFromFormAreaVO> lstComponents = formAreaComponentVO.getRowList();
        if (lstComponents == null || lstComponents.size() == 0) {
            return layoutVO;
        }
        String strEntityName = this.getEntityEname(page, lstComponents.get(0));
        // 计算行数
        int iTrNum = WrapperFtlPageCommon.getTrNum(lstComponents, intCol);
        // 控件总数
        int iQueryConditions = lstComponents.size();
        // 已封装控件数
        int iConditions = 0;
        // 快速表单children信息
        JSONArray jsonTableChildren = new JSONArray();
        // 循环封装tr数据
        List<LayoutVO> lstWrapperTrs = getBlankTRList(iTrNum);
        for (Iterator<LayoutVO> iterator = lstWrapperTrs.iterator(); iterator.hasNext();) {
            LayoutVO trLayout = iterator.next();
            int iCols = 0;
            // 循环封装控件
            List<LayoutVO> lstWrapperTrChildrens = new ArrayList<LayoutVO>();
            for (int k = iConditions; k < iQueryConditions; k++) {
                RowFromFormAreaVO objRowFromFormAreaVO = lstComponents.get(k);
                // 当前控件跨列列数
                int iColspan = objRowFromFormAreaVO.getColspan();
                // 当前行满足控件所需列数
                double iColTotal = iCols + iColspan;
                if (iColTotal > intCol) {
                    iConditions = k;
                    // 空的单元格信息
                    int iBlankNum = (intCol - iCols) * 2;
                    this.wrapperBlankTD(lstWrapperTrChildrens, iBlankNum);
                    break;
                }
                // Label控件所在单元格
                LayoutVO tdVO = this.getStorageComponentTDLayout(intCol * 2, NumberConstant.ZERO, LEFT_ALIGN);
                // Label控件封装
                LayoutVO labelVO = this.getComponentLayout(objRowFromFormAreaVO, null, entityAlias);
                tdVO.getChildren().add(labelVO);
                lstWrapperTrChildrens.add(tdVO);
                
                // 编辑控件封装
                LayoutVO componentTdVO = this.getStorageComponentTDLayout(intCol * 2, (iColspan == 0 ? 1
                    : (2 * iColspan - 1)), RIGHT_ALIGN);
                LayoutVO componentVO = this.getComponentLayout(objRowFromFormAreaVO, strEntityName, entityAlias);
                // 判断当前控件是否进行必填校验，对label控件进行增加必填提示
                boolean isRequired = IsRequiredComponentValidate(objRowFromFormAreaVO.getOptions());
                if (isRequired) {
                    CapMap labelOptions = labelVO.getOptions();
                    labelOptions.put("isReddot", "true");
                }
                componentTdVO.getChildren().add(componentVO);
                lstWrapperTrChildrens.add(componentTdVO);
                
                JSONArray jsonCompentInfo = new JSONArray();
                jsonCompentInfo.add(componentVO.getId());
                jsonCompentInfo.add(labelVO.getId());
                jsonTableChildren.add(jsonCompentInfo);
                // 最后一行如果列不够，则用空列补充
                if (!iterator.hasNext() && iConditions == iQueryConditions - 1 && intCol - iColTotal > 0) {
                    int iBlankNum = (int) ((intCol - iColTotal) * 2);
                    this.wrapperBlankTD(lstWrapperTrChildrens, iBlankNum);
                }
                // 控制当前行数据是否组装完成，跳出td数据封装循环
                iConditions += 1;
                iCols += iColspan;
                if (intCol == iCols) {
                    iConditions = (k + 1);
                    break;
                }
            }
            trLayout.setChildren(lstWrapperTrChildrens);
        }
        
        layoutVO.setChildren(lstWrapperTrs);
        // 更新options信息
        CapMap mapOptions = layoutVO.getOptions();
        Map<String, Object> objUpdateInfo = new HashMap<String, Object>();
        objUpdateInfo.put("col", formAreaComponentVO.getCol().intValue());
        objUpdateInfo.put("objectId", entityId);
        objUpdateInfo.put("children", jsonTableChildren.toString());
        mapOptions.putAll(objUpdateInfo);
        // 表格控件信息
        layoutVO.setOptions(mapOptions);
        return layoutVO;
    }
    
    /**
     * 获取当前快速表单绑定的实体英文名称
     * 
     * @param page 页面对象
     * @param rowFromFormAreaVO 当前表单一行对象
     * @return 实体英文名称
     */
    private String getEntityEname(PageVO page, RowFromFormAreaVO rowFromFormAreaVO) {
        CapMap componentOptions = rowFromFormAreaVO.getOptions();
        String strDatabind = (String) componentOptions.get("databind");
        String strAlias = strDatabind.substring(0, strDatabind.lastIndexOf("."));
        List<DataStoreVO> lstDataStores = page.getDataStoreVOList();
        for (Iterator<DataStoreVO> iterator = lstDataStores.iterator(); iterator.hasNext();) {
            DataStoreVO dataStoreVO = iterator.next();
            String strDataAlias = dataStoreVO.getAlias();
            // 实体必须为object对象
            String strModeType = dataStoreVO.getModelType();
            if (StringUtil.equals(strModeType, "object") && StringUtil.equals(strAlias, strDataAlias)) {
                return dataStoreVO.getEname();
            }
        }
        return "";
    }
    
    /**
     * 封装当前行中空白单元格信息
     * 
     * @param lstchildren 当前行children集合
     * @param blankNum 空白单元格数量
     */
    private void wrapperBlankTD(List<LayoutVO> lstchildren, int blankNum) {
        if (blankNum > 0) {
            for (int i = 0; i < blankNum; i++) {
                lstchildren.add(getBlankTDLayOut());
            }
        }
    }
    
    /**
     * 封装快速表单行控件集合方法
     * 
     * @param iTrNum 行数
     * 
     * @return 快速布局行控件集合对象(空白行对象)
     */
    private List<LayoutVO> getBlankTRList(int iTrNum) {
        List<LayoutVO> lstTr = new ArrayList<LayoutVO>(iTrNum);
        for (int i = 0; i < iTrNum; i++) {
            LayoutVO tr = this.getBlankTRLayOut();
            lstTr.add(tr);
        }
        return lstTr;
    }
    
    /**
     * 封装快速表单行控件方法
     * 
     * @return 快速布局行控件(空白行对象)
     */
    private LayoutVO getBlankTRLayOut() {
        LayoutVO blankTrLayout = new LayoutVO();
        // 行控件options信息
        CapMap mapOptions = new CapMap();
        mapOptions.put("uitype", "tr");
        blankTrLayout.setOptions(mapOptions);
        blankTrLayout.setUiType("tr");
        blankTrLayout.setId("trid-" + WrapperFtlPageCommon.getRandom());
        blankTrLayout.setType("layout");
        return blankTrLayout;
    }
    
    /**
     * 封装快速表单单元格方法
     * 
     * @return 单元格布局对象(空白单元格对象)
     */
    private LayoutVO getBlankTDLayOut() {
        LayoutVO blankTdLayout = new LayoutVO();
        // 行控件options信息
        CapMap objOptions = new CapMap();
        objOptions.put("uitype", "td");
        objOptions.put("text-align", "left");
        blankTdLayout.setOptions(objOptions);
        blankTdLayout.setUiType("td");
        blankTdLayout.setType("layout");
        blankTdLayout.setComponentModelId("uicomponent.layout.component.tableLayout");
        blankTdLayout.setId("tdid-" + WrapperFtlPageCommon.getRandom());
        return blankTdLayout;
    }
    
    /**
     * 封装快速表单元格方法
     * 
     * @param totalColNum 总列数
     * @param colspan 跨列数
     * @param align 对齐方式
     * @return 单元格布局对象
     */
    private LayoutVO getStorageComponentTDLayout(int totalColNum, int colspan, String align) {
        LayoutVO objLayout = this.getBlankTDLayOut();
        // 行控件options信息
        CapMap objOptions = objLayout.getOptions();
        objOptions.put("text-align", LEFT_ALIGN.equals(align) ? RIGHT_ALIGN : LEFT_ALIGN);
        String strWidth = "";
        if (LEFT_ALIGN.equals(align)) {
            strWidth = totalColNum == 1 ? "30%" : (totalColNum == 2 ? "20%" : "10%");
        } else {
            switch (totalColNum) {
                case 4:
                    strWidth = colspan == 1 ? "30%" : "80%";
                    break;
                case 6:
                    strWidth = colspan == 1 ? "23.33%" : (colspan == 3 ? "56.66%" : "90%");
                    break;
                default:
                    break;
            }
        }
        objOptions.put("width", strWidth);
        if (colspan > 0) {
            objOptions.put("colspan", colspan);
        }
        objLayout.setOptions(objOptions);
        return objLayout;
    }
    
    /**
     * 封装控件数据
     * 
     * @param model 快速布局表单行对象
     * @param entityEname 实体英文名称
     * @param entityAlias 实体别名
     * @return 控件布局对象
     */
    @SuppressWarnings("rawtypes")
    private LayoutVO getComponentLayout(RowFromFormAreaVO model, String entityEname, String entityAlias) {
        CapMap objOptions4RowFormArea = model.getOptions();
        String strDatabind = (String) objOptions4RowFormArea.get("databind");
        String strPropertyName = strDatabind.substring(strDatabind.lastIndexOf(".") + 1, strDatabind.length());
        String strComponentModelId = model.getComponentModelId();
        
        CapMap objOptions = new CapMap();
        objOptions.put("label", model.getCname());
        objOptions.put("uid", "uiid-" + WrapperFtlPageCommon.getRandom());
        if (entityEname != null) {
            // String strBindProperty = strDatabind.substring(strDatabind.lastIndexOf("."), strDatabind.length());
            // 当前控件跨列列数
            int iColspan = model.getColspan();
            strComponentModelId = model.getComponentModelId();
            String strUIType = strComponentModelId.substring(strComponentModelId.lastIndexOf(".") + 1,
                strComponentModelId.length());
            objOptions.put("colspan", iColspan == 0 ? "1" : String.valueOf(iColspan));
            objOptions.put("componentModelId", strComponentModelId);
            // objOptions.put("databind", entityEname + strBindProperty);
            objOptions.put("name", strPropertyName);
            objOptions.put("uitype",
                strUIType.substring(0, 1).toUpperCase() + strUIType.substring(1, strUIType.length()));
            objOptions.put("validate",
                objOptions4RowFormArea.get("validate") == null ? null : objOptions4RowFormArea.get("validate"));
            for (Iterator iterator = objOptions4RowFormArea.keySet().iterator(); iterator.hasNext();) {
                Object strOptionName = iterator.next();
                if (!objOptions.containsKey(strOptionName)) {
                    Object objVal = objOptions4RowFormArea.get(strOptionName);
                    // 别名替换成对应的数据集名称
                    if ("String".equals(objVal.getClass().getSimpleName())) {
                        String strVal = (String) objVal;
                        strVal = strVal.replaceAll("^" + entityAlias + "$", entityEname);
                        strVal = strVal.replaceAll("\'" + entityAlias + "\'", "\'" + entityEname + "\'");
                        strVal = strVal.replaceAll("\"" + entityAlias + "\"", "\"" + entityEname + "\"");
                        strVal = strVal.replaceAll("([\'|\"])" + entityAlias + "\\.", "$1" + entityEname + "\\.");
                        strVal = strVal.replaceAll("^\\$" + entityAlias + "\\.", "\\$" + entityEname + "\\.");
                        strVal = strVal.replaceAll("^" + entityAlias + "\\.", entityEname + "\\.");
                        objVal = strVal;
                    }
                    objOptions.put(strOptionName, objVal);
                }
            }
        } else {
            strComponentModelId = "uicomponent.common.component.label";
            // 行控件options信息
            objOptions.put("name", strPropertyName + "Label");
            objOptions.put("uitype", "Label");
            objOptions.put("value", model.getCname() + ":");
            objOptions.put("isReddot", false);
        }
        
        LayoutVO objLayout = new LayoutVO();
        objLayout.setUiType((String) objOptions.get("uitype"));
        objLayout.setId((String) objOptions.get("uid"));
        objLayout.setType("ui");
        objLayout.setComponentModelId(strComponentModelId);
        objLayout.setOptions(objOptions);
        
        return objLayout;
    }
    
    /**
     * 当前控件是否进行必填校验
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param optionsRowFormArea 控件选项信息
     * @return 是否必填校验
     */
    private boolean IsRequiredComponentValidate(CapMap optionsRowFormArea) {
        Object objOptions = optionsRowFormArea.get("validate");
        if (objOptions == null) {
            return false;
        }
        String strValidate = (String) optionsRowFormArea.get("validate");
        return StringUtil.contains(strValidate, "\"type\":\"required\"");
    }
    
}
