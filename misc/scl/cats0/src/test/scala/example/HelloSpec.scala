package example

import org.scalatest._

import com.typesafe.scalalogging.Logger


class HelloSpec extends FlatSpec with Matchers {
  val logger = Logger(this.getClass.getName)

  "The Hello object" should "say hello" in {
    Hello.greeting shouldEqual "hello"
  }

  "Container" should "List: polymorphic" in {

    trait Container[M[_]] { def put[A](x: A): M[A]; def get[A](m: M[A]): A }

    val container = new Container[List] { 
      def put[A](x: A) = List(x); 
      def get[A](m: List[A]) = m.head 
    }
    
    val hey = container.put("hey")
    val one23 = container.put(123)

    container.get(hey) shouldBe ("hey")

    container.get(one23) shouldBe (123)

  }

  "Container" should "Option: polymorphic" in {

    trait Container[M[_]] { def put[A](x: A): M[A]; def get[A](m: M[A]): A }

    val container = new Container[Some] { 
      def put[A](x: A) = Some(x); 
      def get[A](m: Some[A]) = m.get
    }
    
    val hey = container.put("hey")
    val one23 = container.put(123:Short)

    val l0 = List(hey, one23)

    l0 map { i => logger.info(container.get(i).getClass.getName) }

    container.get(hey) shouldBe ("hey")
    container.get(hey) shouldBe a [String]

    container.get(one23) shouldBe (123)
    container.get(one23) shouldBe a [java.lang.Short]

  }

}
