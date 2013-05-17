package org.ncibi.mimiweb.test;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.ncibi.mimiweb.chem.SmilesDepictor;
import org.ncibi.mimiweb.data.Compound;
import org.ncibi.mimiweb.hibernate.HumDBQueryInterface;

public class SmilesDepictorTest
{
	private String makeFilePath(String cName)
	{
		String convertedName = cName.replaceAll("['\"()`+{}]", "_") ;
		convertedName = convertedName.replace(" ", "_") ;
		convertedName = convertedName.replace("[", "_") ;
		convertedName = convertedName.replace("]", "_") ;
		convertedName = convertedName.replace("*", "_") ;
 		return "drawing-" + convertedName ;
	}
	
//	@Test
//	public void testSmilesToSvg()
//	{
//		HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
//		
//		ArrayList<Compound> smileCompounds = humdb.getAllCompoundsWithSmileString() ;
//		String dirPath = "C:/Glenn/metab" ;
//		for (Compound c : smileCompounds)
//		{
//			String fileName = makeFilePath(c.getName()) ;
//			//System.out.println("Converting " + c.getName() + "...") ;
//			
//			String fullPath = dirPath + "/svg/" + fileName + ".svg" ;
//			SmilesDepictor.smilesToSvg(c.getSmile(), fullPath) ;
//		}
//	}
	
//	@Test
//	public void testSmilesToJpg()
//	{
//		HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
//		
//		ArrayList<Compound> smileCompounds = humdb.getAllCompoundsWithSmileString() ;
//		String dirPath = "C:/Glenn/metab" ;
//		for (Compound c : smileCompounds)
//		{
//			String fileName = makeFilePath(c.getName()) ;
//			//System.out.println("Converting " + c.getName() + "...") ;
//			
//			String fullPath = dirPath + "/jpg/" + fileName + ".jpg" ;
//			SmilesDepictor.smilesToJpg(c.getSmile(), fullPath) ;
//		}
//	}
	
	@Test
	public void testSmilesToPng() throws Exception
	{
        if (true)
            return ;
		HumDBQueryInterface humdb = HumDBQueryInterface.getInterface() ;
		
		List<Compound> smileCompounds = humdb.getAllCompoundsWithSmileString() ;
		String dirPath = "C:/Glenn/metab" ;
		
		File probe = new File(dirPath);
		if (!probe.exists()) {
			System.out.println("The base directory for the test does not exist, " + dirPath);
			throw new Exception("testSimlesToPng, no base directory");
		}
		
		for (Compound c : smileCompounds)
		{
			//String fileName = makeFilePath(c.getName()) ;
			//System.out.println("Converting " + c.getName() + "...") ;
			
			String fullPath = dirPath + "/png/" + c.getCid() + ".png" ;
			SmilesDepictor.smilesToPng(c.getSmile(), fullPath) ;
		}
	}
	
	
}
