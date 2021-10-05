import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kickrani/catched.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: '잡았다 킥라니',
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
    },
  ));
}

// 메인에서는 적발된 사진들 타일형태로 띄우고 그걸 클릭하면 상세 페이지로 넘어가게
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            return CupertinoApp(
              // Remove the debug
              debugShowCheckedModeBanner: false,
              title: '잡았다 킥라니',
              home: MyHomePage(),
              localizationsDelegates: [
                DefaultMaterialLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
            );
          }
        });
  }
}

// Main Screen
class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String server = 'Put your server here';
  List<String> images = <String>[];
  List<String> reason = <String>[];
  List<String> lati = <String>[];
  List<String> longi = <String>[];
  List<String> time = <String>[];
  List<String> images2 = <String>[];
  List<String> reason2 = <String>[];
  List<String> lati2 = <String>[];
  List<String> longi2 = <String>[];
  List<String> time2 = <String>[];
  bool img_set = true;

  late BitmapDescriptor kick_icon;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers2 = <MarkerId, Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images.clear();
    reason.clear();
    lati.clear();
    longi.clear();
    time.clear();
    setmarkerimg();
    fillList();
  }

  setmarkerimg() async {
    kick_icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.2), 'assets/marker.png');
  }

  Future<void> updatelist() async {
    print('update 들어옴');
    var json = jsonDecode((await http.get(Uri.parse(server))).body);
    Map<String, dynamic> item;
    for (item in json) {
      images2.add(item['pic']);
      reason2.add(item['reason']);
      lati2.add(item['lati']);
      longi2.add(item['longi']);
      time2.add(item['time']);
      // print(double.parse(item['lati']));
      // print(double.parse(item['longi']));
      var markerIdVal = markers.length + 1;
      String mar = markerIdVal.toString();
      MarkerId markerId = MarkerId(mar);
      Marker marker = Marker(
          markerId: markerId,
          icon: kick_icon,
          infoWindow: InfoWindow(title: '킥라니가 찍힌 위치'),
          position:
              LatLng(double.parse(item['lati']), double.parse(item['longi'])));

      markers2[markerId] = marker;
    }

    print('업데이트 작업중');

    setState(() {
      images = images2.toList();
      reason = reason2.toList();
      lati = lati.toList();
      longi = longi2.toList();
      time = time2.toList();
      markers.clear();
      markers = <MarkerId, Marker>{}..addAll(markers2);
    });

    images2.clear();
    reason2.clear();
    lati2.clear();
    longi2.clear();
    time2.clear();
    markers2.clear();
  }

  Future<void> fillList() async {
    // 나중에 WAS완성시 url바꾸기
    var json = jsonDecode((await http.get(Uri.parse(server))).body);
    setState(() {
      Map<String, dynamic> item;
      for (item in json) {
        images.add(item['pic']);
        reason.add(item['reason']);
        lati.add(item['lati']);
        longi.add(item['longi']);
        time.add(item['time']);
        // print(double.parse(item['lati']));
        // print(double.parse(item['longi']));
        var markerIdVal = markers.length + 1;
        String mar = markerIdVal.toString();
        MarkerId markerId = MarkerId(mar);
        Marker marker = Marker(
            markerId: markerId,
            icon: kick_icon,
            infoWindow: InfoWindow(title: '킥라니가 찍힌 위치'),
            position: LatLng(
                double.parse(item['lati']), double.parse(item['longi'])));

        markers[markerId] = marker;
      }
    });
    // await addmarker();
    img_set = false;
  }

  // Future<void> addmarker() async {
  //   //print(lati.length);
  //   for (int i = 0; i < lati.length; i++) {
  //     _markers.add(Marker(
  //       markerId: MarkerId(reason.elementAt(i)),
  //       position: LatLng(
  //           double.parse(lati.elementAt(i)), double.parse(longi.elementAt(i))),
  //       infoWindow: InfoWindow(
  //         title: '킥라니가 찍힌 위치',
  //       ),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

    const myduration = const Duration(seconds: 5);
    new Timer(myduration, () async {
      print('refressedddddd');
      await updatelist();
    });

    return CupertinoPageScaffold(
        child: Material(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: statusBarHeight,
        ),
        Container(
          height: statusHeight * 0.05,
          child: Text(
            '적발된 모습',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: statusHeight * 0.5,
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //childAspectRatio: 1 / 2,
              mainAxisSpacing: 1, //수평 Padding
              crossAxisSpacing: 1, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              return img_set
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('서버와 통신중입니다!'),
                      ],
                    ))
                  : Container(
                      child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => catched(
                                    imageurl: images[images.length - 1 - index],
                                    reason: reason[images.length - 1 - index],
                                    time: time[images.length - 1 - index],
                                    lati: lati[images.length - 1 - index],
                                    longi: longi[images.length - 1 - index],
                                    kick_icon: kick_icon,
                                  )),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: images[images.length - 1 - index],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ));
            },
          ),
        ),
        Container(
          height: statusHeight * 0.05,
          child: Text(
            '포착된 위치들',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: statusHeight * 0.3,
          width: 300,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(35.1331, 129.102),
              zoom: 15,
            ),
            markers: Set<Marker>.of(markers.values),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
        )
      ],
    )));
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? Color(0xe1f5fe).withOpacity(1.0)
          : Color(0x042a49).withOpacity(1.0),
      body: Center(
          child: lightMode
              ? Image.asset('assets/background.png')
              : Image.asset('assets/background.png')),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 2));
  }
}
