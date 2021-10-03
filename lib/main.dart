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
}

// Main Screen
class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = <String>[];
  List<String> reason = <String>[];
  List<String> lati = <String>[];
  List<String> longi = <String>[];
  List<String> time = <String>[];
  bool img_set = true;

  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillList();
  }

  Future<void> fillList() async {
    // 나중에 WAS완성시 url바꾸기
    var json = jsonDecode(
        (await http.get(Uri.parse("http://211.219.250.41:8080"))).body);
    setState(() {
      Map<String, dynamic> item;
      for (item in json) {
        images.add(item['pic']);
        reason.add(item['reason']);
        lati.add(item['lati']);
        longi.add(item['longi']);
        time.add(item['time']);
        markers.add(Marker(
          markerId: MarkerId(item['reason']),
          position:
              LatLng(double.parse(item['lati']), double.parse(item['longi'])),
          infoWindow: InfoWindow(
            title: '킥라니가 찍힌 위치',
          ),
        ));
      }
    });
    img_set = false;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top; //기기의 상태창 크기
    final double statusHeight = (MediaQuery.of(context).size.height -
        statusBarHeight -
        MediaQuery.of(context).padding.bottom); // 기기의 화면크기

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
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
        )
      ],
    )));
  }
}
