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
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.runtime.base.util.MyBatisSqlHelper;
import com.comtop.top.core.base.dao.CoreDAO;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.sys.accesscontrol.func.FuncConstants;
import com.comtop.top.sys.accesscontrol.func.facade.FuncAssembler;
import com.comtop.top.sys.accesscontrol.func.facade.FuncFacade;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;
import com.comtop.top.sys.accesscontrol.func.model.FuncVO;

/**
 * 生成TopFunc sql脚本文件处理类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月2日 许畅 新建
 */
public class GenerateTopFuncSqlFile extends CoreGenerateSqlFile {

	/**
	 * 构造方法
	 */
	public GenerateTopFuncSqlFile() {
		setSql(new StringBuffer());
	}

	/**
	 * FuncFacade
	 */
	private final FuncFacade funcFacade = AppContext.getBean(FuncFacade.class);

	/** 日志记录器 */
	private final static Logger LOG = LoggerFactory
			.getLogger(GenerateTopFuncSqlFile.class);

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
			// 组装生成top业务需要的FuncDTO
			FuncDTO objFuncDTO = getFuncDTO(pageVO);
			if (StringUtil.isNotEmpty(pageVO.getPageId())) {
				objFuncDTO.setFuncId(pageVO.getPageId());
				FuncDTO objOldFuncVO = funcFacade.getFuncVO(pageVO.getPageId());
				if (objOldFuncVO == null) {
					// 生成保存sql
					this.createTopFuncSaveSQL(objFuncDTO);
				} else {
					// 生成update sql
					this.createTopFuncUpdateSQL(objFuncDTO);
				}
			} else {
				// 生成保存sql
				this.createTopFuncSaveSQL(objFuncDTO);
			}

			String packageName = pageVO.getModelPackage();
			String fileName = getFileName(packageName, "_TopFunc.sql");
			// 生成sql脚本文件
			GenerateSQLfileUtils.writeResourceSqlFile(codePath, RESOURCE_PATH,
					packageName, fileName, getFileContent());

