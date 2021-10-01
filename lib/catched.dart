//서버와 통신후 킥라니 이미지들을 띄워줄 페이지
//이미지랑 찍힌 시간, cctv위치(장소)

//백(WAS)이랑 통신방법은 get으로 할꺼고 백엔드서버에서 DB랑 통신하고 어플에서 요청들어오면
//get으로 어떻게 넘겨줄지
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kickrani/kick_simul.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'maps.dart';

class catched extends StatefulWidget {
  String imageurl;
  String reason;
  //String location;
  String time;
  String lati;
  String longi;

  catched({
    required this.imageurl,
    required this.reason,
    //required this.location,
    required this.time,
    required this.lati,
    required this.longi,
  });
  @override
  catched_State createState() => catched_State(
      imageurl: imageurl,
      //location: location,
      reason: reason,
      time: time,
      lati: lati,
      longi: longi);
}

class catched_State extends State<catched> {
  String imageurl;
  //String location;
  String reason;
  String time;
  String lati;
  String longi;
  Set<Marker> markers = {};
  late LatLng spot;

  catched_State({
    required this.imageurl,
    required this.reason,
    //required this.location,
    required this.time,
    required this.lati,
    required this.longi,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    spot = LatLng(double.parse(lati), double.parse(longi));
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

  Widget popupimg(BuildContext context, String imageurl) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      //title: Text(title),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height - 200,
            width: width,
            child: CachedNetworkImage(
              imageUrl: imageurl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
      actions: <Widget>[
        new TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200,
                width: 250,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      //barrierDismissible: false,
                      builder: (BuildContext context) {
                        return popupimg(
                          context,
                          imageurl,
                        );
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageurl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Text('적발 사유 : ' + reason),
              Container(
                  height: 250,
                  width: 250,
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(spot.latitude, spot.longitude),
                          zoom: 15,
                        ),
                        markers: markers,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                      SafeArea(
                          child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.01),
                                    BlendMode.dstATop),
                                image: NetworkImage(imageurl))),
                        child: TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => maps(
                                        lati: lati,
                                        longi: longi,
                                      )),
                            );
                          },
                          onLongPress: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => kick_simul()));
                          },
                          child: Text(''),
                        ),
                      )),
                    ],
                  )),
              // TextButton(
              //     onPressed: () async {
              //       await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => maps(
              //                   lati: lati,
              //                   longi: longi,
              //                 )),
              //       );
              //     },
              //     child: Text('' + location)),
              Text('적발 시간 : ' + time),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('목록으로 돌아가기')),

              Material(
                child: InkWell(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/simin_icon.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
