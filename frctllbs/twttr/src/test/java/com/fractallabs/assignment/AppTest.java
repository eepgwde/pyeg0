package com.fractallabs.assignment;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.*;

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
    InputStream src = new FileInputStream(this.tfile);
    BufferedReader in = new BufferedReader(new InputStreamReader(src));
    assertNotNull(in);

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

    /**
     * Rigourous Test :-)
     */
    public void testApp()
    {
        assertTrue( true );
    }
}
