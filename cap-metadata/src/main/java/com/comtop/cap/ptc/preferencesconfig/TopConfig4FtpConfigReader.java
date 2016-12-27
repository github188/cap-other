/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.preferencesconfig;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.apache.commons.net.ftp.FTPClient;

import com.comtop.cap.component.loader.config.IFtpConfigReader;
import com.comtop.cap.component.loader.config.LoaderConfig;
import com.comtop.cap.component.loader.util.ApacheFtpUtil;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.cfg.client.facade.ClientConfigFacade;
import com.comtop.top.cfg.model.ClientConfigItemVO;
import com.comtop.top.core.jodd.AppContext;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * @author luozhenming
 *
 */
@DwrProxy
public class TopConfig4FtpConfigReader implements IFtpConfigReader {

	/***/
	private static final String CAP_CDP_HTTP_BASEPATH = "cap_cdp_http_basepath";
	/***/
	private static final String CAP_CDP_FILE_VISIT_URL = "cap_cdp_file_visit_url";
	/***/
	private static final String CAP_CDP_FTP_BASEPATH = "cap_cdp_ftp_basepath";
	/***/
	private static final String CAP_CDP_FTP_ENCODING = "cap_cdp_ftp_encoding";
	/***/
	private static final String CAP_FILE_UPLOAD_TYPE = "cap_file_upload_type";
	
	/***/
	private static final String CAP_CDP_FTP_USERNAME = "cap_cdp_ftp_username";
	/***/
	private static final String CAP_CDP_FTP_PORT = "cap_cdp_ftp_port";
	/***/
	private static final String CAP_CDP_FTP_IP = "cap_cdp_ftp_ip";
	/***/
	private static final String CAP_CDP_FTP_PASSWD = "cap_cdp_ftp_passwd";
	
	/***/
	private final Map<String,String> codeNameMap = new HashMap<String,String>();
	
	{
		codeNameMap.put(CAP_CDP_FTP_IP, "FTP服务IP");
		codeNameMap.put(CAP_CDP_FTP_PORT, "FTP服务端口");
		codeNameMap.put(CAP_CDP_FTP_USERNAME, "FTP服务用户名");
		codeNameMap.put(CAP_CDP_FTP_PASSWD, "FTP服务用户密码");
		codeNameMap.put(CAP_FILE_UPLOAD_TYPE, "文档管理文件上传方式（取值ftp或http）");
		codeNameMap.put(CAP_CDP_FTP_ENCODING, "FTP服务文件字符集");
		codeNameMap.put(CAP_CDP_FTP_BASEPATH, "FTP服务根目录");
		codeNameMap.put(CAP_CDP_FILE_VISIT_URL, "上传文件访问URL");
		codeNameMap.put(CAP_CDP_HTTP_BASEPATH, "HTTP服务上传文件目录");
	}
	
	/****
	 * # http
	upload.fileStoreType=ftp
	http.basepath=/http/uplod

	# ftp
	#ftp host
	ftp.host=10.10.5.223
	ftp.username=admin
	ftp.password=admin
	ftp.port=2121
	ftp.encoding=UTF-8
	ftp.basepath=/

	#visit http url
	visitUrl=http://10.10.5.223:8090/cap-ftp
	 */
	 
	/**
     * 数据字典facade
     */
    protected ClientConfigFacade configFacade = AppContext.getBean(ClientConfigFacade.class);
	
	/* (non-Javadoc)
	 * @see com.comtop.cap.component.loader.config.IFtpConfigReader#readFtpConfig()
	 */
	@Override
	public Properties readFtpConfig() {
		
		Map<String, String> topConfig = readFtpConfigFromTopConfig();
		
		Properties prop = new Properties();
		//# http
		prop.setProperty("upload.fileStoreType", topConfig.get(CAP_FILE_UPLOAD_TYPE));
		prop.setProperty("http.basepath", topConfig.get(CAP_CDP_HTTP_BASEPATH));
		
		//# ftp
		String strFtpUserName = topConfig.get(CAP_CDP_FTP_USERNAME);
		String strFtpPsd = topConfig.get(CAP_CDP_FTP_PASSWD);
		String strFtpIp = topConfig.get(CAP_CDP_FTP_IP);
		
		prop.setProperty("ftp.host", strFtpIp);
		prop.setProperty("ftp.username", strFtpUserName);
		prop.setProperty("ftp.password", strFtpPsd);
		prop.setProperty("ftp.port", topConfig.get(CAP_CDP_FTP_PORT));
		
		prop.setProperty("ftp.encoding", topConfig.get(CAP_CDP_FTP_ENCODING));
		prop.setProperty("ftp.basepath", topConfig.get(CAP_CDP_FTP_BASEPATH));
		
		//#visit http url
		prop.setProperty("visitUrl", topConfig.get(CAP_CDP_FILE_VISIT_URL));
		return prop;
	}
	
	 
    /**
     * 读取ftp配置
     *  
     * @return ftp配置
     */
    @RemoteMethod
    public Map<String, String> readFtpConfigFromTopConfig() {
    	
    	Map<String,String> configMap = new HashMap<String, String>(15);
    	
    	//# ftp
    	String strFtpUserName = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_USERNAME);
    	configMap.put(CAP_CDP_FTP_USERNAME, strFtpUserName);
    			
