package org.ncibi.mimiweb.api;

import java.util.ArrayList ;

public class SagaGeneElement 
{
	public String geneSymbol ;
	public ArrayList<String> connectedGenes ;
	
	public SagaGeneElement(String symbol)
	{
		geneSymbol = symbol ;
		connectedGenes = new ArrayList<String>() ;
	}
}
