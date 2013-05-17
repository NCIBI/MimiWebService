package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.List;

import org.ncibi.lucene.MimiLuceneFields;
import org.ncibi.mimiweb.data.ResultGeneMolecule;

public class SearchTermUtil
{
	private static class SearchEntry
	{
		public SymbolList.SymbolType symbolType ;
		public String searchTerm ;
		
		public SearchEntry(SymbolList.SymbolType stype, String sterm)
		{
			symbolType = stype ;
			searchTerm = sterm ;
		}
	}
	
	/*
	 * This function assumes it was called with mostly valid input.
	 * Results are undefined if it wasn't.
	 */
	private static List<SearchEntry> makeSearchTerms(String searchTerm)
	{
		/*
		 * Clean up the string by removing the AND for taxid, and the
		 * ( ) on either side.
		 */
		ArrayList<SearchEntry> searchTermEntries = new ArrayList<SearchEntry>() ;
		int indexOfParen = searchTerm.indexOf("(") ;
		if (indexOfParen == -1)
		{
			return searchTermEntries ; // return empty list
		}
		
		int indexOfAnd = searchTerm.indexOf(" AND ") ;
		if (indexOfAnd != -1)
		{
			searchTerm = searchTerm.substring(0, indexOfAnd) ;
		}
		
		searchTerm = searchTerm.substring(1) ; // Remove first paren
		searchTerm = searchTerm.replace(')', ' ') ; // Remove second paren
		String[] terms = searchTerm.split(" OR ") ;
		
		for (String term : terms)
		{
			String[] pieces = term.split(":") ;
			if (pieces[0].trim().equals(MimiLuceneFields.FIELD_GENESYMBOL))
			{
				searchTermEntries.add(new SearchEntry(SymbolList.SymbolType.GENESYMBOL, pieces[1].trim())) ;
			}
			else if (pieces[0].trim().equals(MimiLuceneFields.FIELD_GENEID))
			{
				searchTermEntries.add(new SearchEntry(SymbolList.SymbolType.GENEID, pieces[1].trim())) ;
			}
			else
			{
				continue ;
			}
		}
		
		return searchTermEntries ;
	}
	
	private static boolean findGeneId(int geneid, List<ResultGeneMolecule> searchResults)
	{
		boolean found = false ;
		for (ResultGeneMolecule gene : searchResults)
		{
			if (gene.getId() == geneid)
			{
				found = true ;
				break ;
			}
		}
		return found ;
	}
	
	private static boolean findGeneSymbol(String symbol, List<ResultGeneMolecule> searchResults)
	{
		boolean found = false ;
		for (ResultGeneMolecule gene : searchResults)
		{
			if (gene.getSymbol().equalsIgnoreCase(symbol))
			{
				found = true ;
				break ;
			}
		}
		return found ;
	}
	
	public static List<String> getNotFoundList(String searchTerm, List<ResultGeneMolecule> searchResults)
	{
		List<SearchEntry> terms = makeSearchTerms(searchTerm) ;
		List<String> missingTerms = new ArrayList<String>() ;

		for (SearchEntry term : terms)
		{
			if (term.symbolType == SymbolList.SymbolType.GENEID)
			{
				try
				{
					if (findGeneId(Integer.parseInt(term.searchTerm), searchResults) == false)
					{
						missingTerms.add(term.searchTerm) ;
					}
				}
				catch (NumberFormatException e)
				{
					/*
					 * parseInt failed, add as missing term
					 */
					missingTerms.add(term.searchTerm) ;
				}
			}
			else if (term.symbolType == SymbolList.SymbolType.GENESYMBOL)
			{
				if (findGeneSymbol(term.searchTerm, searchResults) == false)
				{
					missingTerms.add(term.searchTerm) ;
				}
			}
		}		
		return missingTerms ;
	}
}
