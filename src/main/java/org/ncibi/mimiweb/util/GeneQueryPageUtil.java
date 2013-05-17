package org.ncibi.mimiweb.util;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.apache.lucene.queryParser.ParseException;
import org.ncibi.lucene.MimiDocument;
import org.ncibi.mimiweb.data.AttributeFilter;
import org.ncibi.mimiweb.data.AttributeTreeNode;
import org.ncibi.mimiweb.data.GeneCoverForSelection;
import org.ncibi.mimiweb.data.GeneQueryInteraction;
import org.ncibi.mimiweb.data.GeneQueryStateHolder;
import org.ncibi.mimiweb.hibernate.HibernateInterfaceForGeneQuery;
import org.ncibi.mimiweb.lucene.LuceneInterface;

public class GeneQueryPageUtil {
	
	private static Logger logger = Logger.getLogger(GeneQueryPageUtil.class);
	
	public static void setGeneQueryStateFromSearch(GeneQueryStateHolder query, String search, String taxidString)
	throws IOException, ParseException{

		LuceneInterface l = LuceneInterface.getInterface();
		HibernateInterfaceForGeneQuery hgq = HibernateInterfaceForGeneQuery.getInterface();

		int taxid = query.getTaxid();
		try {
			if (taxidString != null)
				taxid = Integer.parseInt(taxidString);
		} catch (Throwable ignore){}
	    String organism = Organism.lookupById(taxid);
	    
	    logger.debug("setGeneQueryStateFromSearch: " + search + ", " + taxid);
	    
	    ArrayList<MimiDocument> docs = l.getFirstNeighborListForQuery(taxid, search) ;
	    ArrayList<GeneCoverForSelection> genes = new  ArrayList<GeneCoverForSelection>();

	    for (MimiDocument doc: docs) {
			if ((taxid < 0) || (doc.taxid == taxid)) {
				genes.add(new GeneCoverForSelection(l.makeResultGeneFromMimiDoc(doc)));
			}
		}

	    ArrayList<AttributeTreeNode>geneAttrTree = hgq.getGeneAttributeTreeFromGeneList(genes);
	    ArrayList<AttributeTreeNode>intrAttrTree = hgq.getIntrAttributeTreeFromGeneList(genes);

	    query.setOriginalSearch(search);
	    query.setTaxid(taxid);
	    query.setOrganism(organism);
	    query.setGenes(genes);
	    query.setGeneAttrTree(geneAttrTree);
	    query.setIntrAttrTree(intrAttrTree);

	}
	
	public static void updateAttributeSelections(GeneQueryStateHolder query){
		updateTreeSelection(query.getGeneSelection(),query.getGeneAttrTree());
		updateTreeSelection(query.getIntrSelection(),query.getIntrAttrTree());
	}
	
	public static void clearAttributeSelections(GeneQueryStateHolder query){
		updateTreeSelection(null,query.getGeneAttrTree());
		updateTreeSelection(null,query.getIntrAttrTree());
		
		for (GeneCoverForSelection gene: query.getGenes()) {
			gene.setSelected(false);
		}
	}
	
	private static void updateTreeSelection(String[] selection, ArrayList<AttributeTreeNode> tree) {
		if (tree == null) return;
		for (AttributeTreeNode attribute: tree) {
			attribute.setSelected(false);
			for (AttributeTreeNode value: attribute.getChildList())
				value.setSelected(false);
		}
		
		if (selection == null) return;
		for (String sel: selection){
			// parse selection each is in the form of n-m; n = attribute index;  m = value index;
			int nameIndex = -1;
			int valueIndex = -1;
			String [] parts = sel.split("-");
			if (parts.length == 2) {
				try {nameIndex = Integer.parseInt(parts[0].trim()); } catch (Throwable ignore){}
				try {valueIndex = Integer.parseInt(parts[1].trim()); } catch (Throwable ignore){}
			}
			if ((nameIndex != -1) && (valueIndex != -1)){
				--nameIndex;
				--valueIndex;
				tree.get(nameIndex).setSelected(true);
				tree.get(nameIndex).getChildList().get(valueIndex).setSelected(true);
			}			
		}
	}
	
	public static void setAttributeFilters(GeneQueryStateHolder query){

		clearAttributeFilters(query);
		
		// Gene Attribute Filters
		for (AttributeTreeNode attr: query.getGeneAttrTree()) {
			for (AttributeTreeNode value: attr.getChildList()) {
				if (value.isSelected()){
					query.getGeneAttributeFilters().add(new AttributeFilter(attr.getName(),value.getName()));
				}
			}
		}

		// Interaction Attribute Filters
		for (AttributeTreeNode attr: query.getIntrAttrTree()) {
			for (AttributeTreeNode value: attr.getChildList()) {
				if (value.isSelected()){
					query.getIntrAttributeFilters().add(new AttributeFilter(attr.getName(),value.getName()));
				}
			}
		}
		
		// Gene Filters
		for (GeneCoverForSelection gene: query.getGenes()) {
			if (gene.isSelected())
				query.getGeneFilters().add(gene);
		}

	}
	
	public static void determineMarkedSets(GeneQueryStateHolder query)
	{
		ArrayList<GeneCoverForSelection> markedGeneSet = new ArrayList<GeneCoverForSelection>();
		ArrayList<GeneQueryInteraction> markedIntrSet = new ArrayList<GeneQueryInteraction>();
		
		// dummy data
		if ((query.getGenes() != null) && (query.getGenes().size() > 0)){
			GeneCoverForSelection gene1 = query.getGenes().get(0);
			markedGeneSet.add(gene1);
			if (query.getGenes().size() > 1) {
				GeneCoverForSelection gene2 = query.getGenes().get(1);
				markedIntrSet.add(new GeneQueryInteraction(gene1,gene2));
			}
		}
		
		query.setMarkedGeneSet(markedGeneSet);
		query.setMarkedIntrSet(markedIntrSet);
	}
	
	public static void clearAttributeFilters(GeneQueryStateHolder query)
	{
		query.getGeneAttributeFilters().clear();
		query.getIntrAttributeFilters().clear();
		query.getGeneFilters().clear();		
	}
}
