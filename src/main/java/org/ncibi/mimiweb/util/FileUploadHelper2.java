package org.ncibi.mimiweb.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.BufferedInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import org.ncibi.lucene.MimiLuceneFields ;
import org.ncibi.mimiweb.util.SymbolList ;
import org.ncibi.mimiweb.util.SearchListQueryBuilder ;

public class FileUploadHelper2 extends HttpServlet
{
    private static final long serialVersionUID = -3449840032744254096L;

    @SuppressWarnings("unchecked")
	public static SymbolList extractSymbols(HttpServletRequest request)
            throws ServletException, IOException, IllegalAccessException
    {
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = null;
        
        try
        {
            items = upload.parseRequest(request);
        }
        catch (FileUploadException e)
        {
            e.printStackTrace();
        }

        SymbolList symbols = new SymbolList();
        
        for (FileItem item : items)
        {
            symbols = processFile(item, symbols);
        }

        return symbols;
    }

    private static SymbolList processFile(FileItem item, SymbolList symbolList) throws IOException, IllegalAccessException
    {
        BufferedInputStream bis = null;
        BufferedReader input;

        // Here BufferedInputStream is added for fast reading.
        bis = new BufferedInputStream(item.getInputStream());
        input = new BufferedReader(new InputStreamReader(bis));
        String symbolStr = "";
        
        while ((symbolStr = input.readLine()) != null)
        {
        	symbolList.addSymbol(symbolStr.trim()) ;
        }
        
        return symbolList ;
    }
    
    public static String buildQuery(String symbols[], SymbolList.SymbolType symbolType, int taxid)
    {
    	String query = "" ; 
    	
    	switch (symbolType)
    	{
    		case CID:
    			query = SearchListQueryBuilder.buildCompoundQuery(symbols) ;
    			break ;
    		case GENEID:
    			query = SearchListQueryBuilder.buildLuceneQuery(symbols, symbolType, taxid) ;
    			break ;
    		case GENESYMBOL:
    			query = SearchListQueryBuilder.buildLuceneQuery(symbols, symbolType, taxid) ;
    			break ;
    		default:
    			query = "" ;
    			break ;
    	}
    	
    	return query ;
    }
}
