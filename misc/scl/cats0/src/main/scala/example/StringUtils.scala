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

  /** String to number containers.
   *
   * Capture a string to number type conversion in an Option.
   */
  implicit class StringImprovements(val s: String) {
    import scala.util.control.Exception._

    def toByteOpt = catching(classOf[NumberFormatException]) opt s.toByte
    def toShortOpt = catching(classOf[NumberFormatException]) opt s.toShort
    def toIntOpt = catching(classOf[NumberFormatException]) opt s.toInt
    def toLongOpt = catching(classOf[NumberFormatException]) opt s.toLong

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
     */
    def toNumericOpt = toByteOpt orElse toShortOpt orElse toIntOpt orElse toLongOpt orElse toDoubleOpt 

    def refine = toNumericOpt orElse Option[String](s)
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

