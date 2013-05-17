package org.ncibi.mimiweb.test;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Properties;

import org.ncibi.db.factory.GeneSessionFactory;
import org.ncibi.db.gene.Taxonomy;
import org.ncibi.db.pubmed.Document;

import org.hibernate.Session;
import org.junit.Test;
import org.ncibi.mimiweb.data.MoleculeRecord;
import org.ncibi.mimiweb.hibernate.HibernateInterface;
import org.ncibi.mimiweb.util.DocPageUtil;
import org.ncibi.mimiweb.util.PropertiesUtil;

public class TestHibernatePropertiesUtil {

		@Test
		public void testPropertiesUtil() throws IOException{
            if (true)
                return ;
			
			ClassLoader systemClassLoader = ClassLoader.getSystemClassLoader();
			assert(systemClassLoader != null);
			
			InputStream in = systemClassLoader.getResourceAsStream(PropertiesUtil.getPropertiesFilename());
			assert(in != null);
			
			Properties mimiProperties = new Properties();
			mimiProperties.load(in);
			assert(mimiProperties.containsKey("database.url.default.host"));

			
			Properties test = PropertiesUtil.getProperties();
			assert(test != null);
			
			Enumeration<String> keys = (Enumeration<String>) test.propertyNames();
			assert(keys != null);
			
			for (String key = keys.nextElement(); keys.hasMoreElements(); key = keys.nextElement()){
				System.out.println(key + ": " + test.getProperty(key));
			}
				
		}
		
		@Test
		public void testGene(){
            if (true) return ;
			Session session = GeneSessionFactory.getSessionFactory().getCurrentSession();
			session.beginTransaction();
			// attempt a data request (arbitrary)
			Object o = session.createQuery("from org.ncibi.db.gene.Taxonomy where taxid=9606").uniqueResult();
			Taxonomy t = (Taxonomy)o;
			assert(t != null);

			t.getTaxid();
			assert (t.getTaxid().intValue() == 9606);
			session.close();
		}
		
		@Test
		public void testMimi(){
            if (true) return ;
			HibernateInterface h = HibernateInterface.getInterface();
			// 1436 is CSF1R, gene id
			ArrayList<MoleculeRecord> list = h.getMoleculeRecordsForGeneId(1436);
			for (MoleculeRecord rec: list) {
				System.out.println(rec.formattedPrintableString());
			}
		}

		@Test
		public void testPubmed(){
            if (true) return ;
			HibernateInterface h = HibernateInterface.getInterface();
			Document d = h.getFullDocumentForPubmedId(2172781);
			System.out.println(d.fullString());
			System.out.println(d.toFullString(0));
			
		}

}
