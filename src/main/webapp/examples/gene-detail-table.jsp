<jsp:root version="1.2" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:display="urn:jsptld:http://displaytag.sf.net">
    <jsp:directive.page contentType="text/html; charset=UTF-8" />
    <jsp:directive.page import="org.ncibi.mimiweb.data.*" />
    <jsp:include page="inc/header2.jsp" flush="true" />

    <jsp:scriptlet>
        String geneid = request.getParameter("geneid") ;
		//		This line was generating an error flag in my version of Eclipse - 09/05/2008 - tew
        //        request.setAttribute( "test", new GeneSummaryList(Integer.parseInt(geneid)));
    </jsp:scriptlet>
    <display:table export="true" name="test" pagesize="4">
        <display:column property="id" title="Id" sortable="true" headerClass="sortable"/>
        <display:column property="provSource" title="ProvSource" sortable="true" headerClass="sortable"/>
        <display:column property="name" title="Name" sortable="true" headerClass="sortable"/>
    </display:table>
</jsp:root>
