package org.ncibi.mimiweb.util;

import java.util.ArrayList;
import java.util.List;

import org.ncibi.db.factory.MimiSessionFactory;

import org.hibernate.Session;
import org.ncibi.mimiweb.data.ResultInteractionType;

public class InteractionTypes
{
	private static ArrayList<String> interactionTypes = null;
	
	public static ArrayList<String> getInteractionTypesList()
	{
		InteractionTypeAndExperimentNameMapper mapper = InteractionTypeAndExperimentNameMapper.getInstance() ;
		if (interactionTypes == null)
		{
			interactionTypes = new ArrayList<String>();
			Session mimiSession = MimiSessionFactory.getSessionFactory()
					.getCurrentSession();
			mimiSession.beginTransaction();

			String sql = "select row_number() over (order by attrvalue) as id, attrvalue from "
					+ "( select distinct attrvalue  "
					+ " from denorm.genegeneinteractionattribute "
					+ " where attrtype = 'InteractionType') T ";

			List<ResultInteractionType> l = mimiSession.createSQLQuery(sql)
					.addEntity(ResultInteractionType.class).list();

			for (ResultInteractionType rit : l)
			{
				//System.out.println("rit.getInterationType() = " + rit.getInteractionType()) ;
				if (mapper.isInteractionType(rit.getInteractionType()))
				{
					//System.out.println("  ...isInteractionType()!") ;
					interactionTypes.add(rit.getInteractionType());
				}
			}

			mimiSession.getTransaction().commit();
		}
		return interactionTypes;
	}

}
