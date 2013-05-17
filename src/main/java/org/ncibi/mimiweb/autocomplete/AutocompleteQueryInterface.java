package org.ncibi.mimiweb.autocomplete;

import org.ncibi.db.factory.GeneSessionFactory;

import org.ncibi.mimiweb.hibernate.GenericNamedSqlQuery ;
import org.ncibi.mimiweb.hibernate.QueryPropertyList;
import java.util.ArrayList;
import org.hibernate.SessionFactory;

public class AutocompleteQueryInterface
{
	private static SessionFactory gener2Factory = GeneSessionFactory.getSessionFactory() ;
	private static AutocompleteQueryInterface _instance = new AutocompleteQueryInterface() ;
	
	private AutocompleteQueryInterface()
	{
		// Hide constructor from user
	}
	
	public static AutocompleteQueryInterface getInterface()
	{
		return _instance ;
	}
	
	public ArrayList<AutocompleteItem> getGeneSymbolsMatching(String matchOn)
	{
		String matchOnString = matchOn + "%" ;
		return GenericNamedSqlQuery.getList("getGeneSymbolsMatching", gener2Factory,
				new QueryPropertyList().addProperty("matchOn", matchOnString)) ;
	}
}