    	String strFtpPsd = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_PASSWD);
    	configMap.put(CAP_CDP_FTP_PASSWD, strFtpPsd);
    	
    	String strFtpIp = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_IP);
    	configMap.put(CAP_CDP_FTP_IP, strFtpIp);
    	
    	String strFtpPort = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_PORT);
    	strFtpPort = StringUtil.isBlank(strFtpPort)?FTP_DEFAULT_VALUE_PORT:strFtpPort;
		configMap.put(CAP_CDP_FTP_PORT, strFtpPort);
   			
		String strUploadType = configFacade.getBaseStringConfigValue(CAP_FILE_UPLOAD_TYPE);
		strUploadType = StringUtil.isBlank(strUploadType)?FTP_DEFAULT_FILE_UPLOAD_TYPE:strUploadType;
    	configMap.put(CAP_FILE_UPLOAD_TYPE, strUploadType);
    			
    	String strFtpEncoding = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_ENCODING);
    	strFtpEncoding = StringUtil.isBlank(strFtpEncoding)?FTP_DEFAULT_VALUE_ENCODING:strFtpEncoding;
    	configMap.put(CAP_CDP_FTP_ENCODING, strFtpEncoding);
    			
    	String strFtpBasePath = configFacade.getBaseStringConfigValue(CAP_CDP_FTP_BASEPATH);
    	strFtpBasePath = StringUtil.isBlank(strFtpBasePath)?FTP_DEFAULT_VALUE_FTP_BASEPATH:strFtpBasePath;
    	configMap.put(CAP_CDP_FTP_BASEPATH, strFtpBasePath);
    			
    	String strFileVisitUrl = configFacade.getBaseStringConfigValue(CAP_CDP_FILE_VISIT_URL);
    	configMap.put(CAP_CDP_FILE_VISIT_URL, strFileVisitUrl);
    			
    	String strHttpBasePath = configFacade.getBaseStringConfigValue(CAP_CDP_HTTP_BASEPATH);
    	strHttpBasePath = StringUtil.isBlank(strHttpBasePath)?FTP_DEFAULT_VALUE_HTTP_BASEPATH:strHttpBasePath;
    	configMap.put(CAP_CDP_HTTP_BASEPATH, strHttpBasePath);
    			
    	return configMap;
    }
    
    /**
     * 保存ftp配置
     * 
     * @param config ftp配置
     * @return true 成功 false 失败
     */
    @RemoteMethod
    public boolean saveFtpConfig(Map<String,String> config) {
    	for (Entry<String,String> configItem: config.entrySet()) {
    		ClientConfigItemVO  objConfig = configFacade.queryBaseConfigItemVO(configItem.getKey());
    		if(objConfig == null){
    			objConfig = new ClientConfigItemVO();
    			objConfig.setActionType(ClientConfigItemVO.ACTION_TYPE_ADD);
    			objConfig.setClassifyFullCode("capruntime");//系统模块中“CAP运行时”的module_code的属性值
    			objConfig.setConfigItemDescription(codeNameMap.get(configItem.getKey()));
    			objConfig.setConfigItemFullCode(configItem.getKey());
    			objConfig.setConfigItemName(codeNameMap.get(configItem.getKey()));
    			objConfig.setConfigItemType("0");//0 表示top配置中字符串类型
    			objConfig.setConfigItemValue(configItem.getValue());
    			configFacade.saveBaseConfigItem(objConfig);
    		}else{
    			objConfig.setConfigItemValue(configItem.getValue());
    			configFacade.updateBaseConfigItem(new ClientConfigItemVO[]{objConfig});
    		}
		}
        return true;
    }

    /***
	 * 测试ftp服务器连接
	 * @param map 连接配置
	 * @return 连接结果
	 */
	@RemoteMethod
	public boolean testFtpConnect(Map<String,String> map){
		 LoaderConfig config = new LoaderConfig();
		 config.setHost(map.get(CAP_CDP_FTP_IP));
		 config.setPort(Integer.parseInt(map.get(CAP_CDP_FTP_PORT)));
		 config.setUsername(map.get(CAP_CDP_FTP_USERNAME));
		 config.setPassword(map.get(CAP_CDP_FTP_PASSWD));
		 config.setEncoding(map.get(CAP_CDP_FTP_ENCODING));
		 config.setMainDirectory(map.get(CAP_CDP_FTP_BASEPATH));
		 FTPClient ftpClient=null;
		try {
			ftpClient = ApacheFtpUtil.openFtpClient(config);
		} catch (Exception e) {
			return false;
		}
		ApacheFtpUtil.closeServer(ftpClient);
		return true;
	}
}
