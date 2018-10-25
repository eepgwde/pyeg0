// @author weaves
// @brief JSON parser on a CoinDesk stream
// 

package com.fractallabs.assignment;

import java.time.Instant;
import java.util.Date;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.io.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.mooo.walti.Bag;

public class Parser  {
  /** Remote system format for dates.
  *
  * "Oct 25, 2018 at 09:29 BST"
  */
  java.text.SimpleDateFormat xfmt1 = new java.text.SimpleDateFormat("MMM d, yyyy 'at' HH:mm z");
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
  LocalDateTime start0 = LocalDateTime.now();

  public Parser() {}

  JSONParser parser = new JSONParser();

  protected Date as(Bag<Date> bag, String input) throws Exception {
    bag.payload = xfmt1.parse(input);
    return bag.payload;
  }

  public void parse(BufferedReader in) throws Exception {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
    try {
      JSONObject json = (JSONObject) parser.parse(in);
      JSONObject json0;
      String name;
      Double rate;
      Bag<Date> date = new Bag<Date>();

      json0 = (JSONObject) json.get("time");
      name = (String) json0.get("updateduk");
      System.out.println(name);
      System.out.println(as(date, name));

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

}
