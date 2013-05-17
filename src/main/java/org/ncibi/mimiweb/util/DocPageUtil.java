package org.ncibi.mimiweb.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Collections;
import java.util.List;

import org.ncibi.db.factory.PubmedSessionFactory;
import org.ncibi.db.pubmed.Document;
import org.ncibi.db.pubmed.NamedEntityTag;
import org.ncibi.db.pubmed.Paragraph;
import org.ncibi.db.pubmed.Section;
import org.ncibi.db.pubmed.Sentence;

import org.apache.lucene.queryParser.ParseException;
import org.hibernate.Session;
import org.ncibi.lucene.MimiDocument;
import org.ncibi.mimiweb.data.GeneInteractionList;
import org.ncibi.mimiweb.data.ResultGeneMolecule;
import org.ncibi.mimiweb.data.hibernate.DenormInteraction;
import org.ncibi.mimiweb.data.hibernate.DocumentBriefSimple;
import org.ncibi.mimiweb.hibernate.Gene2PubmedFromPubmed;
import org.ncibi.mimiweb.hibernate.HibernateInterface;
import org.ncibi.mimiweb.lucene.LuceneInterface;

public class DocPageUtil
{
	private static final String EOL = "\n";
	private static final String PM = "http://www.ncbi.nlm.nih.gov/sites/entrez?db=pubmed&cmd=search&term=";

	private ArrayList<NamedEntityTag> geneTags = new ArrayList<NamedEntityTag>();
	//NOTE: there are no mesh tags in the database as of 09/10/08
	//ArrayList<NamedEntityTag> meshTags = new ArrayList<NamedEntityTag>();
	
	public ArrayList<NamedEntityTag> getGeneTags() {
		return geneTags;
	}

	public String getAbstractAndSetPagePartsForDocument(Document d)
	{
		String html = "";
		
		geneTags = new ArrayList<NamedEntityTag>();
		//NOTE: there are no mesh tags in the database as of 09/10/08
		//meshTags = new ArrayList<NamedEntityTag>();
		
		ArrayList<Section> sections = d.getOrderedSections();
		
		if ((sections == null) || (sections.size() == 0))
		{
			return html;
		} else 
		{
			for (Iterator<Section> iSec = d.getOrderedSections().iterator(); iSec.hasNext();)
			{
				Section sec = (Section) iSec.next();
				for (Iterator<Paragraph> iPar = sec.getOrderedParagraphs().iterator(); iPar
						.hasNext();)
				{
					Paragraph p = (Paragraph) iPar.next();
					html += "<p>" + EOL;
					for (Iterator<Sentence> iSen = p.getOrderedSentences().iterator(); iSen
							.hasNext();)
					{
						Sentence sen = (Sentence) iSen.next();
						html += "    " + markText(sen) + EOL;
						if ((sen.getGeneTags() != null)
								&& (sen.getGeneTags().size() > 0))
						{
							for (Iterator<NamedEntityTag> iTag = sen.getGeneTags().iterator(); iTag
									.hasNext();)
							{
								NamedEntityTag tag = (NamedEntityTag) iTag.next();
								geneTags.add(tag);
							}
						}
						//NOTE: there are no mesh tags in the database as of 09/10/08
//						if ((sen.getMeshTags() != null)
//								&& (sen.getMeshTags().size() > 0))
//						{
//							for (Iterator<NamedEntityTag> iTag = sen.getMeshTags().iterator(); iTag
//									.hasNext();)
//							{
//								NamedEntityTag tag = (NamedEntityTag) iTag.next();
//								meshTags.add(tag);
//							}
//						}
					}
					html += "</p>" + EOL;
				}
			}
		}
		geneTags = sortTagsAlphabetically(extend(removeRepeats(geneTags)));
		return html;
	}

	public static String getPubmedRefUrlText(int pubmedid){
		return getPubmedRefUrlText("" + pubmedid);
	}
	
	public static String getPubmedRefUrlText(String pubmedid){
		String url = PM + pubmedid;
		return "<a href=\"" + url + "\" >" + pubmedid + "</a>";
	}
	
	public static ArrayList<NamedEntityTag> getNamedEntityTags(Document d)
	{
		ArrayList<NamedEntityTag> geneTags = new ArrayList<NamedEntityTag>() ;
		for (Iterator<Section> iSec = d.getOrderedSections().iterator(); iSec.hasNext();)
		{
			Section sec = (Section) iSec.next();
			for (Iterator<Paragraph> iPar = sec.getOrderedParagraphs().iterator(); iPar
					.hasNext();)
			{
				Paragraph p = (Paragraph) iPar.next();
				for (Iterator<Sentence> iSen = p.getOrderedSentences().iterator(); iSen
						.hasNext();)
				{
					Sentence sen = (Sentence) iSen.next();
					if ((sen.getGeneTags() != null)
							&& (sen.getGeneTags().size() > 0))
					{
						for (Iterator<NamedEntityTag> iTag = sen.getGeneTags().iterator(); iTag
								.hasNext();)
						{
							NamedEntityTag tag = (NamedEntityTag) iTag.next();
							geneTags.add(tag);
						}
					}
				}
			}
		}
		return removeRepeats(geneTags) ;
	}

