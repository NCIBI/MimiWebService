package org.ncibi.mimiweb.test;

import org.junit.Assert;
import org.junit.Test;
import org.ncibi.mimiweb.util.QuickProbe;

public class QuickDbProbe {

	@Test
	public void probe() {
		
		QuickProbe probeMap = new QuickProbe();
		
		for (String key: probeMap.keys()){
			Assert.assertTrue("Probe of " + key + " database failed.",probeMap.probe(key));
			System.out.println("Probe of " + key + " database. OK.");
		}
	}
}
