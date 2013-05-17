package org.ncibi.mimiweb.util;

public class GeneProvLinkUrl {

	private static String KEGG_SORUCE_LABEL = "KEGG";
	private static String KEGG_BASE_URL = "http://www.genome.jp/dbget-bin/www_bfind_sub?dbkey=kegg&keywords=";

	private static String NCBI_SOURCE_LABEL = "NCBI gene";
	private static String NCBI_BASE_URL = "http://www.ncbi.nlm.nih.gov/sites/entrez?db=protein&term=";
	
	public static String getGeneMolProvUrlHtml(String source, String term){
		
		String ret = source;
		
		if (source.equals(KEGG_SORUCE_LABEL)) { // link to KEGG with symbol
			ret = HtmlUtil.anchor(KEGG_BASE_URL + term, source);
		}
		
		if (source.equals(NCBI_SOURCE_LABEL)) { // link to EntrezGene with symbol
			ret = HtmlUtil.anchor(NCBI_BASE_URL + term, source);
		}

		return ret;
	}

}
