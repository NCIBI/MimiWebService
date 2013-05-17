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
    
   	String unioninteractions = request.getParameter("unioninteractions") ;
    if (unioninteractions != null)
	    pubmedidparm += "&unioninteractions=" + unioninteractions ;
    
    String interactionid = request.getParameter("interactionid");
    if (interactionid != null)
    	pubmedidparm += "&interactionid=" + interactionid;
%>

<html>
    <head>
        <title>MiMI/Pubmed Article Summary</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <script type="text/javascript" src="js/ncibi.js"></script>
        <script type='text/javascript' src="http://code.jquery.com/jquery-latest.js"></script>
        <script type="text/javascript" src="js/jquery.dynacloud-4.js"></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">
            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
            }
            update("update", "/document-details-page.jsp", "<%=pubmedidparm%>") ;
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
            <div id="dynacloud"></div>
            <div class="dynacloud">
<a href="javascript:void($('#dynacloud').parent().dynaCloud());"><strong>Generate a tag/keyword cloud from this blog entry</strong></a>.</p>
                <span id="dt-replace-here">
			    <p>Data loading from database... <br />
			    <image src="images/new_status_bar.gif"></p>
			    </span>
            </div>
        </div>
        <jsp:include page="mimiFooterInc.html" />
    </body>
</html>
