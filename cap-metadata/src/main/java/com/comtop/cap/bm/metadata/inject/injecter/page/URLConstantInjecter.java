/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.common.storage.ObjectOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.page.PageUtil;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.template.model.InputAreaComponentVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.PageTempVO;
import com.comtop.top.core.util.StringUtil;

/**
 * 数据集，类型为URL的页面常量的注入器
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月11日 凌晨
 */
public class URLConstantInjecter implements IMetaDataInjecter {
	
	/** 日志 */
    protected static final Logger LOGGER = LoggerFactory.getLogger(URLConstantInjecter.class);
    
    @Override
    public void inject(Object obj, Object source) {
        // 强制转换GenerateVO
        MetadataGenerateVO genVO = (MetadataGenerateVO) obj;
        // 获取模块的modelPackage
        String newModelPackage = genVO.getModelPackage();
        // 声明模块的中、英文名称
        String newModelCName = null, newModelName = null;
        
        List<InputAreaComponentVO> inputComponentList = genVO.getMetadataValue().getInputComponentList();
        for (InputAreaComponentVO item : inputComponentList) {
            if ("modelName".equals(item.getName())) {
                // 得到模块的英文名称
                newModelName = item.getValue();
            } else if ("cname".equals(item.getName())) {
                // 得到模块的中文名称
                newModelCName = item.getValue();
            }
        }
        
        PageTempVO templateVO = (PageTempVO)source;
        
        ObjectOperator lstOperator = new ObjectOperator(source);
        
        List<PageConstantVO> lstConstants;
		try {
			lstConstants = lstOperator.queryList("dataStoreVOList[ename='pageConstantList']/pageConstantList[constantType='url']",PageConstantVO.class);
			for (PageConstantVO pageConstantVO : lstConstants) {
	        	  CapMap option = pageConstantVO.getConstantOption();
	              if (option != null && StringUtil.isNotBlank((String) option.get("url"))) {
	                  // com.comtop.user.page.PersonListEditPag
	                  //String oldModelId = (String) option.get("pageModelId");
	                  if (isUrlBelongSelfModel((String) option.get("url"), templateVO.getPageModelPackage())) {
	                	  changeUrlToNewValue(pageConstantVO, newModelPackage, newModelName, newModelCName);
	                  }
	                  
	              }
			}
			clearOtherAttribute(templateVO);
		} catch (OperateException e) {
			LOGGER.error("根据模板界面生成界面元数据中的url常量时，依据xpath表达式查询模板界面中的url常量出错，", e);
		}
        
        /*for (Object o : source) {
            PageVO page = (PageVO) o;
            List<DataStoreVO> lstDataStore = page.getDataStoreVOList();
            // 遍历所有数据集
            for (DataStoreVO dataStoreVo : lstDataStore) {
                // 如果是页面常量数据集
                if ("pageConstantList".equals(dataStoreVo.getEname())) {
                    List<PageConstantVO> lstConstant = dataStoreVo.getPageConstantList();
                    // 页面常量数据集中页面常量集合为空，直接循环结束
                    if (CollectionUtils.isEmpty(lstConstant)) {
                        break;
                    }
                    
                    // 遍历页面常量数据集中的常量
                    Iterator<PageConstantVO> it = lstConstant.iterator();
                    while (it.hasNext()) {
                        PageConstantVO constant = it.next();
                        // 如果常量是URL类型，则注入新的URL.其中constantName属性不进行注入替换，constantName在行为里面被使用了。
                        if ("url".equalsIgnoreCase(constant.getConstantType())) {
                            CapMap option = constant.getConstantOption();
                            if (option != null && StringUtil.isNotBlank((String) option.get("url"))) {
                                // /user/personListEditPag.ac
                                String oldUrl = (String) option.get("url");
                                // com.comtop.user.page.PersonListEditPag
                                String oldModelId = (String) option.get("pageModelId");
                                
                                boolean flag = isUrlBelongSelfModel(oldUrl, page.getModelPackage());
                                if (flag) {
                                    // 获得新url并注入
                                    String newUrl = getNewOptionURL(oldUrl, newModelPackage, newModelName);
                                    option.put("url", newUrl);
                                    
                                    // 获得新modelId并注入
                                    String newModelId = getNewModelId(oldModelId, newModelPackage, newModelName);
                                    option.put("pageModelId", newModelId);
                                    
                                    // 注入URL常量的constantValue
                                    String newConstantValue = getNewConstantValue(newUrl, constant.getConstantValue());
                                    constant.setConstantValue(newConstantValue);
                                    
                                    // 注入URL常量的描述
                                    constant.setConstantDescription(newModelCName + constant.getConstantDescription());
                                }
                                
                            }
                        }
                    }
                    // 页面常量数据集处理完毕，结束循环
                    break;
                }
                
            }
        }*/
    }
    
  /**
  * 
  * 清除模板中其他额外的属性
  * 
  * 
  * @param templateVO 模板页面
  */
 private void clearOtherAttribute(PageTempVO templateVO) {
     templateVO.setPageModelId(null);
     templateVO.setPageModelName(null);
     templateVO.setPageModelPackage(null);
     templateVO.setPageModelType(null);
 }
    
