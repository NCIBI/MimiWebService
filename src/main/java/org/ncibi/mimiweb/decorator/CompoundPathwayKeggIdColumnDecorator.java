package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;
import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.mimiweb.util.PathwayUtil;

public class CompoundPathwayKeggIdColumnDecorator implements
		DisplaytagColumnDecorator
{
	public Object decorate(Object arg0, PageContext arg1, MediaTypeEnum arg2)
			throws DecoratorException
	{
		String keggId = (String) arg0;
		return PathwayUtil.getKeggImageUrl(keggId) ;
	}
}
