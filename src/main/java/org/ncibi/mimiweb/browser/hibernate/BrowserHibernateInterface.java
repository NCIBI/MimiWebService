package org.ncibi.mimiweb.browser.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.ncibi.db.factory.MimiSessionFactory;

import org.apache.log4j.Logger;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.ncibi.mimiweb.browser.Constraint;
import org.ncibi.mimiweb.browser.hibernate.data.GeneAttributeCount;

public class BrowserHibernateInterface {

	private static Logger logger = Logger.getLogger(BrowserHibernateInterface.class);

	// quick and dirty singleton...
	private BrowserHibernateInterface() {}
	private static BrowserHibernateInterface theInterface = null;
	public static BrowserHibernateInterface getInterface(){
		if (theInterface == null){
			theInterface = new BrowserHibernateInterface();
		}
		return theInterface;
	}
	
	@SuppressWarnings("unchecked")
	public boolean probe(){
		Session session = MimiSessionFactory.getSessionFactory().getCurrentSession();
		boolean success = false;
		
		try {
			String sql = "SELECT top 1 molId FROM Molecule";
			session.beginTransaction();
			List<Integer> l = (List<Integer>) session.createSQLQuery(sql).addScalar("molId",Hibernate.INTEGER).list();
			for (Object o: l) 
				logger.info("hibernate probe successful with:" + o.toString());
			session.connection().commit();
			success = true;
		} catch (Throwable t) {
			logger.error("Hibernate Probe failed.");
			t.printStackTrace();
		} finally {
			try {
				session.connection().close();
			} catch (Throwable ignore) {
				// too bad... did the best we could
				logger.error("Unexpected error in close.");
			}
		}
		return success;
	}

	public ArrayList<GeneAttributeCount> getConstrainedAttributeTypeCounts(String searchCategroy, ArrayList<Constraint> constraints) {

		String sql="";
		String eol = "\n";
	
		if ((searchCategroy == null) && ((constraints == null) || (constraints.size() == 0))) {
			//special case: no category, no constraints
			sql = "select attrType,count(*) as count " + eol +
				"from ( " + eol +
				"    select distinct attrType, geneid  " + eol +
				"    from denorm.GeneAttribute ) as X  " + eol +
				"group by attrType  " + eol +
				"order by count(*) desc";
		} else if ((constraints == null) || (constraints.size() == 0)) {
			//special case: category, no constraints
			sql = "select attrType,count(*) as count " + eol +
				"from ( " + eol +
				"    select distinct a2.attrType, a2.geneid " + eol +
				"    from denorm.GeneAttribute a1 " + eol +
				"        join denorm.GeneAttribute a2 on a1.geneid=a2.geneid " + eol +
				"    where a1.attrType='" + searchCategroy +  "' " + eol +
				") as X " + eol +
				"group by attrType " + eol +
				"order by count(*) desc";
		} else {
			// general case: categeroy and constraints
			//select attrType,count(*) as count
			//from (
			//    select distinct a2.attrType, a2.geneid 
			//    from denorm.GeneAttribute a1
			//        join denorm.GeneAttribute a2 on a1.geneid=a2.geneid and a1.attrType='pathway' and a1.attrValue='ABC transporters [path:hsa02010]'
			//        join denorm.GeneAttribute a3 on a2.geneid=a3.geneid and a3.attrType='locustag'
			//) as X
			//group by attrType
			//order by count(*) desc

			int i = 0;
			int top = constraints.size() + 1;
			String first = "select attrType,count(*) as count " + eol +
						"from ( " + eol +
						"    select distinct a" + top + ".attrType, a" + top + ".geneid  " + eol +
						"    from denorm.GeneAttribute a1 " + eol;
			String last = 
						") as X " + eol +
						"group by attrType " + eol +
						"order by count(*) desc";
			sql = first;
			for (Constraint c: constraints){
				i++;
				int i1 = i;
				int i2 = i+1;
				sql += "join denorm.GeneAttribute a"+ i2 +" " +
						"on a"+ i1 +".geneid=a"+ i2 +".geneid " +
						"and a"+ i1 +".attrType='"+ c.getType() +"' " +
						"and a"+ i1 +".attrValue='"+ c.getValue() +"' " + eol;
			}
			int i1 = top;
			int i2 = top + 1;
			sql += "join denorm.GeneAttribute a"+ i2 +" " +
				"on a"+ i1 +".geneid=a"+ i2 +".geneid " +
				"and a"+ i1 +".attrType='"+ searchCategroy +"' " + eol;
			sql += last;
		}
			
		// System.out.println(sql);
			
		ArrayList<GeneAttributeCount> ret = new ArrayList<GeneAttributeCount>();

		Session session = MimiSessionFactory.getSessionFactory().getCurrentSession();
		try {			
			session.beginTransaction();
			List<Object[]> l = (List<Object[]>) session.createSQLQuery(sql).list();

			ret = new ArrayList<GeneAttributeCount>();
			for (Object[] row: l){
				GeneAttributeCount c = new GeneAttributeCount((String)row[0],null,((Integer)row[1]).intValue());
				ret.add(c);
			}
		} catch (Throwable t) {
			logger.error("Hibernate Interface getAttributeCounts failed.");
			t.printStackTrace();
		} finally {
			try {
				session.connection().close();
			} catch (Throwable ignore) {
				// too bad... did the best we could
				logger.error("Unexpected error in close.");
			}
		}
		
		return ret;
	}
	
