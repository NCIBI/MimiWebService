<%@ page language="java" 
	contentType="text/xml; charset=ISO-8859-1"
	import="java.io.OutputStream"
%><jsp:useBean id="userProfile" class="org.ncibi.mimiweb.xml.UserProfileCover" scope="session"/><%
	
	response.setHeader("Content-disposition","attachment;filename=\"userState.xml\""); 

	try {
		userProfile.marshel(response.getOutputStream());
	} catch (Throwable t) {
		out.println("<error>" + t.getLocalizedMessage() + "</error>");
	}
%>