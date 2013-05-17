package org.ncibi.mimiweb.test;

import java.util.ArrayList;

import org.junit.Test;
import org.ncibi.mimiweb.util.InteractionTypes;

public class InteractionTypeTest {

	@Test
	public void interacitonTypeTest(){
		ArrayList<String> types = InteractionTypes.getInteractionTypesList();
		assert (types != null);
		assert (types.size() > 0);
		
		for (String type: types) {
			System.out.println(type);
		}
	}
}