			LOG.info("已生成TopFunc sql脚本文件:" + fileName);
		}
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
				// 组装生成top业务需要的FuncDTO
				FuncDTO objFuncDTO = getFuncDTO(pageVO);
				if (StringUtil.isNotEmpty(pageVO.getPageId())) {
					objFuncDTO.setFuncId(pageVO.getPageId());
					FuncDTO objOldFuncVO = funcFacade.getFuncVO(pageVO
							.getPageId());

					if (objOldFuncVO == null) {
						// 生成保存sql
						this.createTopFuncSaveSQL(objFuncDTO);
					} else {
						// 生成update sql
						this.createTopFuncUpdateSQL(objFuncDTO);
					}
				} else {
					// 生成保存sql
					this.createTopFuncSaveSQL(objFuncDTO);
				}
			}
		}

		if (pageVO != null) {
			String packageName = pageVO.getModelPackage();
			String fileName = getFileName(packageName, "_TopFunc.sql");
			// 生成sql脚本文件
			GenerateSQLfileUtils.writeResourceSqlFile(codePath, RESOURCE_PATH,
					packageName, fileName, getFileContent());

			LOG.info("已生成TopFunc sql脚本文件:" + fileName);
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

		// 生成update sql语句
		if (objFuncVO.getFuncNodeType() == 3) {
			sql.append("\t UPDATE top_per_func a SET a.menu_id_full_path = '"
					+ objFuncVO.getMenuIdFullPath() + "' WHERE a.func_id = '"
					+ objFuncVO.getFuncId() + "'; \n");
			sql.append("\t UPDATE top_per_func a SET a.MENU_FULL_NAME = '\'||"
					+ objFuncVO.getFuncName() + " WHERE a.func_id = '"
					+ objFuncVO.getFuncId() + "'; \n");
		} else {
			sql.append("\t UPDATE top_per_func a SET a.menu_id_full_path = (SELECT b.menu_id_full_path||'/"
					+ objFuncVO.getFuncId()
					+ "' FROM top_per_func b WHERE b.func_id = a.parent_func_id) WHERE a.func_id = '"
					+ objFuncVO.getFuncId() + "'; \n");

			sql.append("\t UPDATE top_per_func a SET a.MENU_FULL_NAME = (SELECT b.MENU_FULL_NAME||'\'||'"
					+ objFuncVO.getFuncName()
					+ "' FROM top_per_func b WHERE b.func_id = a.parent_func_id) WHERE a.func_id = '"
					+ objFuncVO.getFuncId() + "'; \n");
		}
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

		if (funcVO == null)
			return;

		CoreDAO coreDAO = AppContext.getBean(CoreDAO.class);

		String mybatisSql = MyBatisSqlHelper.getSqlByNamespace(coreDAO
				.getFactory().openSession(coreDAO.getConnection()),
				"com.comtop.top.sys.accesscontrol.func.model.updateIdFullPath",
				this.beanConvertToMap(funcVO));
		System.out.println("mybatisSql:" + mybatisSql);

		if (funcVO.getCascadeForbidden() == 1) {
			sql.append("\t UPDATE top_per_func a SET a.status = '"
					+ funcVO.getStatus()
					+ "' WHERE a.FUNC_ID IN (SELECT b.FUNC_ID FROM top_per_func b START WITH b.parent_func_id = '"
					+ funcVO.getFuncId()
					+ "' CONNECT BY PRIOR b.func_id = b.parent_func_id); \n");
		}

		if (funcVO.getCascadeOpen() == 2) {
			sql.append("\t delete TOP_PER_ROLE_RESOURCE res where res.RESOURCE_TYPE_CODE='FUNC' and res.RESOURCE_ID='"
					+ funcVO.getFuncId() + "'; \n");
			sql.append("\t delete FROM TOP_PER_SUBJECT_RESOURCE R WHERE R.resource_id='"
					+ funcVO.getFuncId()
					+ "' AND R.resource_type_code='FUNC'; \n");
			sql.append("\t delete FROM TOP_PER_CUSTOM_MENU M WHERE M.MENU_ID IN ('"
					+ funcVO.getFuncId() + "'); \n");
		}

		// 更新TopFunc表
		updateRealFuncVO(funcVO);
	}

	/**
	 * @param funcVO
	 *            FuncVO
	 */
	private void updateRealFuncVO(FuncVO funcVO) {

		sql.append(createUpdateSQL(funcVO));

		if (funcVO.getFuncNodeType() == 3) {
			sql.append("\t UPDATE top_per_func a SET a.MENU_FULL_NAME = '\'||'"
					+ funcVO.getFuncName() + "' WHERE a.func_id = '"
					+ funcVO.getFuncId() + "'; \n");
		} else {
			sql.append("\t UPDATE top_per_func a SET a.MENU_FULL_NAME = (SELECT b.MENU_FULL_NAME||'\'||'"
					+ funcVO.getFuncName()
					+ "' FROM top_per_func b WHERE b.func_id = a.parent_func_id) WHERE a.func_id = '"
					+ funcVO.getFuncId() + "'; \n");
		}

		sql.append("\t UPDATE top_per_func a SET a.menu_full_name = (select b.name_path from (SELECT a.func_id, "
				+ "(SELECT menu_full_name FROM top_per_func WHERE func_id = '"
				+ funcVO.getFuncId()
				+ "')||sys_connect_by_path(func_name,'\\') name_path "
				+ "FROM top_per_func a START WITH a.parent_func_id = '"
				+ funcVO.getFuncId()
				+ "' "
				+ "CONNECT BY PRIOR a.func_id = a.parent_func_id ) b where a.func_id = b.func_id ) "
				+ "where a.func_id in (select func_id from top_per_func start with parent_func_id = '"
				+ funcVO.getFuncId()
				+ "' "
				+ "connect by prior func_id = parent_func_id); \n");
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
	static class GenerateSQLfileUtils {
		/**
		 * 构造函数
		 */
		private GenerateSQLfileUtils() {
		}

		/** 日志记录器 */
		private final static Logger LOGGER = LoggerFactory
				.getLogger(GenerateSQLfileUtils.class);

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
					+ "sql"
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
			String strPrjDir = fixPath(codeDir, true);
			String strDirPath = strPrjDir;
			strDirPath += fixPath(resourceDir, true);
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
	}

}
