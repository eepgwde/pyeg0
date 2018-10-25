package com.fractallabs.assignment;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.*;
import java.util.Vector;
import java.util.stream.*;

/**
 * Unit test for simple App.
 */
public class AppTest 
    extends TestCase
{
  File tfile;

  public void test000() throws Exception {
    String s = this.getClass()
      .getClassLoader()
      .getResource("date-sample.json").getFile();
    assertNotNull(s);
    this.tfile = (File) new File(s);
    System.out.println(tfile.getAbsolutePath());
  }

  public void test002() throws Exception {
    test000();

    assertNotNull(this.tfile);
    FileReader fr = new FileReader(this.tfile);
    Parser parser = new Parser();
    parser.parse((Reader) fr);
    Vector<java.io.Serializable> rs = parser.get((Vector<java.io.Serializable>) null);
    System.out.println("rs: size: " + rs.size());

    System.out.println(rs.stream()
                       .map(e -> e.getClass().getName())
                       .collect(Collectors.toList()) );
  }

  /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AppTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( AppTest.class );
    }

}
