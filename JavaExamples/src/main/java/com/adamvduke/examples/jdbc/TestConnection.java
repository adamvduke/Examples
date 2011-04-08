package com.adamvduke.examples.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestConnection {

	public Connection getConnection() {

		Connection myConnection = null;
		try {
			Class.forName( "org.domain.MyDriver" );
			myConnection = DriverManager.getConnection( "someURL", "userName", "PassWord" );
			return myConnection;
		}
		catch ( ClassNotFoundException e ) {
			e.printStackTrace();
		}
		catch ( SQLException e ) {
			e.printStackTrace();
		}
		finally {
			try {
				myConnection.close();
			}
			catch ( SQLException e ) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
