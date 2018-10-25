package com.fractallabs.assignment;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.*;
import java.util.Vector;
import java.util.Date;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.stream.*;

import java.time.Instant;
import java.time.ZonedDateTime;

import java.util.TimeZone;
import java.util.Date;
import java.util.Vector;

import java.time.LocalDateTime;

/**
 * Unit test for simple App.
 */
public class AppTest 
    extends TestCase
{
  File tfile;

  /// Can we read a JSON file from the source URL.
  public void test000() throws Exception {
    String s = this.getClass()
      .getClassLoader()
      .getResource("date-sample.json").getFile();
    assertNotNull(s);
    this.tfile = (File) new File(s);
    System.out.println(tfile.getAbsolutePath());
  }

  /// Can we pass its contents.
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

    Fetcher.TSValue ts = new Fetcher.TSValue((Date)rs.get(0), (Double)rs.get(1));
    System.out.println("ts: " + ts);
  }


  /// Can we build a SortedSet of Fetcher.TSValue
  public void test004() throws Exception {
    LocalDateTime start0 = LocalDateTime.now();
    Instant instant = ZonedDateTime.of(start0, TimeZone.getDefault().toZoneId()).toInstant();

    Fetcher.TSValue ts = new Fetcher.TSValue(instant, (double)1000.0);
    System.out.println("ts: " + ts);

    Fetcher.TSValue ts1 = (Fetcher.TSValue) ts.clone();
    assertNotSame(ts, ts1);

    int n0 = 100;
    Vector<Fetcher.TSValue> tss = new Vector<Fetcher.TSValue>(n0);
    while (--n0 >= 0) {
      ts1 = new Fetcher
        .TSValue(ts.getTimestamp().minusSeconds((n0 + 1) * 60), (n0 + 1)*ts.getVal());
      tss.add(ts1);
    }

    assertTrue(tss.size() > 0);

    System.out.println(tss.size() +"; " + tss.firstElement() + "; " + tss.lastElement());

    SortedSet<Fetcher.TSValue> set = new TreeSet<Fetcher.TSValue>(tss);

    /// Most recent
    System.out.println("last: " + set.last());
    // from an hour beforehand.
    Instant i0 = set.last().getTimestamp().minusSeconds(60 * 60);
    ts1 = new Fetcher.TSValue(i0, set.last().getVal());
    /// first within an hour
    ts = set.tailSet(ts1).first();
    System.out.println("prior-hour: " + ts);
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
