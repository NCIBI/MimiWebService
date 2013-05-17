package org.ncibi.mimiweb.autocomplete;

import org.ncibi.indexer.rdb.MyDB;
import org.ncibi.indexer.rdb.MyResultSet;
import java.sql.*;
import java.io.*;

public class AutocompleteLoader
{
	static String namesFile = "names.txt";
	
	public static void loadNames()
	{
		String sql = ""
			+ " declare @Geneids table (geneid int primary key) "
			+ " insert into @Geneids(geneid) "
			+ " select distinct mg.geneid from mimir2.dbo.Molecule m "
			+ " join mimir2.dbo.MoleculeGene mg on m.molid = mg.molid "
			+ " join mimir2.dbo.ProvenanceTarget pt on pt.targetID = m.molID "
			+ " join mimir2.dbo.TargetType tt on tt.targetTypeID = pt.targetTypeID and ( tt.targetType = 'Molecule' "
			+ "   or tt.targetType = 'MoleculeGene') "
			+ " join mimir2.dbo.Provenance p on p.provID = pt.provID "
			// + " where mg.geneid in (1436, 1537) " // For testing purposes
			+ " select distinct lower(item) as name "
			+ " from ( "
			+ " select g.symbol as item from gener2.dbo.Gene g "
		    + " where g.geneid in (select * from @Geneids) "
		    + " union "
		    + " select gn.name as item from gener2.dbo.GeneName gn "
		    + " where gn.geneid in (select * from @Geneids) "
		    + " ) T "
		    + " order by lower(item) " ;
		
		MyResultSet myrs;
		myrs = MyDB.getDB().executeQuery(sql);
		int rowCount = 0 ;
		
		try
		{
		    FileWriter fstream = new FileWriter(namesFile);
	        BufferedWriter out = new BufferedWriter(fstream);
			while (myrs._rs.next())
			{
				out.write(myrs._rs.getString("name") + "\n") ;
				rowCount++ ;
				if ((rowCount % 1000) == 0)
				{
					System.out.println("Processed " + rowCount + " names") ;
				}
			}
			out.close();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	public static void main(String[] args)
	{
		if (args.length > 0)
		{
			namesFile = args[0];
		}
		System.out.println("Names file is: " + namesFile);
		loadNames() ;
		System.out.println("Done...") ;
	}

}
