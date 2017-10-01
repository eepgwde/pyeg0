// * @author weaves
// * @file CSV.scala
// * @brief CSV file accessing.


package example

import scala.sys.process._
import resource._

import java.nio.file.{Files, Paths}

import java.sql._

import javax.sql.rowset._
import javax.sql.RowSet

import java.nio.charset.StandardCharsets
import java.nio.file.StandardOpenOption._
import scala.collection.JavaConverters._

import com.typesafe.scalalogging.Logger

import org.relique.jdbc.csv.CsvDriver

import org.scalatest.{FlatSpec, Matchers}

class CSV1 extends FlatSpec with Matchers {
  import example.StringUtils._

  val logger = Logger(this.getClass.getName)

  val testPath = Paths.get("src", "test", "resources", "wine.csv")

  var count0 = 0:Int

  "CachedRowSet Test" should "Create a new CachedRowSetImpl instance" in {
    val rsf = RowSetProvider.newFactory
    val rowSet: CachedRowSet = rsf.createCachedRowSet

    rowSet should not be null

    val rowSet1: CachedRowSet = RowSetProvider.newFactory.createCachedRowSet

    rowSet1 should not be null
  }

  "CSVJDBC" should "contain lines" in {

    // Load the driver.
    Class.forName("org.relique.jdbc.csv.CsvDriver");

    // Create a connection. The first command line parameter is
    // the directory containing the .csv files.
    // A single connection is thread-safe for use by several threads.
    val conn = DriverManager.getConnection("jdbc:relique:csv:" 
						  + testPath.getParent.toAbsolutePath.toString);

    // Create a Statement object to execute the query with.
    // A Statement is not thread-safe.
    val stmt = conn.createStatement()

    // No need to add a limit, because we would use .next() to get a row.
    val results = stmt.executeQuery("SELECT * FROM wine limit 2")

    val meta = results.getMetaData()
    val r0 = 1 to meta.getColumnCount
    
    r0.map { i => meta.getColumnTypeName(i) }
    r0.map { i => meta.getColumnName(i) }
    
    if (results.next()) {
      logger.info("first: " + results.getObject(r0(0)).toString)
      val v0 = results.getObject(r0(0)).toString.refine4
      logger.info("first: v0: " + v0 + "; : " + v0.get.getClass.getName)
    }

    val rowSet = RowSetProvider.newFactory.createCachedRowSet

    rowSet.populate(results)

    if (rowSet.next()) {
      logger.info("first: " + rowSet.getObject(r0(0)).toString)
      val v0 = rowSet.getObject(r0(0)).toString.refine4
      logger.info("first: v0: " + v0 + "; : " + v0.get.getClass.getName)

      // val t0: Double = v0.get
      // rowSet.setDouble(r0(0), t0 )

      logger.info("first: v0: " + rowSet.getDouble(r0(0)) + "; : " 
		  + rowSet.getDouble(r0(0)).getClass.getName)
    }

    // No type map given to us.
    // rowSet.getTypeMap() should be empty

    // Dump out the results to a CSV file with the same format
    // using CsvJdbc helper function
    val append = true;
    CsvDriver.writeToCsv(results, System.out, append);

    // Clean up
    conn.close();
  }
  

} 

// The following are the file variables.

// Local Variables:
// mode:scala
// scala-edit-mark-re: "^// [\\*]+ "
// comment-column:50 
// comment-start: "// "  
// comment-end: "" 
// eval: (outline-minor-mode)
// outline-regexp: "// [*]+"
// eval: (auto-fill-mode)
// fill-column: 85 
// End: 

