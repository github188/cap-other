/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;

/**
 * WrapperFtlPageCommon 类根据元数据进行数据封装，转换为Json对象
 *
 *
 * @author 肖威
 * @since jdk1.6
 * @version 2015年10月22日 肖威、2016年1月14日 诸焕辉 界面元数据模版生成的元数据格式变更
 */
public class WrapperFtlPageCommon {
    
    /**
     * 
     * 根据元数据信息进行数据封装，转换为Json对象
     * 
     * @param objMetadataGenerateVO 元数据对象
     * @param isWrapperConstantURL 是否需要封装url常量
     * @return objJSONObject 封装ftl模版需要的json对象
     */
    public static JSONObject wrapperDataToFtlTmp(MetadataGenerateVO objMetadataGenerateVO, boolean isWrapperConstantURL) {
        JSONObject objJSONObject = new JSONObject();
        // 封装通用数据
        wrapperCommon(objJSONObject, objMetadataGenerateVO);
        // 封装获取数据模型
        wrapperDataStore(objJSONObject, objMetadataGenerateVO, isWrapperConstantURL);
        // 封装获取引入文件信息
        wrapperIncludeFile(objJSONObject, objMetadataGenerateVO);
        // 封装获取布局信息
        wrapperQueryArea(objJSONObject, objMetadataGenerateVO);
        // 封装Grid信息
        wrapperGrid(objJSONObject, objMetadataGenerateVO);
        // 封装编辑区域信息
        wrapperEditArea(objJSONObject, objMetadataGenerateVO);
        // 封装获取行为信息
        wrapperAction(objJSONObject, objMetadataGenerateVO);
        return objJSONObject;
    }
    
