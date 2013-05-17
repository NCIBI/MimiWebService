<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.util.ArrayList,
                org.ncibi.mimiweb.autocomplete.*"%>
<%
    String q = (String) request.getParameter("q") ;
    AutocompleteSearcher as = new AutocompleteSearcher() ;
    ArrayList<String> matches = as.findMatch(q) ;
    response.setContentType("text/html");
    out.clear() ;
    out.clearBuffer() ;
    for (String match : matches)
    {
        out.print(match) ;
        out.newLine() ;
        out.flush() ;
    }
    out.flush() ;
%>

