import 'dart:ffi';

import 'package:cts/models/physical_stop.dart';

//  List<Stop> stopFromJson(String str) => List<Stop>.from(json.decode(str).map((x) => Stop.fromJson(x)));

// String postToJson(List<Stop> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stop {
  Stop({
    required this.name,
    required this.logicalStopCode,
    this.listPhysicalStop,
  });

  String name;
  String logicalStopCode;
  List<PhysicalStop>? listPhysicalStop;

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
      name: json["userId"],
      logicalStopCode: json["id"],
      listPhysicalStop: json["title"],
  );

  // getStopPointRefs() {
  //   List<String> stopPointRef;

  //   this.physcialStops.forEach(ps => {
      // stopPointRefs.push(ps.stopPointRef)
  //     stopPointRef.
  //   })

  //   return stopPointRefs
  // }
}


