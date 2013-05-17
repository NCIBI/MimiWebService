package org.ncibi.mimiweb.tools;

import org.junit.Test;
import org.ncibi.mimiweb.tools.ToolWebService;

public class ToolsWebServiceTest
{
    @Test
    public void testGetCountForGeneSearch()
    {
        final int count = ToolWebService.getCountForGeneSearch("prostate cancer", -1);
        System.out.println("count = " + count);
    }
    
    @Test
    public void testConceptgenCount()
    {
        final int count = ToolWebService.getCountForConceptgen("tp53");
        System.out.println("count = " + count);
    }
}
