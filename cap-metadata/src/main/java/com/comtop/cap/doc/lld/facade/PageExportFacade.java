/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.lld.facade;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.EventDTO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataDTO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.bm.req.subfunc.appservice.ReqFunctionPageAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqPageVO;
import com.comtop.cap.component.loader.util.LoaderUtil;
import com.comtop.cap.doc.lld.model.PageDTO;
import com.comtop.cap.doc.lld.model.PageElementDTO;
import com.comtop.cap.doc.lld.model.PageElementEventDTO;
import com.comtop.cap.doc.lld.model.PageElementServiceDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 页面导出门面
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月4日 lizhiyong
 */
@DocumentService(name = "Page", dataType = PageDTO.class)
public class PageExportFacade extends AbstractExportFacade<PageDTO> {
    
    /** 界面原型操作bean */
    protected ReqFunctionPageAppService pageService = AppBeanUtil.getBean(ReqFunctionPageAppService.class);
    
    /** UIType类型 */
    public static Map<String, String> uiTypeMap = new HashMap<String, String>(16);
    static {
        uiTypeMap.put("validate", "验证器");
        uiTypeMap.put("databind", "数据绑定器");
        uiTypeMap.put("button", "按钮");
        uiTypeMap.put("tab", "Tab页");
        uiTypeMap.put("panel", "面板");
        uiTypeMap.put("borderlayout", "边框布局");
        uiTypeMap.put("handlmask", "遮罩层");
        uiTypeMap.put("tip", "提示");
        uiTypeMap.put("tree", "树");
        uiTypeMap.put("pagination", "分页组件");
        uiTypeMap.put("multinav", "导航栏");
        uiTypeMap.put("msgbox", "消息框");
        uiTypeMap.put("menu", "菜单");
        uiTypeMap.put("editablegrid", "可编辑表单");
        uiTypeMap.put("dialog", "对话框");
        uiTypeMap.put("customform", "自定义表单");
        uiTypeMap.put("editor", "富文本编辑器");
        uiTypeMap.put("listbox", "下拉框");
        uiTypeMap.put("calender", "日历");
        uiTypeMap.put("textarea", "文本输入框");
        uiTypeMap.put("clickinput", "单击选择框");
        uiTypeMap.put("checkboxgroup", "复选框");
        uiTypeMap.put("radiogroup", "单选按钮");
        uiTypeMap.put("pulldown", "下拉选择框");
        uiTypeMap.put("grid", "网格");
        uiTypeMap.put("input", "输入框");
        uiTypeMap.put("label", "标签");
        uiTypeMap.put("page", "页面");
    }
    
    @Override
    public List<PageDTO> loadData(PageDTO condition) {
        PageMetadataProvider metadataProvider = new PageMetadataProvider();
        List<PageVO> pagevos;
        try {
            pagevos = metadataProvider.getPagesByModelId(condition.getPackageId());
            if (pagevos == null || pagevos.size() == 0) {
                return null;
            }
            PageDTO pageDTO = null;
            List<PageDTO> alRet = new ArrayList<PageDTO>(pagevos.size());
            for (PageVO pageVO : pagevos) {
                pageDTO = vo2DTO(pageVO);
                loadAndSetPageElement(pageDTO);
                alRet.add(pageDTO);
            }
            return alRet;
        } catch (OperateException e) {
            LOGGER.error(MessageFormat.format("加载指定的应用下的页面时发生异常。当前应用id={0}", condition.getId()), e);
            return null;
        }
    }
    
    /**
     * VO转为DTO
     *
     * @param pageVO 页面VO
     * @return DTO
     */
    private PageDTO vo2DTO(PageVO pageVO) {
        PageDTO pageDTO = new PageDTO();
        pageDTO.setId(pageVO.getModelId());
        pageDTO.setName(pageVO.getModelName());
        pageDTO.setCnName(pageVO.getCname());
        pageDTO.setPageType(pageVO.getPageType());
        pageDTO.setNewData(false);
        pageDTO.setCode(pageVO.getCode());
        pageDTO.setDescription(pageVO.getDescription());
        pageDTO.setPackageId(pageVO.getModelPackageId());
        pageDTO.setCrudeUIIds(pageVO.getCrudeUIIds());
        // pageDTO.setPageFrom(pageVO.get);
        pageDTO.setCrudeUIs(convertCrudeUIs(pageVO.getCrudeUIIds()));
        pageDTO.setCrudeUINames(pageVO.getCrudeUINames());
        return pageDTO;
    }
    
    /**
     * 转换界面原型
     *
     * @param crudeUIIds 界面原型id
     * @return 界面原型字符串集合
     */
    private List<String> convertCrudeUIs(String crudeUIIds) {
        if (StringUtils.isBlank(crudeUIIds)) {
            return null;
        }
        String[] strCrudeUIId = crudeUIIds.split("[;]");
        Arrays.asList(strCrudeUIId);
        List<ReqPageVO> pages = pageService.queryReqPageListByIds(Arrays.asList(strCrudeUIId));
        List<String> alRet = new ArrayList<String>(pages.size());
        for (ReqPageVO page : pages) {
            alRet.add(toImgTagString(page));
        }
        return alRet;
    }
    
