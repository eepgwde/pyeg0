// * @author weaves
// * @file StringUtilsT.scala
// * @brief Pimp file accessing.

package example

import org.scalatest.{FlatSpec, Matchers}

import scala.sys.process._
import resource._

import com.typesafe.scalalogging.Logger

import example.StringUtils._

// * Tests

class StringUtilsT extends FlatSpec with Matchers {

  val logger = Logger(this.getClass.getName)

  "Pimp" should "format integer" in {
    val v0 = "1234".toIntOpt
    v0.get should equal (1234)
    v0.get shouldBe a [java.lang.Integer]
  }

  "Pimp" should "format short" in {
    val v0 = "1234".toShortOpt
    logger.info("v0: " + v0.get.getClass.getName)
    v0.get should equal (1234)
    v0.get shouldBe a [java.lang.Short]
  }

  "Pimp" should "format either" in {
    val v0 = "1234".toNumericOpt
    logger.info("v0: " + v0.get.getClass.getName)
    v0.get should equal (1234)
    v0.get shouldBe a [java.lang.Short]
  }

  "Pimp" should "format any(1)" in {
    val v0 = "1000000".toNumericOpt
    logger.info("v0: " + v0.get.getClass.getName)
    v0.get should equal (1000000)
    v0.get shouldBe a [java.lang.Integer]
  }

  "Pimp" should "format any(2)" in {
    val v0 = "1000000.0".toNumericOpt
    logger.info("v0: " + v0.get.getClass.getName)
    v0.get should equal (1000000.0)
    v0.get shouldBe a [java.lang.Double]
  }

  "Pimp" should "format any(3)" in {
    val v0 = java.lang.Double.MAX_VALUE.toString.toNumericOpt
    logger.info("v0: " + v0.get.getClass.getName)
    v0.get shouldBe a [java.lang.Double]
  }

  "Pimp" should "not format" in {
    val v0 = "red".toNumericOpt

    logger.info("v0: " + v0.getClass.getName)

    v0 shouldBe empty
  }

  "Pimp" should "be a string" in {
    val v0 = "red".refine

    logger.info("v0: " + v0.getClass.getName)

    v0 should not be empty
    "123".refine should not be empty
    "1230".refine should not be empty
    "123000000".refine should not be empty
    "123000000.0".refine should not be empty
  }

  "Pimp" should "contain byte" in {
    val v0 = "123".toByteOpt1
    v0.get.get should equal (123)
    v0.get.get shouldBe a [java.lang.Byte]
  }

}

// ** Notes

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

