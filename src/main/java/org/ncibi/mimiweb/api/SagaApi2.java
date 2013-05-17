package org.ncibi.mimiweb.api;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.ncibi.db.factory.MimiSessionFactory;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.ncibi.mimiweb.data.ResultGeneMolecule;
import org.ncibi.mimiweb.lucene.LuceneInterface;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.lucene.queryParser.ParseException;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

public class SagaApi2
{
	private KeggHolder kh = new KeggHolder();
	private HashMap<String, Integer> geneHash ;
	private ArrayList<Integer> geneIdList ;
	
//    private final static String ko_translator_url = "http://www.bioinformatics.med.umich.edu/app/nlp/ncibi_dbx/query_NCIBI_DBX_gene.php?GENE=";
    private static final String SAGA_URL = "http://saga.ncibi.org/cgi-bin/saga_direct_rpc.cgi";
    private static final String KEGG_DB = "kegg_2007_12_5";
//    private static final String _percent = "40";

    private static final String SAGA_FAILED = "sagaFailed.html";
//
// The commented out code below is a hard coded test.
// TODO: Move to a unit test (someday!)
//
	//private final String LUCENE_DIR = //"/Users/gtarcea/SVN/MimiWebR2/tomcat/MimiWebR2Lucene" ;
//	private final String LUCENE_DIR = "c:/cygwin/home/Administrator/workspace/SVN/MimiWebR2/tomcat/MimiWebR2Lucene" ;
//	
//	public static void main (String[] args)
//	{
//		SagaApi2 sapi2 = new SagaApi2() ;
//    	String geneidGraphStr = "1453|1454|1857,1454|1453|1857,1857|1453|1454|2932|7976|8326,2932|1857|51199,51199|2932,10009|7481,7481|10009|6425|7976|8326|11197|6424,7482|6425|7976|8326|11197|6424,6425|7481|7482|7976|8326|7480|89780|7479,7976|1857|7481|7482|6425|7480|89780|7479|6424,8326|1857|7481|7482|6425|7480|89780|7479|6424,7480|6425|7976|8326|11197|6424,89780|6425|7976|8326|11197|6424,7479|6425|7976|8326|11197|6424,11197|7481|7482|7480|89780|7479,6424|7481|7482|7976|8326|7480|89780|7479" ;
//    	String geneSymbolGraphStr = sapi2.convertIdsToSymbols(geneidGraphStr) ;
//    	//System.out.println(geneSymbolGraphStr) ;
//    	ArrayList<SagaGeneElement> graph = SagaUtil.createGraph(geneSymbolGraphStr) ;
//    	String s = sapi2.getSagaGraphStr(graph) ;
//    	System.out.println(s) ;
//	}
	
//	private String convertIdsToSymbols(String graphstr)
//	{
//		LuceneInterface.forceDir(LUCENE_DIR);
//		String[] top = graphstr.split(",") ;
//		ResultGeneSummaryPage p = null ;
//		MimiWebService2 service = new MimiWebService2Impl();
//		ClientUserRecord u = service.getUser();
//		String convertedStr = "" ;
//		
//		for (String listofids : top)
//		{
//			String[] splitListofIds = listofids.split("\\|");
//			String query = "" ;
//			boolean firstTime = true ;
//			for (String geneid : splitListofIds)
//			{
//				query = "geneid:" + geneid ;
//				try
//				{
//					p = service.getTopPageSummary(u.getUserHashcode(), -1, query, 10);
//				}
//				catch (SerializableException e)
//				{
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				
//				if (firstTime)
//				{
//					convertedStr += p.getPageContent()[0].getSymbol() ;
//					firstTime = false ;
//				}
//				else
//				{
//					convertedStr += "|" + p.getPageContent()[0].getSymbol() ;
//				}
//				
//			}
//			convertedStr += "," ;
//		}
//		return convertedStr ;
//	}

	public String getSagaGraphStr(ArrayList<SagaGeneElement> graph)
	{   
		/*
		 * We have a graph, now we need to convert as below.
		 */
		String sagaContent = null ;
	    geneIdList = new ArrayList<Integer>() ;
		buildGeneIdList(graph, -1);
		String flattenedGeneIdList = getFlattenedGeneIdList();
		
		if (flattenedGeneIdList != null)
		{
		    getKeggIds(flattenedGeneIdList);
		    sagaContent = buildSagaContent(graph);
		}
		
		return sagaContent;
	}
	
	private String buildQueryFromGraph(ArrayList<SagaGeneElement> graph)
	{
		/*
		 * Create unique genes list
		 */
		geneHash = new HashMap<String, Integer>() ;
		for (SagaGeneElement gene : graph)
		{
			geneHash.put(gene.geneSymbol, -1) ;
			for (String cgene : gene.connectedGenes)
			{
				geneHash.put(cgene, -1) ;
			}
		}
		
		/*
		 * Create Lucene query. Keys are genes.
		 */
		String lquery = null ;
		boolean firstTime = true ;
		for (String gene : geneHash.keySet())
		{
			if (firstTime)
			{
				lquery = gene ;
				firstTime = false ;
			}
			else
			{
				lquery += " OR " + gene ;
			}
		}
		
		return lquery ;
	}