    /**
     * 
     * 封装模板中通用信息
     * 
     * @param objJSONObject 需要封装JSon对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperCommon(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<InputAreaComponentVO> lstInputAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getInputComponentList();
        String packageId = "";
        if (StringUtil.isEmpty(objMetadataGenerateVO.getModelPackageId())) {
            SysmodelFacade sysmodelFacade = AppContext.getBean(SysmodelFacade.class);
            PackageVO packageVO = sysmodelFacade.queryPackageVOByPath(objMetadataGenerateVO.getModelPackage());
            packageId = packageVO == null ? "" : packageVO.getId();
        } else {
            packageId = objMetadataGenerateVO.getModelPackageId();
        }
        
        for (InputAreaComponentVO objInputAreaComponentVO : lstInputAreaComponentVO) {
            objJSONObject.put(objInputAreaComponentVO.getId(), objInputAreaComponentVO.getValue());
        }
        List<HiddenComponentVO> lstHiddenComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getHiddenComponentList();
        for (HiddenComponentVO objHiddenComponentVO : lstHiddenComponentVO) {
            objJSONObject.put(objHiddenComponentVO.getId(), objHiddenComponentVO.getValue());
        }
        List<MenuAreaComponentVO> lstMenuAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getMenuComponentList();
        for (MenuAreaComponentVO objMenuAreaComponentVO : lstMenuAreaComponentVO) {
            objJSONObject.put(objMenuAreaComponentVO.getId(), objMenuAreaComponentVO.getValue());
        }
        
        objJSONObject.put("charEncode", "UTF-8");
        // 包名(.转为_)+页面名称(首字母小写)
        objJSONObject.put("createrId", objMetadataGenerateVO.getCreaterId());
        objJSONObject.put("createrName", objMetadataGenerateVO.getCreaterName());
        objJSONObject.put("createTime", String.valueOf(objMetadataGenerateVO.getCreateTime()));
        objJSONObject.put("description", StringUtil.EMPTY);
        objJSONObject.put("hasMenu", "false");
        objJSONObject.put("hasPermission", "true");
        objJSONObject.put("layoutVO", StringUtils.EMPTY);
        objJSONObject.put("menuName", StringUtils.EMPTY);
        objJSONObject.put("menuType", String.valueOf(NumberConstant.ONE));
        objJSONObject.put("minWidth", "1024px");
        objJSONObject.put("modelType", "page");
        objJSONObject.put("modelPackage", objMetadataGenerateVO.getModelPackage());
        objJSONObject.put("modelPackageId", packageId);
        objJSONObject.put("pageType", "1");
    }
    
    /**
     * 
     * 封装引入文件信息
     * 
     * @param objJSONObject 需要封装JSon对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperIncludeFile(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<IncludeFileVO> lstTempIncludeFileVO = new ArrayList<IncludeFileVO>();
        List<EditAreaComponentVO> lstEditAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getEditComponentList();
        for (EditAreaComponentVO objEditAreaComponentVO : lstEditAreaComponentVO) {
            List<GridAreaComponentVO> lstGridAreaComponentVO = objEditAreaComponentVO.getEditGridAreaList();
            for (GridAreaComponentVO objGridAreaComponentVO : lstGridAreaComponentVO) {
                lstTempIncludeFileVO.addAll(objGridAreaComponentVO.getIncludeFileList());
            }
        }
        // 去重
        List<IncludeFileVO> lstFilterIncludeFileVO = new ArrayList<IncludeFileVO>();
        HashSet<String> objFilePath = new HashSet<String>();
        for (IncludeFileVO objIncludeFileVO : lstTempIncludeFileVO) {
            if (objFilePath.add(objIncludeFileVO.getFilePath())) {
                lstFilterIncludeFileVO.add(objIncludeFileVO);
            }
        }
        // 引入文件数组不为空时放入Json对象中
        if (lstFilterIncludeFileVO.size() > 0) {
            objJSONObject.put("includeFileList", lstFilterIncludeFileVO);
        }
    }
    
    /**
     * 
     * 封装引入数据模型
     * 
     * @param objJSONObject 需要封装JSon对象
     * @param objMetadataGenerateVO 元数据对象
     * @param isWrapperConstantURL 是否封装跳转常量
     */
    public static void wrapperDataStore(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO,
        boolean isWrapperConstantURL) {
        List<RowFromEntityAreaVO> lstEntity = objMetadataGenerateVO.getMetadataValue().getEntityComponentList().get(0)
            .getRowList();
        if (!CollectionUtils.isEmpty(lstEntity)) {
            JSONObject objDataEntity = new JSONObject();
            // 记录集英文名称，首字母小写
            for (RowFromEntityAreaVO rowFromEntityAreaVO : lstEntity) {
                String strEngName = rowFromEntityAreaVO.getEngName();
                strEngName = strEngName.substring(0, 1).toLowerCase() + strEngName.substring(1, strEngName.length());
                rowFromEntityAreaVO.setEngName(strEngName);
            }
            objDataEntity.put("dataEntityList", lstEntity);
            if (isWrapperConstantURL) {
                // 封装常量
                JSONObject objPageConstant = new JSONObject();
                // 模块包路劲
                String strModelPackage = objJSONObject.getString("modelPackage");
                String strCurrModel = strModelPackage.replace("com.comtop.", "");
                String strModelName = objJSONObject.getString("modelName");
                // 首字母转小写
                String strConstantName = strModelName.substring(0, 1).toLowerCase() + strModelName.substring(1);
                objPageConstant.put("constantName", strConstantName);
                objPageConstant.put("pageModelId", strModelPackage + ".page."
                    + strModelName.substring(0, 1).toUpperCase() + strModelName.substring(1));
                objPageConstant.put("url", "/" + strCurrModel.replace(".", "/") + "/" + strConstantName);
                objDataEntity.put("pageConstant", objPageConstant);
            }
            
            objJSONObject.put("dataStoreList", objDataEntity);
        }
    }
    
