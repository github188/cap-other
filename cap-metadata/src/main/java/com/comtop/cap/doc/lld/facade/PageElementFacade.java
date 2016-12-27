/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.lld.facade;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.external.EventDTO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataDTO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.doc.lld.model.PageElementDTO;
import com.comtop.cap.doc.lld.model.PageElementEventDTO;
import com.comtop.cap.doc.lld.model.PageElementServiceDTO;
import com.comtop.cap.doc.service.AbstractExportFacade;
import com.comtop.cap.document.expression.annotation.DocumentService;

/**
 * 页面元素Facade
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月4日 lizhiyong
 */
@DocumentService(name = "PageElement", dataType = PageElementDTO.class)
public class PageElementFacade extends AbstractExportFacade<PageElementDTO> {
    
    /** UIType类型 */
    public static Map<String, String> uiTypeMap = new HashMap<String, String>(16);
    static {
        uiTypeMap.put("button", "按钮");
        uiTypeMap.put("Page", "页面");
    }
    
    @Override
    public List<PageElementDTO> loadData(PageElementDTO condition) {
        PageMetadataProvider metadataProvider = new PageMetadataProvider();
        try {
            List<PageMetadataDTO> pageDatas = metadataProvider.getAllElementsByPageModelId(condition.getPageId());
            if (pageDatas == null || pageDatas.size() == 0) {
                return null;
            }
            PageElementDTO pageElementDTO = null;
            List<PageElementDTO> alRet = new ArrayList<PageElementDTO>();
            int i = 0;
            for (PageMetadataDTO pageMetadataDTO : pageDatas) {
                pageElementDTO = vo2DTO(pageMetadataDTO);
                pageElementDTO.setSortIndex(i++);
                alRet.add(pageElementDTO);
            }
            return alRet;
        } catch (OperateException e) {
            LOGGER.error(MessageFormat.format("查询页面元素时发生异常。当前页面id={0}", condition.getPageId()), e);
        }
        return null;
    }
    
    /**
     * VO转为DTO
     *
     * @param data 元数据
     * @return 页面元素
     */
    private PageElementDTO vo2DTO(PageMetadataDTO data) {
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
                elementEventDTO.setCode(eventDTO.getAction().getEname());
                elementEventDTO.setDescription(eventDTO.getAction().getDescription());
                elementEventDTO.setId(eventDTO.getAction().getPageActionId());
                elementEventDTO.setName(eventDTO.getAction().getEname());
                elementEventDTO.setCnName(eventDTO.getEventDef().getCname());
                if (StringUtils.isBlank(elementEventDTO.getCnName())) {
                    elementEventDTO.setCnName(eventDTO.getAction().getCname());
                }
                elementEventDTO.setNewData(false);
                elementEventDTO.setCnElementName(dto.getCnName());
                elementEventDTO.setElementName(dto.getName());
                elementEventDTO.setSortIndex(i++);
                dto.addEvent(elementEventDTO);
                
                elementService = new PageElementServiceDTO();
                elementService.setCode(eventDTO.getService().getChName());
                elementService.setDescription(eventDTO.getService().getDescription());
                elementService.setId(eventDTO.getService().getMethodId());
                elementService.setName(eventDTO.getService().getEngName());
                elementService.setCnName(eventDTO.getService().getChName());
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
