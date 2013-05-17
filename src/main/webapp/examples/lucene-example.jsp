<jsp:root version="1.2" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:display="urn:jsptld:http://displaytag.sf.net">
    <jsp:directive.page contentType="text/html; charset=UTF-8" />
    <jsp:directive.page import="org.ncibi.mimiweb.lucene.*, org.ncibi.mimiweb.data.*" />
    <jsp:include page="inc/header2.jsp" flush="true" />

    <jsp:scriptlet> 
        String search = (String) request.getParameter("search") ;
        LuceneInterface l = LuceneInterface.getInterface() ;
        request.setAttribute("lucene", l.fullGeneSearch(9606, search)) ; 
    </jsp:scriptlet>
    <display:table export="true" name="lucene" pagesize="4" class="displaytag" id="interactionspage" requestURI="replaceURI">
    </display:table>
</jsp:root>
