package com.fractallabs.assignment;

import java.time.Instant;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.util.Timer;
import java.util.TimerTask;
import java.net.URL;
import java.io.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;

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
  URL url;

  public Fetcher(String companyName) {
    this.companyName = companyName;
  }

  public Fetcher(URL urlOfJSON) {
    this.url = urlOfJSON;
  }

  JSONParser parser = new JSONParser();

  @Override
  public void run() {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
    try {
      BufferedReader in = new BufferedReader(new InputStreamReader(this.url.openStream()));
      JSONObject json = (JSONObject) parser.parse(in);
      JSONObject json0;
      String name;
      Double rate;

      json0 = (JSONObject) json.get("time");
      name = (String) json0.get("updateduk");
      System.out.println(name);

      json0 = (JSONObject) json.get("bpi");
      json0 = (JSONObject) json0.get("USD");
      name = (String) json0.get("rate");
      // System.out.println(name);
      rate = (Double) json0.get("rate_float");
      System.out.println(rate);

      System.out.println(dtf.format(LocalDateTime.now()));
    } catch (IOException ioe) {
      System.err.println(ioe.getMessage());
    } catch (ParseException pe) {
      System.err.println(pe.getMessage());
    } catch (Exception ex) {
      System.err.println(ex.getMessage());
    }
  }

  private void storeValue(TSValue value) {
    // ...
  }

  static Timer timer = new Timer(true);

  public static void main(String ... args) throws Exception {
    System.setProperty("http.agent", 
                       "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2");
    int secs = 10 ;        // seconds in an hour
    URL url ;
    url = new URL("https://api.coindesk.com/v1/bpi/currentprice.json");
    Fetcher scanner = new Fetcher(url);
    timer.scheduleAtFixedRate(scanner, 1000, 1000*secs);
    scanner.run();
    if (false) scanner.cancel();
  }
}
