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
//import java.util.Calendar ;
import org.ncibi.lucene.MimiLuceneFields ;

public class FileUploadHelper extends HttpServlet
{
    private static final long serialVersionUID = -3449840032744254096L;

    public static GeneExtraction extractGenes(HttpServletRequest request)
            throws ServletException, IOException, IllegalAccessException, FileUploadException
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
//            e.printStackTrace();
        	throw e;
        }

        GeneExtraction genes = new GeneExtraction();
        
        for (FileItem item : items)
        {
            genes = processFile(item, genes);
        }

        return genes;

    }

    private static GeneExtraction processFile(FileItem item, GeneExtraction genes) throws IOException, IllegalAccessException
    {
//        Calendar today = Calendar.getInstance();
        BufferedInputStream bis = null;
        BufferedReader input;

        // Here BufferedInputStream is added for fast reading.
        bis = new BufferedInputStream(item.getInputStream());
        input = new BufferedReader(new InputStreamReader(bis));
        String geneString = "";
        int geneid = -1;
        ArrayList<Integer> geneIdList = new ArrayList<Integer>();
        ArrayList<String> geneSymbolList = new ArrayList<String>();

        // set type from first read
        int type = GeneExtraction.UNDEFINED_LIST;
        
        while ((geneString = input.readLine()) != null)
        {
        	// if geneid is an int then all are gene id values
        	// else all are gene symbol values
        	geneid = -1;
        	try {
        		geneid = Integer.parseInt(geneString);
        	} catch (Throwable ignore){}
        	if (type == GeneExtraction.UNDEFINED_LIST) {
        		if (geneid > 0)
                	type = GeneExtraction.ID_LIST;
        		else
        			type = GeneExtraction.SYMBOL_LIST;
        	}
        	if (geneid > 0){
        		if (type != GeneExtraction.ID_LIST) {
                	throw new IllegalAccessException ("Inconsistent file content: must be all integer id values or all symbols");
        		}
        		geneIdList.add(new Integer(geneid));
        	}
        	else {
        		if (type != GeneExtraction.SYMBOL_LIST) {
                	throw new IllegalAccessException ("Inconsistent file content: must be all integer id values or all symbols");        			
        		}
        		geneSymbolList.add(geneString);
        	}
        }

        // dispose all the resources after using them.
        bis.close();
        input.close();
        
        if (genes.getType() == GeneExtraction.UNDEFINED_LIST){
        	if (type == GeneExtraction.ID_LIST)
        	{
        		genes.setGeneIdList(geneIdList);
        	}
        	else if (type == GeneExtraction.SYMBOL_LIST)
        	{
        		genes.setGeneSymbolList(geneSymbolList);
        	}
        }
        else if (type == genes.getType())
        {
        	if (type == GeneExtraction.ID_LIST)
        	{
        		ArrayList<Integer> ids = genes.getGeneIdList();
        		ids.addAll(geneIdList);
        		genes.setGeneIdList(ids);
        	}
        	else if (type == GeneExtraction.SYMBOL_LIST)
        	{
        		ArrayList<String> symbols = genes.getGeneSymbolList();
        		symbols.addAll(geneSymbolList);
         		genes.setGeneSymbolList(symbols);
        	}
        } else {
        	throw new IllegalAccessException ("Inconsistent file list content: must be all integer id values or all all symbols");
        }
        return genes;
    }
    
    public static String buildQuery(String[] geneArray, boolean typeIsSymbol, int taxid){
    	String typeHeader = MimiLuceneFields.FIELD_GENEID + ":";
    	if (typeIsSymbol) typeHeader = MimiLuceneFields.FIELD_GENESYMBOL + ":";
    	String part1 = null;
    	for (String s: geneArray)
    	{
    		if (part1 == null) 
    		{
    			part1 = typeHeader + s.trim();
    		}
    		else
    		{
    			part1 += " OR " + typeHeader + s.trim();
    		}
    	}
    	String part2 = "";
    	if (taxid != -1)
    		part2 = " AND " + MimiLuceneFields.FIELD_TAXID + ":" + taxid ;
    	String query = "(" + part1 + ")" + part2;
    	
    	return query;
    }
}