	private void buildGeneIdList(ArrayList<SagaGeneElement> graph, int taxidToUse)
	{
		String query = buildQueryFromGraph(graph) ;
		
		if (query == null)
		{
			return ;
		}

		int taxId ;
		
		if (taxidToUse == -1)
		{
			taxId = 9606 ;
		}
		else
		{
			taxId = taxidToUse ;
		}

		// System.out.println("Making query for: " + query + " with tax id = " + taxId);
        LuceneInterface l = LuceneInterface.getInterface() ;
        ArrayList<ResultGeneMolecule> genes = new ArrayList<ResultGeneMolecule>(); // in case exception
		try {
			genes = l.fullGeneSearch(taxId, query);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		for (ResultGeneMolecule gene : genes)
		{
			if (gene.getTaxid() == taxId)
			{
				geneHash.put(gene.getSymbol(), gene.getId()) ;
				geneIdList.add(gene.getId()) ;
			}
		}
	}
	
	private int getNodeCount()
	{
		int i = 0 ;
		int geneid ;
		HashSet<String> hs ;
		for (String key : geneHash.keySet())
		{
			geneid = geneHash.get(key) ;			
			if (geneid != -1)
			{
				hs = kh.keggIdSet(geneid) ;
				if (hs != null)
				{
					i++ ;
				}
			}
		}
		return i ;
	}
	
	private String emitInteraction(int geneid1, int geneid2)
	{
	    String outStr = null ;
		if (geneid1 != -1 && geneid2 != -1)
		{
			// Both geneids are good, now we just need to make
			// sure there are kegg ids associated with them.
			HashSet<String> g1hashSet = kh.keggIdSet(geneid1) ;
			HashSet<String> g2hashSet = kh.keggIdSet(geneid2) ;
			
			if (g1hashSet != null && g2hashSet != null)
			{
				int pos1 = geneIdList.indexOf(geneid1) ;
				int pos2 = geneIdList.indexOf(geneid2) ;
				
				outStr = Integer.toString(pos1) + " " + Integer.toString(pos2) + " 1\n" ;
				//System.out.print(outStr) ;
			}
		}
		
		return outStr ;
	}

	private String buildSagaContent(ArrayList<SagaGeneElement> graph)
	{
	    String tab = "\t" ; // Separator
	    String eol = "\n" ; // Newline
	    Calendar today = Calendar.getInstance();
	    String sagaStr = "" ; 
	    
	    // Title
	    sagaStr += "fromMimiWeb:" + today.getTimeInMillis() + eol ;
	    
	    // Number of nodes
	    sagaStr += getNodeCount() + eol ;
	    
	    // Build gene symbol, kegg id associations
	    for (String gene : geneHash.keySet())
	    {
	    	int geneid = geneHash.get(gene) ;
	    	if (geneid != -1)
	    	{
	    	    HashSet<String> h = kh.keggIdSet(geneid) ;
	    	    if (h != null)
	    	    {
	    	        //System.out.print(gene + tab) ;
	    	        //System.out.print(h.size()) ;
	    	        
	    	        sagaStr += gene + tab + h.size() ;
	    	        for (String keggId : h)
	    	        {
	    	            // System.out.print( tab + keggId) ;
	    	            sagaStr += tab + keggId ;
	    	        }
	    	        // System.out.println() ;
	    	        sagaStr += eol ;
	    	    }
	    	}
	    }
	    
	    // Build interactions graph
	    int interactionsCount = 0 ;
	    String sagaInteractions = "" ;
	    
	    for (SagaGeneElement sge : graph)
	    {
	    	int geneid1 = geneHash.get(sge.geneSymbol) ;
	    	if (geneid1 != -1)
	    	{
	    		for (String interactionSymbol : sge.connectedGenes)
	    		{
	    			int geneid2 = geneHash.get(interactionSymbol) ;
	    			String s = emitInteraction(geneid1, geneid2) ;
	    			if (s != null)
	    			{
	    				interactionsCount++ ;
	    			    sagaInteractions += s ;
	    			}
	    		}
	    	}
	    }
	    sagaStr += interactionsCount + eol + sagaInteractions ;
		return sagaStr;
	}

	private String getFlattenedGeneIdList()
	{
	    String geneidlist = null ;
	    Integer id ;
	    
	    for (String geneKey : geneHash.keySet())
	    {
	        id = geneHash.get(geneKey) ;
	        if (geneidlist == null)
	        {
	            geneidlist = id.toString();
	        }
	        else
	        {
	            geneidlist += " " + id.toString() ;
	        }
	    }
	    
		return geneidlist ;
	}

	private void getKeggIds(String flattenedGeneIdList)
	{
		Session mimiSession = MimiSessionFactory.getSessionFactory()
				.getCurrentSession();
		mimiSession.beginTransaction();

		String sql = "execute mimiCytoPlugin.mimiR2SagaKegg '"
				+ flattenedGeneIdList + "'";

		List<Object[]> l = mimiSession.createSQLQuery(sql).addScalar("geneid",
				Hibernate.INTEGER).addScalar("groupAcc", Hibernate.STRING)
				.list();

		Iterator<Object[]> it = l.iterator();

		while (it.hasNext())
		{
			Object[] row = it.next();
			Integer geneId = (Integer) row[0];
			String keggId = (String) row[1];
			kh.addKeggId(geneId, keggId);
			// System.out.println("GeneId, KeggId: " + geneId + "," + keggId);
		}

		mimiSession.getTransaction().commit();
	}

	private class KeggHolder
	{
		Hashtable<Integer, HashSet<String>> geneToKeggTable = new Hashtable<Integer, HashSet<String>>();
		Hashtable<String, HashSet<Integer>> keggToGeneTable = new Hashtable<String, HashSet<Integer>>();

		public void addKeggId(Integer geneId, String keggId)
		{
			HashSet<String> probeKegg = geneToKeggTable.get(geneId);
			if (probeKegg == null)
			{
				probeKegg = new HashSet<String>();
				geneToKeggTable.put(geneId, probeKegg);
			}
			probeKegg.add(keggId);

			HashSet<Integer> probeGene = keggToGeneTable.get(keggId);
			if (probeGene == null)
			{
				probeGene = new HashSet<Integer>();
				keggToGeneTable.put(keggId, probeGene);
			}
			probeGene.add(geneId);
		}

		public HashSet<String> keggIdSet(Integer geneId)
		{
			HashSet<String> probe = geneToKeggTable.get(geneId);
			return probe;
		}

		public HashSet<Integer> geneIdSet(String keggId)
		{
			HashSet<Integer> probe = keggToGeneTable.get(keggId);
			return probe;
		}
	}
	
    private String processStream(InputStream inStream) throws IOException
    {
        BufferedReader in = new BufferedReader(new InputStreamReader(inStream));

        String inputLine;

        while ((inputLine = in.readLine()) != null)
        {
        	//System.out.println("inputLine = '" + inputLine + "'") ;
            if (inputLine.trim().equals(""))
            {
                continue ;
            }
            
            if (inputLine.startsWith("<"))
            {
                return SAGA_FAILED;
            }
            return inputLine ;
        }
        
        return null ;
    }
    
    public  String callSagaGet(String database, String percent, String query)
    {
        if (database == null)
        {
            database = KEGG_DB;
        }

        if (percent == null)
        {
            percent = "40";
        }
        
        HttpClient c = new HttpClient();
        
        String rv = SAGA_FAILED ;

        //System.out.println("query = \n" + query) ;
        String fullUrl = "" ;
        try
        {
            fullUrl = "http://saga.ncibi.org/cgi-bin/saga_direct_rpc.cgi?database=" + database + "&percent=" + percent + "&query=" + URLEncoder.encode(query, "UTF-8");
        }
        catch (UnsupportedEncodingException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        
        //System.out.println("fullUrl = \n" + fullUrl) ;
        GetMethod get = new GetMethod(fullUrl) ;
        try
        {
            c.executeMethod(get);

            if (get.getStatusCode() == HttpStatus.SC_OK)
            {
                rv = processStream(get.getResponseBodyAsStream());
            }
            else
            {
                System.out.println("Unexpected failure: "
                        + get.getStatusLine().toString());
            }
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        finally
        {
            get.releaseConnection();
        }
        
        return rv ;
    }

    public String callSagaPost(String database, String percent, String query)
    {
        if (database == null)
        {
            database = KEGG_DB;
        }

        if (percent == null)
        {
            percent = "20";
        }
        
        //System.out.println("database = " + database) ;
        //System.out.println("percent = " + percent) ;

        HttpClient c = new HttpClient();
        PostMethod post = new PostMethod(SAGA_URL);
        String rv = SAGA_FAILED;
        // post.setParameter(parameterName, encodedString);
        post.setParameter("database", database);
        post.setParameter("percent", percent);

        try
        {
            post.setParameter("query", query) ; //URLEncoder.encode(query, "UTF-8"));
            c.executeMethod(post);

            if (post.getStatusCode() == HttpStatus.SC_OK)
            {
                rv = processStream(post.getResponseBodyAsStream());
            }
            else
            {
                System.out.println("Unexpected failure: "
                        + post.getStatusLine().toString());
            }
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        finally
        {
            post.releaseConnection();
        }

        return rv;
    }

}
