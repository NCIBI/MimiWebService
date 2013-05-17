package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.List;

import org.ncibi.commons.exception.ConstructorCalledError;
import org.ncibi.mimiweb.data.Compound;
import org.ncibi.mimiweb.data.ResultGeneMolecule;

public final class SearchListCompare
{
    private static class SymbolFoundStatus
    {
        public String symbol;
        public boolean found;
        
        public SymbolFoundStatus(String symbol)
        {
            this.symbol = symbol.trim();
            this.found = false;
        }
    }
    
    private static abstract class SymbolsNotFoundSearch<T>
    {
        public abstract String getSymbol(T obj);
        
        private int findSymbol(String symbol, List<SymbolFoundStatus> symbolList)
        {
            for (int i = 0 ; i < symbolList.size(); i++)
            {
                if (symbolList.get(i).symbol.equalsIgnoreCase(symbol))
                {
                    return i;
                }
            }
            
            return -1;
        }
        
        public List<String> notFoundList(List<T> itemsFound, String[] itemsSearched)
        {
            List<SymbolFoundStatus> symbolStatusList = new ArrayList<SymbolFoundStatus>(itemsSearched.length);
            for (String item : itemsSearched)
            {
                symbolStatusList.add(new SymbolFoundStatus(item));
            }
             
            for (T item : itemsFound)
            {
                int index = findSymbol(getSymbol(item), symbolStatusList);
                if (index != -1)
                {
                    symbolStatusList.get(index).found = true;
                }
            }
            
            List<String> itemsNotFound = new ArrayList<String>();
            for (SymbolFoundStatus s : symbolStatusList)
            {
                if (! s.found)
                {
                    itemsNotFound.add(s.symbol);
                }
            }
            
            return itemsNotFound;
        }
    }
    
    private SearchListCompare()
    {
        throw new ConstructorCalledError(this.getClass());
    }
    
    

    public static List<String> compoundsNotFound(List<Compound> compoundsFound,
            String[] compoundsSearched)
    {
        SymbolsNotFoundSearch<Compound> notFoundSearch = new SymbolsNotFoundSearch<Compound>()
        {
            @Override
            public String getSymbol(Compound c)
            {
                return c.getCid();
            }
        };
        
        return notFoundSearch.notFoundList(compoundsFound, compoundsSearched);
    }

    public static List<String> geneidsNotFound(List<ResultGeneMolecule> genesFound,
            String[] genesSearched)
    {
        SymbolsNotFoundSearch<ResultGeneMolecule> notFoundSearch = new SymbolsNotFoundSearch<ResultGeneMolecule>()
        {

            @Override
            public String getSymbol(ResultGeneMolecule obj)
            {
                return obj.getId().toString();
            }
            
        };
        
        return notFoundSearch.notFoundList(genesFound, genesSearched);
    }

    public static List<String> geneSymbolsNotFound(List<ResultGeneMolecule> genesFound,
            String[] genesSearched)
    {
        SymbolsNotFoundSearch<ResultGeneMolecule> notFoundSearch = new SymbolsNotFoundSearch<ResultGeneMolecule>()
        {

            @Override
            public String getSymbol(ResultGeneMolecule obj)
            {
                return obj.getSymbol();
            }
            
        };
        
        return notFoundSearch.notFoundList(genesFound, genesSearched);
    }
}
