package com.restore.interview

import org.scalatest._

import com.typesafe.scalalogging.Logger

// * Class

class VendingT extends FlatSpec with Matchers {
  val logger = Logger(this.getClass.getName)

  // ** Initial

  val ones = List.fill(10)(1)

  val sn = new Item("snickers")
  val ca = new Item("cola")

  // ** Tests

  "The Vending object" should "say hello" in {
    (new VendingMachine).version shouldEqual "0.1.0-weaves"
  }

  "Coins" should "list" in {
    val ch0 = ones
    val coins = ch0.map(new Coin(_) )

    coins.size should equal (ch0.size)
  }

  "change" should "contain" in {

    val ch0 = ones
    val coins = ch0.map(new Coin(_) )

    val vm = new VendingMachine()

    vm.addChange(coins)
    vm.ch.size should equal (coins.size)

    vm.addChange(coins)
    vm.ch.size should equal (coins.size + coins.size)
  }

  "products" should "contain" in {

    val vm = new VendingMachine()

    vm.addItems(sn, 10)
    vm.pr.size should equal (10)

    vm.addItems(ca, 10)
    vm.pr.size should equal (10 + 10)
    
  }

  "pricing" should "map" in {

    class MappedPricing(prices: Map[Item, Int]) extends RealtimePricingService {
      def getPrice(itemType: Item): Int = prices(itemType)
    }

    val ps = new MappedPricing(Map(sn -> 10, ca -> 15))

    val vm = new VendingMachine()
    vm.setPricer(ps)

    vm.ps.isDefined shouldBe (true)

    vm.ps.get.getPrice(sn) should equal (10)
  }

  "products" should "no cola" in {

    val vm = new VendingMachine()

    vm.addItems(sn, 10)
    vm.pr.size should equal (10)

    val noca = vm.purchaseItem(ca, List(new Coin(10)))
    logger.info("noca: " + noca)

    // Need the manual
    noca match {
      case FailureResult(errorMessage, coins) => logger.info("expected-failure: " + errorMessage)
      case _ => 1 should equal (0)
    }

    val unimp = vm.purchaseItem(sn, List(new Coin(10)))
    logger.info("unimp: " + unimp)

    // Need the manual
    unimp match {
      case FailureResult(errorMessage, coins) => logger.info("expected-failure: " + errorMessage)
      case _ => 1 should equal (0)
    }

  }


}

// * Postamble

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