    /**
     * 转为Imag标签字符串
     *
     * @param page 页面
     * @return 字符串
     */
    private String toImgTagString(ReqPageVO page) {
        StringBuffer sbBuffer = new StringBuffer();
        sbBuffer.append("<img ");
        sbBuffer.append(" src='").append(LoaderUtil.getVisitUrl() + "/" + page.getImgId()).append("'");
        sbBuffer.append(" height='").append(page.getHeight()).append("'");
        sbBuffer.append(" width='").append(page.getWidth()).append("'");
        sbBuffer.append("/>");
        return sbBuffer.toString();
    }
    
    /**
     * 加载界面元素
     *
     * @param pageDTO 界面DTO
     */
    private void loadAndSetPageElement(PageDTO pageDTO) {
        try {
            PageMetadataProvider metadataProvider = new PageMetadataProvider();
            List<PageMetadataDTO> pageDatas = metadataProvider.getAllElementsByPageModelId(pageDTO.getId());
            PageElementDTO pageElementDTO = null;
            int i = 0;
            for (PageMetadataDTO pageMetadataDTO : pageDatas) {
                pageElementDTO = vo2DTO(pageDTO, pageMetadataDTO);
                pageDTO.addEvents(pageElementDTO.getEvents());
                pageDTO.addServices(pageElementDTO.getServices());
                pageDTO.addElement(pageElementDTO);
                pageElementDTO.setSortIndex(++i);
            }
        } catch (Throwable e) {
            LOGGER.error(MessageFormat.format("查询页面元素时发生异常。当前页面id={0}", pageDTO.getId()), e);
        }
    }
    
    /**
     * VO转为DTO
     * 
     * @param pageDTO 界面DTO
     *
     * @param data 元数据
     * @return 页面元素
     */
    private PageElementDTO vo2DTO(PageDTO pageDTO, PageMetadataDTO data) {
        PageElementDTO dto = new PageElementDTO();
        dto.setId(data.getLayout().getId());
        CapMap options = data.getLayout().getOptions();
        Object value = options.get("name");
        dto.setName(value == null ? "" : value.toString());
        dto.setUiType(data.getLayout().getUiType());
        dto.setCnUiType(getCnUiType(dto.getUiType()));
        value = options.get("label");
        dto.setCnName(value == null ? "" : value.toString());
        dto.setNewData(false);
        if (data.getComponent() != null) {
            dto.setDescription(data.getComponent().getDescription());
        }
        
        fillEventAndService(dto, data);
        return dto;
    }
    
    /**
     * 填充事件信息和服务信息
     *
     * @param dto dto
     * @param data data
     */
    private void fillEventAndService(PageElementDTO dto, PageMetadataDTO data) {
        List<EventDTO> events = data.getEvents();
        if (events != null && events.size() > 0) {
            PageElementEventDTO elementEventDTO = null;
            int i = 0;
            PageElementServiceDTO elementService = null;
            for (EventDTO eventDTO : events) {
                elementEventDTO = new PageElementEventDTO();
                if (eventDTO.getAction() != null) {
                    elementEventDTO.setCode(eventDTO.getAction().getEname());
                    elementEventDTO.setDescription(eventDTO.getAction().getDescription());
                    elementEventDTO.setId(eventDTO.getAction().getPageActionId());
                    elementEventDTO.setName(eventDTO.getAction().getEname());
                    if (StringUtils.isBlank(elementEventDTO.getCnName())) {
                        elementEventDTO.setCnName(eventDTO.getAction().getCname());
                    }
                }
                if (eventDTO.getEventDef() != null) {
                    elementEventDTO.setCnName(eventDTO.getEventDef().getCname());
                }
                elementEventDTO.setNewData(false);
                elementEventDTO.setCnElementName(dto.getCnName());
                elementEventDTO.setElementName(dto.getName());
                elementEventDTO.setSortIndex(++i);
                dto.addEvent(elementEventDTO);
                
                elementService = new PageElementServiceDTO();
                if (eventDTO.getService() != null) {
                    EntityVO entityVO = eventDTO.getEntity();
                    elementService.setCode(entityVO.getEngName() + "." + eventDTO.getService().getEngName());
                    elementService.setDescription(eventDTO.getService().getDescription());
                    elementService.setId(eventDTO.getService().getMethodId());
                    elementService.setName(eventDTO.getService().getEngName());
                    elementService.setCnName(eventDTO.getService().getChName());
                }
                
                elementService.setNewData(false);
                elementService.setCnElementName(dto.getCnName());
                elementService.setElementName(dto.getName());
                elementService.setSortNo(i);
                dto.addService(elementService);
            }
        }
    }
    
    /**
     * @param uiType UiType
     * @return 获取 cnUiType属性值
     */
    private String getCnUiType(String uiType) {
        if (StringUtils.isBlank(uiType)) {
            return "未知类型";
        }
        String cnUiType = uiTypeMap.get(uiType.toLowerCase());
        if (StringUtils.isBlank(cnUiType)) {
            return uiType;
        }
        return cnUiType;
    }
}
