// @author weaves
// 

package example

/** An object for an implicit conversions.
 *
 *  {{{
 *  import example.StringUtils._
 *  val c = "1234".toIntOpt.get
 *  }}}
 */
object StringUtils {

  import scala.util.control.Exception._
  import scala.util.{Try, Success, Failure}

  trait Container[M[_]] { def put[A](x: A): M[A]; def get[A](m: M[A]): A }

  val container = new Container[Option] { 
    def put[A](x: A) = Option(x); 
    def get[A](m: Option[A]) = m.get
  }

  /** String to number containers.
   *
   * Capture a string to number type conversion in an Option.
   */
  implicit class StringImprovements(val s: String) {
    def toByteOpt1 = container put (catching(classOf[NumberFormatException]) opt s.toByte)
    def toShortOpt1 = container put (catching(classOf[NumberFormatException]) opt s.toShort)

    def toByteOpt = catching(classOf[NumberFormatException]) opt s.toByte
    def toShortOpt = catching(classOf[NumberFormatException]) opt s.toShort
    def toIntOpt = catching(classOf[NumberFormatException]) opt s.toInt
    def toLongOpt = catching(classOf[NumberFormatException]) opt s.toLong

    def refine1 = container put (toByteOpt orElse toShortOpt)

    def refine2 = container put (toNumericOpt orElse Option[String](s))

    /** Convert a string to float.
     *
     * This may return infinity.
     */
    def toFloatOpt = catching(classOf[NumberFormatException]) opt s.toFloat

    /** Convert a string to double.
     *
     * This may return infinity.
     */
    def toDoubleOpt = catching(classOf[NumberFormatException]) opt s.toDouble

    /** Chain the conversions.
     *
     *  The order is byte, short, integer, long, double.
     * @note
     * We don't use float because of the int
     * @return None if no conversion works else returns AnyVal
     */
    def toNumericOpt = toByteOpt orElse toShortOpt orElse toIntOpt orElse toLongOpt orElse toDoubleOpt 

    /** Chain the conversions and return the original string on failure.
     *
     *  The order is byte, short, integer, long, double.
     * @note
     * We don't use float because of the int
     * @return None if no conversion works else Any and first conversion that works.
     */
    def refine = toNumericOpt orElse Option[String](s)

    def refine3 = container put s.refine
    def refine4 = container put s.refine.get
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