	private static ArrayList<NamedEntityTag> extend(ArrayList<NamedEntityTag> arrayList) {
		HibernateInterface h = HibernateInterface.getInterface();
		return h.addGeneAndTaxonomyToNamedEntityTagArray(arrayList);
	}

	@SuppressWarnings("unchecked")
	private static String markText(Sentence sen)
	{
		String text = sen.getSentence();
		// if there are no tags... return the text
		if (((sen.getGeneTags() == null) || sen.getGeneTags().size() == 0)
				&& ((sen.getMeshTags() == null) || sen.getMeshTags().size() == 0))
			return text;

		// otherwise... process tags
		ArrayList tags = new ArrayList();

		if (sen.getGeneTags() != null)
			for (Iterator i = sen.getGeneTags().iterator(); i.hasNext();)
				tags.add((NamedEntityTag) i.next());
		if (sen.getMeshTags() != null)
			for (Iterator i = sen.getMeshTags().iterator(); i.hasNext();)
				tags.add((NamedEntityTag) i.next());

		tags = sortTagsByPosition(tags);

		int offset = 0;
		int lastpos = -1;
		for (Iterator i = tags.iterator(); i.hasNext();)
		{
			NamedEntityTag tag = (NamedEntityTag) i.next();
			if (tag.getFirstChar().intValue() != lastpos)
			{
				int start = tag.getFirstChar().intValue() + offset;
				int end = tag.getLastChar().intValue() + offset;
//				String anchor = makeAnchor(tag);
				String pre = text.substring(0, start);
				String part = text.substring(start, end + 1);
				String post = text.substring(end + 1, text.length());
				String a1 = "<span class=\"doc-detail-text-highlight\" id=\"doc-detail-text-highlight\" >";
				String a2 = "</span>";
				text = pre + a1 + part + a2 + post;
				offset += a1.length() + a2.length();
			}
			lastpos = tag.getFirstChar().intValue();
		}

		return text;
	}

	@SuppressWarnings("unchecked")
	private static ArrayList sortTagsByPosition(ArrayList tags)
	{
		Collections.sort(tags, new Comparator()
		{
			public int compare(Object o1, Object o2)
			{
				return ((NamedEntityTag) o1).getFirstChar().compareTo(
						((NamedEntityTag) o2).getFirstChar());
			}
		});
		return tags;
	}

	// not currently used
//	private static String makeAnchor(NamedEntityTag tag)
//	{
//		return "Gene-" + tag.getGeneId();
//	}

	private static ArrayList<NamedEntityTag> removeRepeats(ArrayList<NamedEntityTag> tagList)
	{
		ArrayList<NamedEntityTag> ret = new ArrayList<NamedEntityTag>();
		HashSet<Integer> set = new HashSet<Integer>();

		for (NamedEntityTag tag: tagList)
		{
			Integer id = tag.getTagsGene().getGeneId();
			if (!set.contains(id))
			{
				set.add(id);
				ret.add(tag);
			}
		}

		return ret;
	}

	private static ArrayList<NamedEntityTag> sortTagsAlphabetically(ArrayList<NamedEntityTag> tags)
	{
		Collections.sort(tags, new Comparator<NamedEntityTag>()
		{
			public int compare(NamedEntityTag tag1, NamedEntityTag tag2) {
				if ((tag1.getTaxId() == null) && (tag2.getTaxId() != null))
					return -1;
				if ((tag1.getTaxId() != null) && (tag2.getTaxId() == null))
					return 1;
				if (((tag1.getTaxId() == null) && (tag2.getTaxId() == null))
					|| (tag1.getTaxId().compareTo(tag2.getTaxId()) == 0))
					return tag1.getMatchString().compareTo(tag2.getMatchString());
				return tag1.getTaxId().compareTo(tag2.getTaxId());
			}
		});
		return tags;
	}
	
