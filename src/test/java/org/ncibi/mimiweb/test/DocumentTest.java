package org.ncibi.mimiweb.test;

import java.util.ArrayList;
import java.util.Set;

import org.ncibi.mimiweb.data.hibernate.DenormInteraction;
import org.ncibi.mimiweb.hibernate.HibernateInterface;

import org.ncibi.db.pubmed.Citation;
import org.ncibi.db.pubmed.Document;
import org.ncibi.db.pubmed.NamedEntityTag;
import org.ncibi.mimiweb.util.DocPageUtil;
import org.ncibi.mimiweb.util.DocPageUtilGenePojo;

import org.junit.Test;

public class DocumentTest {

//	@Test
//	public void basicDocumentFetch() {
//		int pubmedid = 523351;
//		HibernateInterface h = HibernateInterface.getInterface();
//		Document d = h.getFullDocumentForPubmedId(pubmedid);
//		System.out.println(d.fullString());
//		System.out.println(d.toFullString(0));
//		
//	}

	@Test
	public void pageCodeTest() throws Exception {
        if (true)
            return ;
		int pubmedid = 523351;
		Integer geneid = new Integer(1436);
		Integer interactionid = null;
		HibernateInterface h = HibernateInterface.getInterface() ;
		
		Document doc = h.getFullDocumentDetails(pubmedid) ;
		
		assert(doc != null);
		
		Set s = doc.getCitations();
		if (s == null) {
			System.out.println("No Citation set.");
		} else if (s.size() < 1) {
			System.out.println("Empty Citation set.");
		} else {
			Citation c = doc.getCitations().iterator().next();
			
			System.out.println("Document...");
			System.out.println("  PubmedId = " + c.getPmid());
			System.out.println("  Title = " + c.getTitle());
			System.out.println("  Author(s) = " + c.getAuthorList());
			System.out.println("  Publication = " + c.getNlmTa());
			System.out.println("  Volume = " + c.getVolume());
			System.out.println("  Issue = " + c.getIssue());
			System.out.println("  Pages = " + c.getPages());
			System.out.println("  Data = " + c.getDate());
		}

		DocPageUtil docUtil = new DocPageUtil();
		
		String abstractText = docUtil.getAbstractAndSetPagePartsForDocument(doc);
		
		String noAbstract = "No Abstract in the database. See " +
		DocPageUtil.getPubmedRefUrlText(doc.getPmid()) + " for additional information.</p>";
		String header = "Annotated Abstract (showing tagged text)";
		
		if (abstractText.length() == 0) {
			abstractText = noAbstract;
			header = "No Abstract";
		}

		ArrayList<NamedEntityTag> geneTags = docUtil.getGeneTags();

		if (geneTags.size() == 0) {
			header = "Abstract";
		}
		
		System.out.println("Header: " + header);
		System.out.println("Abstract HTML... ");
		System.out.println(abstractText);
		
		ArrayList<DocPageUtilGenePojo> externalGeneList = docUtil.getUtilPojoForGenes(pubmedid);
		ArrayList<DocPageUtilGenePojo> tagGeneList = docUtil.getUtilPojoForTags();

		ArrayList<DocPageUtilGenePojo> geneList = new ArrayList<DocPageUtilGenePojo>();

		for (DocPageUtilGenePojo gene: externalGeneList) {
			geneList.add(gene);
		}
		for (DocPageUtilGenePojo gene: tagGeneList) {
			geneList.add(gene);	
		}

		DocPageUtilGenePojo highlightGene = null;
		DenormInteraction highlightInteraction = null;

		if (geneid != null) {
			// Note: gene.isHighlight() == true will set the id of the row to 'doc-detail-gene-table-highlight'
			// see: org.ncibi.mimiweb.decorator.DocDetailGeneTableDecorator
			for (DocPageUtilGenePojo gene: geneList) {
				if (gene.getId() == geneid.intValue()){
					gene.setHighlight(true);
					highlightGene = gene;
				}
				else
					gene.setHighlight(false);
			}
		}

		if (interactionid != null) {
			highlightInteraction = docUtil.getBasicInteractionDetails(interactionid) ;
			for (DocPageUtilGenePojo gene: geneList) {
				gene.setHighlight(false);
				if (gene.getId() == highlightInteraction.getGeneid1())
					gene.setHighlight(true);
				if (gene.getId() == highlightInteraction.getGeneid2())
					gene.setHighlight(true);
			}
		}

		if (highlightGene != null){
			if (highlightInteraction != null){
				if (highlightInteraction.getGeneid1() == highlightInteraction.getGeneid2()){
					System.out.println("Gene of Interest: self-referential gene: " + highlightInteraction.getGeneid1());
				} else {
					System.out.println("Genes of Interest: " +  highlightInteraction.getSymbol1() +
							" and " + highlightInteraction.getSymbol2() );
				}
			}
		}
		
		for (DocPageUtilGenePojo gene: geneList) {
			System.out.println("" + gene.getId() + ", " + gene.getSymbol() + ", "+ (gene.isHighlight()?"highlighted":"not highlighted"));
		}
	}
}
