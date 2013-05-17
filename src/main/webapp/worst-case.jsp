<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Worst Case testing of Gene Detail Page</title>
</head>
<%
	String[] titles = {
		"Other Name list",
		"Other Description list",
		"Biological Process",
		"Molecular Function",
		"Cellular Component",
		"Long other name strings",
		"Long name list with long strings"
	};

	int[][] geneIdValues = {
		{47877, 44505, 37455},
		{47877, 44505, 37455},
		{29192, 84353, 29627},
		{25486, 24413, 11481},
		{29192,  84353,  29627},
		{838348, 822200, 827210},
		{837327, 835813, 32624}
	};
	
	String base = "gene-details-page-front.jsp?geneid=";

%>
<body>
<%
	int index=0;
	for (String title: titles){
%>
		<h3><%= title %></h3>
		<b>Gene Detail pages demonstrating overflow problems:</b>
<%
		for (int id: geneIdValues[index]){
			String url = base + id + "&overflow=yes";
%>
			<a href="<%= url %>"><%= id %></a>
<%		
		}
%>
		<br />
		<b>Gene Detail pages with overflow truncated:</b>
<%
		for (int id: geneIdValues[index++]){
			String url = base + id;
%>
			<a href="<%= url %>"><%= id %></a>
<%		
		}
%>
		<br />
<%		
	}
%>
</body>
</html>