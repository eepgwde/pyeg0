// * @author weaves
// * @file CSV.scala
// * @brief CSV file accessing.


package example

import scala.sys.process._
import resource._

import java.nio.file.{Files, Paths}

import java.nio.charset.StandardCharsets
import java.nio.file.StandardOpenOption._
import scala.collection.JavaConverters._

import com.typesafe.scalalogging.Logger

import java.sql._
import org.relique.jdbc.csv.CsvDriver

import org.scalatest.{FlatSpec, Matchers}

class CSV1 extends FlatSpec with Matchers {
  import example.StringUtils._

  val logger = Logger(this.getClass.getName)

  val testPath = Paths.get("src", "test", "resources", "wine.csv")

  var count0 = 0:Int

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
    val results = stmt.executeQuery("SELECT * FROM wine limit 10")

    val meta = results.getMetaData()
    val r0 = 1 to meta.getColumnCount
    
    r0.map { i => meta.getColumnTypeName(i) }
    r0.map { i => meta.getColumnName(i) }
    
    if (results.next()) {
      logger.info("first: " + results.getObject(r0(0)).toString)
      val v0 = results.getObject(r0(0)).toString.toNumericOpt
      logger.info("first: v0: " + v0 + "; : " + v0.get.getClass.getName)
    }

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

