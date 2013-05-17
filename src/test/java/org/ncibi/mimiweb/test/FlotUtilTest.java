package org.ncibi.mimiweb.test;


import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.ncibi.mimiweb.data.StringItem;
import org.ncibi.mimiweb.util.FlotUtil;

public class FlotUtilTest
{
	@Test
	public void testGenerateSubcelluarBarGraph()
	{
		List<StringItem> entries = new ArrayList<StringItem>() ;
		entries.add(new StringItem("A", 5)) ;
		entries.add(new StringItem("B", 5)) ;
		entries.add(new StringItem("C", 5)) ;
		entries.add(new StringItem("A", 42)) ;
		entries.add(new StringItem("B", 42)) ;
		entries.add(new StringItem("D", 42)) ;
		entries.add(new StringItem("A", 42)) ;
		
		FlotUtil.generateSubcellularBarGraph("ABC", entries) ;
	}
}
