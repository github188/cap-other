/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.editor.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cip.graph.editor.model.DeployDiagramVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;
import com.comtop.top.sys.module.appservice.ModuleAppService;
import com.comtop.top.sys.module.model.ModuleVO;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 部署图 业务逻辑处理类 门面
 * 
 * @author 缪柏年
 * @since 1.0
 * @version 2015-9-15 缪柏年
 */
@DwrProxy
@PetiteBean
public class DeployDiagramFacade extends BaseFacade {
	
	/** 实体属性DAO */
	@PetiteInject
	protected ModuleAppService moduleAppService;

	/**
	 * 保存 部署图
	 * 
	 * @param deployDiagramVO
	 *            部署图对象
	 * @return 新增结果
	 * @throws ValidateException
	 *             验证异常
	 */
	@RemoteMethod
	public boolean saveModel(final DeployDiagramVO deployDiagramVO)
			throws ValidateException {
		boolean bResult = false;
		String strModelId = deployDiagramVO.getModelId();
		if (strModelId == null) {// 新增
			ModuleVO objModuleVO = moduleAppService
					.readModuleVO(deployDiagramVO.getModuleId());
			if (objModuleVO != null) {
				String strName = objModuleVO.getShortName();
				String strModelPackage = strName + "." + deployDiagramVO.getDiagramType();
				deployDiagramVO.setModelPackage(strModelPackage);
				strModelId = strModelPackage + "."
						+ deployDiagramVO.getModelType() + "."
						+ deployDiagramVO.getModelName();
				deployDiagramVO.setModelId(strModelId);
			}
		}
		bResult = deployDiagramVO.saveModel();
		return bResult;
	}

	/**
	 * 验证VO对象
	 *
	 * @param deployDiagramVO
	 *            被校验对象
	 * @return 结果集
	 * @throws OperateException
	 *             操作异常
	 */
	// @RemoteMethod
	// public ValidateResult<DeployDiagramVO> validate(
	// DeployDiagramVO deployDiagramVO) throws OperateException {
	// ValidateResult<DeployDiagramVO> objValidateResult = null;
	// // 新增
	// if (deployDiagramVO.getDiagramId() == null) {
	// boolean bResult = this.isExistNewModelName(
	// deployDiagramVO.getModelPackage(),
	// deployDiagramVO.getModelType(),
	// deployDiagramVO.getModelName());
	// if (bResult) {
	// Set<ConstraintViolation<DeployDiagramVO>> objConstraintViolations = new
	// HashSet<ConstraintViolation<DeployDiagramVO>>();
	// ConstraintViolation<DeployDiagramVO> objConstraintViolation = new
	// ConstraintViolationImpl<DeployDiagramVO>(
	// null, "部署图名称重复！", null, null, null, null, null, null,
	// null);
	// objConstraintViolations.add(objConstraintViolation);
	// objValidateResult = new ValidateResult<DeployDiagramVO>(
	// objConstraintViolations);
	// }
	// }
	// if (objValidateResult != null) {
	// Set<ConstraintViolation<DeployDiagramVO>> objConstraintViolations =
	// ValidatorUtil
	// .validate(deployDiagramVO).getConstraintViolation();
	// objValidateResult.getConstraintViolation().addAll(
	// objConstraintViolations);
	// } else {
	// objValidateResult = ValidatorUtil.validate(deployDiagramVO);
	// }
	// return objValidateResult;
	// }

	/**
	 * 删除模型
	 *
	 * @param deployDiagramVO
	 *            被删除的对象
	 * @return 是否删除成功
	 * @throws OperateException
	 *             操作异常
	 */
	@RemoteMethod
	public boolean deleteModel(DeployDiagramVO deployDiagramVO)
			throws OperateException {
		return deployDiagramVO.deleteModel();
	}

	/**
	 * 通过模块ID查询部署图对象
	 * 
	 * @param moduleId
	 *            模块id
	 * @param diagramType
	 *            模型类型
	 * @throws OperateException
	 *             异常
	 * @return 部署图对象
	 * 
	 */
	@RemoteMethod
	public List<DeployDiagramVO> queryListByModuleIdAndType(String moduleId,
			String diagramType) throws OperateException {
		List<DeployDiagramVO> lstDeployDiagramVO = null;
		ModuleVO objModuleVO = moduleAppService.readModuleVO(moduleId);
		if (objModuleVO != null) {
			String strName = objModuleVO.getShortName();
			String strModelPackage = strName + "." + diagramType;
			lstDeployDiagramVO = CacheOperator.queryList(
					strModelPackage + "/graph", DeployDiagramVO.class);
		}

		return lstDeployDiagramVO;
	}

	/**
	 * 检查部署图文件名称是否已存在（注：只有新增，没有更新操作）
	 *
	 * @param modelPackage
	 *            包全路径
	 * @param modelType
	 *            文件类型
	 * @param modelName
	 *            文件名称
	 * @return 是否存在（false： 不存在、true：存在）
	 * @throws OperateException
	 *             操作异常
	 */
	@RemoteMethod
	public boolean isExistNewModelName(String modelPackage, String modelType,
			String modelName) throws OperateException {
		boolean bResult = false;
		List<DeployDiagramVO> lstDeployDiagramVO = CacheOperator.queryList(
				modelPackage + modelType, DeployDiagramVO.class);
		for (DeployDiagramVO objDeployDiagramVO : lstDeployDiagramVO) {
			String strModelName = objDeployDiagramVO.getModelName();
			if (strModelName.equals(modelName)) {
				bResult = true;
				break;
			}
		}
		return bResult;
	}

}
