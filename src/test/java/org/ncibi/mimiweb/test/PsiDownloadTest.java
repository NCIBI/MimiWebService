package org.ncibi.mimiweb.test;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.lucene.queryParser.ParseException;
import org.junit.Test ;
import org.ncibi.mimiweb.data.ResultGeneMolecule;
import org.ncibi.mimiweb.lucene.LuceneInterface;
import org.ncibi.mimiweb.util.PsiDownload;

//import static org.junit.Assert.*;

public class PsiDownloadTest
{
	@Test
	public void testXml() throws ParseException, IOException
	{
        if (true)
            return ;
        LuceneInterface l = LuceneInterface.getInterface() ;
        ArrayList<ResultGeneMolecule> genes = l.fullGeneSearch(-1, "CSF1R") ;
        String xml = PsiDownload.createXml(genes) ;
        System.out.println("Done") ;
        System.out.println("xml = " + xml) ;
	}
}
