package org.ncibi.mimiweb.chem;

import org.openscience.cdk.smiles.SmilesParser ;
import org.openscience.cdk.exception.InvalidSmilesException;
import org.openscience.cdk.layout.StructureDiagramGenerator ;
import net.sf.structure.cdk.util.ImageKit ;

public class SmilesDepictor
{
	private enum DepictorType { SVG, PNG, JPG } ;
	
	public static void writeSmiles(String smileString, String filePath, DepictorType dt)
	{
		SmilesParser sParser = new SmilesParser() ;
		StructureDiagramGenerator sdg = new StructureDiagramGenerator() ;
		try
		{
			sdg.setMolecule(sParser.parseSmiles(smileString)) ;
			sdg.generateCoordinates() ;
			switch (dt)
			{
				case SVG:
					ImageKit.writeSVG(sdg.getMolecule(), 300, 300, filePath) ;
					break ;
				case PNG:
					ImageKit.writePNG(sdg.getMolecule(), 300, 300, filePath) ;
					break ;
				case JPG:
					ImageKit.writeJPG(sdg.getMolecule(), 300, 300, filePath) ;
					break ;
				default:
					break ;
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			System.out.println("Failed writing file: " + filePath) ;
			System.out.println("  smileString: " + smileString) ;
			//e.printStackTrace();
		}
	}
	
	public static void smilesToSvg(String smileString, String filePath)
	{
		writeSmiles(smileString, filePath, DepictorType.SVG) ;
	}
	
	public static void smilesToJpg(String smileString, String filePath)
	{
		writeSmiles(smileString, filePath, DepictorType.JPG) ;
	}

	public static void smilesToPng(String smileString, String filePath)
	{
		writeSmiles(smileString, filePath, DepictorType.PNG) ;
	}
}
