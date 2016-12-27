/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.sqlfile;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.soareg.ISoaServiceManager;
import com.comtop.cap.bm.metadata.soareg.SoaServiceFactory;
import com.comtop.cap.runtime.base.util.MyBatisSqlHelper;
import com.comtop.corm.session.SqlSession;
import com.comtop.top.core.base.dao.CoreDAO;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.DateTimeUtil;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.sys.accesscontrol.func.FuncConstants;
import com.comtop.top.sys.accesscontrol.func.facade.FuncAssembler;
import com.comtop.top.sys.accesscontrol.func.facade.FuncFacade;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;
import com.comtop.top.sys.accesscontrol.func.model.FuncVO;

/**
 * 生成TopFunc sql脚本文件(根据mybatis文件id生成 sql)
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月2日 许畅 新建
 */
public class GenFuncSqlFileBestWay extends CoreGenerateSqlFile {

	/**
	 * GenFuncSqlFileBestWay构造方法
	 */
	public GenFuncSqlFileBestWay() {
		setSql(new StringBuffer());
	}

	/**
	 * FuncFacade
	 */
	private final FuncFacade funcFacade = AppContext.getBean(FuncFacade.class);

	/** 日志记录器 */
	private final static Logger LOG = LoggerFactory
			.getLogger(GenFuncSqlFileBestWay.class);

	/** mybatis SqlSession */
	private static SqlSession sqlSession;

	/** 更新Func表的IdFullPath mybatis id */
	private static final String UPDATEIDFULLPATH_ID = "com.comtop.top.sys.accesscontrol.func.model.updateIdFullPath";

	/** 更新Func表NameFullPath mybatis id */
	private static final String UPDATENAMEFULLPATH_ID = "com.comtop.top.sys.accesscontrol.func.model.updateNameFullPath";

	/** 更新子节点状态 mybatis id */
	private static final String UPDATECHILDSTATUS_ID = "com.comtop.top.sys.accesscontrol.func.model.updateChildStatus";

	/** 删除角色资源文件id mybatis id */
	private static final String DELETEROLERESOURCE_ID = "com.comtop.top.sys.accesscontrol.role.model.deleteRoleResourceResourceId";

	/** 删除目录资源文件id mybatis id */
	private static final String DELETESUBJECTRESOURCE_ID = "com.comtop.top.sys.accesscontrol.userdelegate.model.deleteSubjectResouceByResourceId";

	/** 删除自定义菜单mybatis id */
	private static final String DELETECUSTOMMENU_ID = "com.comtop.top.sys.accesscontrol.func.model.deleteCustomMenuByMenuIdAndUserId";

	/** 更新子节点名称FullPath mybatis id */
	private static final String UPDATECHILDNAMEFULLPATH_ID = "com.comtop.top.sys.accesscontrol.func.model.updateChildNameFullPath";

	static {
		@SuppressWarnings("rawtypes")
		CoreDAO coreDAO = AppContext.getBean(CoreDAO.class);
		sqlSession = coreDAO.getFactory().openSession(coreDAO.getConnection());
	}

	/**
	 * 批量生成
	 *
	 * @param list
	 *            list
	 * @param codePath
	 *            生成代码路径
	 */
	@Override
	public <M extends BaseMetadata> void createBatchOptSQLfile(List<M> list,
			String codePath) {
		PageVO pageVO = null;
		for (M m : list) {
			pageVO = (PageVO) m;
			if (StringUtil.isNotEmpty(pageVO.getParentId())) {
				// 组装生成topFuncSQL
				this.createTopFuncSQL(pageVO);
			}
		}

		if (pageVO != null) {
			String packageName = pageVO.getModelPackage();
			String fileName = getFileName(packageName, "_TopFunc.sql");
			String content = getFileContent();
			// 生成sql脚本文件
			GenerateSQLfileUtils.writeResourceSqlFile(codePath, RESOURCE_PATH,
					packageName, fileName, content);
			LOG.info("已生成TopFunc sql脚本文件:" + fileName);

			GenerateSQLfileUtils.executeProcedureSql(sql.toString());
			LOG.info("已完成TopFunc调用soa远程服务...");
		}
	}

	/**
	 * 生成数据脚本
	 * 
	 * @param codePath
	 *            codePath
	 */
	@Override
	public <M extends BaseMetadata> void createDataOptSQLfile(M metadataVO,
			String codePath) {
		PageVO pageVO = (PageVO) metadataVO;

		if (StringUtil.isNotEmpty(pageVO.getParentId())) {
			// 组装生成topFuncSQL
			this.createTopFuncSQL(pageVO);

			String modelPackage = pageVO.getModelPackage();
			String fileName = getFileName(pageVO.getModelName(), "_TopFunc.sql");
			// 生成sql脚本文件
			GenerateSQLfileUtils.writeResourceSqlFile(codePath, RESOURCE_PATH,
					modelPackage, fileName, getFileContent());
			LOG.info("已生成TopFunc sql脚本文件:" + fileName);

			GenerateSQLfileUtils.executeProcedureSql(sql.toString());
			LOG.info("已完成TopFunc调用soa远程服务...");
		}
	}

