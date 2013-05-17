package org.ncibi.mimiweb.util;

public class PathwayUtil
{
	   public static String getPathnameHTML(String pathName)
	    {
	    	String html = "" ;
	    	int colon = pathName.indexOf(":") ;
	    	
	    	if (colon == -1)
	    	{
	    		// Reactome Pathway
	    		html = "<a href=\"http://www.reactome.org/cgi-bin/eventbrowser_st_id?ST_ID=" + pathName +
	    			"\">" + "Reactome:" + pathName + "</a>" ;
	    	}
	    	else
	    	{
	    		String[] pieces = pathName.split("\\:") ;
	    		// KEGG Pathway
	    		html = "<a href=\"http://www.genome.jp/dbget-bin/www_bget?pathway+" + pieces[1] +
	    			"\">" + "KEGG:" + pieces[1] 
	    			      + " </a>&nbsp;&nbsp;<a href=\"http://www.genome.jp/dbget-bin/show_pathway?" 
	    			      + pieces[1] + "\">Image</a>" ;
	    	}
	    	return html ;
	    }

	   public static String getKeggImageUrl(String id)
	   {
		   return "<a href=\"http://www.genome.jp/dbget-bin/show_pathway?" + id + "\">" + id + "</a>" ;
	   }

}
