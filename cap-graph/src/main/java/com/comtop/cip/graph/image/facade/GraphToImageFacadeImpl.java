/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用�?
 * 复制、修改或发布本软�?
 *****************************************************************************/

package com.comtop.cip.graph.image.facade;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FilenameFilter;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.graph.image.GraphToImageConstants;
import com.comtop.cip.graph.image.model.ImageVO;
import com.comtop.cip.graph.image.utils.GraphToImageUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 
 * 图形生成图片接口实现
 * 
 * @author duqi
 *
 */
@PetiteBean
public class GraphToImageFacadeImpl extends BaseFacade implements IGraphToImageFacade {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphToImageFacadeImpl.class);
    
    @Override
    public ImageVO getModuleStructImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.MODULE_STRUCTURE_GRAPH_BASEURL, rootUrl, cookieString);
    }
    
    @Override
    public ImageVO getModuleRelationImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.MODULE_RELA_GRAPH_BASEURL, rootUrl, cookieString);
    }
    
    @Override
    public ImageVO getResourceRelationImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.RESOURCE_RELA_GRAPH_BASEURL, rootUrl, cookieString);
    }
    
    @Override
    public ImageVO getLogicDeploymentImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.LOGIC_DEPLOYMENT_BASEURL, rootUrl, cookieString);
    }
    
    @Override
    public ImageVO getPhysicDeploymentImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.PHYSIC_DEPLOYMENT_BASEURL, rootUrl, cookieString);
    }
    
    @Override
    public ImageVO getERImage(String moduleId, String rootUrl, String cookieString) {
        return exportImage(moduleId, GraphToImageConstants.ER_GRAPH_BASEURL, rootUrl, cookieString);
    }
    
    /**
     * 导出图片方法
     * 
     * @param moduleId 模块ID
     * @param baseUrl 基本URL
     * @param rootUrl 路径 URL
     * @param cookieString cookies字符
     * @return 导出图片的位置
     */
    private ImageVO exportImage(String moduleId, String baseUrl, String rootUrl, String cookieString) {
        ImageVO objImageVO = new ImageVO();
        clearTmpImage();
        String url = rootUrl + baseUrl;
        if (StringUtils.isNotBlank(moduleId)) {
            if (baseUrl.contains("?")) {
                url += "&moduleId=" + moduleId;
            } else {
                url += "?moduleId=" + moduleId;
            }
        }
        File file = new File(GraphToImageConstants.TMP_IMAGE_DIR);
        if (!file.exists()) {
            file.mkdir();// 创建临时文件夹
        }
        
        String name = System.currentTimeMillis() + ".png";
        String imagePath = GraphToImageConstants.TMP_IMAGE_DIR + File.separator + name;
        GraphToImageUtil.execCommand(url, imagePath, cookieString);
        try {
            BufferedImage image = ImageIO.read(new FileInputStream(imagePath));
            objImageVO.setHigh(image.getHeight());
            objImageVO.setWidth(image.getWidth());
        } catch (FileNotFoundException e) {
            LOGGER.error("找不到图片", e);
        } catch (IOException e) {
            LOGGER.error("读取图片出错", e);
        }
        objImageVO.setImageName(name);
        objImageVO.setImagePath(imagePath);
        return objImageVO;
    }
    
    /**
     * 清除之前产生的临时文件
     */
    private void clearTmpImage() {
        String tmpDir = GraphToImageConstants.TMP_IMAGE_DIR;
        File file = new File(tmpDir);
        if (!file.exists()) {
            return;
        }
        
        File[] files = file.listFiles(new FilenameFilter() {
            
            @Override
            public boolean accept(File dir, String name) {
                return name.endsWith(".png");
            }
        });
        
        long currentTime = System.currentTimeMillis();
        for (int i = 0; i < files.length; i++) {
            File f = files[i];
            if (f.isDirectory()) {
                continue;
            }
            long time = f.lastModified();
            
            if (currentTime - time > 21600000) {// 超过6小时 //
                f.delete();
            }
        }
    }
    
}
