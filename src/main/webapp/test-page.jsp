<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.io.*,
                java.util.ArrayList,
                org.ncibi.mimiweb.data.hibernate.*,
                org.ncibi.mimiweb.hibernate.*,
                org.ncibi.mimiweb.util.FlotUtil,
                org.ncibi.mimiweb.data.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
    <head>
        <title>MiMI Reaction Details</title>
        <script type='text/javascript' src='<c:url value="/dwr/interface/LuceneSearchService.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/engine.js"/>'></script>
        <script type='text/javascript' src='<c:url value="/dwr/util.js"/>'></script>
        <link rel="stylesheet" type="text/css" href='<c:url value="/css/displaytag.css"/>' />

        <script type="text/javascript">

            function runtest()
            {
                LuceneSearchService.findMatchingGenes("diabetes", 9606, function(data) {
                    alert(data) ;
                }) ;
            
            }
            runtest() ;
        </script>
    </head>
    <body>
        <p>hello world<p>
    </body>
</html>
