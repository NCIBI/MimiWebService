<%@
    page language="java"
    import="org.ncibi.mimiweb.lucene.LuceneInterface,
    java.util.HashSet, java.util.Collections, java.util.ArrayList,
    org.ncibi.mimiweb.data.ResultGeneMolecule"
    contentType="text/plain; charset=UTF-8"
%><%
	String query = request.getParameter("query") ;
	String taxidString = request.getParameter("taxid") ;
	String useAllCaseString = request.getParameter("usecase") ;
	boolean useAllCase = (useAllCaseString != null);
	int taxid = -1;
	try {
		int value = Integer.parseInt(taxidString);
		taxid=value;
	} catch (Throwable ignore) {}
	if (query == null) {
		out.println("%ERROR%: query parameter not supplied. It is null.");
		return;
	}
	LuceneInterface l = LuceneInterface.getInterface();
	boolean ok = l.probe();
	if (!ok) {
		out.println("%ERROR%: query database (Lucene) is not available. Please notify mimi-help@umich.edu.");
		return;
	}
	HashSet<String> results = new HashSet<String>();
	ArrayList<ResultGeneMolecule> genes = l.searchForSummary(taxid,query);
	for (ResultGeneMolecule gene: genes){
		String symbol = gene.getSymbol();
		if (!useAllCase) symbol = symbol.toUpperCase();
		results.add(symbol);
	}
	ArrayList<String> list = new ArrayList<String>(results);
	boolean first = true;
	Collections.sort(list);
	for (String geneSymbol: list) {
		if (first) {
			out.print(geneSymbol);
			first = false;
		}
		else
			out.print("," + geneSymbol);
	}
	out.println();
%>