	public ArrayList<GeneAttributeCount> getAllAttributeCounts() {
		return getAllAttributeCounts(null,null);
	}

	public ArrayList<GeneAttributeCount> getAllAttributeCounts(String searchCategroy) {
		return getAllAttributeCounts(searchCategroy,null);
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<GeneAttributeCount> getAllAttributeCounts(String searchCategroy, ArrayList<Constraint> constraints) {
		ArrayList<GeneAttributeCount> ret = new ArrayList<GeneAttributeCount>();
		
//		Select top 5 count(*) as count, a3.attrValue as 'function'
//	    from denorm.GeneAttribute a1
//	        join denorm.GeneAttribute a2 on a1.geneid=a2.geneid
//	        join denorm.GeneAttribute a3 on a2.geneid=a3.geneid
//	    where a1.attrType='process'
//	        and a1.attrValue='signal transduction [GO:0007165]'
//	        and a2.attrType='chromosome' and a2.attrValue='3'
//	        and a3.attrType='function'
//	    group by a3.attrValue
//	    order by count(*) desc

		Session session = MimiSessionFactory.getSessionFactory().getCurrentSession();

		String sql="";
		
		try {
			session.beginTransaction();

		//special case: no category, no constraints
		if ((searchCategroy == null) && ((constraints == null) || (constraints.size() == 0))) {
			sql = "select attrType,count(*) as count "+
				"from ( "+
				"    select distinct attrType, geneid  "+
				"    from denorm.GeneAttribute ) as X  "+
				"group by attrType  "+
				"order by count(*) desc";
			List<Object[]> l = 
				(List<Object[]>) session.createSQLQuery(sql).list();

			ret = new ArrayList<GeneAttributeCount>();
			for (Object[] row: l){
				GeneAttributeCount c = new GeneAttributeCount((String)row[0],null,((Integer)row[1]).intValue());
				ret.add(c);
			}
			
			return ret;
		}
		//special case: category, no constraints
		if ((constraints == null) || (constraints.size() == 0)) {
			sql = "Select attrValue, count(*) as count from denorm.GeneAttribute " +
					"where attrType='" + searchCategroy +  "'" + 
					"group by attrValue order by count(*) desc";
			
			List<Object[]> l = 
				(List<Object[]>) session.createSQLQuery(sql).list();

			ret = new ArrayList<GeneAttributeCount>();
			for (Object[] row: l){
				GeneAttributeCount c = new GeneAttributeCount(searchCategroy,(String)row[0],((Integer)row[1]).intValue());
				ret.add(c);
			}
			
			return ret;			
		}
		
		int n = constraints.size();
		
		String eol = "\n";
		sql = "Select count(*) as count, " +
				"a" + (n+1) + ".attrValue as attrValue, " +
						"a" + (n+1) + ".attrType as attrType " + eol;
		String from = "from denorm.GeneAttribute a1 " + eol;
		String where = "where " + eol;
		int i = 0;
		for (Constraint c: constraints){
			i++;
			if (i > 1)
				from += "join denorm.GeneAttribute a" + i + " " +
					"on a" + (i-1) + ".geneid=a" + i + ".geneid" + eol;
			where += "a" + i +".attrType='" + c.getType() 
					+ "' and a" + i + ".attrValue='" + c.getValue() + "' and " + eol;
		}

		from += "join denorm.GeneAttribute a" + (n+1)  + " " +
			"on a" + n + ".geneid=a" + (n+1) + ".geneid" + eol;
		
		where += "a" + (n+1) +".attrType='" + searchCategroy + "' " + eol;

		sql += from + where
			+ "group by a" + (n+1) + ".attrType, a" + (n+1) + ".attrValue " + eol
			+ "order by count(*) desc";
		
		// System.out.println("sql = " + sql);

		List<GeneAttributeCount> l = 
			(List<GeneAttributeCount>) session.createSQLQuery(sql).addEntity(GeneAttributeCount.class).list();

		ret = new ArrayList<GeneAttributeCount>(l);
		} catch (Throwable t) {
			logger.error("Hibernate Interface getAttributeCounts failed.");
			t.printStackTrace();
		} finally {
			try {
				session.connection().close();
			} catch (Throwable ignore) {
				// too bad... did the best we could
				logger.error("Unexpected error in close.");
			}
		}
		
		return ret;
	}

	public ArrayList<Object[]> getGeneListFromAttributeConstraints(int count,
			ArrayList<Constraint> constraints) {
		
		ArrayList<Object[]> ret = null;
		Session session = null;

		try {

			int n = constraints.size();
			
			String eol = "\n";
			String sql = "Select distinct top " + (count + 1) + "  a" + n + ".geneid, g.symbol, t.taxname " + eol;
			String from = "from gener2.dbo.Gene g join gener2.dbo.TaxName t on g.taxid=t.taxid and t.class='scientific name' " + eol
				+ "join denorm.GeneAttribute a1 on g.geneid=a1.geneid " + eol;
			String where = "where " + eol;
			int i = 0;
			for (Constraint c : constraints) {
				i++;
				if (i > 1)
					from += "join denorm.GeneAttribute a" + i + " " + "on a"
							+ (i - 1) + ".geneid=a" + i + ".geneid" + eol;
				if (i == n)
					where += "a" + i + ".attrType='" + c.getType() + "' and a" + i
						+ ".attrValue='" + c.getValue() + "'" + eol;
				else
					where += "a" + i + ".attrType='" + c.getType() + "' and a" + i
						+ ".attrValue='" + c.getValue() + "' and " + eol;
			}

			sql += from + where + "order by taxname, symbol";

			// System.out.println("sql = " + sql);

			session = MimiSessionFactory.getSessionFactory().getCurrentSession();
			session.beginTransaction();

			List<Object[]> l = (List<Object[]>) session.createSQLQuery(sql).list();

			if (l == null) ret = new ArrayList<Object[]>();
			else ret = new ArrayList<Object[]>(l);
			
		} catch (Throwable t) {
			logger.error("Hibernate Interface getAttributeCounts failed.");
			t.printStackTrace();
		} finally {
			try {
				if (session != null)
					session.connection().close();
			} catch (Throwable ignore) {
				// too bad... did the best we could
				logger.error("Unexpected error in close.");
			}
		}
		return ret;
	}
	
}
