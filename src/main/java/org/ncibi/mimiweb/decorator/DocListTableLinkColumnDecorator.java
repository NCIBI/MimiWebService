package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

public class DocListTableLinkColumnDecorator implements DisplaytagColumnDecorator {

	public Object decorate(Object docObj, PageContext arg1, MediaTypeEnum arg2) throws DecoratorException 
	{
		DocListDataWrapper doc = (DocListDataWrapper)docObj;
		String url = "document-details-page-front.jsp?pubmedid=" + doc.getId();
		if (doc.getWhichCase().equals(DocListDataWrapper.GENE) || doc.getWhichCase().equals(DocListDataWrapper.GENE_INTERACTION))
			url += "&geneid=" + doc.getRefId();
		if (doc.getWhichCase().equals(DocListDataWrapper.GENE_INTERACTION))
			url += "&unioninteractions=yes";
		if (doc.getWhichCase().equals(DocListDataWrapper.INTERACTION))
			url += "&interactionid=" + ((DocListDataWrapper)doc).getRefId();
		return
			"<a href=\"" + url + "\" >" + doc.getLinkText() + "</a>";
	}

}