    /**
     * 
     * 根据查询区域Json对象封装查询table数据
     *
     * @param objFormAreaComponentVO 固定查询区域数据对象
     * @param strDataStoreName 当前查询区域绑定数据模型英文名称
     * @param strEntityAlias 实体别名
     * @return JSONObject 返回封装后json对象
     */
    public static JSONObject transforQueryTable(FormAreaComponentVO objFormAreaComponentVO, String strDataStoreName,
        String strEntityAlias) {
        int iCol = objFormAreaComponentVO.getCol() != null ? objFormAreaComponentVO.getCol() : NumberConstant.ONE;
        List<RowFromFormAreaVO> rowList = objFormAreaComponentVO.getRowList();
        JSONArray objListTrConditions = new JSONArray();
        // 获取属性总数
        int iQueryConditions = rowList.size();
        // 计算tr行数
        int iTrNum = getTrNum(rowList, iCol);
        // 快速表单中对应控件信息
        JSONArray objQuickTableinfo = new JSONArray();
        // 循环查询条件，进行封装
        // 已封装条件数
        int iConditions = 0;
        // 循环封装tr数据
        for (int j = 0; j < iTrNum; j++) {
            // tr数据封装
            JSONObject objTr = new JSONObject();
            objTr.put("trId", getRandom());
            // td数据封装
            // 循环条件，将查询条件放入tr中
            JSONArray objListQueryConditions = new JSONArray();
            int iCols = 0;
            // 循环封装查询条件
            for (int k = (iConditions != 0 ? iConditions : 0); k < iQueryConditions; k++) {
                RowFromFormAreaVO objRowFromFormAreaVO = rowList.get(k);
                // 跨列
                int iColspan = objRowFromFormAreaVO.getColspan();
                // 当前行满足控件所需列数
                int iColTotal = iCols + iColspan;
                if (iColTotal > iCol) {
                    iConditions = k;
                    // 空的单元格信息
                    int iBlankNum = iCol - iCols;
                    if (iBlankNum > 0) {
                        objListQueryConditions.addAll(getBlankCell(iBlankNum));
                    }
                    break;
                }
                objListQueryConditions.add(wrapperTdChildren(objQuickTableinfo, objRowFromFormAreaVO,
                    objFormAreaComponentVO.getCol(), iColspan, strDataStoreName, strEntityAlias));
                // 最后一行如果列不够，则用空列补充
                if (j == iTrNum - 1 && iConditions == iQueryConditions - 1 && iCol - iColTotal > 0) {
                    int iBlankNum = iCol - iColTotal;
                    objListQueryConditions.addAll(getBlankCell(iBlankNum));
                }
                // 控制当前行数据是否组装完成，跳出td数据封装循环
                iConditions += 1;
                iCols += iColspan;
                if (iCol == iCols) {
                    iConditions = (k + 1);
                    break;
                }
            }
            // 将td数据放入对应tr中
            objTr.put("listQueryConditions", objListQueryConditions);
            objListTrConditions.add(objTr);
        }
        // 将快速表单数据放入数组
        JSONObject objTableInfo = new JSONObject();
        objTableInfo.put("listTrConditions", objListTrConditions);
        objTableInfo.put("children", objQuickTableinfo);
        return objTableInfo;
    }
    
    /**
     * 封装td下的Children属性数据
     *
     * @param objQuickTableinfo 快速表单中对应控件信息
     * @param objRowFromFormAreaVO 控件对象
     * @param totalColNum 总列数
     * @param iColspan 合并行数
     * @param strDataStoreName 当前表单中绑定数据模型英文名称
     * @param strEntityAlias 实体别名
     * @return 结果
     */
    private static JSONObject wrapperTdChildren(JSONArray objQuickTableinfo, RowFromFormAreaVO objRowFromFormAreaVO,
        int totalColNum, int iColspan, String strDataStoreName, String strEntityAlias) {
        JSONObject objQueryCondition = new JSONObject();
        String strCname = objRowFromFormAreaVO.getCname();
        String strId = objRowFromFormAreaVO.getId();
        String strComponentModelId = objRowFromFormAreaVO.getComponentModelId();
        // label单元格及控件信息
        objQueryCondition.put("labelId", getRandom());
        objQueryCondition.put("tdLabel", strCname);
        objQueryCondition.put("tdLabelName", strId);
        objQueryCondition.put("tdLabelValue", strCname);
        objQueryCondition.put("tdLabelId", getRandom());
        objQueryCondition.put("tdLabelWidth", totalColNum == 1 ? "30%" : (totalColNum == 2 ? "20%" : "10%"));
        // 条件输入框单元格及控件信息
        objQueryCondition.put("tdConditionId", getRandom());
        objQueryCondition.put("tdDataBind", strId);
        objQueryCondition.put("tdDataBindLabel", strCname);
        objQueryCondition.put("tdDataBindName", strId);
        objQueryCondition.put("tdColspan", iColspan == 0 ? 1 : (2 * iColspan - 1));
        String strWidth = "70%";
        switch (totalColNum) {
            case 2:
                strWidth = iColspan == 1 ? "30%" : "80%";
                break;
            case 3:
                strWidth = iColspan == 1 ? "23.33%" : (iColspan == 2 ? "56.66%" : "90%");
                break;
            default:
                break;
        }
        objQueryCondition.put("tdWidth", strWidth);
        objQueryCondition.put("componentModelId", strComponentModelId);
        // objQueryCondition.put("tdUiType", getUIType());// --componentModelId
        // 封装控件option内容
        CapMap objOptions = objRowFromFormAreaVO.getOptions();
        if (!objOptions.isEmpty()) {
            objQueryCondition.put("validate", changeJsonString((String) objOptions.get("validate")));
            objQueryCondition.put("tdUiType", objOptions.get("uitype"));
            // 别名替换成对应的数据集名称
            entityAliasReplaceDataStoreName(objOptions, strEntityAlias, strDataStoreName);
            objOptions.put("required", objOptions.containsKey("validate") ? true : false);
            objOptions.put("componentModelId", strComponentModelId);
            objOptions.put("colspan", (iColspan > 1) ? String.valueOf(iColspan) : "1");
            objOptions.put("label", strCname);
            objOptions.put("name", strId);
            String strOption = JSONObject.toJSONString(objOptions);
            strOption = strOption.substring(1, strOption.length() - 1);
            objQueryCondition.put("options", strOption);
        }
        objQueryCondition.put("tdDataBindId", getRandom());
        // 组装快速表单数据
        // 封装属性控件数组，提供给快速表单布局
        JSONArray objQuickTable = new JSONArray();
        objQuickTable.add("uiid-" + objQueryCondition.get("tdConditionId"));
        objQuickTable.add("uiid-" + objQueryCondition.get("labelId"));
        objQuickTableinfo.add(objQuickTable);
        // 跨列，默认为1
        objQueryCondition.put("colspan", (iColspan > 1) ? iColspan : 1);
        
        return objQueryCondition;
    }
    
