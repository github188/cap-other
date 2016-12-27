package com.comtop.cap.bm.metadata.utils;

import static org.junit.Assert.*;

import org.junit.Test;

/**
 * StringConvertorTest test case
 * @author yangsai
 *
 */
public class StringConvertorTest {

	/**
	 * testToCamelCaseStringInt
	 */
	@Test
	public final void testToCamelCaseStringInt() {
		assertEquals("DataValue", StringConvertor.toCamelCase("APP_DATA_VALUE", 1));
		assertEquals("Milestone", StringConvertor.toCamelCase("BMS_CONTRACT_MILESTONE", 2));
		assertEquals("Attachment", StringConvertor.toCamelCase("BMS_ATTACHMENT", 1));
		
	}

}
