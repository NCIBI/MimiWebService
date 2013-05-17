package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.HashMap;

import org.ncibi.mimiweb.data.ExternalReference;
import org.ncibi.mimiweb.data.ResultGeneMolecule ;
import org.ncibi.mimiweb.hibernate.HibernateInterface ;
import java.net.UnknownHostException;
import org.ncibi.mimiweb.data.GeneInteractionList ;
import org.ncibi.mimiweb.data.hibernate.DenormInteraction;

public class PsiDownload
{
	private static int interactionId = 0 ;
	private static HashMap<String, Integer> interactorRefs = new HashMap<String, Integer>();
	
	public static String getAnchorTag(String webapp, int geneid)
	{
		return "<a href=\"/" + webapp + "/psidownload.jsp?geneid="+geneid+"\">Download as PSI-MI</a>" ;
	}
	
	public static String createXml(ArrayList<ResultGeneMolecule> genes)
	{
		interactionId = 0 ;
		interactorRefs.clear();
		//ArrayList<ResultGeneMolecule> interactionGenes ;
		
		String xml = "" ;
		genes = filloutGenes(genes) ;
		
		//interactionGenes = filloutInteractionGenes(genes) ;
		
		xml = makeXmlHeader() ;
		xml = addxml(xml, "<interactorList>") ;
		int id = 0 ;
		for (ResultGeneMolecule gene : genes)
		{
			interactorRefs.put(gene.getSymbol(), id) ;
			xml += makeInteractorXml(gene, id) ;
			id++ ;
		}
		xml = addxml(xml, "</interactorList>") ;
		
		xml = addxml(xml, "<interactionList>") ;
		id = 0 ;
		for (ResultGeneMolecule gene : genes)
		{
			xml += makeInteractionXml(gene, id) ;
			id++ ;
		}
		xml = addxml(xml, "</interactionList>") ;
		
		xml += makeXmlFooter() ;
		return xml ;
	}
	