    /**
     * 别名替换成对应的数据集名称
     * 
     * 替换规则如下：【
     * "entityAlias"
     * "entityAlias.id"
     * "$editEntity.id"
     * "{\"codeName\":\"editEntity.code\"}"
     * "{'codeName':'editEntity.code'}"
     * "{'data':'editEntity'}"
     * "{\"data\":\"editEntity\"}"
     * 】
     * 
     * @param objOptions 控件属性对象
     * @param entityAlias 实体别名
     * @param dataStoreName 数据集名称
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private static void entityAliasReplaceDataStoreName(CapMap objOptions, String entityAlias, String dataStoreName) {
        Iterator<CapMap.Entry> objEntries = objOptions.entrySet().iterator();
        while (objEntries.hasNext()) {
            CapMap.Entry objEntry = objEntries.next();
            if ("String".equals(objEntry.getValue().getClass().getSimpleName())) {
                String strVal = (String) objEntry.getValue();
                strVal = strVal.replaceAll("^" + entityAlias + "$", dataStoreName);
                strVal = strVal.replaceAll("\'" + entityAlias + "\'", "\'" + dataStoreName + "\'");
                strVal = strVal.replaceAll("\"" + entityAlias + "\"", "\"" + dataStoreName + "\"");
                strVal = strVal.replaceAll("([\'|\"])" + entityAlias + "\\.", "$1" + dataStoreName + "\\.");
                strVal = strVal.replaceAll("^\\$" + entityAlias + "\\.", "\\$" + dataStoreName + "\\.");
                strVal = strVal.replaceAll("^" + entityAlias + "\\.", dataStoreName + "\\.");
                objOptions.put(objEntry.getKey(), strVal);
            }
        }
    }
    
    /**
     * 补充空列
     *
     * @param num 空列数
     * @return td对象
     */
    private static JSONArray getBlankCell(int num) {
        JSONArray objListQueryConditions = new JSONArray();
        for (int i = 0; i < num; i++) {
            JSONObject objQueryCondition = new JSONObject();
            objQueryCondition.put("tdDataBindId1", getRandom());
            objQueryCondition.put("colspan", 1);
            objQueryCondition.put("tdDataBindId2", getRandom());
            objQueryCondition.put("colspan", 1);
            objListQueryConditions.add(objQueryCondition);
        }
        return objListQueryConditions;
    }
    
    /**
     * 
     * 封装查询区域数据
     *
     * @param objJSONObject 需要封装的Json对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperQueryArea(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<QueryAreaComponentVO> lstQueryAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getQueryComponentList();
        for (QueryAreaComponentVO objQueryAreaComponentVO : lstQueryAreaComponentVO) {
            String strEntityId = objQueryAreaComponentVO.getEntityId();
            JSONObject objQueryArea = new JSONObject();
            List<FormAreaComponentVO> lstFixedQueryArea = objQueryAreaComponentVO.getFixedQueryAreaList();
            for (FormAreaComponentVO objFormAreaComponentVO : lstFixedQueryArea) {// 获取固定查询区域数据
                objQueryArea.put(
                    "fixed",
                    wrapperFormAreaData(objJSONObject, objFormAreaComponentVO, strEntityId, "queryFixedCodeArea",
                        objQueryAreaComponentVO.getEntityAlias()));
            }
            List<FormAreaComponentVO> lstMoreQueryArea = objQueryAreaComponentVO.getMoreQueryAreaList();
            for (FormAreaComponentVO objFormAreaComponentVO : lstMoreQueryArea) {// 获取更多查询区域数据
                if (objFormAreaComponentVO.getRowList().size() > 0) {
                    objQueryArea.put(
                        "detail",
                        wrapperFormAreaData(objJSONObject, objFormAreaComponentVO, strEntityId, "queryMoreCodeArea",
                            objQueryAreaComponentVO.getEntityAlias()));
                }
            }
            objJSONObject.put("queryArea", objQueryArea);
        }
    }
    
    /**
     * 
     * 封装表单区域数据
     *
     * @param objJSONObject 需要封装的Json对象
     * @param objFormAreaComponentVO 表单数据
     * @param strEntityId 所选实体id
     * @param uitype 子控件类型["queryFixedCodeArea", "queryMoreCodeArea", "editFormCodeArea"]
     * @param strEntityAlias 实体别名
     * @return 返回封装成表单格式的json对象
     */
    private static JSONObject wrapperFormAreaData(JSONObject objJSONObject, FormAreaComponentVO objFormAreaComponentVO,
        String strEntityId, String uitype, String strEntityAlias) {
        JSONObject objTableData = new JSONObject();
        String strDataStoreName = getDataStoreName(objJSONObject, strEntityId);
        JSONObject objTrData = transforQueryTable(objFormAreaComponentVO, strDataStoreName, strEntityAlias);
        objTableData.put("dataList", objTrData.get("listTrConditions"));
        // 填写快速表单信息
        objTableData.put("children", changeJsonString(objTrData.get("children").toString()));
        objTableData.put("bindObject", strDataStoreName);
        objTableData.put("col", objFormAreaComponentVO.getCol());
        objTableData.put("objectId", strEntityId);
        objTableData.put("tableId", getRandom());
        objTableData.put("uitype", uitype);
        return objTableData;
    }
    
