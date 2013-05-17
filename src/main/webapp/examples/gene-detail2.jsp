<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>

<%
    String geneid1 = request.getParameter("geneid1") ;
    String geneid2 = request.getParameter("geneid2") ;
    String jsp1 = "/example-mimi.jsp?geneid=" + geneid1 ;
    String jsp2 = "geneid=" + geneid2 ;
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
                    dwr.util.setValue("demoReply", data, { escapeHtml:false });
                });
            }
            function update2(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, function(data) {
                    dwr.util.setValue("demoReply2", data, { escapeHtml:false }) ;
                }) ;
            }
            update("update", "/example-mimi.jsp", "") ;
            update2("update2", "/example-mimi2.jsp", "<%=jsp2%>") ;
        </script>
    </head>
    <body>
        <hr/>
        <div id="displayTable">
            <span id="demoReply"></span>
        </div>
        <hr/>
        <div id="displayTable2">
            <span id="demoReply2"></span>
        </div> 
    </body>
</html>
