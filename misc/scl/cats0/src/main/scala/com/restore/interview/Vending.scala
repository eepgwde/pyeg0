package com.restore.interview

// ** pre-reqs

import scala.annotation.tailrec

import scala.util.{Try, Success, Failure}
import com.typesafe.scalalogging.Logger


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
  val logger = Logger(this.getClass.getName)

  val version = "0.1.0-weaves"

  /** Change held. */
  var ch = List[Coin]()

  /** Products held. */
  var pr = List[Item]()

  var ps : Option[RealtimePricingService] = None

  /** Pricing implementation. */
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

  // TODO: find and drop first product.
  // TODO: add their payment to our change
  protected def vend(item: Item, inputCoins: List[Coin]) : Unit = {
    0 == inputCoins.size
  }

  def purchaseItem(item: Item, inputCoins: List[Coin]): PurchaseResult = {
    if (!pr.find(_ == item).isDefined) 
      return new FailureResult("out of stock", inputCoins)

    if (!ps.isDefined) 
      return new FailureResult("no prices", inputCoins)

    val ask0 = Try(ps.get.getPrice(item)) match { 
      case Success(v) => v
      case Failure(v) => return new FailureResult("no price", inputCoins)
    }

    val bid0 = inputCoins.map(_.value).sum

    logger.info("ask0: " + ask0 + "; bid0: " + bid0)

    if (! (bid0 >= ask0) )
      return new FailureResult("not enough coins", inputCoins)

    // They will need change, we don't have it.
    if ( bid0 > ask0) {
      val ch1 = ch.map(_.value).sum
      if ( (bid0 - ask0) > ch1 )
	return new FailureResult("not enough change", inputCoins)

      // A simple vend is if the change required is exactly the change we have.
      if ( (bid0 - ask0) == ch1 ) {
	val ch2 = ch
	ch = List[Coin]()
	vend(item, inputCoins)
	return new SuccessfulResult(ch2)
      }
    }

    // When exact, we can vend.
    if (bid0 == ask0) {
      vend(item, inputCoins)
      return new SuccessfulResult(List[Coin]())
    }

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
