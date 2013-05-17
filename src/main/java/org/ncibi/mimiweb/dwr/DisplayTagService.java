package org.ncibi.mimiweb.dwr;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletRequest;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.ncibi.mimiweb.displaytag.DisplayTagUtil ;

public class DisplayTagService
{
	public String updateLinks(String js, String jsp, String criteria)
	{
		WebContext wctx = WebContextFactory.get();

		//
		// Not sure if I'll need to do the following below, or not...
		//
		HttpServletRequest request = wctx.getHttpServletRequest();
		String contextPath = request.getContextPath() ;
		
		//request.setAttribute(getObjectsName(), getObjects(firstResult, maxResults, orderBy, ascending));
		//request.setAttribute(getNumberOfObjectsName(), numberOfObjects);
		try 
		{
			String html = wctx.forwardToString(jsp + "?" + criteria);
			html = DisplayTagUtil.fixAllReplaceURI(js, jsp, contextPath, html) ;
			return html ;
		} 
		catch (ServletException e) 
		{
			return "<p> Error processing request: ServeltException = " + e.getLocalizedMessage() + "  </p>";
		} 
		catch (IOException e) 
		{
			return "<p> Error processing request: IO Exception = " + e.getLocalizedMessage() + " </p>";
		}
	}
	
}