    /**
     * 
     * 封装grid数据
     *
     * @param objJSONObject 需要封装的Json对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperGrid(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<GridAreaComponentVO> lstGridAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getGridComponentList();
        for (GridAreaComponentVO objGridAreaComponentVO : lstGridAreaComponentVO) {
            CapMap objOptions = objGridAreaComponentVO.getOptions();
            String strColumns = (String) objOptions.get("columns");
            // 循环判断列是否需要增加渲染函数
            JSONArray objColumns = JSONArray.parseArray(strColumns);
            if (objColumns.size() > 0) {
                JSONObject objChangeColumns = getRenderInfo(objColumns, objGridAreaComponentVO.getEntityAlias());
                JSONArray objChangeColumn = objChangeColumns.getJSONArray("columns");
                objJSONObject.put("gridColumns", changeJsonString(objChangeColumn.toJSONString()));
                objJSONObject.put("gridRender", objChangeColumns.get("gridRender"));
                objJSONObject.put("primarykey", objOptions.get("primarykey"));
                objJSONObject.put(
                    "gridExtras",
                    updateExtras((String) objOptions.get("extras"), objChangeColumn, objJSONObject,
                        objGridAreaComponentVO.getEntityId()));
                objJSONObject.put("gridSelectrows", objOptions.get("selectrows"));
            }
        }
    }
    
    /**
     * 
     * 封装编辑区域数据
     *
     * @param objJSONObject 需要封装的Json对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperEditArea(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<EditAreaComponentVO> lstEditAreaComponentVO = objMetadataGenerateVO.getMetadataValue()
            .getEditComponentList();
        for (EditAreaComponentVO objEditAreaComponentVO : lstEditAreaComponentVO) {
            String strEntityId = objEditAreaComponentVO.getEntityId();
            JSONObject objTemp = new JSONObject();
            List<GroupingBarComponentVO> lstGroupingBarComponentVO = objEditAreaComponentVO.getGroupingBarList();
            for (GroupingBarComponentVO objGroupingBarComponentVO : lstGroupingBarComponentVO) {// 封装分组栏信息
                objTemp.put(objGroupingBarComponentVO.getId(), wrapperGroupingBarData(objGroupingBarComponentVO));
            }
            List<FormAreaComponentVO> lstFormAreaComponentVO = objEditAreaComponentVO.getFormAreaList();
            for (FormAreaComponentVO objFormAreaComponentVO : lstFormAreaComponentVO) {// 封装表单信息
                objTemp.put(
                    objFormAreaComponentVO.getId(),
                    wrapperFormAreaData(objJSONObject, objFormAreaComponentVO, strEntityId, "editFormCodeArea",
                        objEditAreaComponentVO.getEntityAlias()));
            }
            List<GridAreaComponentVO> lstGridAreaComponentVO = objEditAreaComponentVO.getEditGridAreaList();
            if (!lstGridAreaComponentVO.isEmpty()) {
                objJSONObject.put("isCascadeOperation", true);
            }
            for (GridAreaComponentVO objGridAreaComponentVO : lstGridAreaComponentVO) {// 封装编辑网格信息
                if (objGridAreaComponentVO.getOptions().isEmpty()) {
                    continue;
                }
                objTemp.put(objGridAreaComponentVO.getId(),
                    wrapperEditGridCodeAreaData(objJSONObject, objGridAreaComponentVO, strEntityId));
            }
            // 子控件排版
            List<String> lstSubCompLayoutSort = objEditAreaComponentVO.getSubComponentLayoutSortList();
            JSONArray objEditArea = new JSONArray();
            for (String strSubCompLayoutSort : lstSubCompLayoutSort) {
                if (objTemp.containsKey(strSubCompLayoutSort)) {
                    objEditArea.add(objTemp.get(strSubCompLayoutSort));
                }
            }
            objJSONObject.put("editArea", objEditArea);
            
        }
    }
    
    /**
     * 封装编辑区域子控件分组栏控件的数据
     * 
     * @param objGroupingBarComponentVO 表单对象
     * @return 返回封装成编辑grid格式的json对象
     */
    private static JSONObject wrapperGroupingBarData(GroupingBarComponentVO objGroupingBarComponentVO) {
        JSONObject objTableData = new JSONObject();
        objTableData.put("labelId", getRandom());
        objTableData.put("labelName", objGroupingBarComponentVO.getValue());
        objTableData.put("tableId", getRandom());
        objTableData.put("uitype", "groutingCloumn");
        return objTableData;
    }
    
