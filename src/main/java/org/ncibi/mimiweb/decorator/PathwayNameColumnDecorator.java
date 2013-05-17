package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;
import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.mimiweb.util.PathwayUtil;

public class PathwayNameColumnDecorator implements DisplaytagColumnDecorator
{
	public Object decorate(Object arg0, PageContext arg1, MediaTypeEnum arg2)
		throws DecoratorException
	{
		String pathName = (String) arg0 ;
		return PathwayUtil.getPathnameHTML(pathName) ;
	}
}
