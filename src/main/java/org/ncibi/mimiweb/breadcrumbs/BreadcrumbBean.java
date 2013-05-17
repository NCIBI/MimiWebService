package org.ncibi.mimiweb.breadcrumbs;

import java.util.ArrayList ;

public class BreadcrumbBean
{
	private ArrayList<Breadcrumb> breadcrumbList = new ArrayList<Breadcrumb>() ;
	private String divid ;
	
	public BreadcrumbBean(String divid)
	{
		this.divid = divid ;
	}
	
	public BreadcrumbBean()
	{
		this.divid = "breadCrumb0" ;
	}
	
	public void addBreadcrumb(String desc, String link)
	{
		Breadcrumb bc = new Breadcrumb(desc, link) ;
		breadcrumbList.add(bc) ;
	}
	
	public void addUniqueBreadcrumb(String desc, String link)
	{
		boolean found = false ;
		
		for (Breadcrumb bc : breadcrumbList)
		{
			if (bc.getDescription().equals(desc))
			{
				found = true ;
				break ;
			}
		}
		
		if (! found)
		{
			addBreadcrumb(desc, link) ;
		}
	}
	
	public void clearBreadcrumbs()
	{
		breadcrumbList.clear() ;
	}

	public String generateBreadcrumbTrail()
	{
		String html = "<div class=\"breadCrumbHolder module\">\n" ;
		
		html += "<div id=\"" + divid + "\" class=\"breadCrumb module\">\n" ;
		html += "<ul>\n" ;
		
		for (Breadcrumb bc : breadcrumbList)
		{
			html += "<li>\n" ;
			html += "<a href=\"" + bc.getLink() + "\">" + bc.getDescription() + "</a>\n" ;
			html += "</li>\n" ;
		}
		html += "</ul>\n" ;
		html += "</div>\n" ;
		html += "</div>\n" ;
		
		return html ;
	}
}
