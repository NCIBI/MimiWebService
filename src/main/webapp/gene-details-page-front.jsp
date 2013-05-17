<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>
<%@
    page language="java"
    import="java.util.ArrayList,
            org.ncibi.mimiweb.util.WebApp,
            org.ncibi.mimiweb.util.Organism,
            org.ncibi.mimiweb.breadcrumbs.*"
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String geneid = request.getParameter("geneid") ;

    String geneidparm = "geneid=" + geneid ;
    String overflow = request.getParameter("overflow") ;
    if (overflow != null)
    	geneidparm += "&overflow=yes";
%>
<html>
    <head>
        <title>MiMI Gene Details</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <script src="http://www.google.com/jsapi"></script>
        <script> google.load("jquery", "1") </script>
        <script type='text/javascript' src="js/jquery.easing.1.3.js"></script>
        <script type='text/javascript' src="js/jquery.jBreadCrumb.js"></script>
        <script type="text/javascript" src="js/ncibi.js"></script>
        <!-- <link rel="stylesheet" href="css/Base.css" type="text/css"> -->
        <link rel="stylesheet" href="css/BreadCrumb.css" type="text/css">
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/genedetailtoptable.css"/>' />
        <script type="text/javascript">
            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback);
            }
            update("update", "/gene-details-page.jsp", "<%=geneidparm%>") ;
        </script>
    </head>
    <body>
<jsp:include page="mimiHeaderInc.html" />
<input type="hidden" id="savestate" value="no"/>
<input type="hidden" id="savestate2" value="no"/>
<div id="mimi-nav">
	<ul>
	<li><a href="main-page.jsp">Free Text Search</a></li>
	<li><a href="upload-page.jsp">List Search</a></li>
	<li><a href="interaction-query-page.jsp">Query Interactions</a></li>
	<li><a href="AboutPage.html">About MiMI</a></li>
	<li><a href="HelpPage.html">Help</a></li>
	</ul>
</div><!-- End mimi-nav div -->
    <div class="chevronOverlay main"></div>
        <div id="displayTable">
            <span id="dt-replace-here">
			<p>Data loading from database... <br />
			<image src="images/new_status_bar.gif"></p>
			</span>
        </div>
        <jsp:include page="mimiFooterInc.html" />
    </body>
</html>
