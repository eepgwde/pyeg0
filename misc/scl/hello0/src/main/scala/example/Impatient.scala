package example

import com.typesafe.scalalogging._

import org.slf4j.Logger
import org.slf4j.LoggerFactory

/*
 * Scala objects
 *
 * These are useful containers for static methods, but don't run a
 * constructor until invoked.
 *
 * Logger0 below is invoked with apply() and because of that runs its
 * constructor code. 
 */

object Logging {
  val logger_ = LoggerFactory.getLogger("Logger0")

  // a one-arg constructor
  def apply() = {
    logger_.info("apply:")
    logger_
  }
}

object Impatient extends Greeting with App {
  val l0 = Logging()
  l0.info("Impatient: " + greeting)
}

