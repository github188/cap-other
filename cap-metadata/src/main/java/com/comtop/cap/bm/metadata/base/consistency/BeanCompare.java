/**
 * 
 */
package com.comtop.cap.bm.metadata.base.consistency;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.consistency.annotation.ConsistencyReferencedField;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cip.jodd.bean.BeanCopy;
import com.comtop.cip.jodd.bean.BeanUtil;
import com.comtop.cip.jodd.introspector.ClassDescriptor;
import com.comtop.cip.jodd.introspector.ClassIntrospector;
import com.comtop.cip.jodd.introspector.FieldDescriptor;

/**
 * @author luozhenming
 *
 */
public class BeanCompare extends BeanCopy {
	
	/**是否为copy*/
	private boolean isCopy;
	
	/***/
	private List<BeanCompareResult> modifyProList;

	/**
	 * @return the modifyProList
	 */
	public List<BeanCompareResult> getModifyProList() {
		return modifyProList;
	}
	
	public static BeanCompare beans(Object source, Object destination){
		return new BeanCompare(source, destination);
	}

	/**
	 * 
	 * @param source 最新对象
	 * @param destination 原始数据
	 */
	public BeanCompare(Object source, Object destination) {
		super(source, destination);
	}
	
	@Override
	public void copy() {
		this.isCopy = true;
		super.copy();
	}

	/* (non-Javadoc)
	 * @see com.comtop.cip.jodd.bean.BeanVisitor#visitProperty(java.lang.String, java.lang.Object)
	 */
	@Override
	protected boolean visitProperty(String paramString, Object paramObject) {
		if(isCopy){
			return super.visitProperty(paramString, paramObject);
		}
		checkConsisValueIsChange(paramString, paramObject);
		return true;
	}

	/**
	 * @param paramString 属性名称
	 * @param paramObject 新的属性值
	 */
	private void checkConsisValueIsChange(String paramString, Object paramObject) {
		ClassDescriptor objClassDescriptor = ClassIntrospector.lookup(this.destination.getClass());
		FieldDescriptor field = objClassDescriptor.getFieldDescriptor(paramString, this.declared);
		if(field.getField().getAnnotation(IgnoreField.class) != null){
			return;
		}
		ConsistencyReferencedField objReferenced = field.getField().getAnnotation(ConsistencyReferencedField.class);
		if(objReferenced == null){
			return;
		}
		Object value;
		if (this.declared)
			value = BeanUtil.getDeclaredProperty(this.destination, paramString);
		else {
			value = BeanUtil.getProperty(this.destination, paramString);
		}
		if(value != null && isValueChange(paramObject, value)){
			BeanCompareResult obj = new BeanCompareResult();
			obj.setSourceBean(this.destination);
			obj.setProName(paramString);
			obj.setSourceValue(value);
			obj.setNewBean(this.source);
			obj.setNewValue(paramObject);
			modifyProList.add(obj);
		}
	}
	
	/**
	 * 判断值是否发生变化
	 * @param newValue 新值
	 * @param value 原始值
	 * @return true发生变化 false未发生变化
	 */
	private boolean isValueChange(Object newValue,Object value){
		return value.equals(newValue);
	}
	
	/**
	 * @return 当前对象
	 * 
	 */
	public BeanCompare compare(){
		modifyProList = new ArrayList<BeanCompareResult>();
		this.isCopy = false;
		visit();
		return this;
	}

}