    /**
     * 封装编辑区域子控件编辑grid控件的数据
     * 
     * @param objJSONObject 需要封装的Json对象
     * @param objGridAreaComponentVO 编辑grid对象
     * @param entityId 绑定的数据集关联的实体Id
     * @return 返回封装成编辑grid格式的json对象
     */
    private static JSONObject wrapperEditGridCodeAreaData(JSONObject objJSONObject,
        GridAreaComponentVO objGridAreaComponentVO, String entityId) {
        CapMap objOptions = objGridAreaComponentVO.getOptions();
        String strColumns = (String) objOptions.get("columns");
        // 循环判断列是否需要增加渲染函数
        JSONArray objColumns = JSONArray.parseArray(strColumns);
        JSONObject objChangeColumns = getRenderInfo(objColumns, objGridAreaComponentVO.getEntityAlias());
        JSONArray objChangeColumn = objChangeColumns.getJSONArray("columns");
        JSONArray objGridRender = objChangeColumns.getJSONArray("gridRender");
        // 判断Json中是否已经存在行为数组
        if (objJSONObject.containsKey("editGridRender")) {
            JSONArray objRenders = mergeActionArray(objGridRender, objJSONObject.getJSONArray("editGridRender"));
            objJSONObject.put("editGridRender", objRenders);
        } else {
            objJSONObject.put("editGridRender", objGridRender);
        }
        JSONObject objTableData = new JSONObject();
        objTableData.put("columns", changeJsonString(objChangeColumn.toJSONString()));
        objTableData.put("extras",
            updateExtras((String) objOptions.get("extras"), objChangeColumn, objJSONObject, entityId));
        objTableData.put("databind", objOptions.get("databind"));
        objTableData.put("primarykey", objOptions.get("primarykey"));
        objTableData.put("edittype", changeJsonString((String) objOptions.get("edittype")));
        objTableData.put("selectrows", objOptions.get("selectrows"));
        objTableData.put("tableId", getRandom());
        objTableData.put("uitype", "editGridCodeArea");
        // EditGridID
        objTableData.put("editGridId", "uiid-" + getRandom());
        // EditGrid新增按钮及行为
        objTableData.put("editGridAddButtonUIID", "uiid-" + getRandom());
        objTableData.put("editGridAddButtonId", getRandom());
        objTableData.put("editGridAddActionName", "addRows" + getRandom());
        objTableData.put("editGridAddActionId", "addRows" + getRandom());
        // EditGrid删除按钮及行为
        objTableData.put("editGridDelButtonUIID", "uiid-" + getRandom());
        objTableData.put("editGridDelButtonId", getRandom());
        objTableData.put("editGridDelActionName", "deleteRows" + getRandom());
        objTableData.put("editGridDelActionId", "deleteRows" + getRandom());
        // EditGrid操作table
        objTableData.put("editGridOperationTd", getRandom());
        objTableData.put("editGridOperationTr", getRandom());
        objTableData.put("editGridOperationTable", getRandom());
        // EditGridTable
        objTableData.put("editGridTd", getRandom());
        objTableData.put("editGridTr", getRandom());
        return objTableData;
    }
    
