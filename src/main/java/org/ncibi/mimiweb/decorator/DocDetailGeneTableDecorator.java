package org.ncibi.mimiweb.decorator;

import java.util.ArrayList;

import org.displaytag.decorator.TableDecorator;
import org.ncibi.mimiweb.util.DocPageUtilGenePojo;
import org.ncibi.mimiweb.util.GoUtils;

public class DocDetailGeneTableDecorator extends TableDecorator
{
	public DocDetailGeneTableDecorator()
	{
		super() ;
	}
	
	public String addRowId(){
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject();
		if (gene.isHighlight()) return "doc-detail-gene-table-highlight";
		return null;
	}
	
	public String getInteractionCount()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject();
		int i = gene.getInteractionCount() ;
		return (i == 0) ? "-" : "<a href=\"interaction-list-page-front.jsp?geneid=" + gene.getId() + "\">" + i + "</a>" ;
	}
	
	public String getPathwayCount()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		int i = gene.getPathwayCount() ;
		return (i == 0) ? "-" : "<a href=\"pathway-list-page-front.jsp?geneid=" + gene.getId() + "\">" + i + "</a>" ;
	}
	
	public String getPubCount()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		int pubCount = gene.getPubCount() ;
		return (pubCount == 0) ? "-" : "<a href=\"document-list-page-front.jsp?geneid=" + gene.getId() + "\">" + pubCount + "</a>" ;
	}
	
	public String getCellularComponents()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		ArrayList<String> cc = gene.getCellularComponents() ;
		return GoUtils.makeGoTermsHTML(cc) ;
	}
	
	public String getBiologicalProcesses()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		ArrayList<String> bp = gene.getBiologicalProcesses() ;
		return GoUtils.makeGoTermsHTML(bp) ;
	}
	
	public String getMolecularFunctions()
	{
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		ArrayList<String> mf = gene.getMolecularFunctions() ;
		return GoUtils.makeGoTermsHTML(mf) ;
	}
	
	public String getTagged(){
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		String s = "merge";
		if (gene.getTagged()) s="tag";
		return s;
	}
	
	public String getTagText() {
		DocPageUtilGenePojo gene = (DocPageUtilGenePojo) getCurrentRowObject() ;
		String s = "-";
		if ((gene.getTagText() != null) && (gene.getTagText().length() > 0)) s = gene.getTagText();
		return s;
	}
}
