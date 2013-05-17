<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<html>
    <head>
        <title>Gene Detail Page</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/DisplayTagService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />
<% String jsp2="What is this"; %>
        <script type="text/javascript">
            function update2(js, jsp, criteria) {
                DisplayTagService.updateLinks(js, jsp, criteria, function(data) {
                    dwr.util.setValue("demoReply2", data, { escapeHtml:false }) ;
                }) ;
            }
            update2("update2", "/example-mimi2.jsp", "<%=jsp2%>") ;
        </script>
    </head>
    <body>
        <hr/>
        <h3>Interactions</h3>
        <div id="displayTable1">
            <span id="interactions"></span>
        </div>
        <hr/>
        <h3>Molecule Provenance</h3>
        <div id="displayTable2">
            <span id="molprov"></span>
        </div>
        <hr/>
        <h3>Related Documents</h3>
        <div id="displayTable3">
            <span id="rdocs"></span>
        </div>
    </body>
</html>
