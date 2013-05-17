<jsp:root version="1.2" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:display="urn:jsptld:http://displaytag.sf.net">
    <jsp:directive.page contentType="text/html; charset=UTF-8" />
    <jsp:directive.page import="org.ncibi.mimiweb.data.*" />
    <jsp:include page="inc/header2.jsp" flush="true" />

    <jsp:scriptlet> 
        String geneid = (String) request.getParameter("geneid") ;
        request.setAttribute( "test2", new GeneSummaryList2(Integer.parseInt(geneid))); 
        //request.setAttribute( "test2", new GeneSummaryList2(554)) ;
    </jsp:scriptlet>
    <display:table export="true" name="test2" pagesize="4" class="displaytag" id="genesummarypage2" requestURI="replaceURI">
        <display:column property="id" title="Id" sortable="true" headerClass="sortable" sortName="id"/>
        <display:column property="provSource" title="ProvSource" sortable="true" headerClass="sortable" sortName="provSource"/>
        <display:column property="name" title="Name" sortable="true" headerClass="sortable" sortName="name"/>
    </display:table>
</jsp:root>