	/**
	 * 组装生成topFuncSQL
	 * 
	 * @param pageVO
	 *            PageVO
	 */
	private void createTopFuncSQL(PageVO pageVO) {
		// 组装生成top业务需要的FuncDTO
		FuncDTO objFuncDTO = getFuncDTO(pageVO);
		if (StringUtil.isNotEmpty(pageVO.getPageId())) {
			objFuncDTO.setFuncId(pageVO.getPageId());
			FuncDTO objOldFuncVO = funcFacade.getFuncVO(pageVO.getPageId());
			if (objOldFuncVO == null) {
				// 生成保存sql
				this.createTopFuncSaveSQL(objFuncDTO);
			} else {
				//生成insert sql语句
				this.createTopFuncSaveSQL(objFuncDTO);
				// 生成update sql
				this.createTopFuncUpdateSQL(objFuncDTO);
			}
		} else {
			// 生成保存sql
			objFuncDTO.setCreateTime(DateTimeUtil.formatDateTime(new Date()));
			objFuncDTO.setCreatorId(pageVO.getCreaterId());
			this.createTopFuncSaveSQL(objFuncDTO);
		}
	}

	/**
	 * 创建保存SQL脚本
	 * 
	 * @param objFuncDTO
	 *            objFuncDTO
	 */
	protected void createTopFuncSaveSQL(FuncDTO objFuncDTO) {
		// DTO转为VO
		FuncVO funcVO = createVOByDTO(objFuncDTO);

		if (funcVO == null)
			return;

		// 生成insert sql语句
		String strFuncId = this.createInsertSQL(funcVO);

		// 组装成top业务需要的 FuncVO
		FuncVO objFuncVO = getFuncVO(funcVO, strFuncId);

		if (sqlSession == null)
			return;

		// updateIdFullPath
		String updateIdFullPath = MyBatisSqlHelper.getSqlByNamespace(sqlSession,
				UPDATEIDFULLPATH_ID, objFuncVO);
		sql.append("\t" + updateIdFullPath + "; \n");

		// updateNameFullPath
		String updateNameFullPath = MyBatisSqlHelper.getSqlByNamespace(
				sqlSession, UPDATENAMEFULLPATH_ID, objFuncVO);
		sql.append("\t" + updateNameFullPath + "; \n");
	}

	/**
	 * 创建更新sql脚本
	 * 
	 * @param objFuncDTO
	 *            objFuncDTO
	 */
	protected void createTopFuncUpdateSQL(FuncDTO objFuncDTO) {
		// DTO转VO
		FuncVO funcVO = assemblerToVO(objFuncDTO);

		if (funcVO == null || sqlSession == null)
			return;

		if (funcVO.getCascadeForbidden() == 1) {
			// 更新子节点状态
			String updateChildStatus = MyBatisSqlHelper.getSqlByNamespace(
					sqlSession, UPDATECHILDSTATUS_ID, funcVO);
			sql.append("\t" + updateChildStatus + "; \n");
		}

		if (funcVO.getCascadeOpen() == 2) {
			Map<String, String> objRoleResourceMap = new HashMap<String, String>();
			objRoleResourceMap.put("resourceTypeCode", "FUNC");
			objRoleResourceMap.put("resourceId", funcVO.getFuncId());
			// 删除角色资源文件
			String deleteRoleResourceResourceId = MyBatisSqlHelper
					.getSqlByNamespace(sqlSession, DELETEROLERESOURCE_ID,
							objRoleResourceMap);
			sql.append("\t" + deleteRoleResourceResourceId + "; \n");

			// 删除目录资源文件
			String deleteSubjectResouceByResourceId = MyBatisSqlHelper
					.getSqlByNamespace(sqlSession, DELETESUBJECTRESOURCE_ID,
							objRoleResourceMap);
			sql.append("\t" + deleteSubjectResouceByResourceId + "; \n");

			// 删除自定义菜单
			String[] strFuncIds = { funcVO.getFuncId() };
			Map<String, Object> objParam = new HashMap<String, Object>(2);
			objParam.put("menuIds", strFuncIds);
			objParam.put("userId", null);
			String deleteCustomMenuByMenuIdAndUserId = MyBatisSqlHelper
					.getSqlByNamespace(sqlSession, DELETECUSTOMMENU_ID, objParam);
			sql.append("\t" + deleteCustomMenuByMenuIdAndUserId + "; \n");
		}

		// 更新TopFunc表
		updateRealFuncVO(funcVO);
	}

