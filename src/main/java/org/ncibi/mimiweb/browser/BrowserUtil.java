package org.ncibi.mimiweb.browser;

import java.util.ArrayList;
import java.util.HashMap;

import org.ncibi.mimiweb.browser.hibernate.BrowserHibernateInterface;
import org.ncibi.mimiweb.browser.hibernate.data.GeneAttributeCount;

public class BrowserUtil {

	// http://mimi.ncibi.org/MimiWeb/MimiWebApplication.html?userhash=1&usertag=GENE_DETAIL_PAGE|-1|-1&pageGeneId=1620
	// http://biosearch2d.ncibi.org/conceptgen/Network/mimi.jsp?taxid=9606&geneid=NA&symbol=DBC1,CTAG1B,HIC1
	
	// public static String netBBrowserPrefix
	//  = "http://biosearch2d.ncibi.org/conceptgen/Network/mimi.jsp?taxid=NA&symbol=NA&geneid=";

	public static String makeLinkString(String baseUrl, BrowserState state, GeneAttributeCount c){
		Constraint last = new Constraint(c.getId().getAttributeType(), c.getId().getAttributeValue());
		ArrayList<Constraint> constraints = new ArrayList<Constraint>(state.getConstraints());
		constraints.add(last);

		int max = state.getGenesToShow();
		BrowserHibernateInterface h = BrowserHibernateInterface.getInterface();
		ArrayList<Object[]> geneIdList = h.getGeneListFromAttributeConstraints(max,constraints);

//		String flat = null;
		String list = null;
		String mimi = "";
		
		int count = 0;
		for (Object[] row: geneIdList){
			count++;
			
			Integer geneid = (Integer)row[0];
			String symbol = row[1].toString();
			String taxname = row[2].toString();
			
			if (count > max)
				mimi = "...";
			else
				mimi = "<a href=\"" + baseUrl + "/gene-details-page-front.jsp?geneid=" + geneid.toString() + "\" >" 
					+ symbol + "(" + taxname + ")" + "</a>";
			
			if (list == null) list = mimi;
			else list += ", " + mimi;
			if (count > max) break;
		}
		
		if (count > max)
			list = "** " + list;
		
		String ret = list;

		return ret ;
	}
	
	public static void printConstraintList(ArrayList<Constraint> list){
		System.out.println("Printing constraint list... ");
		for (Constraint c: list){
			System.out.println("  " + c.getType() + ": " + c.getValue());
		}
	}
	
	/**
	 * Maps mimi attribute types (from the denorm.GeneAttribute table) to display names or null (if
	 * the attribute should not be displayed).
	 * @param attributeType
	 * @return
	 */
	public static String attributeDisplayName(String attributeType){
		if (attributeTypeTable == null) makeAttributeTypeTable();
		return attributeTypeTable.get(attributeType);
	}
	
	public static ArrayList<String> attributeTypeList(){
		if (attributeTypeTable == null) makeAttributeTypeTable();
		return new ArrayList<String>(attributeTypeTable.keySet());
	}
	
	private static void makeAttributeTypeTable() {
		attributeTypeTable = new HashMap<String,String>();
		for (String[] entry: attributeMappingArray){
			attributeTypeTable.put(entry[0],entry[1]);
		}
	}

	//	Attribute Types from the database...
	//	sql: select distinct attrType from denorm.GeneAttribute
	//	chromosome          
	//	 Component           
	//	 description         
	//	 Function            
	//	 gene type           
	//	 kegg gene           
	//	 locustag            
	//	 map_loc             
	//	 molecule type       
	//	 organism            
	//	 pathway             
	//	 pathway description 
	//	 pathway name        
	//	 Process             
	//	 symbol              
	//	 synonyms            
	//	 taxid              
	private static String[][] attributeMappingArray = {
		{"chromosome","Chromosome"},
		{"Component","Cellular Component"},
		{"Function","Molecular Function"},
		{"organism","Organism (Scientific Name)"},
		{"pathway","Pathway"},
		{"molecule type","Molecule Type"},
		{"Process","Biological Process"},
		{"gene type","Gene Type"}
	};
	
	private static HashMap<String,String> attributeTypeTable = null;
	
}
