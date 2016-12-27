<%
/**********************************************************************
 * 自动生成sql对象
 * 2005-08-01 李寿荣 新建
 **********************************************************************/
%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*,com.comtop.cip.jodd.db.DbManager" %>
<%@ page import="com.comtop.top.component.app.sna.RemoteCache"%>
<%@ page import="com.comtop.top.component.common.cache.CacheInterface"%>
<%@ page import="com.comtop.top.component.common.cache.CacheManager"%>




<%
	CacheInterface  objDataCache = CacheManager.getServiceInstance("default");   
	CacheInterface  objSessionCache = CacheManager.getServiceInstance("sessionShareCache");   
	String strTestString = "testCacheConnnect";
	boolean testDataCache = false;
	boolean testSessionCache = false;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try {
		//RemoteCache.put("testCacheConnnect_key", strTestString, 30);
		//String strCacheValue = (String) RemoteCache.get("testCacheConnnect_key");
		
		// 检测数据缓存
		objDataCache.setAttribute("testDataCacheConnnect_key", strTestString, 30);
		String strDataCacheValue = (String) objDataCache.getAttribute("testDataCacheConnnect_key");
		if (null != strDataCacheValue) {
		    testDataCache = true;
		}
		if (!testDataCache) {
		    out.println("false");
		}

		// 检测会话缓存
		objSessionCache.setAttribute("testSessionCacheConnnect_key", strTestString, 30);
		String strSessionCacheValue = (String) objSessionCache.getAttribute("testSessionCacheConnnect_key");
		if (null != strSessionCacheValue) {
		    testSessionCache = true;
		}
		if (!testSessionCache) {
		    out.println("false");
		}
	    
		// 检测数据库
	    conn = DbManager.getInstance().getConnectionProvider().getConnection();
	    stmt = conn.createStatement();
	    rs = stmt.executeQuery("select 1 from dual");
	    ResultSetMetaData metaData = rs.getMetaData();
	    int columnCount = metaData.getColumnCount();
	    if (columnCount > 0 && testDataCache&&testSessionCache) {
	        out.println("true");
	    } else {
	        out.println("false");
	    }
	} catch (Exception ex) {
	} finally {
	    if (rs != null) {
	        rs.close();
	        rs = null;
	    }
	    if (stmt != null) {
	        stmt.close();
	        stmt = null;
	    }
	    if (conn != null) {
	        conn.close();
	        conn = null;
	    }
	}
 %> 
