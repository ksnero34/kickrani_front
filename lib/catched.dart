//서버와 통신후 킥라니 이미지들을 띄워줄 페이지
//이미지랑 찍힌 시간, cctv위치(장소)

//백(WAS)이랑 통신방법은 get으로 할꺼고 백엔드서버에서 DB랑 통신하고 어플에서 요청들어오면
//get으로 어떻게 넘겨줄지
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class catched extends StatefulWidget {
  String imageurl;
  String location;
  String time;

  catched({
    required this.imageurl,
    required this.location,
    required this.time,
  });
  @override
  catched_State createState() =>
      catched_State(imageurl: imageurl, location: location, time: time);
}

class catched_State extends State<catched> {
  String imageurl;
  String location;
  String time;

  catched_State(
      {required this.imageurl, required this.location, required this.time});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                width: 200,
                child: TextButton(
                  onPressed: null,
                  child: Image.network(imageurl, fit: BoxFit.cover),
                ),
              ),
              Text(location),
              Text(time),
              Material(
                child: InkWell(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.asset('assets/simin_icon.png'),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}