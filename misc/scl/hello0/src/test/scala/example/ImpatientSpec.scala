package example

import org.scalatest._

class ImpatientSpec extends FlatSpec with Matchers {
  "The Impatient object" should "say hello" in {
    Impatient.greeting shouldEqual "hello"
  }
}
