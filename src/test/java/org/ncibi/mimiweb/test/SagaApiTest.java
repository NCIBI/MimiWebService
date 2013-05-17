package org.ncibi.mimiweb.test;

import org.junit.BeforeClass;
import org.junit.Test;
import org.ncibi.mimiweb.api.SagaApi2 ;
import org.ncibi.mimiweb.api.SagaGeneElement ;
import java.util.ArrayList ;
import org.ncibi.mimiweb.api.SagaUtil ;

public class SagaApiTest
{
//      private static ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>() ;
      private static SagaGeneElement pwp1 = new SagaGeneElement("CSF1R") ;
//      private static SagaGeneElement sge2noints = new SagaGeneElement("CSF1R") ;
      private static SagaGeneElement sge3 = new SagaGeneElement("GENEC") ;
      private static SagaGeneElement sge4 = new SagaGeneElement("GENED") ;
    
    @BeforeClass
    public static void setUp() 
    {
        pwp1.connectedGenes.add("GRAP2") ;
        pwp1.connectedGenes.add("SOCS3") ;
        
        sge3.connectedGenes.add("C1") ;
        
        sge4.connectedGenes.add("D1") ;
        sge4.connectedGenes.add("D2") ;
        sge4.connectedGenes.add("D3") ;
        sge4.connectedGenes.add("D4") ;  
    }
    
//    @Test
//	public void testNoInteractions()
//	{
//		ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>();
//		SagaApi2 sapi2 = new SagaApi2() ;
//		
//		graph.add(sge2noints);
//
//		String graphstr = sapi2.getSagaGraphStr(graph);
//
//		System.out.println(graphstr);
//		System.out.println("========");
//	}

	@Test
	public void test1GeneWithInteractions()
	{
		ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>();
		graph.add(pwp1);
		SagaApi2 sapi2 = new SagaApi2() ;
		
		String graphstr = sapi2.getSagaGraphStr(graph);
		System.out.println(graphstr);
		System.out.println("========");
	}
    
//    @Test
//    public void testCallSagaGet()
//    {
//        System.out.println("testCallSagaGet()") ;
//        ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>() ;
//        graph.add(pwp1) ;
//        SagaApi2 sapi2 = new SagaApi2() ;
//        String graphstr = sapi2.getSagaGraphStr(graph) ;
//        String url = sapi2.callSagaGet(null, null, graphstr) ;
//        System.out.println("url = " + url) ;
//        assertFalse(url.equals("FAILED")) ;
//    }
    
//    @Test
//    public void testCallInvalid()
//    {
//        ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>() ;
//        graph.add(pwp1) ;
//        SagaApi2 sapi2 = new SagaApi2() ;
//        String graphstr = sapi2.getSagaGraphStr(graph) ;
//        String url = sapi2.callSagaGet(null,null, graphstr) ;
//        System.out.println("url = " + url) ;
//        assertTrue(url.equals("FAILED")) ;
//    }
//
//    
    @Test 
    public void testCallSagaPost()
    {
        SagaApi2 sapi2 = new SagaApi2() ;
        ArrayList<SagaGeneElement> graph = new ArrayList<SagaGeneElement>() ;
        graph.add(pwp1) ;
        String graphstr = sapi2.getSagaGraphStr(graph) ;
        String url = sapi2.callSagaPost(null, null, graphstr) ;
        System.out.println("url = " + url) ;
    }
    
//    @Test
//    public void testWorkingExample1()
//    {
//    	String g = "1453|1454|1857,1454|1453|1857,1857|1453|1454|2932|7976|8326,2932|1857|51199,51199|2932,10009|7481,7481|10009|6425|7976|8326|11197|6424,7482|6425|7976|8326|11197|6424,6425|7481|7482|7976|8326|7480|89780|7479,7976|1857|7481|7482|6425|7480|89780|7479|6424,8326|1857|7481|7482|6425|7480|89780|7479|6424,7480|6425|7976|8326|11197|6424,89780|6425|7976|8326|11197|6424,7479|6425|7976|8326|11197|6424,11197|7481|7482|7480|89780|7479,6424|7481|7482|7976|8326|7480|89780|7479" ;
//    	ArrayList<SagaGeneElement> sge ;
//    	sge = SagaUtil.createGraph(g) ;
//    	String graphstr = SagaApi.getSagaGraphStr(sge) ;
//    	System.out.println(graphstr) ;
//    }

    @Test
    public void testWorkingExample2()
    {
    	String g = "1453|1454|1857,1454|1453|1857,1857|1453|1454|2932|7976|8326,2932|1857|51199,51199|2932,10009|7481,7481|10009|6425|7976|8326|11197|6424,7482|6425|7976|8326|11197|6424,6425|7481|7482|7976|8326|7480|89780|7479,7976|1857|7481|7482|6425|7480|89780|7479|6424,8326|1857|7481|7482|6425|7480|89780|7479|6424,7480|6425|7976|8326|11197|6424,89780|6425|7976|8326|11197|6424,7479|6425|7976|8326|11197|6424,11197|7481|7482|7480|89780|7479,6424|7481|7482|7976|8326|7480|89780|7479" ;
        SagaApi2 sapi2 = new SagaApi2() ;
    	ArrayList<SagaGeneElement> sge ;
    	sge = SagaUtil.createGraph(g) ;
    	String graphstr = sapi2.getSagaGraphStr(sge) ;
    	System.out.println("In test, graphsrt = " + graphstr) ;
        String url = sapi2.callSagaPost(null, null, graphstr) ;
        System.out.println("url = " + url) ;
    }

}
