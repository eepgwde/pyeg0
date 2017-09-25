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

import org.apache.commons.csv.CSVFormat

import org.scalatest.{FlatSpec, Matchers}

class CSVLoad extends FlatSpec with Matchers {

  val logger = Logger(this.getClass.getName)

  val testPath = Paths.get("src", "test", "resources", "wine.csv")

  var count0 = 0:Int

  // Using the managed resource wrapper we can 
  def parse0[B <: java.io.Reader](x:B) = managed(CSVFormat.RFC4180
						 .withFirstRecordAsHeader()
						 .parse(x)) map {
						   input => input.asScala
						 }

  "OS CSV" should "contain lines" in {
    // Run ls -l on the file. If it exists, then count the lines.
    def countLines(fileName: String) = s"ls -l $fileName" #&& s"wc -l $fileName"

    val count1 = countLines(testPath.toAbsolutePath.toString) !!

    val count2 = count1.split("\n")(1).split(" ")(0).toInt

    count2 should be >= 4000
  }
  
  "commons CSV" should "contain lines" in {

    val testReader = Files.newBufferedReader(testPath, StandardCharsets.UTF_8)
    var count2 = 0

    // replaced by parse0. 
    // The advantage of parse0 is that it returns, as a val, the inner block value "tp"
    try {
      val tp = CSVFormat.RFC4180.withFirstRecordAsHeader().parse(testReader).asScala
      count2 = tp.size
    } finally {
      testReader.close()
    }
    
    logger.info(s"count: $count2")

    count2 should be >= count0
  }


  // Uses the managed resource.
  "commons CSV(1)" should "contain lines" in {

    val testReader = Files.newBufferedReader(testPath, StandardCharsets.UTF_8)

    val tp = parse0(testReader)
    // Note the use of "opt" to access the inner object. It should be tested.
    val count2 = tp.opt.size
    logger.info(s"count: $count2")

    count2 should be >= count0
  }


  // This variant is simpler that the Java component, but less capable
  "Basic CSV" should "contain lines" in {

    val testPath = Paths.get("src", "test", "resources", "wine.csv")

    val src = scala.io.Source.fromFile(testPath.toFile)

    val count2 = src.reset().getLines().length

    val iter = src.reset().getLines().map(_.split(","))

    logger.info(s"count: $count2")

    count2 should be >= count0
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

