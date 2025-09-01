package com.cafein.persistence;

import static org.junit.Assert.fail;
import org.junit.Test;
import lombok.extern.log4j.Log4j;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Log4j
public class JDBCTests {	
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}//end static
	
	@Test
	public void TestConnection() {
		try {
			Connection con = 
					DriverManager.getConnection(
							"jdbc:oracle:thin:@localhost:1521/xepdb1"
							,"cafein","cafein");
			log.info(con);
		} catch (SQLException e) {
			fail(e.getMessage());			
		}//end try			
	}//end test
}//end class

