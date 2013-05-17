package org.ncibi.mimiweb.test;

import org.junit.Test ;
import static org.junit.Assert.*;
import org.ncibi.mimiweb.autocomplete.*;
import java.util.ArrayList ;

public class AutocompleteTests
{
//	@Test
//	public void testGetGeneSymbolsMatching()
//	{
//		AutocompleteQueryInterface autoc = AutocompleteQueryInterface.getInterface() ;
//		
//		ArrayList<AutocompleteItem> matches = autoc.getGeneSymbolsMatching("a") ;
//		for (AutocompleteItem item : matches)
//		{
//			System.out.println("Id = " + item.getId() + ", Symbol = " + item.getItem()) ;
//		}
//	}
	
	@Test
	public void testFindMatch()
	{
		AutocompleteSearcher as = new AutocompleteSearcher() ;
		
		AutocompleteSearcher.setNamesFilePath("names.txt") ;
		
		ArrayList<String> matches = as.findMatch("c") ;
		
		System.out.println("==========================") ;
		for (String m : matches)
		{
			System.out.println("match = '" + m + "'") ;
		}
		
		matches = as.findMatch("csfffff") ;
		System.out.println("==========================") ;
		for (String m : matches)
		{
			System.out.println("match = '" + m + "'") ;
		}
		
		matches = as.findMatch("csf") ;
		System.out.println("==========================") ;
		for (String m : matches)
		{
			System.out.println("match = '" + m + "'") ;
		}
	}
}
