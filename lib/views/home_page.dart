import 'package:cts/models/physical_stop.dart';
import 'package:cts/models/posts.dart';
import 'package:cts/models/stop.dart';
import 'package:cts/models/schedule.dart';
import 'package:cts/services/remote_services.dart';
import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  TimeOfDay _time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  
  List<Stop>? _stops;
  final List<String> _stopsString = [];
  String _stopSelected = "";

  final _vehicles = ["Tous", "Bus", "Tram"];
  String? _vehicle = "Tous";

  bool _isButtonDisabled = true;

  List<Post>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    // _controller = TextEditingController();
    getStops();
  }

  getData() async {
    posts = await RemoteService().getPosts();
    if(posts != null){
      print(posts);
      setState(() {
        isLoaded = true;
      });
    }
  }

  getStops() async {
    print("test 1");
    _stops = await RemoteService().getStops();
    // _stopSelected = _stops![0].name;
    if(_stops != null){
      setState(() {
        for(var i = 0; i < _stops!.length; i++){
          _stopsString.add(_stops![i].name);
        }
        _stopSelected = _stops![0].name;
        _isButtonDisabled = false;
      });
    }
  }

    getSchedules() async {

    Stop s = _stops!.firstWhere((stop) => stop.name == _stopSelected);

    List<Schedule>? schedules = await RemoteService().getSchedules(s, _time);
    print(schedules);
    // if(posts != null){
    //   print(posts);
    //   setState(() {
    //     isLoaded = true;
    //   });
    // }
    }

  // void _incrementCounter() {
  //   setState(() {
  //     _isButtonDisabled = true;
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: _time
                  );

                  if(newTime == null) return;

                  setState(() { _time = newTime; });
                }, 
                child: const Text('Séléctionner l\'horaire')
              ),

              Text(
                '${_time.hour < 10 ? "0${_time.hour}" : _time.hour }:${_time.minute < 10 ? "0${_time.minute}" : _time.minute }',
                style: TextStyle(fontSize: 32),
              ),

              DropdownSearch<String>(
                selectedItem: _stopSelected,
                items: _stopsString,
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSearchBox: true,
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Arrêt",
                    filled: true,
                  ),
                ),
              ),

              DropdownSearch<String>(
                selectedItem: _vehicle,
                items: ['Tous', 'Bus', 'Tram'],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Véhicule",
                    filled: true,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  child: const Text('Récupérer les prochains passages'),
                  onPressed: _isButtonDisabled ? null : () { getSchedules(); },
                )
                // child: ElevatedButton(
                //   onPressed: _isValidated
                //   ? () async {
                //     print("ok");
                //   }: null,,
                //   child: const Text('Récupérer les prochains passages'),
                // ),
              ),

              // Visibility(
              //   visible: isLoaded,
              //   replacement: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              //   child: ListView.builder(
              //     itemCount: posts?.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         child: Text(
              //           posts![index].title,
              //           maxLines: 2,
              //           overflow: TextOverflow.ellipsis,
              //           style: const TextStyle(
              //             fontSize: 24, fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ]
          ),
        ),
      ),
    );
  }
}