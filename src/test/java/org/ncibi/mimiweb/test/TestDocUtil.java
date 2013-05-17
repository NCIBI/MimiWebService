package org.ncibi.mimiweb.test;

import java.util.ArrayList;

import org.junit.Test;
import org.ncibi.mimiweb.data.hibernate.DenormInteraction;
import org.ncibi.mimiweb.data.hibernate.DocumentBriefSimple;
import org.ncibi.mimiweb.decorator.DocListDataWrapper;
import org.ncibi.mimiweb.util.DocPageUtil;

public class TestDocUtil {

	private int interactionid=63869;
	private DocPageUtil docUtil = new DocPageUtil();
	
	@Test
	public void interactionDocs(){
	    DenormInteraction i = docUtil.getBasicInteractionDetails(interactionid) ;

        ArrayList<Integer> pmids = i.getPubmedIdList() ;
        System.out.println("PMID count = " + pmids.size());
        for (Integer id: pmids){
        	System.out.println("  " + id);
        }
	    
	    ArrayList<DocListDataWrapper> wrapperList = new ArrayList<DocListDataWrapper>();

        ArrayList<DocumentBriefSimple> dlist = docUtil.getDocumentsForInteraction(i);
        for (DocumentBriefSimple doc: dlist) {
        	wrapperList.add(new DocListDataWrapper(DocListDataWrapper.INTERACTION,interactionid,doc,""));
        }

	    System.out.println("Size of list = " + wrapperList.size());
	}
	
}
