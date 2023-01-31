import 'dart:ffi';
import 'dart:convert';

List<PhysicalStop> physicalStopFromJson(String str) => List<PhysicalStop>.from(json.decode(str)['StopPointsDelivery']['AnnotatedStopPointRef'].map((x) => PhysicalStop.fromJson(x)));

class PhysicalStop {
    PhysicalStop({
        required this.code,
        required this.name,
        required this.logicalStopCode,
        this.stopPointRef,
        this.longitude,
        this.latitude,
        this.isFlexhopStop,
    });

    String code;
    String name;
    String logicalStopCode;
    String? stopPointRef;
    double? longitude;
    double? latitude;
    Bool? isFlexhopStop;

    factory PhysicalStop.fromJson(Map<String, dynamic> json) => PhysicalStop(
      code: json["Extension"]["StopCode"],
      name: json["StopName"],
      logicalStopCode: json["Extension"]["LogicalStopCode"],
      stopPointRef: json["StopPointRef"],
      longitude: json["Location"]["Longitude"],
      latitude: json["Location"]["Latitude"],
      isFlexhopStop: json["Extension"]["isFlexhopStop"],
    );
}