package com.fractallabs.assignment;

import java.time.Instant;

public class TwitterScanner {

  public static class TSValue {
    private final Instant timestamp;
    private final double val;

    public TSValue(Instant timestamp, double val) {
      this.timestamp = timestamp;
      this.val = val;
    }

    public Instant getTimestamp() {
      return timestamp;
    }

    public double getVal() {
      return val;
    }
  }

  public TwitterScanner(String companyName) {
    // ...
  }

  public void run() {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
  }

  private void storeValue(TSValue value) {
    // ...
  }

  public static void main(String ... args) {
    TwitterScanner scanner = new TwitterScanner("Facebook");
    scanner.run();
  }
}