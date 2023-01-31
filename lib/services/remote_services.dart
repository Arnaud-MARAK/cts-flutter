import 'package:cts/models/physical_stop.dart';
import 'package:cts/models/schedule.dart';
import 'package:cts/models/stop.dart';
import 'package:cts/models/posts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class RemoteService {

  Future<List<Post>?> getPosts() async {
    var client = http.Client();

    var uri = Uri.parse('http://jsonplaceholder.typicode.com/posts');
    var response = await client.get(uri);
    if(response.statusCode == 200){
      var json = response.body;
      print(json);
      return postFromJson(json);
    }
  }

  Future<List<Stop>?> getStops() async {
    var client = http.Client();

    // print("try request");
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('2acdc187-706a-475d-8acb-d53d76278b96:2acdc187-706a-475d-8acb-d53d76278b96'));

    final response = await client.get(
      Uri.parse('https://api.cts-strasbourg.eu/v1/siri/2.0/stoppoints-discovery'),
      // Send authorization headers to the backend.
      headers: <String, String>{'authorization': basicAuth}
    );

    if(response.statusCode == 200){
      var jsonPhysicalStop = response.body;
      List<PhysicalStop> listPs = physicalStopFromJson(jsonPhysicalStop);

      // print("Test 2");
      // print(listPs[0].code);

      var psCodeUsed = [];

      List<Stop> listStop = [];

      for(var i = 0; i <= listPs.length - 1; i++){
        PhysicalStop ps = listPs[i];
        if(!psCodeUsed.contains(ps.logicalStopCode)){
          psCodeUsed.add(ps.logicalStopCode);

          List<PhysicalStop> newListPs = [];

          for(var j = i; j <= listPs.length - 1; j++){
            PhysicalStop ps2 = listPs[j];
            if(i != j && ps.logicalStopCode == ps2.logicalStopCode){
              newListPs.add(ps2);
            }
          }
          listStop.add(Stop(name: ps.name, logicalStopCode: ps.logicalStopCode, listPhysicalStop: newListPs));
        }
      }

      listStop.sort((a, b) => a.name.compareTo(b.name));

      print(listStop.length);

      return listStop;
    }
    return null;
  }


  Future<List<Schedule>?> getSchedules(Stop stop, TimeOfDay time) async {
    var client = http.Client();

    String minute = time.minute < 10 ? "0" + time.minute.toString() : time.toString();
    String hour = time.hour < 10 ? "0" + time.hour.toString() : time.toString();

    print(minute + ":" + hour);
    
    String date = '2022-11-17T22:00:00';
    
    // print("try request");
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('2acdc187-706a-475d-8acb-d53d76278b96:2acdc187-706a-475d-8acb-d53d76278b96'));

    String url = 'https://api.cts-strasbourg.eu/v1/siri/2.0/stop-monitoring';
    url += '?MonitoringRef=${stop.logicalStopCode}';
    url += '&StartTime=$date';
    url == '&MinimumStopVisitsPerLine=5';
    print(url);
    final response = await client.get(
      Uri.parse(url),
      // Send authorization headers to the backend.
      headers: <String, String>{'authorization': basicAuth}
    );

    if(response.statusCode == 200){
      var jsonSchedule = response.body;
      return scheduleFromJson(jsonSchedule);
    }

    return null;
  }
}