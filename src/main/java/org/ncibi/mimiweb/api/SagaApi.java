package org.ncibi.mimiweb.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Random;
import java.util.ArrayList;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

public class SagaApi
{
    private final static String ko_translator_url = "http://www.bioinformatics.med.umich.edu/app/nlp/ncibi_dbx/query_NCIBI_DBX_gene.php?GENE=";
    private static final String SAGA_URL = "http://saga.ncibi.org/cgi-bin/saga_direct_rpc.cgi";
    private static final String KEGG_DB = "kegg_2007_12_5";
//    private static final String percent = "40";

    public static ArrayList<String> getKeggOrthologIds(String geneSymbol)
    {
        ArrayList<String> koIDs = new ArrayList<String>();
        try
        {
            String url = SagaApi.ko_translator_url
                    + URLEncoder.encode(geneSymbol, "UTF-8");
            URL ncibi_dbx = new URL(url);
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    ncibi_dbx.openStream()));
            String inputLine;

            while ((inputLine = br.readLine()) != null)
            {
                koIDs.add(inputLine);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

        return koIDs;
    }

    private static String processKeggIds(String genesymbol,
            ArrayList<String> koids)
    {
        //String sagaLine = genesymbol + "%20" + koids.size();
        String sagaLine = genesymbol + "\t" + koids.size();
        String keggid;
        for (int i = 0; i < koids.size(); i++)
        {
            keggid = (String) koids.get(i);
            // System.out.println("|" + keggid + "|") ;
            //sagaLine += "%20" + keggid.trim();
            sagaLine += "\t" + keggid.trim() ;
        }
        //sagaLine += "%24";
        sagaLine += "\n" ;
        return sagaLine;
    }

    public static String getSagaGraphStr(ArrayList<SagaGeneElement> graph)
    {
        String toSagaStr = "fromMimiWeb:";
        Random r = new Random();
        int graphLength = graph.size();
        int baseCount = 0;
        //toSagaStr += r.nextInt() + ":" + graphLength + "%24";
        toSagaStr += r.nextInt() + ":" + graphLength + "\n" ;

        ArrayList<String> koids; // = new ArrayList() ;
        int edgeCount = 0;
        String keggStr = "";
        for (int i = 0; i < graph.size(); i++)
        {
            baseCount++;
            koids = getKeggOrthologIds(graph.get(i).geneSymbol);
            keggStr += processKeggIds(graph.get(i).geneSymbol, koids);
            for (int j = 0; j < graph.get(i).connectedGenes.size(); j++)
            {
                edgeCount++;
                koids = getKeggOrthologIds(graph.get(i).connectedGenes.get(j));
                keggStr += processKeggIds(graph.get(i).connectedGenes.get(j),
                        koids);
            }
        }

        //toSagaStr += (edgeCount + baseCount) + "%24" + keggStr;
        toSagaStr += (edgeCount+baseCount) + "\n" + keggStr ;
        //toSagaStr += edgeCount + "%24";
        toSagaStr += edgeCount + "\n" ;
        /*
         * Construct graph layout
         */
        for (int i = 0; i < graph.size(); i++)
        {
            for (int j = 0; j < graph.get(i).connectedGenes.size(); j++)
            {
                //toSagaStr += "0%20" + (j + 1) + "%20" + "1%24";
                toSagaStr += "0\t" + (j+1) + "\t" + "1\n" ;
            }
        }
        // return SAGA_URL+"?database=" +KEGG_DB + "&percent="+ percent +
        // "&query=" + toSagaStr ;
        return toSagaStr ; // URLEncoder.encode(toSagaStr, "UTF-8") ;
    }

    private static String processStream(InputStream inStream) throws IOException
    {
        BufferedReader in = new BufferedReader(new InputStreamReader(inStream));

        String inputLine;

        while ((inputLine = in.readLine()) != null)
        {
            if (inputLine.trim().equals(""))
            {
                continue ;
            }
            
            if (inputLine.startsWith("<"))
            {
                return "FAILED";
            }
            return inputLine ;
        }
        
        return null ;
    }
    
    public static String callSagaGet(String database, String percent, String query)
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
        
        String rv = "FAILED" ;

        String fullUrl = "" ;
        
        // System.out.println("query = \n" + query ) ;
        try
        {
            fullUrl = "http://saga.ncibi.org/cgi-bin/saga_direct_rpc.cgi?database=" + database + "&percent=" + percent + "&query=" + URLEncoder.encode(query, "UTF-8");
        }
        catch (UnsupportedEncodingException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        // System.out.println("fullUrl = \n" + fullUrl) ;
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

    public static String callSagaPost(String database, String percent, String query)
    {
        if (database == null)
        {
            database = KEGG_DB;
        }

        if (percent == null)
        {
            percent = "40";
        }
        
        // System.out.println("database = " + database) ;
        // System.out.println("percent = " + percent) ;

        HttpClient c = new HttpClient();
        PostMethod post = new PostMethod(SAGA_URL);
        String rv = "FAILED";
        // post.setParameter(parameterName, encodedString);
        post.setParameter("database", database);
        post.setParameter("percent", percent);

        try
        {
            post.setParameter("query", URLEncoder.encode(query, "UTF-8"));
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
