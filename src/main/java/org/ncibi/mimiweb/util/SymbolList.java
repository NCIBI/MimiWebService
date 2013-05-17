package org.ncibi.mimiweb.util;

import java.util.ArrayList;

public class SymbolList 
{	
	public static enum SymbolType
	{
		UNDEFINED,
		GENESYMBOL,
		GENEID,
		CID,
	}
	
	private ArrayList<String> symbolList ;
	private SymbolType symbolType ;
	
	public SymbolList()
	{
		symbolList = new ArrayList<String>() ;
		symbolType = SymbolType.UNDEFINED ;
	}
	
	public void addSymbol(String symbol)
	{
		symbolList.add(symbol) ;
	}
	
	public ArrayList<String> getSymbolList()
	{
		return symbolList ;
	}
	
	public SymbolType getSymbolType()
	{
		return symbolType ;
	}
	
	public void setSymbolType(SymbolType newType)
	{
		symbolType = newType ;
	}
	
	public static SymbolType parseEnum(String s)
	{
		if (s == null)
		{
			return SymbolType.UNDEFINED ;
		}
		else if (s.equalsIgnoreCase("CID"))
		{
			return SymbolType.CID ;
		}
		else if (s.equalsIgnoreCase("GENESYMBOL"))
		{
			return SymbolType.GENESYMBOL ;
		}
		else if (s.equalsIgnoreCase("GENEID"))
		{
			return SymbolType.GENEID ;
		}
		else
		{
			return SymbolType.UNDEFINED ;
		}
	}
}