	/**
	 * @param funcVO
	 *            FuncVO
	 */
	private void updateRealFuncVO(FuncVO funcVO) {

		// 全部更新Func表
		sql.append(createUpdateSQL(funcVO));

		// 更新Func表NameFullPath
		String updateNameFullPath = MyBatisSqlHelper.getSqlByNamespace(
				sqlSession, UPDATENAMEFULLPATH_ID, funcVO);
		sql.append("\t" + updateNameFullPath + "; \n");

		// 更新子节点名称FullPath
		String updateChildNameFullPath = MyBatisSqlHelper.getSqlByNamespace(
				sqlSession, UPDATECHILDNAMEFULLPATH_ID, funcVO);
		sql.append("\t" + updateChildNameFullPath + "; \n");
	}

	/**
	 * @param pageVO
	 *            PageVO
	 * @return FuncDTO
	 */
	private FuncDTO getFuncDTO(PageVO pageVO) {
		FuncDTO objParentFuncDTO = funcFacade.getFuncVO(pageVO.getParentId());
		FuncDTO objFuncDTO = new FuncDTO();
		objFuncDTO.setParentFuncId(objParentFuncDTO.getFuncId());
		objFuncDTO.setParentFuncName(objParentFuncDTO.getFuncName());
		objFuncDTO.setParentFuncCode(objParentFuncDTO.getFuncCode());
		objFuncDTO.setFuncNodeType(pageVO.isHasMenu() ? FuncConstants.FUNC_MENU
				: FuncConstants.FUNC_PAGE);
		objFuncDTO.setPermissionType(objParentFuncDTO.getPermissionType());
		if (pageVO.isHasMenu()) {
			objFuncDTO.setFuncTag(pageVO.getMenuType());
			objFuncDTO.setFuncName(pageVO.getMenuName());
		} else {
			objFuncDTO.setFuncName(pageVO.getCname());
		}
		objFuncDTO
				.setPermissionType(pageVO.isHasPermission() ? FuncConstants.NEED_ASSIGN_PERMISSTION
						: FuncConstants.OPEN_PERMISSION);
		objFuncDTO.setFuncCode(pageVO.getCode());
		objFuncDTO.setFuncUrl(pageVO.getUrl());
		objFuncDTO.setDescription(pageVO.getDescription());
		objFuncDTO.setStatus(1);
		return objFuncDTO;
	}

	/**
	 * @param funcVO
	 *            FuncVO
	 * @param strFuncId
	 *            主键
	 * @return FuncVO top业务需要的FuncVO
	 */
	private FuncVO getFuncVO(FuncVO funcVO, String strFuncId) {
		FuncVO objFuncVO = new FuncVO();
		objFuncVO.setFuncId(strFuncId);
		objFuncVO.setFuncName(funcVO.getFuncName());
		objFuncVO.setFuncNodeType(funcVO.getFuncNodeType());

		if (funcVO.getFuncNodeType() == 3) {
			StringBuilder sbIdFullPath = new StringBuilder(200);
			sbIdFullPath.append("/").append(strFuncId);
			StringBuilder sbNameFullPath = new StringBuilder(200);
			sbNameFullPath.append("\\").append(funcVO.getFuncName());
			objFuncVO.setMenuIdFullPath(sbIdFullPath.toString());
			objFuncVO.setMenuFullName(sbNameFullPath.toString());
		}
		return objFuncVO;
	}

	/**
	 * @param objFuncDTO
	 *            FuncDTO
	 * @return FuncVO
	 */
	private FuncVO createVOByDTO(FuncDTO objFuncDTO) {
		FuncAssembler funcAssembler = new FuncAssembler();
		FuncVO funcVO = funcAssembler.createVOByDTO(objFuncDTO);

		if (funcVO.getFuncNodeType() != 3) {
			funcVO.setSortNo(getMaxSortNo(funcVO) + 1);
		}

		return funcVO;
	}

	/**
	 * @param funcVO
	 *            FuncVO
	 * @return int
	 */
	@SuppressWarnings("rawtypes")
	private int getMaxSortNo(FuncVO funcVO) {
		CoreDAO coreDAO = new CoreDAO();
		return ((Integer) coreDAO.selectOne(
				"com.comtop.top.sys.accesscontrol.func.model.queryMaxSortNo",
				funcVO)).intValue();
	}

	/**
	 * @param objFuncDTO
	 *            FuncDTO
	 * @return FuncVO FuncVO
	 */
	private FuncVO assemblerToVO(FuncDTO objFuncDTO) {
		FuncAssembler funcAssembler = new FuncAssembler();
		return funcAssembler.createVOByDTO(objFuncDTO);
	}

	/**
	 * GenerateSQLfileUtils
	 * 
	 * @author 许畅
	 * @since JDK1.6
	 * @version 2016年3月2日 许畅 新建
	 */
	private static class GenerateSQLfileUtils {
		/**
		 * 构造函数
		 */
		private GenerateSQLfileUtils() {
		}

