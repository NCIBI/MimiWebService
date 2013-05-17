package org.ncibi.mimiweb.util;

import java.util.HashMap;
import java.util.Set;

import org.hibernate.SessionFactory;
import org.ncibi.db.factory.GeneSessionFactory;
import org.ncibi.db.factory.HumDBSessionFactory;
import org.ncibi.db.factory.MimiSessionFactory;
import org.ncibi.db.factory.PubmedSessionFactory;
import org.ncibi.db.factory.ReactomeDBSessionFactory;
import org.ncibi.mimiweb.hibernate.GenericSqlQuery;

public class QuickProbe {
	
	private HashMap<String,ProbeHolder> probeMap = new HashMap<String,ProbeHolder>();
	
	public QuickProbe(){
		probeMap.put("gene",new ProbeHolder("gene",GeneSessionFactory.getSessionFactory(),"select count(*) from Taxonomy"));
		probeMap.put("mimi",new ProbeHolder("mimi",MimiSessionFactory.getSessionFactory(),"select count(*) from Interaction"));
		probeMap.put("HumDb",new ProbeHolder("HumDb",HumDBSessionFactory.getSessionFactory(),"select count(*) from CMPDS"));
		probeMap.put("Pubmed",new ProbeHolder("Pubmed",PubmedSessionFactory.getSessionFactory(),"select count(*) from Citation"));
		probeMap.put("Reactome",new ProbeHolder("Reactome",ReactomeDBSessionFactory.getSessionFactory(),"select count(*) from affiliation"));
	}
	
	public Set<String> keys() {
		return probeMap.keySet();
	}
	
	public boolean probe(String key){
		ProbeHolder probe = probeMap.get(key);
		if (probe == null) return true;
		return probe.probe() != null;
	}
	
	private class ProbeHolder {
		String name;
		SessionFactory factory;
		String sql;

		ProbeHolder(String name, SessionFactory factory, String sql) {
			this.name = name;
			this.factory = factory;
			this.sql = sql;
		}

		Integer probe() {
			return GenericSqlQuery.getCount(sql, factory);
		}
	}

}
