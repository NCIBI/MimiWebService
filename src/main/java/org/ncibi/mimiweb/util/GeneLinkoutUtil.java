package org.ncibi.mimiweb.util;

import org.ncibi.mimiweb.data.ResultGeneMolecule;
import java.util.Random;

public class GeneLinkoutUtil {

	//TODO: get rid of hard-wired URL, at least a property in some property file
	// private final static String TEST = "test";
	private final static String TEST = "";
	
	private final static String BASE = "http://mimi" + TEST + ".ncibi.org";
	private final static String SITE = BASE + "/MimiWeb";
	private final static String CYTOSCAPE_PLUGIN_LAUNCHER_URL = BASE + "/cytoscape";
	private final static String NETBROWSER_URL = "http://biosearch2d.ncibi.org/conceptgen/Network";
	private final static String BIOSEARCH2D_URL = "http://biosearch2D.ncibi.org";
	private final static String GENE2MESH_BASE_URL = "http://gene2mesh.ncibi.org/index.php";
	private final static String GENE2MESH_FULL_URL = GENE2MESH_BASE_URL + "?view=simple&qtype=gene";
	private final static String KEGG_URL = "http://www.genome.jp/dbget-bin/www_bget?pathway+" ;

	public static String getBaseUrl() {return BASE;}
	public static String getSiteUrl() {return SITE;}
	public static String getCytoscapeLauncherUrl() {return CYTOSCAPE_PLUGIN_LAUNCHER_URL;}
	public static String getNetBrowserUrl() {return NETBROWSER_URL;}
	public static String getBioSearch2DUrl() {return BIOSEARCH2D_URL;}
	public static String getGene2MeshBaseUrl() {return GENE2MESH_BASE_URL;}
	public static String getGene2MeshFullUrl() {return GENE2MESH_FULL_URL;}
	public static String getKeggUrl() {return KEGG_URL;}

	public static String getNetbrowserLinkout(ResultGeneMolecule g)
    {
        /* We would like to do geneids, but can't yet */
        String[] interactionGeneids = g.getInteractionGeneSymbols(); 
        if (interactionGeneids == null)
        {
            return null;
        }
        else
        {
            String geneidList = g.getSymbol();
            for (int i = 0; i < interactionGeneids.length; i++)
            {
                geneidList += "," + interactionGeneids[i];
            }
            String url = getNetBrowserUrl() + "/mimi.jsp?taxid="
                    + g.getTaxid() + "&geneid=NA&symbol=" + geneidList;
            return(url);
        }
    }

	public static String getGene2MeshLinkout(ResultGeneMolecule g) {
		String name = "\"View Mesh terms for " + g.getSymbol() + "\"" ;
		return ("<a href=\"" + getGene2MeshBaseUrl() 
				+ "?view=simple&qtype=gene&term=" + g.getSymbol() 
				+ "&taxid=" + g.getTaxid() + "\" target=\"_blank\" name=\"" + name + "\"" 
				+ " title=\"" + name + "\"> View in Gene2Mesh</a>") ;
	}
	
	public static String getCytoscapeLauncherLinkout(ResultGeneMolecule g){
		String name = "\"View Interactions Graph for " + g.getSymbol() + " in MiMI Plugin for Cytoscape\"" ;
		return("<a href=\"" + getCytoscapeLauncherUrl()
				+ "/launcher?queryMiMIById=" + g.getId() + "\" target=\"_blank\" name=\"" + name + "\"" 
				+ " title=\"" + name + "\"> View in MiMI Plugin for Cytoscape</a>") ;
	}
	
	public static String getGinLinkout(ResultGeneMolecule g){
		String name = "\"Find related articles on " + g.getSymbol() + " in GiN using NLP\"" ;
		return ("<a href=\"http://belobog.si.umich.edu:8080/gin/viewMolecule?name=" + g.getSymbol() 
				+ "\" target=\"_blank\" name=" + name + "title=" + name + "> View in GiN</a>") ;
	}

	public static String getPubMedLinkout(ResultGeneMolecule g){
		String name = "\"Find related PubMed Articles on " + g.getSymbol() + "\"" ;
		//TODO: add user id
		Random r = new Random();
		int userId = r.nextInt();
		return("<a href=\"http://misearch.ncibi.org?query=" + g.getSymbol() + 
				"&user=mimiweb_" + userId + "\" target=\"_blank\" name=" + name + " title=" + name + ">View in MiSearch</a>") ;
	}
	
}
