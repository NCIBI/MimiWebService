<%@
    page language="java"
    import="java.net.URL"
%><%
	String interactionid = request.getParameter("interactionid") ;
	String hostname = request.getSession().getServletContext().getInitParameter("external-hostname");
	if ((hostname != null) && (hostname.length() == 0)) hostname = null;
	String serverName = request.getServerName();
	if (hostname != null) serverName = hostname;
	int port = request.getServerPort();
	String uri = request.getRequestURI();
	int pos = uri.indexOf("/",1);
	String webappName = "MimiWeb";
	if (pos > 0) {
		webappName = uri.substring(1,pos);
	}
	String base = (new URL(request.getScheme(),serverName,port,"/" + webappName + "/interaction-details-page-front.jsp")).toString();
	if (hostname != null)
		base = "http://" + hostname + "/" + webappName + "/interaction-details-page-front.jsp";
	String redirectURLbase = base + "?interactionid=";
	String redirectURL = redirectURLbase + interactionid;
	if (interactionid != null) {
		response.sendRedirect(redirectURL);
		return;
	}
%>
<html><head><title>Redirect</title></head><body>
<%	if (interactionid != null) { %>
Your should have been redirected to <a href="<%= redirectURL %>">this page</a>.
<%	} else { %>
Using this page requires the URL to supply an Interaction ID (internal MiMI representation).<br />
Usage is: show-interaction.jsp?interactionid=<i>ineractionIdValue</i> <br />
For Example: <b>show-interaction.jsp?interactionid=135370</b>
<%	} %>
</body></html>
