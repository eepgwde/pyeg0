// @author weaves
// @brief JSON parser on a CoinDesk stream
// 

package com.fractallabs.assignment;

import java.time.Instant;
import java.util.Date;
import java.util.Date;
import java.util.Vector;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.io.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Parser  {
  /** Remote system format for dates.
  *
  * "Oct 25, 2018 at 09:29 BST"
  */
  java.text.SimpleDateFormat xfmt1 = new java.text.SimpleDateFormat("MMM d, yyyy 'at' HH:mm z");
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
  LocalDateTime start0 = LocalDateTime.now();

  enum Variants { COINDESK, TWHTSTATUS };

  //** Provides a parser.
  public Parser() {}

  //** Provides a parser with named set of patterns.
  public Parser(Variants parserType) {
    // Some private implementation of parse
  }

  JSONParser parser = new JSONParser();
  Vector<java.io.Serializable> results = new Vector<java.io.Serializable>(2);

  protected Date as(Vector<Date> bag, String input) throws Exception {
    Date dt = xfmt1.parse(input);
    if (bag!=null) bag.add(dt);
    return dt;
  }

  public Vector<java.io.Serializable> get(Vector<java.io.Serializable> bag) {
    return results;
  }

  Vector<Date> dates = new Vector<Date>(1);

  public Parser parse(Reader in) throws Exception {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
    try {
      JSONObject json = (JSONObject) parser.parse(in);
      JSONObject json0;
      String name;
      Double rate;

      dates.clear();
      results.clear();

      json0 = (JSONObject) json.get("time");
      name = (String) json0.get("updateduk");
      as(dates, name);
      results.add(dates.lastElement());

      json0 = (JSONObject) json.get("bpi");
      json0 = (JSONObject) json0.get("USD");
      name = (String) json0.get("rate");
      // System.out.println(name);
      rate = (Double) json0.get("rate_float");
      results.add(rate);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return this;
  }

}
