package org.ncibi.mimiweb.decorator;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;
import org.ncibi.mimiweb.hibernate.HumDBQueryInterface;
import org.ncibi.mimiweb.data.CompoundAttribute ;

public class RxnTxtColumnDecorator implements DisplaytagColumnDecorator
{
	private String makeCompoundStr(String rid, String cid)
	{
		String formatedCidStr = "<a href=\"compound-details-page-front.jsp?cid=" + cid + "\">";
		HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
		CompoundAttribute ca = humdb.getCompoundAttributeForRidCid(rid, cid) ;
		if (ca == null)
		{
		    formatedCidStr += "UNKNOWN" + "</a>";
		}
		else
		{
		    formatedCidStr += ca.getName() + "</a>" ;
		    if (ca.getMaincmpd() == 1)
		    {
		        formatedCidStr = "<b>" + formatedCidStr + "</b>" ;
		    }
		}
		return formatedCidStr ;
	}
	
	private String makeCompoundPartStr(String rid, String cidpart)
	{
		String numOf = "" ;
		String cid = "" ;
		int space = cidpart.indexOf(" ") ;
		if (space == -1)
		{
			// There aren't multiples of this compound
			cid = cidpart ;
		}
		else
		{
			numOf = cidpart.substring(0, space) ;
			cid = cidpart.substring(space + 1) ;
		}
		
		return numOf + " " + makeCompoundStr(rid, cid) ;
	}
	
	private String makeEquationSide(String rid, String[] io)
	{
		int i = 1 ;
		String equationstr = "" ;
		for (String cid : io)
		{
			String cmpdstr = makeCompoundPartStr(rid, cid) ;
			if (i != io.length)
			{
				equationstr += cmpdstr + " + " ;
			}
			else
			{
				equationstr += cmpdstr ;
			}
			i++ ;
		}
		return equationstr ;
	}
	
	public Object decorate(Object arg0, PageContext arg1, MediaTypeEnum arg2)
			throws DecoratorException
	{
		String ridrxntxt = (String) arg0 ;
		String[] io = ridrxntxt.split("=") ;
		String rid = io[0] ;
		String[] inputs = io[1].split("[+]") ;
		String[] outputs = io[2].split("[+]") ;
		
		String equationstr = makeEquationSide(rid, inputs) ;
		equationstr += " = " + makeEquationSide(rid, outputs) ;
		return equationstr ;
	}
}
