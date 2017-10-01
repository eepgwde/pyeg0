// * @author weaves
// * @file Vending.scala
// * @brief Framework change-making.


package example

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

/** Change-making problem framework. */

class VendingMachine {
  val logger = Logger(this.getClass.getName)

  val version = "0.1.0-weaves"

  /** Change held. */
  var ch = List[Coin]()

  /** Products held. */
  var pr = List[Item]()

  /** A pricing service.
   *
   * @note
   * This should be either a constructor parameter or an implicit on invocation.
   */
  var ps : Option[RealtimePricingService] = None

  /** Pricing implementation. */
  def setPricer(ps0: RealtimePricingService): Unit = {
    ps = Option(ps0)
  }

  /** Management interface to put change in the machine
    *
    * The coins, like the products, are bundled into a single list. We can optimize
    * the representation when we find our algorithm.
    * 
    * @param coins coins added to the machine as change
    */
  def addChange(coins: List[Coin]): Unit = {
    ch = ch ::: coins
  }

  /** Add some products.
   *
   * A simple optimization here is to use product buckets.
   * But early optimization can compromise later extensions.
   *
   * So, for now, we keep this as a list and use list operations to maintain the
   * inventory.
   */
  def addItems(item: Item, number: Int): Unit = {
    pr = pr ::: List.fill(number)(item)
  }

  /** An exact vend.
   *
   * @TODO
   * find and drop first product.
   *
   * @TODO
   * remove their change from ours
   */
  protected def vend(item: Item, inputCoins: List[Coin], 
		     changeToGive: List[Coin]) : List[Coin] = {
    ch = ch ::: inputCoins
    // ch = ch - changeToGive
    changeToGive
  }

  /** How to buy a single instance of an item.
   *
   * This captures the logic. We use the branching style, because it is easier to
   * implement as separate tasks. Those separate tasks can then be run in isolation.
   *
   * If a threaded implementation were to be used. This method would launch a parent
   * thread, the tasks would return state results, any failure would terminate all
   * sub-threads and the parent.
   * 
   * @note
   * Change-giving is a knapsack problem, so we want to concentrate on that
   * aspect. The over-riding optimization is to sell as much product as possible
   * without change-giving failures preventing a sale. Unfortunately, such an
   * optimal algorithm would be need to tune itself to the input loading, that is,
   * what change is required.
   *
   * Because of that, there are various sub-optimal algorithms (A* breadth-first and
   * so on) that are easy to implement but not assuredly optimal.
   * 
   * @note
   * Real vending machine change-giving systems usually have practical considerations:
   * you want to minimize exposure to fake coins, to prevent people from using
   * changing small coins to larger ones. Also, mechanical design considerations can
   * be introduced: balancing the coin-hopper loads and so on.
   * 
   */
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

    // When exact, we can vend.
    if (bid0 == ask0) {
      return new SuccessfulResult(vend(item, inputCoins, List[Coin]()))
    }

    // This purchase attempt will need change
    // following cases are all: ( bid0 > ask0) 

    // A couple of cases can be classified. 
    

    // is the change they want exactly equal to the change we hold

    val chNeed = bid0 - ask0

    {
      val chSum = ch.map(_.value).sum		  // cache this
      // A simple vend is if the change required is exactly the change we have.
      if ( chNeed == chSum ) 
	return new SuccessfulResult(vend(item, inputCoins, ch))
    }

    // is the change they want exactly equal to the change we hold and their coins
    // And there is a new failure condition.

    {
      val chSum = ch.map(_.value).sum + inputCoins.map(_.value).sum

      if ( chNeed > chSum )
	return new FailureResult("not enough change", inputCoins)

      // A simple vend is if the change required is exactly the change we have.
      if ( chNeed == chSum )
	return new SuccessfulResult(vend(item, inputCoins, ch ::: inputCoins))
    }

    // Now, we only have cases where chNeed < chSum
    // And we need an allocation algorithm.

    val rch = Try(alloc(chNeed, ch ::: inputCoins)) match { 
      case Success(v) => return new SuccessfulResult(v)
      case Failure(v) => return new FailureResult("no change", inputCoins)
    }

    new FailureResult("unimplemented", inputCoins)
  }

  def alloc(N: Int, coins: List[Coin]) : List[Coin] = {
    throw new java.lang.IllegalArgumentException("no change available");
    List[Coin]()
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
