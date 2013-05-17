package org.ncibi.mimiweb.generate;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;

public class GenerateOrganism {
	
	//this is the location of the organisms.txt file in this package
	private static String base = "/base/svn/MimiWeb/MimiWebR3/trunk/src";
	private static String packageLocation = "org/ncibi/mimiweb/generate/";
	private static String fileLocation = base + packageLocation + "organisms.txt";

	public static void main(String[] args) {
		(new GenerateOrganism()).exec();
	}

	private void exec() {
		try {
			File f = new File(GenerateOrganism.fileLocation);
			BufferedReader in = new BufferedReader(new FileReader(f));
			String line = in.readLine(); // discard header
			ArrayList<Holder> list = new ArrayList<Holder>();
			while (null != (line =  in.readLine()))
			{
				list.add(makeHolder(line));
			}
			list = sortList(list);
			System.out.println ("\tString[][] organismArray = {");
			int count = 0;
			for (Holder h: list) {
				count++;
				System.out.print("\t\t{\"" + h.name +"\",\"" + h.number + "\"}");
				if (count < list.size())
					System.out.println(",");
			}
			System.out.println("};");
		} catch (Throwable t) {
			t.printStackTrace();
		}
	}

	private ArrayList<Holder> sortList(ArrayList<Holder> list) {
		
		ArrayList<Holder> ret = new ArrayList<Holder>();
		
		// first n items stay in the order they are in
		for (int i = 0; i < 12; i++)
		{
			ret.add(list.get(0));
			list.remove(0);
		}
		

		ret.add(new Holder("----------------","-1"));
		
		// sort the remaining items
		Holder[] array = list.toArray(new Holder[list.size()]);
		Arrays.sort(array,new Comparator<Holder>(){
			public int compare(Holder h1, Holder h2) {
				return h1.name.compareToIgnoreCase(h2.name);
			}});
		for (Holder h: array) ret.add(h);
		
		return ret;
	}

	private Holder makeHolder(String line) {
		String [] parts = line.split(",");
		String name = parts[0].trim();
		name = name.substring(1, name.length()-1); // remove " " marks
		String number = parts[1].trim();
		return new Holder(name,number);
	}

	public class Holder {
		public Holder(String na, String nu) {name = na; number = nu; }
		public String name;
		public String number;
	}

}
