<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String pubmedid = request.getParameter("pubmedid") ;
    String pubmedidparm = "pubmedid=" + pubmedid ;

    String geneid = request.getParameter("geneid") ;
    if (geneid != null)
	    pubmedidparm += "&geneid=" + geneid ;
%>

<html>
    <head>
        <title>MiMI/Pubmed Article Summary</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <script type="text/javascript" src="js/ncibi.js"></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">
            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
            }
            update("update", "/document-details-page-v2.jsp", "<%=pubmedidparm%>") ;
        </script>
    </head>
    <body>
<jsp:include page="mimiHeaderInc.html" />
<div id="mimi-nav">
	<ul>
	<li><a href="main-page.jsp">Free Text Search</a></li>
	<li><a href="upload-page.jsp">List Search</a></li>
	<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
	<li><a href="AboutPage.html">About MiMI</a></li>
	<li><a href="HelpPage.html">Help</a></li>
	</ul>
</div><!-- End mimi-nav div -->
        <div id="displayTable">
            <span id="dt-replace-here">
			<p>Data loading from database... <br />
			<image src="images/new_status_bar.gif"></p>
			</span>
        </div>
        <jsp:include page="mimiFooterInc.html" />
    </body>
</html>
