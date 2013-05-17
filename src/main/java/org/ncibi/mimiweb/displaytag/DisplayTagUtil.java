package org.ncibi.mimiweb.displaytag;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

public class DisplayTagUtil
{
//	private static final String DASHBOARD_LINK_REGEX = "(\"(replaceURI)\\?([a-zA-Z_0-9-&;=]*)(\"))";
	private static final String DASHBOARD_LINK_REGEX = "(\"(replaceURI)\\?([a-zA-Z_0-9-&;=+%]*)(\"))";

	private static Logger logger = Logger.getLogger(DisplayTagUtil.class);

	public static String fixAllReplaceURI(String js, String jsp, String contextPath, String html)
	{
		Matcher matcher = Pattern.compile(DASHBOARD_LINK_REGEX).matcher(html) ;
		String newhtml = html ;
		int isExport = 0 ;
		logger.info("html = " + html) ;

		while (matcher.find())
		{
			/*
			 * Look for export tags. We don't want to replace these tags with javascript
			 * but instead want to use the jsp in its place.
			 */
	
			logger.info("group(1) = " + matcher.group(1)) ;
			logger.info("group(2) = " + matcher.group(2)) ;
			logger.info("group(3) = " + matcher.group(3)) ;
				
			isExport = matcher.group(1).indexOf("-e=") ;
			if (isExport == -1)
			{
				newhtml = newhtml.replace(matcher.group(1), "\"javascript:" + js + "('" + js + "', '"+ jsp + "'," + "'" + matcher.group(3) + "\');\"") ;
			}
			else
			{
				newhtml = newhtml.replace(matcher.group(1), "\"" + contextPath + jsp + "?" + matcher.group(3) + "\"") ;
			}
		}
		logger.info("newhtml = " + newhtml) ;
		return newhtml ;
	}
}