	private static String makeXmlHeader()
	{
		String xml = "" ;
		
		xml = addxml(xml, "<entrySet minorVersion=\"3\" version=\"5\" level=\"2\" xmlns=\"mi\"") ;
		xml = addxml(xml, "    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"") ;
		xml = addxml(xml, "    xmlns:xdf=\"http://dip.doe-mbi.ucla.edu/services/dxf\"") ;
		xml = addxml(xml, "    xsi:schemaLocation=\"mi http://psidev.sourceforge.net/mi/rel25/src/MIF25.xsd\">") ;
		
		xml = addxml(xml, "<entry>") ;
		xml = addxml(xml, "<source>") ;
		xml = addxml(xml, "<attributeList>") ;
		xml = addxml(xml, "<attribute name=\"url\">http://www.ncibi.org</attribute>") ;
		xml = addxml(xml, "<attribute name=\"postalAddress\">mimi-help@umich.edu</attribute>") ;
		xml = addxml(xml, "<attribute name=\"email\">ncibi.org</attribute>") ;
		xml = addxml(xml, "</attributeList>") ;
		xml = addxml(xml, "</source>") ;
		
		return xml;
	}
	
	private static String makeXmlFooter()
	{
		String xml = "" ;	
		xml = addxml(xml, "</entry>") ;
		xml = addxml(xml, "</entrySet>") ;
		return xml ;
	}
	
	private static String addxml(String xmlstr, String xmltoadd)
	{
		xmlstr += xmltoadd + "\n" ;
		return xmlstr ;
	}
	
	private static String makeInteractorXml(ResultGeneMolecule gene, int id)
	{
		String xml = "" ;
		xml = addxml(xml, "<interactor id=\"" + id + "\">") ;
		xml = addxml(xml, "<names>") ;
		xml = addxml(xml, "<fullName>" + gene.getSymbol() + "</fullName>") ;
		xml = addxml(xml, "</names>") ;
		xml = addxml(xml, "<xref>") ;
		
		boolean firstTime = true ;
		for (ExternalReference xref : gene.getExternalRefs())
		{
			if (firstTime)
			{
				xml = addxml(xml, "<primaryRef db=\"" + xref.getIdType() + "\"" + " id=\"" + xref.getIdValue() + "\""+ " refType=\"identify\"") ;
				firstTime = false ;
			}
			else
			{
				xml = addxml(xml, "<secondaryRef db=\"" + xref.getIdType() + "\"" + " id=\"" + xref.getIdValue() + "\""+ " refType=\"identify\"") ;
			}
		}
		xml = addxml(xml, "</xref>") ;
		
		xml = addxml(xml, "<interactorType>") ;
		xml = addxml(xml, "<names>") ;
		xml = addxml(xml, "<fullName>gene</fullName>") ;
		xml = addxml(xml, "</names>") ;
		xml = addxml(xml, "</interactorType>") ;

		xml = addxml(xml, "<organism ncbiTaxId=\"" + gene.getTaxid() + "\">") ;
		xml = addxml(xml, "<names>") ;
		xml = addxml(xml, "<shortLabel>" + gene.getTaxScientificName() + "</shortLabel>") ;
		xml = addxml(xml, "</names>") ;
		xml = addxml(xml, "</organism>") ;
		
		xml = addxml(xml, "</interactor>") ;
		
		return xml ;
	}
	
	private static String makeInteractionXml(ResultGeneMolecule gene, int id)
	{
		String xml = "" ;
		ArrayList<DenormInteraction> interactions = new GeneInteractionList(gene.getId()) ;
		xml = addxml(xml, "<interaction id=\"" + interactionId + "\">") ;
		
		for(DenormInteraction di : interactions)
		{
			xml = addxml(xml, "<participantList>") ;
			interactionId++ ;
			String symbol = "" ;
			int iref ;
			for (int i = 0 ; i < 2 ; i++)
			{
				if (i == 0)
				{
					symbol = di.getSymbol1() ;
					iref = interactorRefs.get(symbol) ;
				}
				else
				{
					symbol = di.getSymbol2() ;
					iref = -1 ;
				}

				xml = addxml(xml, "<participant>") ;
				xml = addxml(xml, "<names>") ;
				xml = addxml(xml, "<shortLabel>" + symbol + "</shortLabel>") ;
				xml = addxml(xml, "</names>") ;
				
				if (iref != -1)
				{
					xml = addxml(xml, "<interactorRef>" + iref + "</interactorRef>") ;
				}
				xml = addxml(xml, "</participant>") ;
			}
			xml = addxml(xml, "</participantList>") ;
		}
		
		xml = addxml(xml, "</interaction>") ;
		
		return xml ;
	}
	
	// not currently used
	/*
	 * Add to arraylist all the unique genes that occur in the interactions.
	 */
//	private static ArrayList<ResultGeneMolecule> filloutInteractionGenes(ArrayList<ResultGeneMolecule> genes)
//	{
//		HibernateInterface h = HibernateInterface.getInterface() ;	
//		HashMap<Integer, Integer> allGeneIds = new HashMap<Integer, Integer>() ;
//		
//		for (ResultGeneMolecule gene : genes)
//		{
//			allGeneIds.put(gene.getId(), gene.getId()) ;
//			ArrayList<DenormInteraction> diList = new GeneInteractionList(gene.getId()) ;
//			for (DenormInteraction di : diList)
//			{
//				allGeneIds.put(di.getGeneid2(), di.getGeneid2()) ;
//			}
//		}
//		
//		ArrayList<ResultGeneMolecule> allGenes = new ArrayList<ResultGeneMolecule>() ;
//		for (Integer geneid : allGeneIds.keySet())
//		{
//			try
//			{
//				ResultGeneMolecule g = h.getSingleGene(geneid) ;
//				g = h.extendSingleGene(g) ;
//				allGenes.add(g) ;
//			}
//			catch(UnknownHostException e)
//			{
//				continue ;
//			}
//		}
//		return allGenes ;
//	}
	
	
	private static ArrayList<ResultGeneMolecule> filloutGenes(ArrayList<ResultGeneMolecule> genes)
	{
		HibernateInterface h = HibernateInterface.getInterface() ;
		ArrayList<ResultGeneMolecule> filledGenes = new ArrayList<ResultGeneMolecule>() ;
		ResultGeneMolecule g ;
		for (ResultGeneMolecule gene : genes)
		{
			try
			{
				g = h.extendSingleGene(gene) ;
			}
			catch(UnknownHostException e)
			{
				continue ;
			}	
			filledGenes.add(g) ;
		}	
		return filledGenes ;
	}
}
