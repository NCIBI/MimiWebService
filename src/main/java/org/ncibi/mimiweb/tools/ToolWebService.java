package org.ncibi.mimiweb.tools;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang.math.NumberUtils;
import org.ncibi.commons.exception.ConstructorCalledError;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

/**
 * Utility class with routines for accessing the Gene2Mesh webservice to retrieve counts for
 * searches or to make a url linkout to the gene2mesh website.
 * 
 * @author gtarcea
 * 
 */
public final class ToolWebService
{
    private static final String GENE2MESH_WS_URL = "http://gene2mesh.ncibi.org/fetch?";
    private static final String GENE2MESH_URL = "http://gene2mesh.ncibi.org/index.php";
    private static final String CONCEPTGEN_WS_URL = "http://conceptgen.ncibi.org/ConceptWeb/webservice?output=xml&search=";
    private static final String CONCEPTGEN_URL = "http://conceptgen.ncibi.org/core/conceptGen/result.jsp?keywordType=concept&rset=0&query=";

    /**
     * Constructor.
     */
    private ToolWebService()
    {
        throw new ConstructorCalledError(this.getClass());
    }

    /**
     * For a given Gene2Mesh URL returns a list of nodes matching the xpathQuery.
     * 
     * @param url
     *            The url to connect to.
     * @param xpathQuery
     *            The xpath query to run against the results.
     * @return The NodeList resulting from running the xpathQuery against the url.
     */
    private static NodeList getNodeListFor(final String url, final String xpathQuery)
    {
        boolean errorEncountered = false;
        Exception exception = null;
        NodeList nodes = null;

        try
        {
            
            final URL ws = new URL(url);
            final URLConnection urlConnection = ws.openConnection();
            final InputStream is = urlConnection.getInputStream();
            final DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
            f.setCoalescing(true);
            f.setNamespaceAware(true);
            final Document doc = f.newDocumentBuilder().parse(is);
            if (doc != null)
            {
                final XPath xpath = XPathFactory.newInstance().newXPath();
                nodes = (NodeList) xpath.evaluate(xpathQuery, doc, XPathConstants.NODESET);
            }
        }
        catch (final MalformedURLException e)
        {
            errorEncountered = true;
            exception = e;
        }
        catch (final IOException e)
        {
            errorEncountered = true;
            exception = e;
        }
        catch (final SAXException e)
        {
            errorEncountered = true;
            exception = e;
        }
        catch (final ParserConfigurationException e)
        {
            errorEncountered = true;
            exception = e;
        }
        catch (final XPathExpressionException e)
        {
            errorEncountered = true;
            exception = e;
        }
        catch (final Throwable t)
        {
            
        }

        if (errorEncountered)
        {
            //throw new IllegalStateException("Unable to access Gene2Mesh Webservice.", exception);
            return null;
        }

        return nodes;
    }

    /**
     * Create a url string for querying gene2mesh using a gene.
     * 
     * @param gene
     *            The gene to look up.
     * @param taxid
     *            The taxid to limit results to (-1 means all taxonomies).
     * @return
     */
    public static String getLinkForGeneSearch(final String gene, final int taxid)
    {
        return GENE2MESH_URL + "?term=" + gene + "&qtype=gene" + "&taxid="
                + (taxid == -1 ? "ALL" : taxid) + "&clear";
    }
    
    private static int getCountFor(String url)
    {
        final NodeList nodes = getNodeListFor(url, "//ResultSet/@count");

        int count = 0;
        if (nodes != null && nodes.getLength() > 0)
        {
            Node n = nodes.item(0);
            count = NumberUtils.toInt(n.getNodeValue(), 0);
        }

        return count;
    }

    /**
     * Get a count of the matches in gene2mesh for a given gene.
     * 
     * @param gene
     *            The gene symbol to look up.
     * @param taxid
     *            The taxid to limit results to (-1 means all taxonomies).
     * @return The count of matches.
     */
    public static int getCountForGeneSearch(final String gene, final int taxid)
    {
        final StringBuilder sb = new StringBuilder(64);
        sb.append(GENE2MESH_WS_URL);
        try
        {
            sb.append("genesymbol=" + URLEncoder.encode(gene, "UTF-8"));
        }
        catch (UnsupportedEncodingException e)
        {
            //e.printStackTrace();
            return 0;
        }

        if (taxid != -1)
        {
            sb.append("&taxid=" + taxid);
        }

        return getCountFor(sb.toString());
    }

    /**
     * Create a url string for querying gene2mesh using a mesh term.
     * 
     * @param meshTerm
     *            The mesh term to look up.
     * @param taxid
     *            The taxid to limit results to (-1 means all taxonomies).
     * @return
     */
    public static String getLinkForMeshSearch(final String meshTerm, final int taxid)
    {
        return GENE2MESH_URL + "?term=" + meshTerm + "&qtype=mesh" + "&taxid="
                + (taxid == -1 ? "ALL" : taxid) + "&clear";
    }

    /**
     * Get a count of the matches in gene2mesh for a given mesh term.
     * 
     * @param meshTerm
     *            The mesh term to look up.
     * @param taxid
     *            The taxid to limit results to (-1 means all taxonomies).
     * @return The count of matches.
     */
    public static int getCountForMeshSearch(final String meshTerm, final int taxid)
    {
        final StringBuilder sb = new StringBuilder(64);
        sb.append(GENE2MESH_WS_URL);
        try
        {
            sb.append("mesh=" + URLEncoder.encode(meshTerm, "UTF-8"));
        }
        catch (UnsupportedEncodingException e)
        {
            return 0;
        }

        if (taxid != -1)
        {
            sb.append("&taxid=" + taxid);
        }

        return getCountFor(sb.toString());
    }
    
    public static int getCountForConceptgen(final String searchterm)
    {
        NodeList nl;
        try
        {
            nl = getNodeListFor(CONCEPTGEN_WS_URL + URLEncoder.encode(searchterm, "UTF-8"), "//Concept");
        }
        catch (UnsupportedEncodingException e)
        {
            return 0;
        }
        
        if (nl != null)
        {
            return nl.getLength();
        }
        
        return 0;
    }
    
    public static String getLinkForConceptgen(final String searchterm)
    {
        return CONCEPTGEN_URL + searchterm;
    }
}
