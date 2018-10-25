// @author weaves
// @brief Demonstration application URL fetch.
// 
// 

package com.fractallabs.assignment;

import java.time.Instant;
import java.util.Date;
import java.util.Vector;
import java.util.SortedSet;
import java.util.TreeSet;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.util.Timer;
import java.util.TimerTask;
import java.net.URL;
import java.io.*;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;

public class Fetcher extends TimerTask {
  LocalDateTime start0 = LocalDateTime.now();  

  public static class TSValue implements Cloneable, Comparable<TSValue> {
    protected final Instant timestamp;
    protected final double val;

    public TSValue(Instant timestamp, double val) {
      this.timestamp = timestamp;
      this.val = val;
    }

    public TSValue(Date date, Double val) {
      this(date.toInstant(), val.doubleValue());
    }

    public Instant getTimestamp() {
      return timestamp;
    }

    public double getVal() {
      return val;
    }

    public String toString() {
      return String.format("%8.2f @ %s", val, timestamp.toString());
    }

    public int compareTo(TSValue o) {
      return this.timestamp.compareTo(o.getTimestamp());
    }

    /// Use the basic clone.
    ///
    /// @TODO
    /// No longer needed.
    public Object clone() {
      try {
          return super.clone();
        } catch (CloneNotSupportedException e) { return null; }
      // this won't happen, since we are Cloneable
    }
    
  }

  String companyName;
  URL url;

  public Fetcher(String companyName) {
    this.companyName = companyName;
  }

  Parser parser;

  public Fetcher(URL urlOfJSON) {
    this.url = urlOfJSON;
    parser = new Parser();
  }

  /// Prior values
  SortedSet<Fetcher.TSValue> set = new TreeSet<Fetcher.TSValue>();

  TSValue getPrior() {
    // from an hour beforehand.
    if (set.size() <= 1) return set.last();
    Instant i0 = set.last().getTimestamp().minusSeconds(60 * 60);
    TSValue ts1 = new TSValue(i0, set.last().getVal());
    /// first over an hour ago
    return set.tailSet(ts1).first();
  }

  @Override
  public void run() {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
    try {
      BufferedReader in = new BufferedReader(new InputStreamReader(this.url.openStream()));
      parser.parse(in);
      Vector<java.io.Serializable> rs = parser.get((Vector<java.io.Serializable>) null);
      TSValue ts = new TSValue((Date)rs.get(0), (Double)rs.get(1));

      System.out.println("new: ts: " + ts);
      set.add(ts);

      TSValue prior = getPrior();

      System.out.println("size: " + set.size() + "; " + prior + "; " + set.last());

      double y = set.last().getVal();
      double x = prior.getVal();

      System.out.println( String.format("delta: %4.2f%%", (y - x)/x * 100.0 ) );

    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  private void storeValue(TSValue value) {
    // ...
  }

  static Timer timer = new Timer(true);

  public static void main(String ... args) throws Exception {
    int secs = 10 ;        // seconds to wait

    System.setProperty("http.agent", 
                       "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2");
    if (args.length > 0) {
      int idx = 0;
      secs = Integer.parseInt(args[idx++]);
    }
    URL url ;
    url = new URL("https://api.coindesk.com/v1/bpi/currentprice.json");
    Fetcher scanner = new Fetcher(url);
    timer.scheduleAtFixedRate(scanner, 1000, 1000*secs);
    scanner.run();
    if (false) scanner.cancel();
  }
}
