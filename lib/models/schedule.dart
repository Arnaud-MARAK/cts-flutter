import 'dart:ffi';
import 'dart:convert';

List<Schedule> scheduleFromJson(String str) => List<Schedule>.from(json.decode(str)['ServiceDelivery']['StopMonitoringDelivery'][0]['MonitoredStopVisit'].map((x) => Schedule.fromJson(x)));


class Schedule {
    Schedule({
        required this.code,
        this.ref,
        this.name,
        this.vehicleMod,
        required this.destinationName,
        required this.destinationShortName,
        required this.lineRef,
        required this.expectedArrived,
        this.isRealTime,
    });

    String code;
    String? ref;
    String? name;
    String? vehicleMod;
    String destinationName;
    String destinationShortName;
    String lineRef;
    String expectedArrived;
    bool? isRealTime;

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
      code: json["StopCode"],
      ref: json["MonitoredRef"],
      name: json["MonitoredVehicleJourney"]["MonitoredCall"]["StopPointName"],
      vehicleMod: json["MonitoredVehicleJourney"]["VehicleMode"],
      destinationName: json["MonitoredVehicleJourney"]["DestinationName"],
      destinationShortName: json["MonitoredVehicleJourney"]["DestinationShortName"],
      lineRef: json["MonitoredVehicleJourney"]["LineRef"],
      expectedArrived: json["MonitoredVehicleJourney"]["MonitoredCall"]["ExpectedArrivalTime"],
      isRealTime: json["MonitoredVehicleJourney"]["MonitoredCall"]["Extension"]["IsRealTime"], 
    );

    //  getExpectArrivedText() {
    //   return expectedArrived.substring(11, 19);
    // }
}