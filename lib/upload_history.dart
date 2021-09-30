import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../main.dart';

class upload_history {
  static Future<void> upload_drive_history(List<List> input_data) async {
    List<String> separated = [];

    print(input_data.length);
    separated.add(input_data.elementAt(0)[0]);
    separated.add(input_data.elementAt(0)[1]);
    separated.add(input_data.elementAt(0)[2]);
    try {
      String url = 'http://211.219.250.41/input_kickrani';
      //print(input_data);
      var uri = Uri.parse(url);
      var data = {
        "lati": separated[0],
        "longi": separated[1],
        "time": separated[2],
      };
      var body = json.encode(data);
      http.Response response = await http.post(uri,
          headers: <String, String>{"Content-Type": "application/json"},
          body: body);
      print(response.statusCode);
      print(body);

      separated.clear();

      //print(body);
      //print(userlocation_global.latitude);
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
