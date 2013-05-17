package org.ncibi.mimiweb.browser.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDataSource;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;

public class DatabaseConnection {
	
	private final String url = "jdbc:sqlserver://";
	private String serverName= "ncibidb.bicc.med.umich.edu";
	private final String portNumber = "1433";
	private String databaseName= "mimiR2";
	private String userName = "userMimiCytoPlugin";
	private String password = "GoBlue08!";

	String driverClass = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	
	private PoolingDataSource dataSource = null ;
	
	// Informs the driver to use a server-side cursor, which permits more 
	// than one active statement on a connection.
	private final String selectMethod = "cursor";
	
	public ArrayList<Object[]> makeQuery(String sql) throws SQLException, ClassNotFoundException {
		ArrayList<Object[]> ret = null;
		Connection ctx = null;
		try {
			ctx = makeConnection();
        	Statement stmt = ctx.createStatement();
        	ResultSet rs = stmt.executeQuery(sql);
    		ret = processResultSet(rs);
		} catch (ClassNotFoundException e) {
			throw e;
		} catch (SQLException e) {
			throw e;
		} finally {
			ctx.close();
		}
       	return ret;
	}

	private ArrayList<Object[]> processResultSet(ResultSet rs) throws SQLException {
		ArrayList<Object[]> ret = new ArrayList<Object[]>();
		while (rs.next())
		{
			Object[] row = new Object[rs.getMetaData().getColumnCount()];
			for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++)
				row[i-1] = rs.getObject(i);
			ret.add(row);
		}
		return ret;
	}

	private DataSource setupDataSource() throws ClassNotFoundException {

		if (dataSource != null){
			return dataSource ;
		}

		Class.forName(driverClass);

		// The following code was taking from example code located at:
		// http://svn.apache.org/viewvc/jakarta/commons/proper/dbcp/trunk/doc/ManualPoolingDataSourceExample.java?view=co

		ObjectPool connectionPool = new GenericObjectPool(null);
		ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(getConnectionUrl(),userName, password);
		PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory,connectionPool,null,null,false,true);
		connectionPool.setFactory(poolableConnectionFactory) ;
		dataSource = new PoolingDataSource(connectionPool);
		return dataSource;
	}
	
	private String getConnectionUrl() 
	{
		return url+serverName+":"+portNumber+";databaseName="+databaseName+";selectMethod="+selectMethod+";";
	}

	private Connection makeConnection() throws ClassNotFoundException, SQLException
	{
		return setupDataSource().getConnection();
	}

}
