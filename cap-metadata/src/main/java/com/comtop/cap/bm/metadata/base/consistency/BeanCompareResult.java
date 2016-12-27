/**
 * 
 */
package com.comtop.cap.bm.metadata.base.consistency;

/**
 * @author luozhenming
 *
 */
public class BeanCompareResult {
	
	/***/
	private String proName;
	
	/***/
	private Object sourceValue;
	
	/***/
	private Object sourceBean;
	
	/***/
	private Object newValue;
	
	/***/
	private Object newBean;

	/**
	 * @return the sourceValue
	 */
	public Object getSourceValue() {
		return sourceValue;
	}

	/**
	 * @param sourceValue the sourceValue to set
	 */
	public void setSourceValue(Object sourceValue) {
		this.sourceValue = sourceValue;
	}

	/**
	 * @return the sourceBean
	 */
	public Object getSourceBean() {
		return sourceBean;
	}

	/**
	 * @param sourceBean the sourceBean to set
	 */
	public void setSourceBean(Object sourceBean) {
		this.sourceBean = sourceBean;
	}

	/**
	 * @return the newValue
	 */
	public Object getNewValue() {
		return newValue;
	}

	/**
	 * @param newValue the newValue to set
	 */
	public void setNewValue(Object newValue) {
		this.newValue = newValue;
	}

	/**
	 * @return the newBean
	 */
	public Object getNewBean() {
		return newBean;
	}

	/**
	 * @param newBean the newBean to set
	 */
	public void setNewBean(Object newBean) {
		this.newBean = newBean;
	}

	/**
	 * @return the proName
	 */
	public String getProName() {
		return proName;
	}

	/**
	 * @param proName the proName to set
	 */
	public void setProName(String proName) {
		this.proName = proName;
	}

}
