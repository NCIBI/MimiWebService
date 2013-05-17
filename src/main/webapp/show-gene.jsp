<%@
    page language="java"
    import="java.net.URL"
%><%
	String geneid = request.getParameter("geneid") ;
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
	String base = (new URL(request.getScheme(),serverName,port,"/" + webappName + "/gene-details-page-front.jsp")).toString();
	if (hostname != null)
		base = "http://" + hostname + "/" + webappName + "/gene-details-page-front.jsp";
	String redirectURLbase = base + "?geneid=";
	String redirectURL = redirectURLbase + geneid;
	if (geneid != null) {
		response.sendRedirect(redirectURL);
		return;
	}
%>
<html><head><title>Redirect</title></head><body>
<%	if (geneid != null) { %>
Your should have been redirected to <a href="<%= redirectURL %>">this page</a>.
<%	} else { %>
Using this page requires the URL to supply a geneId (internal MiMI representation).<br />
Usage is: show-gene.jsp?geneid=<i>geneIdValue</i> <br />
For Example: <b>show-gene.jsp?geneid=1436</b>
<%	} %>
</body></html>
