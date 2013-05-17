<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>

<%
    String geneid1 = request.getParameter("geneid1") ;
    String geneid2 = request.getParameter("geneid2") ;
    String jsp1 = "/example-mimi.jsp?geneid=" + geneid1 ;
    String jsp2 = "geneid1=" + geneid1 + "&geneid2=" + geneid2 ;
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
                    dwr.util.setValue("example3", data, { escapeHtml:false });
                });
            }
            update("update", "/example-mimi3.jsp", "<%=jsp2%>") ;
        </script>
    </head>
    <body>
        <hr/>
        <div id="displayTable">
            <span id="example3"></span>
        </div>
        <hr/>
    </body>
</html>