    /**
     * 
     * 封装行为方法
     * 
     * @param objJSONObject 需要封装的Json对象
     * @param objMetadataGenerateVO 元数据对象
     */
    public static void wrapperAction(JSONObject objJSONObject, MetadataGenerateVO objMetadataGenerateVO) {
        List<RowFromEntityAreaVO> lstEntity = objMetadataGenerateVO.getMetadataValue().getEntityComponentList().get(0)
            .getRowList();
        EntityFacade objEntityFacade = AppContext.getBean(EntityFacade.class);
        for (RowFromEntityAreaVO objRowFromEntityAreaVO : lstEntity) {
            String strEname = objRowFromEntityAreaVO.getEngName();
            if (StringUtil.isNotBlank(strEname)) {
                String strEntityId = objRowFromEntityAreaVO.getModelId();
                objJSONObject.put("queryEntityEName", strEname);
                objJSONObject.put("queryEntityId", strEntityId);
                EntityVO objEntity = objEntityFacade.loadEntity(strEntityId, objMetadataGenerateVO.getModelPackageId());
                List<EntityAttributeVO> lstAttributes = objEntity.getAttributes();
                for (int i = 0; i < lstAttributes.size(); i++) {
                    EntityAttributeVO objEntityAttributeVO = lstAttributes.get(i);
                    if (objEntityAttributeVO.isPrimaryKey()) {
                        objJSONObject.put("queryEntityPrimaryKey", objEntityAttributeVO.getEngName());
                        break;
                    }
                }
                if (StringUtils.isNotBlank(objRowFromEntityAreaVO.getEntityAlias())) {
                    String strEntityAlias = objRowFromEntityAreaVO.getEntityAlias();
                    objJSONObject.put(
                        "queryAliasEntityId",
                        strEntityId.substring(NumberConstant.ZERO, strEntityId.lastIndexOf(".") + NumberConstant.ONE)
                            + String.valueOf(strEntityAlias.charAt(NumberConstant.ZERO)).toUpperCase()
                            + strEntityAlias.substring(NumberConstant.ONE));
                }
            }
        }
    }
    
    /**
     * 
     * Json字符串增加"\"
     *
     * @param strTatget 待封装的字符串
     * @return String 返回封装后的字符串
     */
    private static String changeJsonString(String strTatget) {
        String strChange = "";
        //处理JSon中特殊字符 \
        strChange = StringUtil.replace(strTatget, "\"", "$");
        strChange = StringUtil.replace(strChange, "\\", "☭▓卐/");
        //处理Json中特殊字符\\
        strChange = StringUtil.replace(strChange, "$", "\\\"");
        strChange = StringUtil.replace(strChange, "☭▓卐/", "\\\\");
        return strChange;
    }
    
    /**
     * 
     * 获取随机数作为ui控件的ID
     *
     * @return String类型
     */
    public static String getRandom() {
        Random random = new Random();
        return String.valueOf(random.nextDouble()).replace(".", "");
    }
    
    /**
     * 
     * 判断table中行数
     * 
     * @param rowList 存放表格中应填充的属性数据
     * @param colNum table列数，存放当前表格限制的列数
     * @return boolean 是否需要跳出当前循环
     */
    public static int getTrNum(List<RowFromFormAreaVO> rowList, int colNum) {
        if (CollectionUtils.isEmpty(rowList)) {
            return NumberConstant.ZERO;
        }
        int iTotalTR = 1;
        int iCols = 0;
        for (RowFromFormAreaVO objRowFromFormAreaVO : rowList) {
            // 跨列
            int iColspan = objRowFromFormAreaVO.getColspan();
            // 当前行满足控件所需列数
            int iColTotal = iCols + iColspan;
            if (iColTotal > colNum) {
                iTotalTR += 1;
                iCols = 0;
            }
            iCols += iColspan;
        }
        return iTotalTR;
    }
    
    /**
     * 根据EntityId获取对应数据模型英文名称
     *
     * @param objJSONObject Json对象
     * @param strEntityId 实体id
     * @return String 数据模型英文名称
     */
    private static String getDataStoreName(JSONObject objJSONObject, String strEntityId) {
        String strDataStoreEname = "";
        JSONObject objDataStoreList = (JSONObject) objJSONObject.get("dataStoreList");
        JSONArray objDataEntitys = objDataStoreList.getJSONArray("dataEntityList");
        if (objDataEntitys != null) {
            for (int i = 0, len = objDataEntitys.size(); i < len; i++) {
                JSONObject objEntity = (JSONObject) objDataEntitys.get(i);
                if (StringUtil.equals(strEntityId, objEntity.getString("modelId"))) {
                    strDataStoreEname = objEntity.getString("engName");
                    break;
                }
            }
        }
        return strDataStoreEname;
    }
    
