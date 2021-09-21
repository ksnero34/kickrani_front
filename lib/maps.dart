import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class maps extends StatefulWidget {
  String lati, longi;

  maps({
    required this.lati,
    required this.longi,
  });

  @override
  State<StatefulWidget> createState() => maps_state(lati: lati, longi: longi);
}

class maps_state extends State<maps> {
  String lati, longi;
  late LatLng spot;
  Set<Marker> markers = {};

  maps_state({
    required this.lati,
    required this.longi,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spot = LatLng(35.1331, 129.102);
    markers.add(Marker(
      markerId: MarkerId('userstartloc'),
      position: LatLng(
        spot.latitude,
        spot.longitude,
      ),
      infoWindow: InfoWindow(
        title: '킥라니가 찍힌 위치',
      ),
    ));
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition kickrani = CameraPosition(
    target: LatLng(35.1331, 129.102),
    zoom: 19,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799, //얼마나 북을 기준으로 돌릴지.
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: kickrani,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pop(context);
        },
        label: Text('이전 화면으로 돌아가기'),
        icon: Icon(Icons.backspace),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
