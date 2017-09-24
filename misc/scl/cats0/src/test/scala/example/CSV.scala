package example

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import java.nio.file.StandardOpenOption._
import scala.collection.JavaConverters._

import com.typesafe.scalalogging.Logger

import org.apache.commons.csv.CSVFormat

import org.scalatest.{FlatSpec, Matchers}

class CSVLoad extends FlatSpec with Matchers {

  val logger = Logger(this.getClass.getName)
  
  "commons CSV" should "contain lines" in {

    val testPath = Paths.get("src", "test", "resources", "wine.csv")
    val testReader = Files.newBufferedReader(testPath, StandardCharsets.UTF_8)

    var count0 = 1

    try {
      val tp = CSVFormat.RFC4180.withFirstRecordAsHeader().parse(testReader).asScala
      
      count0 = tp.size
    } finally {
      testReader.close()
    }
    
    logger.info(s"Count0: $count0")

    count0 should be >= 4000
  }

} 
