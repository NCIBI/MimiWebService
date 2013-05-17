package org.ncibi.mimiweb.util;

import javax.servlet.http.HttpServletRequest;

public class WebApp
{

	public static String getWebApp(HttpServletRequest request)
	{
		String uri = request.getRequestURI();
		int pos = uri.indexOf("/",1);
		return uri.substring(1,pos) ;
	}
	
	public static String getWebAppHost(HttpServletRequest request)
	{
		return request.getLocalName() ;
	}
	
	public static String constructWebAppPath(HttpServletRequest request, String rest)
	{
		String webPath = "http://" ;
		
		webPath += getWebAppHost(request) ;
		webPath += "/" + getWebApp(request) ;
		
		if (! rest.startsWith("/"))
		{
			webPath += "/" ;
		}
		webPath += rest ;
		
		return webPath ;
	}

}
