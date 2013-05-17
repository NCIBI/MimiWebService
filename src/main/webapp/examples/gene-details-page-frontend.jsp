<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>

<%
    String geneid = request.getParameter("search") ;
    String geneidparm = "search=" + geneid ;
%>

<html>
    <head>
        <title>Displaytag Ajaxified with dwr</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">
            function update(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, function(data) {
                    dwr.util.setValue("interactions", data, { escapeHtml:false });
                });
            }
            update("update", "/interactions-table.jsp", "<%=geneidparm%>") ;
        </script>
    </head>
    <body>
        <hr/>
        <div id="displayTable">
            <span id="interactions"></span>
        </div>
        <hr/>
    </body>
</html>
