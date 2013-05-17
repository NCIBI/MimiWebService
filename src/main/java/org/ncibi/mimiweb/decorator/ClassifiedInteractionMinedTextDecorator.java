package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.db.pubmed.gin.ClassifiedInteraction;

/**
 * Decorator class for ClassifiedInteraction to link to document details page.
 * @author gtarcea
 *
 */
public class ClassifiedInteractionMinedTextDecorator implements DisplaytagColumnDecorator
{
    /**
     * Decorate a ClassifiedInteraction to show the link to the document details page.
     */
    public Object decorate(final Object arg0, final PageContext arg1, final MediaTypeEnum arg2)
            throws DecoratorException
    {
        final ClassifiedInteraction ci = (ClassifiedInteraction) arg0;
        final String url = "document-details-page-front.jsp?pubmedid=" + ci.getPmid() + "&geneid="
                + ci.getGeneID1();
        final String html = "<a href=\"" + url + "\" >" + "view" + "</a>";

        return html;
    }

}
