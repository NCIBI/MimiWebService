package org.ncibi.mimiweb.util;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.ncibi.lucene.MimiLuceneFields;
import org.ncibi.mimiweb.data.GeneSummary;
import org.ncibi.mimiweb.hibernate.HumDBQueryInterface;

public class SearchListQueryBuilder
{
	public static String buildLuceneQuery(String symbols[],
			SymbolList.SymbolType st, int taxid)
	{
		String luceneSpec = "";
		
		if (st == SymbolList.SymbolType.GENEID)
		{
			luceneSpec = MimiLuceneFields.FIELD_GENEID + ":" ;
		}
		else if (st == SymbolList.SymbolType.GENESYMBOL)
		{
			luceneSpec = MimiLuceneFields.FIELD_GENESYMBOL + ":" ;
		}
		else
		{
			luceneSpec = "DOES_NOT_EXIST:" ;
		}

		String part1 = null;
		for (String s : symbols)
		{
			if (part1 == null)
			{
				part1 = luceneSpec + s.trim();
			}
			else
			{
				part1 += " OR " + luceneSpec + s.trim();
			}
		}

		String part2 = "";
		if (taxid != -1)
		{
			part2 = " AND " + MimiLuceneFields.FIELD_TAXID + ":" + taxid;
		}

		String query = "(" + part1 + ")" + part2;

		return query;
	}
	
	/*
	 * Given an array of compound symbols, find all the matching gene ids
	 * Is taxid valid for compound search? Ignore for now...
	 */
	public static String buildCompoundQueryToGenes(String symbols[], int taxid)
	{
		HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
		HashMap<Integer, Integer> cmpdGeneList = new HashMap<Integer, Integer>() ;
		
		/*
		 * Get a unique list of geneids for all the compounds
		 */
		for (String cid : symbols)
		{
			String tcid = cid.trim();
			List<GeneSummary> genes = humdb.getGeneIdsForCompound(tcid) ;
			for (GeneSummary gene : genes)
			{
				cmpdGeneList.put(gene.getId(), gene.getId()) ;
			}
		}
		
		String[] geneids = new String[cmpdGeneList.size()];
		
		int i = 0 ;
		for (Integer geneid : cmpdGeneList.keySet())
		{
			geneids[i] = geneid.toString();
			i++ ;
		}
		
		return buildLuceneQuery(geneids, SymbolList.SymbolType.GENEID, taxid) ;
	}
	
	/**
	 * Turn a list of compound ids into a single separated by commas
	 * 
	 */
	public static String buildCompoundQuery(String cids[])
	{
		String cidString = StringUtils.join(cids, ",") ;
		return StringUtils.deleteWhitespace(cidString) ;
	}

}
