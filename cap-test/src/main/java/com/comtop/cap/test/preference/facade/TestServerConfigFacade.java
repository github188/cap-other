
package com.comtop.cap.test.preference.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.preferencesconfig.facade.PreferencesFacade;
import com.comtop.cap.bm.metadata.preferencesconfig.model.PreferenceConfigVO;
import com.comtop.cap.bm.metadata.preferencesconfig.model.PreferencesFileVO;
import com.comtop.cap.test.robot.FileUploader;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 测试服务器配置
 *
 * <pre>
 * [调用关系:
 * 实现接口及父类:
 * 子类:
 * 内部类列表:
 * ]
 * </pre>
 *
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年6月22日 章尊志
 */
@DwrProxy
@PetiteBean
public class TestServerConfigFacade {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(TestServerConfigFacade.class);
    
    /** 测试服务url */
    public final static String SERVER_URL = "serverUrl";
    
    /** 测试服务name */
    public final static String SERVER_NAME = "serverName";
    
    /** 测试服务PassWord */
    public final static String SERVER_PASSWORD = "serverPassword";
    
    /** 环境变量首选项facade类 */
    @PetiteInject
    protected PreferencesFacade preferencesFacade;
    
    /**
     * 测试服务器的连通性
     * 
     * @param url 测试服务器地址
     * @param name 测试服务器用户名
     * @param password 测试服务器密码
     * @return 成功或失败
     */
    @RemoteMethod
    public boolean testConnect(String url, String name, String password) {
        boolean bRet = false;
        try {
            FileUploader uploader = FileUploader.getInstance(url, name, password);
            bRet = uploader.testConenction();
        } catch (Exception e) {
            logger.error("连接ftp服务器出错！", e);
        }
        
        return bRet;
    }
    
    /**
     * 获取测试服务配置信息
     * 
     * @return Map服务配置的MAP
     */
    public Map<String, String> getServerConfig() {
        Map<String, String> objServerConfig = new HashMap<String, String>();
        PreferencesFileVO objPreferencesFileVO = preferencesFacade.getCustomPreferencesFileVO();
        List<PreferenceConfigVO> configs = objPreferencesFileVO.getSubConfig();
        for (PreferenceConfigVO configVO : configs) {
            if (configVO.getConfigKey().equals(SERVER_URL)) {
                objServerConfig.put(configVO.getConfigKey(), configVO.getConfigValue());
            } else if (configVO.getConfigKey().equals(SERVER_NAME)) {
                objServerConfig.put(configVO.getConfigKey(), configVO.getConfigValue());
            } else if (configVO.getConfigKey().equals(SERVER_PASSWORD)) {
                objServerConfig.put(configVO.getConfigKey(), configVO.getConfigValue());
            }
        }
        return objServerConfig;
    }
}