    /**
     * 
     * @param constant url变量
     * @param newModelPackage 目标包路径
     * @param newModelName 目标模块英文名
     * @param newModelCName 目标模块中文名
     */
    private void changeUrlToNewValue(PageConstantVO constant,String newModelPackage,String newModelName,String newModelCName){
    	
    	CapMap option = constant.getConstantOption();
    	
    	String oldUrl = (String) option.get("url");
         // com.comtop.user.page.PersonListEditPag
        String oldModelId = (String) option.get("pageModelId");
    	 // 获得新url并注入
        String newUrl = getNewOptionURL(oldUrl, newModelPackage, newModelName);
        option.put("url", newUrl);
        
        // 获得新modelId并注入
        String newModelId = getNewModelId(oldModelId, newModelPackage, newModelName);
        option.put("pageModelId", newModelId);
        
        // 注入URL常量的constantValue
        String newConstantValue = getNewConstantValue(newUrl, constant.getConstantValue());
        constant.setConstantValue(newConstantValue);
        
        // 注入URL常量的描述
        constant.setConstantDescription(newModelCName + constant.getConstantDescription());
    
    }
    
//    /**
//     * 判断URL是否属于当前模块的URL
//     *
//     * @param pageModelId pageModelId
//     * @param pageList 页面集合
//     * @return 判断结果
//     */
//    private boolean isUrlNeedReplace(String pageModelId, List<Object> pageList) {
//    	PageTempVO objPageVO;
//    	for (Object object : pageList) {
//			objPageVO = (PageTempVO)object;
//			if(objPageVO.getPageModelId().equals(pageModelId)){
//				return true;
//			}
//		}
//    	return false;
//    }
    
    /**
     * 判断URL是否属于当前模块的URL
     *
     * @param url url
     * @param modelPackage 当前模块的package
     * @return 判断结果
     */
    private boolean isUrlBelongSelfModel(String url, String modelPackage) {
        int lastIndex = url.lastIndexOf("/"); // /lc/fmws/user/humanEdit.ac
        String rootPath_t = url.substring(0, lastIndex+1); // /lc/fmws/user/
        // modelPackage = com.comtop.lc.fmws.user
        String rootPath_s = PageUtil.getPageFilePath(modelPackage);
        if (rootPath_t.equals(rootPath_s)) {
            return true;
        }
        return false;
    }
    
    /**
     * 获取最新注入的选项中的URL
     *
     * @param oldURL 模板中的URL
     * @param modelPackage 新模块的<code>modelPackage</code>
     * @param modelName 模块英文名称
     * @return 需要注入的新URL
     */
    private String getNewOptionURL(String oldURL, String modelPackage, String modelName) {
        String urlHead = PageUtil.getPageFilePath(modelPackage);
        
        // 获取URL后半截，并且把首字母转换成大写
        int lastIndex = oldURL.lastIndexOf("/");
        String urlTail = oldURL.substring(lastIndex + 1);
        String tailFirstChar = urlTail.charAt(0) + "";
        urlTail = urlTail.replaceFirst("\\w", tailFirstChar.toUpperCase());
        
        // 获取modelName第一个字母
        String firstChar = modelName.charAt(0) + "";
        String newURL = urlHead + modelName.replaceFirst("\\w", firstChar.toLowerCase()) + urlTail;
        return newURL;
    }
    
    /**
     * 获取最新注入的URL对应的页面的<code>moldeId</code>
     *
     * 
     * @param oldModelId 原<code>modelId</code>
     * @param modelPackage 新模块的<code>modelPackage</code>
     * @param modelName 新的模块名称
     * @return 最新注入的URL对应的页面的<code>modelId</code>
     */
    private String getNewModelId(String oldModelId, String modelPackage, String modelName) {
        String head = modelPackage + ".page.";
        // oldModelId=com.comtop.user.page.PersonListEditPag
        int lastIndex = oldModelId.lastIndexOf(".");
        String tail = oldModelId.substring(lastIndex + 1);
        // 获取modelName第一个字母
        String firstChar = modelName.charAt(0) + "";
        return head + modelName.replaceFirst("\\w", firstChar.toUpperCase()) + tail;
    }
    
    /**
     * 获得URL类型常量的最新的<code>constantValue</code>
     *
     * @param newOptionUrl 新的选项中存储的url
     * @param oldConstantValue 原来的<code>constantValue</code>
     * @return 最新的<code>constantValue</code>
     */
    private String getNewConstantValue(String newOptionUrl, String oldConstantValue) {
        // 截取option中url的前半截
        String[] splitUrl = newOptionUrl.split("\\.ac");
        // 加个单引号
        String head = "'" + splitUrl[0];
        // 从原来的constantValue中截取.ac的后半截;只截取一次;正常情况下constantValue仅出现一次.ac，如："'/user/personListEditPag.ac'+'?pageMode=edit'"
        String[] splitConstantValue = oldConstantValue.split("\\.ac", 2);
        if (splitConstantValue.length >= 2) {
            String tail = splitConstantValue[1];
            // 重组
            return head + ".ac" + tail;
        }
        // 如果constantValue中没出现.ac，则直接返回最新option中的url
        return newOptionUrl;
    }
}
