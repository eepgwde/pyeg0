// @author weaves
// @brief JSON parser on a CoinDesk stream
// 

package com.fractallabs.assignment;

import java.time.Instant;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

import java.io.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Parser  {
  java.text.SimpleDateFormat xfmt1 = new SimpleDateFormat("M d,Y ")
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
0  LocalDateTime start0 = LocalDateTime.now();  

  public Parser() {}

  JSONParser parser = new JSONParser();

  public void parse(BufferedReader in) {
    // Begin aggregating mentions. Every hour, "store" the relative change
    // (e.g. write it to System.out).
    
    try {
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

}
