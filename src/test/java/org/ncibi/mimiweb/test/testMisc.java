package org.ncibi.mimiweb.test;

import org.junit.Test ;
import org.apache.commons.lang.StringUtils ;

public class testMisc
{
	@Test
	public void testStrings()
	{
		String[] cids = {"C0001\n", "C0002" } ;
		
		String cidString = StringUtils.join(cids, ",") ;
		
		System.out.println(cidString) ;
		
		cidString = StringUtils.deleteWhitespace(cidString) ;
		
		System.out.println(cidString) ;
	}

}