		/** 日志记录器 */
		private final static Logger LOGGER = LoggerFactory
				.getLogger(GenerateSQLfileUtils.class);
		
		/** SQL文件路径前缀 */
		private static final String SQL_FILE_PATH_PREFIX = "\\sql\\[1]default";

		/** 前缀业务名称 */
		private static final String PREFIX_BUSINESS = "\\[6]business";

		/**
		 * 生成实体相关sql文件
		 * 
		 * @param projectPath
		 *            前端配置的项目路径
		 * @param resourcePath
		 *            资源文件路径
		 * @param pkgPath
		 *            包路径
		 * @param fileName
		 *            文件名称
		 * @param fileContent
		 *            文件内容
		 * 
		 */
		public static void writeResourceSqlFile(String projectPath,
				String resourcePath, String pkgPath, String fileName,
				String fileContent) {
			// 根据实体生成实体注册SOA的SQL脚本
			File objSqlFile = getFile(projectPath, resourcePath, pkgPath,
					fileName);
			writeFile(objSqlFile, fileContent);
		}

		/**
		 * 根据实体VO获取模型文件
		 * 
		 * @param projectPath
		 *            前端配置的项目路径
		 * @param resourcePath
		 *            资源文件路径
		 * @param pkgPath
		 *            包路径
		 * @param fileName
		 *            文件名称
		 * @return 文件
		 */
		private static File getFile(String projectPath, String resourcePath,
				String pkgPath, String fileName) {
			String strPkgPath = pkgPath.replace(".", "/");
			String strFilePath = getDirectory(projectPath, resourcePath,
					strPkgPath)
					+ File.separator
					+ File.separator
					+ fileName;
			return new File(strFilePath);
		}

		/**
		 * 获取目标文件的目录
		 * 
		 * 
		 * @param codeDir
		 *            项目所在目录
		 * @param resourceDir
		 *            资源文件路径
		 * @param pkgFullPath
		 *            包路径
		 * @return 目标文件所在目录
		 */
		private static String getDirectory(final String codeDir,
				final String resourceDir, final String pkgFullPath) {
			DBType dbType = DBTypeAdapter.getDBType();
			String strPrjDir = fixPath(codeDir + SQL_FILE_PATH_PREFIX + "\\"+dbType.getValue() + PREFIX_BUSINESS, true);
	        String strDirPath = strPrjDir;
			// strDirPath += CapCodegenUtils.fixPath(resourceDir, true);
	        strDirPath += pkgFullPath;
	        return strDirPath;
		}

		/**
		 * 修正路径(将路径中双斜杠转换为反斜杠，并在目录末尾加上反斜杠)
		 * 
		 * @param path
		 *            原路径
		 * @param toDir
		 *            是否转为目录路径
		 * @return 修正后的路径
		 */
		public static String fixPath(final String path, final boolean toDir) {
			String strTempPath = path.replace('\\', '/');
			strTempPath = strTempPath.startsWith("/") ? strTempPath
					.substring(1) : strTempPath;
			if (toDir && !strTempPath.endsWith("/")) {
				return strTempPath + "/";
			}
			return strTempPath;
		}

		/**
		 * 将字符串写入文件
		 * 
		 * @param dest
		 *            写入文件
		 * @param file
		 *            写入文件内容
		 */
		private static void writeFile(File dest, String file) {
			// 如果当前目录不存在则创建
			if (!dest.getParentFile().exists()) {
				dest.getParentFile().mkdirs();
			}
			BufferedWriter objWriter = null;
			try {
				if (!dest.canWrite()) {
					dest.setWritable(true);
				}
				objWriter = new BufferedWriter(new OutputStreamWriter(
						new FileOutputStream(dest), "utf-8"));
				objWriter.write(file);
				objWriter.flush();
				objWriter.close();
			} catch (FileNotFoundException e) {
				LOGGER.error(e.getMessage());
			} catch (IOException e) {
				LOGGER.error(e.getMessage());
			} finally {
				try {
					if (objWriter != null) {
						objWriter.close();
					}
				} catch (IOException e) {
					LOGGER.error(e.getMessage());
				}
			}
		}

		/**
		 * 注册soa服务 执行sql
		 * 
		 * @param sqlContent
		 *            sql脚本
		 */
		public static void executeProcedureSql(String sqlContent) {
			ISoaServiceManager iSoaServiceManager = SoaServiceFactory.getSoaServiceExecutor();
			iSoaServiceManager.registerSoaSql(sqlContent);
			// 通过soa远程调用，执行soa服务注册脚本
			String sid = "capSoaExtendFacade.registerEntitySoaSql";
			iSoaServiceManager.callSoaRemoteService(sid, sqlContent);
		}
	}

}
