package org.ncibi.mimiweb.decorator;

import java.util.ArrayList;

import org.displaytag.decorator.TableDecorator;
import org.ncibi.mimiweb.data.ResultGeneMolecule;
import org.ncibi.mimiweb.util.GoUtils;

public class ResultGeneMoleculeDecorator extends TableDecorator
{
	public ResultGeneMoleculeDecorator()
	{
		super() ;
	}
	
	public String getInteractionCount()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject();
		int i = rgm.getInteractionCount() ;
		return (i == 0) ? "-" : "<a href=\"interaction-list-page-front.jsp?geneid=" + rgm.getId() + "\">" + i + "</a>" ;
	}
	
	public String getPathwayCount()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		int i = rgm.getPathwayCount() ;
		return (i == 0) ? "-" : "<a href=\"pathway-list-page-front.jsp?geneid=" + rgm.getId() + "\">" + i + "</a>" ;
	}
	
	public String getPubCount()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		int pubCount = rgm.getPubCount() ;
		return (pubCount == 0) ? "-" : "<a href=\"document-list-page-front.jsp?geneid=" + rgm.getId() + "\">" + pubCount + "</a>" ;
	}
	
	public String getCellularComponents()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		ArrayList<String> cc = rgm.getCellularComponents() ;
		return GoUtils.makeGoTermsHTML(cc) ;
	}
	
	public String getBiologicalProcesses()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		ArrayList<String> bp = rgm.getBiologicalProcesses() ;
		return GoUtils.makeGoTermsHTML(bp) ;
	}
	
	public String getMolecularFunctions()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		ArrayList<String> mf = rgm.getMolecularFunctions() ;
		return GoUtils.makeGoTermsHTML(mf) ;
	}
	
	public String getKeggIds()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		String html = "" ;
		boolean firstTime = true ;
		for (String id : rgm.getKeggIds())
		{
            String[] pieces = id.split("\\:") ;
            String thtml = "<a href=\"http://www.genome.jp/dbget-bin/www_bget?" 
            	+ pieces[0] + "+" + pieces[1] + "\">" + id + "</a>";
			
			if (firstTime)
			{
				html = thtml ;
				firstTime = false ;
			}
			else
			{
				html += ", " + thtml ;
			}
		}
		return html ;
	}
	
	public String getChromosome()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		String chromosome = rgm.getChromosome() ;
		int taxid = rgm.getTaxid() ;
		return "<a href=\"http://www.ncbi.nlm.nih.gov/projects/mapview/maps.cgi?taxid=" 
				+ taxid + "&chr=" + chromosome + "\">" + chromosome + "</a>" ;
	}
	
	public String getMapLocus()
	{
		ResultGeneMolecule rgm = (ResultGeneMolecule) getCurrentRowObject() ;
		String mapLocus = rgm.getMapLocus() ;
		String html = "<a href=\"http://www.ncbi.nlm.nih.gov/sites/entrez?db=gene&cmd=search&term=" +
				mapLocus + "\">" + mapLocus + "</a>" ;
		
		return html ;
	}
}