	public ArrayList<MimiDocument> getMimiDocsForDocument(Integer pubmedId) throws Exception {
		
		ArrayList<MimiDocument> genes = new ArrayList<MimiDocument>();
		if (pubmedId == null) return genes;
		
		ArrayList<Gene2PubmedFromPubmed> gene2pub = new ArrayList<Gene2PubmedFromPubmed>();
		Session session = PubmedSessionFactory.getSessionFactory().getCurrentSession() ;
		session.beginTransaction() ;
		
		try {
			
			String hsql = "From Gene2PubmedFromPubmed where PMID=" + pubmedId.toString();
			List<Gene2PubmedFromPubmed> ret = session.createQuery(hsql).list();
			
			gene2pub = new ArrayList<Gene2PubmedFromPubmed>(ret);
			
		} catch (Exception e) {
			throw e;
		} finally {
			session.getTransaction().commit();
		}

		if (gene2pub.size() == 0) return genes;
		
		// System.out.println("Number of records = " + gene2pub.size());
		// for (Gene2PubmedFromPubmed rel: gene2pub){
		//	System.out.println("Geneid = " + rel.getId().getGeneid());
		//}
		
		LuceneInterface l = LuceneInterface.getInterface();

		ArrayList<Integer> geneIdList = new ArrayList<Integer>();
		for (Gene2PubmedFromPubmed rel: gene2pub){
			geneIdList.add(rel.getId().getGeneid());
		}

		genes = l.lookupByGeneId(geneIdList);
		
		// for (MimiDocument gene: genes) {
		//	System.out.println("Gene: " + gene.geneSymbol + ":" + gene.geneid);
		// }
		
		return genes;
	}
	
	public ArrayList<MimiDocument> getMimiDocsForTags() throws IOException, ParseException{

		ArrayList<MimiDocument> genes = new ArrayList<MimiDocument>();
		
		if ((geneTags == null) || (geneTags.size() == 0)) return genes;
		
		LuceneInterface l = LuceneInterface.getInterface();

		HashSet<Integer> geneIdSet = new HashSet<Integer>();
		for (NamedEntityTag tag: geneTags){
			if (tag.getTagsGene().getGeneId() != null)
				geneIdSet.add(tag.getTagsGene().getGeneId());
		}

		if (geneIdSet.size() == 0) return genes;
		
		genes = l.lookupByGeneId(new ArrayList<Integer>(geneIdSet));
		
		return genes;
		
	}
	
	public ArrayList<DocPageUtilGenePojo> getUtilPojoForGenes(int pubmedid) throws Exception{
		
		ArrayList<DocPageUtilGenePojo> ret = new ArrayList<DocPageUtilGenePojo>();
		
		ArrayList<MimiDocument> docs = getMimiDocsForDocument(new Integer(pubmedid));
		
		if (docs.size() == 0) return ret;

		for (MimiDocument doc: docs) {
			ret.add(new DocPageUtilGenePojo(doc,false,null));
		}

		return ret;
	}

	public ArrayList<DocPageUtilGenePojo> getUtilPojoForTags() throws IOException, ParseException{

		ArrayList<DocPageUtilGenePojo> ret = new ArrayList<DocPageUtilGenePojo>();
		
		ArrayList<MimiDocument> docs = getMimiDocsForTags();

		if (docs.size() == 0) return ret;

		HashMap<Integer,MimiDocument> table = new HashMap<Integer,MimiDocument>();

		for (MimiDocument doc: docs)
			table.put(new Integer(doc.geneid), doc);
		
		for (NamedEntityTag tag: geneTags) {
			if (tag.getTagsGene().getGeneId() != null) {
				MimiDocument doc = table.get(tag.getTagsGene().getGeneId());
				if (doc != null)
					ret.add(new DocPageUtilGenePojo(doc,true,tag.getActualString()));
			}
		}
		return ret;
	}
	
	public ArrayList<DocumentBriefSimple> getDocumentsForGeneId(int geneId){
		
		HibernateInterface h = HibernateInterface.getInterface() ;
		return h.getDocumentsForGeneId(geneId);
	}
	
	public ArrayList<DocumentBriefSimple> getDocumentsForInteraction(DenormInteraction i){
		HibernateInterface h = HibernateInterface.getInterface() ;
        ArrayList<Integer> pmids = i.getPubmedIdList() ;
  
        return h.getDocumentDetailsForPubmedList(pmids) ;
	}
	
	public List<DocumentBriefSimple> getDocumentsForInteraction(int interactionId)
	{
	    HibernateInterface h = HibernateInterface.getInterface();
	    return h.getDocumentsForInteractionId(interactionId);
	}
	
	public DenormInteraction getBasicInteractionDetails(int interactionId){
		HibernateInterface h = HibernateInterface.getInterface() ;
    	return h.getBasicInteractionDetails(interactionId) ;
	}
	
	public ArrayList<DocumentBriefSimple> getDocumentsForGeneInteractions(ResultGeneMolecule gene){
		ArrayList<DenormInteraction> list = new GeneInteractionList(gene.getId());
		HashSet<Integer> set = new HashSet<Integer>();
		for (DenormInteraction i: list){
			for (Integer pmid: i.getPubmedIdList())
				set.add(pmid);
		}
		ArrayList<Integer> pmids = new ArrayList<Integer>(set);

		HibernateInterface h = HibernateInterface.getInterface() ;
		
		return h.getDocumentDetailsForPubmedList(pmids) ;
	}
}
