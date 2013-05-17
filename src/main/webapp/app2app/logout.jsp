<?xml version="1.0" encoding="ISO-8859-1" ?><%@ 
	page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><%
    
    // remove username and password; and return to the login page
    
    session.removeAttribute("username");
    session.removeAttribute("password");
    
    String redirectURL = "login.jsp";
%><jsp:forward page="<%= redirectURL %>" />
