<%@ page language="java" contentType="text/plain; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><%@page import="java.util.Iterator,
	java.util.ArrayList,
	java.net.URL,
	org.ncibi.mimiweb.browser.Constraint,
	org.ncibi.mimiweb.browser.BrowserUtil,
	org.ncibi.mimiweb.browser.hibernate.BrowserHibernateInterface,
	org.ncibi.mimiweb.browser.hibernate.data.GeneAttributeCount"%><jsp:useBean 
	id="state" class="org.ncibi.mimiweb.browser.BrowserState" scope="session"/><%@ 
	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%

	// set up
	BrowserHibernateInterface h = BrowserHibernateInterface.getInterface();
	ArrayList<GeneAttributeCount> list = null;
	ArrayList<GeneAttributeCount> attributeCounts 
		= h.getAllAttributeCounts(state.getSearchConstraint(),state.getConstraints());

	String position = request.getParameter("index");

	int index = -1;
	try {
		index = Integer.parseInt(position);
	} catch (Throwable ignore) {}

	if ((index > -1 ) && (index < attributeCounts.size())) {
		GeneAttributeCount c = attributeCounts.get(index);
		Constraint last = new Constraint(c.getId().getAttributeType(), c.getId().getAttributeValue());
		ArrayList<Constraint> constraints = new ArrayList<Constraint>(state.getConstraints());
		constraints.add(last);

		ArrayList<Object[]> geneIdList = h.getGeneListFromAttributeConstraints(c.getCount(),constraints);

		for (Object[] row: geneIdList){
			Integer geneid = (Integer)row[0];
			String symbol = row[1].toString();
			String taxname = row[2].toString();
			out.println(geneid + "," + symbol + "," + taxname);			
		}
		
	}
%>
