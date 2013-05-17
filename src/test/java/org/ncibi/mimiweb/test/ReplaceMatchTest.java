package org.ncibi.mimiweb.test;

import org.junit.Assert;
import org.junit.Test;
import org.ncibi.mimiweb.displaytag.DisplayTagUtil;

public class ReplaceMatchTest {

	public static final String PROBLEM = "<a href=\"replaceURI?search=%28genesymbol%3AA1BG+OR+genesymbol%3AA2M+OR+genesymbol%3ANAT1+" +
			"OR+genesymbol%3ANAT2+OR+genesymbol%3ASERPINA3+OR+genesymbol%3AAADAC+OR+genesymbol%3AAAMP+OR+genesymbol%3AAANAT+" +
			"OR+genesymbol%3AAARS+OR+genesymbol%3AABAT+OR+genesymbol%3AABCA1+OR+genesymbol%3AABCA2+OR+genesymbol%3AABCA3+" +
			"OR+genesymbol%3AABCB7+OR+genesymbol%3AABCF1+OR+genesymbol%3AABCA4+OR+genesymbol%3AABL1+OR+genesymbol%3AABP1+" +
			"OR+genesymbol%3AABL2+OR+genesymbol%3AABO+OR+genesymbol%3AABR+OR+genesymbol%3AACAA1+OR+genesymbol%3AACACA+" +
			"OR+genesymbol%3AACACB%29+AND+taxid%3A9606&amp;d-3608684-e=1&amp;6578706f7274=1\"><span class=\"export csv\">CSV " +
			"</span></a>";
	
	public static final String OK = "<a href=\"replaceURI?search=csf1r&amp;d-3608684-e=3&amp;6578706f7274=1&amp;taxid=9606\">" +
			"<span class=\"export xml\">XML </span></a></div>";
	
	@Test
	public void test(){
		String js = "JS";
		String jsp = "JSP";
		String contextPath = "CONTEXT-contextPath-CONTEXT";
		String test;
		System.out.println(test = DisplayTagUtil.fixAllReplaceURI(js, jsp, contextPath, OK));
		Assert.assertTrue(test.contains(contextPath));
		System.out.println(test = DisplayTagUtil.fixAllReplaceURI(js, jsp, contextPath, PROBLEM));		
		Assert.assertTrue(test.contains(contextPath));
	}
	
}
