import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kickrani/catched.dart';
import 'package:http/http.dart' as http;

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
  List<String> location = <String>[];
  List<String> time = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillList();
  }

  Future<void> fillList() async {
    // Fill the list with links
    var json = jsonDecode(
        (await http.get(Uri.parse("https://picsum.photos/v2/list?limit=40")))
            .body);
    setState(() {
      Map<String, dynamic> item;
      for (item in json) {
        images.add(item['download_url']);
        location.add(item['author']);
        time.add(item['url']);
      }
    });
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
            child: GridView.builder(
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //childAspectRatio: 1 / 2,
        mainAxisSpacing: 1, //수평 Padding
        crossAxisSpacing: 1, //수직 Padding
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: TextButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => catched(
                        imageurl: images[index],
                        location: location[index],
                        time: time[index],
                      )),
            );
          },
          child: Image.network(images[index], fit: BoxFit.cover),
        ));
      },
    )));
  }
}