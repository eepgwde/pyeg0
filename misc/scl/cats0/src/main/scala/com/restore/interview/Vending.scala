package com.restore.interview

// ** pre-reqs

import scala.annotation.tailrec

case class Item(productIdentifier: String)

trait RealtimePricingService {
  def getPrice(itemType: Item): Int
}

case class Coin(value: Int) {
  require(value > 0)
}

trait PurchaseResult

case class SuccessfulResult(returnedCoins: List[Coin]) extends PurchaseResult

case class FailureResult(errorMessage: String,
                         returnedCoins: List[Coin]) extends  PurchaseResult

// ** class

class VendingMachine {

  val version = "0.1.0-weaves"

  /** Change held. */
  var ch = List[Coin]()

  var pr = List[Item]()

  var ps : Option[RealtimePricingService] = None

  def setPricer(ps0: RealtimePricingService): Unit = {
    ps = Option(ps0)
  }

  /**
    * Management interface to put change in the machine
    *
    * @param coins coins added to the machine as change
    */
  def addChange(coins: List[Coin]): Unit = {
    ch = ch ::: coins
  }

  def addItems(item: Item, number: Int): Unit = {
    pr = pr ::: List.fill(number)(item)
  }

  def purchaseItem(item: Item, inputCoins: List[Coin]): PurchaseResult = {
    if (!pr.find(_ == item).isDefined) 
      return new FailureResult("out of stock", inputCoins)

    new FailureResult("unimplemented", inputCoins)
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
