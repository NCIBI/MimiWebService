package org.ncibi.mimiweb.dwr;

import org.ncibi.mimiweb.tools.ToolWebService;

public class CountWebService
{
    public String getHtmlGeneCountForGene2Mesh(final String gene, final int taxid)
    {
        final int count = ToolWebService.getCountForGeneSearch(gene, taxid);
        String heading = "headings";

        if (count != 0)
        {
            if (count == 1)
            {
                heading = "heading";
            }
            
            return "<p>" + count + " <b>MeSH</b> " + heading
                    + " found matching gene in Gene2MeSH. To view click <a href='"
                    + ToolWebService.getLinkForGeneSearch(gene, taxid) + "'>here.</a> </p>";
        }

        return "";
    }

    public String getHtmlMeshCountForGene2Mesh(final String mesh, final int taxid)
    {
        final int count = ToolWebService.getCountForMeshSearch(mesh, taxid);
        String gene = "genes";

        if (count != 0)
        {
            if (count == 1)
            {
                gene = "gene";
            }
            
            return "<p>" + count + " <b>" + gene
                    + "</b> found matching MeSH heading in Gene2MeSH. To view click <a href='"
                    + ToolWebService.getLinkForMeshSearch(mesh, taxid) + "'>here.</a> </p>";
        }

        return "";
    }

    public String getHtmlConceptCountForConceptgen(final String searchterm)
    {
        final int count = ToolWebService.getCountForConceptgen(searchterm);
        String match = "matches were";

        if (count != 0)
        {
            if (count == 1)
            {
                match = "match was";
            }
            return "<p>" + count
                    + " <b>Concept</b> " + match + " found in Conceptgen. To view click <a href='"
                    + ToolWebService.getLinkForConceptgen(searchterm) + "'>here.</a> </p>";
        }

        return "";
    }
}
