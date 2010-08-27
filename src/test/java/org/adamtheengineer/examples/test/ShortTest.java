package org.adamtheengineer.examples.test;

import junit.framework.Assert;

import org.junit.Test;

public class ShortTest {

	/**
	 * Someone asked what happens if you try to parse a
	 * number larger than Short.MAX_VALUE into a Short
	 * The answer is a NumberFormatException
	 */
	@Test(expected=NumberFormatException.class)
	public void testBigShort(){
		Short maxShort = Short.valueOf(Short.MAX_VALUE);
		Integer integer = maxShort + 1;
		Short aShort = Short.valueOf(integer.toString());
		Assert.assertNotNull(aShort);
	}
}
