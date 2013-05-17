package org.ncibi.mimiweb.api;

import org.ncibi.mimiweb.api.SagaGeneElement ;
import java.util.ArrayList ;

public class SagaUtil 
{
    public static ArrayList<SagaGeneElement> createGraph(String genelist)
    {
        ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>() ;
        
        String glist[] = genelist.split(",") ;
        
        for (int i = 0 ; i < glist.length ; i++)
        {
            String interactionsList[] = glist[i].split("\\|") ;
            String primaryGene = interactionsList[0] ;
            SagaGeneElement sge = new SagaGeneElement(primaryGene) ;
            for (int j = 1 ; j < interactionsList.length ; j++)
            {
                sge.connectedGenes.add(interactionsList[j]) ;
            }
            graph.add(sge) ;
        }
        
        return graph ;
    }

}
