package com.fractallabs.assignment;

import java.time.Instant;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.util.Timer;
import java.util.TimerTask;

public class Fetcher extends TimerTask {
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
  LocalDateTime start0 = LocalDateTime.now();  

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

  String companyName;

  public Fetcher(String companyName) {
    this.companyName = companyName;
  }

  @Override
  public void run() {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    System.out.println(dtf.format(start0));
  }

  private void storeValue(TSValue value) {
    // ...
  }

  static Timer timer = new Timer(true);

  public static void main(String ... args) {
    int secs = 60 ;        // seconds in an hour
    Fetcher scanner = new Fetcher("FaceBook");
    timer.scheduleAtFixedRate(scanner, 0, 60*secs);
    scanner.run();
    if (false) scanner.cancel();
  }
}
