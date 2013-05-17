package org.ncibi.mimiweb.test;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.lucene.queryParser.ParseException;
import org.junit.Test;
import org.ncibi.db.pubmed.Gene2Mesh;
import org.ncibi.mimiweb.hibernate.HibernateInterfaceForGene2Mesh;

public class GeneToMesh {
	
	@Test
	public void test1() throws IOException, ParseException {
		
		HibernateInterfaceForGene2Mesh hi = HibernateInterfaceForGene2Mesh.getInterface();

		System.out.println("-- With gene id = 1436 -----------------");
		ArrayList<Gene2Mesh> list = hi.getGene2MeshByGeneId(1436);
		
		for (Gene2Mesh g2m: list){
			System.out.println(g2m.getGeneSymbol() + "(" + g2m.getTaxonomy() + "):" 
					+ g2m.getDescriptor() + "," + g2m.getQualifier());
		}
		
		System.out.println("-- With Mesh descriptor = 7951 -----------------");
		
		list = hi.getGene2MeshByMeshDescriptorId(7951);

		for (Gene2Mesh g2m: list){
			System.out.println(g2m.getGeneSymbol() + "(" + g2m.getTaxonomy() + "):" 
					+ g2m.getDescriptor() + ";" + g2m.getQualifier());
		}

		System.out.println("-- With gene id = 1436, 1437 -----------------");
		ArrayList<Integer> geneIdList = new ArrayList<Integer>();
		geneIdList.add(new Integer(1436));
		geneIdList.add(new Integer(1437));
		
		list = hi.getGene2MeshFromGeneIdList(geneIdList);

		for (Gene2Mesh g2m: list){
			System.out.println(g2m.getGeneSymbol() + "(" + g2m.getTaxonomy() + "):" 
					+ g2m.getDescriptor() + ";" + g2m.getQualifier());
		}

		System.out.println("-- With Mesh descriptor = 7951, 7835 -----------------");
		ArrayList<Integer> meshIdList = new ArrayList<Integer>();
		meshIdList.add(new Integer(7951));
		meshIdList.add(new Integer(7835));
		
		list = hi.getGene2MeshFromMeshDescriptorList(meshIdList);

		for (Gene2Mesh g2m: list){
			System.out.println(g2m.getGeneSymbol() + "(" + g2m.getTaxonomy() + "):" 
					+ g2m.getDescriptor() + ";" + g2m.getQualifier());
		}

		System.out.println("-------------------");
	}
	
}
