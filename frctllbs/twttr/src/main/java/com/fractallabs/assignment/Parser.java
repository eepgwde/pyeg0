// @author weaves
// @brief JSON parser on a CoinDesk stream
// 

package com.fractallabs.assignment;

import java.util.Date;
import java.util.Vector;

import java.time.format.DateTimeFormatter;  

import java.io.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Parser  {
  /// Factory is given a type of parser to instantiate.
  enum Variants { COINDESK, TWHTSTATUS };

  /// Results are cached in this vector.
  ///
  /// Loose-fitting bag.
  Vector<java.io.Serializable> results = new Vector<java.io.Serializable>(2);

  /// Get the bag of results.
  ///
  /// This uses a dummy type parameter.
  public Vector<java.io.Serializable> get(Vector<java.io.Serializable> bag) {
    return results;
  }

  /// Provides a parser.
  public Parser() {}

  /// Provides a parser with named set of patterns.
  ///
  /// @TODO
  /// This should be a factory, instantiating an implementation for the given Variant.
  public Parser(Variants parserType) {
    // Some private implementation of parse is then used within parse().
  }

  /// This is the only parser at the moment. JSON for CoinDesk bitcoin price.

  /** Remote system format for dates.
   *
   * "Oct 25, 2018 at 09:29 BST"
   */
  java.text.SimpleDateFormat xfmt1 = new java.text.SimpleDateFormat("MMM d, yyyy 'at' HH:mm z");
  JSONParser parser = new JSONParser();

  protected Date as(Vector<Date> bag, String input) throws Exception {
    Date dt = xfmt1.parse(input);
    if (bag!=null) bag.add(dt);
    return dt;
  }

  Vector<Date> dates = new Vector<Date>(1);

  /// This should be a vectored (pointer to implementation) invocation.
  public Parser parse(Reader in) throws Exception {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
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
    return this;
  }

}
