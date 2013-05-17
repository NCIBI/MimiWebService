package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.mimiweb.data.hibernate.DenormInteraction;

public class InteractionPublicationCountColumnDecorator implements DisplaytagColumnDecorator{

	public static final String URL = "document-list-page-front.jsp";
	public static final String PARAMETER = "interactionid";
	
	public Object decorate(Object o, PageContext pc, MediaTypeEnum mt)
			throws DecoratorException {
		if (!(o instanceof DenormInteraction)) return "-";
		DenormInteraction i = (DenormInteraction)o;
		if (i.getPubMedCount() == 0) return "-";
		return "<a href=\"" + URL + "?" + PARAMETER + "=" + i.getGgIntID() + "\">" + i.getPubMedCount() + "</a>";
	}

}
