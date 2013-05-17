package org.ncibi.mimiweb.decorator;

import org.displaytag.decorator.TableDecorator;
import org.ncibi.mimiweb.data.hibernate.GenePathways;

/**
 * Decorates the GenePathways for Display tag to filter out Reactome pathways
 * and not display a link to a details page on them.
 * 
 * @author gtarcea
 * 
 */
public final class GenePathwaysDecorator extends TableDecorator
{
    /**
     * Constructor.
     */
    public GenePathwaysDecorator()
    {
        super();
    }

    /**
     * Creates the string for linking to the details on a pathway. Never creates
     * a link for a Reactome pathway, but instead returns "-".
     * 
     * @return For KEGG Pathways a HTML href tag to the pathway details. For
     *         reactome the string "-".
     */
    public String getId()
    {
        final GenePathways gp = (GenePathways) getCurrentRowObject();

        /*
         * Hack to handle Reactome Pathways. There are no details for a Reactome
         * Pathway currently, so don't create a link to a details page. The way
         * that we identify a Reactome pathway is to look for "REACT" in its
         * pathway name. Ugh....
         */
        final String pathname = gp.getPathname();
        final int reactomeIndex = pathname.indexOf("REACT");
        return (reactomeIndex == -1) ? "<a href=\"pathway-details-page-front.jsp?pathwayid="
                + gp.getId() + "\">View Related</a>"
                : "-";
    }
}
