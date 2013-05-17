package org.ncibi.mimiweb.decorator;
import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

public class PubmedColumnDecorator implements DisplaytagColumnDecorator
{
	public Object decorate(Object arg0, PageContext arg1, MediaTypeEnum arg2)
		throws DecoratorException
	{
		Integer pubmedid = (Integer) arg0 ;
		
		String html = "<a href=\"http://www.ncbi.nlm.nih.gov/sites/entrez?db=pubmed&cmd=search&term=" + pubmedid +
		"\">" + pubmedid + "</a>" ;
		
		return html ;
	}
}
