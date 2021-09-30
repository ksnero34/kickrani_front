import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'upload_history.dart';

class kick_simul extends StatefulWidget {
  kick_simul();

  @override
  State<StatefulWidget> createState() => kick_simul_state();
}

class kick_simul_state extends State<kick_simul> {
  LatLng spot = LatLng(35.1331, 129.102);
  String mention = '운행 시작';
  Set<Marker> markers = {};
  bool isrunning = false;
  List<List> drive_his = [];
  List<String> lochis_ele = [];

  late GoogleMapController mapController;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Location location = new Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getposition();

    //  markers.add(Marker(
    //   markerId: MarkerId('userstartloc'),
    //   position: LatLng(
    //     spot.latitude,
    //     spot.longitude,
    //   ),
    //   infoWindow: InfoWindow(
    //     title: '킥라니가 찍힌 위치',
    //   ),
    // ));
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    mapController = _cntlr;
    location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble()),
              zoom: 19),
        ),
      );
      if (isrunning) {
        lochis_ele.add(l.latitude.toString());
        lochis_ele.add(l.longitude.toString());
        lochis_ele.add(DateTime.now().toString());
        //print(lochis_ele.toString());
        drive_his.add(lochis_ele.toList());
        //print(drive_his);
        lochis_ele.clear();
      }
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799, //얼마나 북을 기준으로 돌릴지.
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  void _getlocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.enableBackgroundMode(enable: true);

    _locationData = await location.getLocation();
    setState(() {
      spot = LatLng(_locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble());
    });
    //print('$_locationData.latitude,$_locationData.longitude');
  }

  void button_pressed() {
    if (mention == '운행 시작') {
      drive_his.clear();
      setState(() {
        isrunning = true;
        mention = '운행 종료';
      });
    } else {
      setState(() {
        isrunning = false;
        mention = '운행 시작';
      });
      drive_his.clear();
    }
  }

  void getposition() async {
    _getlocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: spot, zoom: 19),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
      SafeArea(
          child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (isrunning) {
                      print(drive_his);
                      isrunning = false;
                      upload_history.upload_drive_history(drive_his);
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('운행중 위치 트래킹'),
                          content: SingleChildScrollView(
                              child: Text(drive_his.toString())),
                          actions: <Widget>[
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text('CLOSE'),
                            ),
                          ],
                        ),
                      );
                    }

                    button_pressed();
                  },
                  label: Text(mention),
                  icon: Icon(Icons.backspace),
                ),
              )))
    ]));
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
