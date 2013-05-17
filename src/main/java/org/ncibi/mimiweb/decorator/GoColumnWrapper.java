package org.ncibi.mimiweb.decorator;

import java.util.ArrayList;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.mimiweb.util.GoUtils;

public class GoColumnWrapper implements DisplaytagColumnDecorator
{

	@SuppressWarnings("unchecked")
	/***
	 * This function intentionally does not specify the item type for the ArrayList.
	 * This allows me to use the generic GoUtils.makeGoTermsHTML() function, without
	 * having to create different wrappers for the different types.
	 */
	public Object decorate(Object arg0, PageContext arg1, MediaTypeEnum arg2)
			throws DecoratorException
	{
		ArrayList goTerms = (ArrayList) arg0 ; 	
		return GoUtils.makeGoTermsHTML(goTerms);
	}

}