    /**
     * 根据列信息更新渲染名称
     *
     * @param objColumns grid中列数组
     * @param entityAlias 实体别名
     * @return JSONArray对象
     */
    private static JSONObject getRenderInfo(JSONArray objColumns, String entityAlias) {
        JSONArray objChangeColumns = new JSONArray();
        JSONArray objRenders = new JSONArray();
        for (int i = 0; i < objColumns.size(); i++) {
            if (objColumns.get(i) instanceof JSONArray) {
                JSONObject objSub = getRenderInfo((JSONArray) objColumns.get(i), entityAlias);
                objChangeColumns.add(objSub.get("columns"));
                JSONArray objSubRenders = (JSONArray) objSub.get("gridRender");
                for (int j = 0, len = objSubRenders.size(); j < len; j++) {
                    objRenders.add(objSubRenders.get(j));
                }
            } else {
                JSONObject objColumn = (JSONObject) objColumns.get(i);
                JSONObject objRender = new JSONObject();
                if (objColumn.containsKey("render")) {
                    String strRender = objColumn.getString("render");
                    String strRenderModelName = strRender.substring(strRender.lastIndexOf(".") + NumberConstant.ONE,
                        strRender.length());
                    String strBindName = objColumn.getString("bindName");
                    String wrapperRenderName = String.format(
                        "%sBy%s",
                        strRenderModelName,
                        strBindName.substring(NumberConstant.ZERO, NumberConstant.ONE).toUpperCase()
                            + strBindName.substring(NumberConstant.ONE));
                    objRender.put(strRenderModelName, wrapperRenderName);
                    objRender.put("actionModelName", strRenderModelName);// 用来过滤重复行为
                    objRender.put("pageActionId", getRandom());
                    objRender.put("bindName", strBindName);
                    objColumn.put("render", wrapperRenderName);// 更改columns对应的render值
                    objRenders.add(objRender);
                    
                }
                objChangeColumns.add(objColumn);
            }
        }
        JSONObject objChangeCloumn = new JSONObject();
        objChangeCloumn.put("columns", objChangeColumns);
        objChangeCloumn.put("gridRender", objRenders);
        return objChangeCloumn;
    }
    
    /**
     * 合并行为数组
     *
     * @param objArray 待增加行为数组
     * @param objTargetArray 页面中已存在行为数组
     * @return JSONArray 页面中存在行为数组
     */
    private static JSONArray mergeActionArray(JSONArray objArray, JSONArray objTargetArray) {
        for (int j = 0, len = objArray.size(); j < len; j++) {
            JSONObject objNewRender = (JSONObject) objArray.get(j);
            String strRenderName = objNewRender.getString(objNewRender.getString("actionModelName"));
            for (int k = 0, len1 = objTargetArray.size(); k < len1; k++) {
                JSONObject objTargetRender = (JSONObject) objTargetArray.get(k);
                String strRenderName1 = objTargetRender.getString(objTargetRender.getString("actionModelName"));
                if (!StringUtil.equals(strRenderName, strRenderName1)) {
                    objTargetArray.add(objNewRender);
                }
            }
        }
        return objTargetArray;
    }
    
    /**
     * 更新扩展属性（extras）【grid和editableGrid】
     *
     * @param extras 扩展属性
     * @param column 列数组对象
     * @param objJSONObject 需要封装的Json对象
     * @param entityId 关联的实体Id
     * @return 返回处理后的extras
     */
    private static String updateExtras(String extras, JSONArray column, JSONObject objJSONObject, String entityId) {
        JSONObject objExtras = JSONObject.parseObject(extras);
        objExtras.put("dataStoreEname", getDataStoreName(objJSONObject, entityId));
        JSONArray objTableHeader = JSONArray.parseArray(objExtras.getString("tableHeader"));
        updateRender(column, objTableHeader);
        objExtras.put("tableHeader", objTableHeader.toJSONString());
        return changeJsonString(objExtras.toJSONString());
    }
    
    /**
     * 更新render函数
     *
     * @param column 行
     * @param tableHeader tableHeader
     */
    private static void updateRender(JSONArray column, JSONArray tableHeader) {
        for (int i = 0, len = column.size(); i < len; i++) {
            if (column.get(i) instanceof JSONArray) {
                updateRender((JSONArray) column.get(i), tableHeader);
            } else {
                JSONObject objColumn = (JSONObject) column.get(i);
                String strRender = (String) objColumn.get("render");
                if (StringUtil.isNotBlank(strRender)) {
                    JSONObject objColumn4Extras = (JSONObject) tableHeader.get(i);
                    objColumn4Extras.put("render", strRender);
                }
            }
        }
    }
}
