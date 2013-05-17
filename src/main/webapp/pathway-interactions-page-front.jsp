<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String pathwayid = request.getParameter("pathwayid") ;
    String pathwayidparm = "pathwayid=" + pathwayid ;
%>

<html>
    <head>
        <title>Pathway Interactions</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <script type="text/javascript" src="js/ncibi.js"></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">
            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, ncibi_callback) ;
            }
            update("update", "/pathway-interactions-page.jsp", "<%=pathwayidparm%>") ;
        </script>
    </head>
    <body>
<jsp:include page="mimiHeaderInc.html" />
        <div id="displayTable">
            <span id="dt-replace-here">
			<p>Data loading from database... <br />
			<image src="images/new_status_bar.gif"></p>
			</span>
        </div>
        <jsp:include page="mimiFooterInc.html" />
    </body>
</html>
