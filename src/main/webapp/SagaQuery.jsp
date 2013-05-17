<%@
    page language = "java" import =    "org.ncibi.mimiweb.api.SagaApi2, 
                                        org.ncibi.mimiweb.api.SagaUtil, 
                                        org.ncibi.mimiweb.api.SagaGeneElement,
                                        java.util.ArrayList"
%>

<%
    String genelist = (String) request.getParameter("genelist") ;
    String percent = (String) request.getParameter("percent") ;
    percent = "20" ;
    ArrayList<SagaGeneElement> graph = SagaUtil.createGraph(genelist) ;
    SagaApi2 sapi = new SagaApi2() ;
    String graphstr = sapi.getSagaGraphStr(graph) ;
    String url = sapi.callSagaPost(null, percent, graphstr) ;
    //response.setContentType("text/plain") ;
    response.sendRedirect(url) ;
%>

