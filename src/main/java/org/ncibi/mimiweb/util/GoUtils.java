package org.ncibi.mimiweb.util;

import java.util.ArrayList;

import org.ncibi.mimiweb.data.ResultGeneMolecule;
import org.ncibi.mimiweb.data.StringItem;

public class GoUtils
{
	public static String constructGoTerm(String term)
	{
		int bracket = term.indexOf("[GO") ;
		
		String html = "" ;
		
		if (bracket != -1)
		{
			String goName = term.substring(0, bracket-1) ;
			String goId = term.substring(bracket+1, term.length()-1) ; // Don't get ending ']'
			html = "<a href='http://www.ebi.ac.uk/ego/GTerm?id=" + goId + "'>" + goName 
								+ "</a>\n" ;
		}
		
		return html ;
	}
	
	public static <T> String makeGoTermsHTML (ArrayList<T> goterms)
	{
		String html = "" ;
		String str ;
		boolean firstTime = true ;
		for(T item : goterms)
		{
			str = item.toString();
			String thtml = constructGoTerm(str) ;
			if (firstTime)
			{
				if (thtml.equals("") == false)
				{
					html = thtml ;
					firstTime = false ;
				}
			}
			else
			{
				if (thtml.equals("") == false)
				{
					html += ", " + thtml ;
				}
			}
		}
		if (html.equals(""))
		{
			return "---" ;
		}
		
		return html ;
	}

	public static boolean noGoTermsInGene(ResultGeneMolecule g){
		int np = 0;
		if ((g.getBiologicalProcesses() != null) && (g.getBiologicalProcesses().get(0) != null)
				&& (g.getBiologicalProcesses().get(0).length() != 0)) np = g.getBiologicalProcesses().size();
		int nc = 0;
		if ((g.getCellularComponents() != null) && (g.getCellularComponents().get(0) != null)
				&& (g.getCellularComponents().get(0).length() != 0)) nc = g.getCellularComponents().size();
		int nf = 0;
		if ((g.getMolecularFunctions() != null) && (g.getMolecularFunctions().get(0) != null)
				&& (g.getMolecularFunctions().get(0).length() != 0)) nf = g.getMolecularFunctions().size();
		return ((np == 0) && (nc == 0) && (nf == 0));
	}
}
