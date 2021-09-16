//서버와 통신후 킥라니 이미지들을 띄워줄 페이지

import 'package:flutter/cupertino.dart';

class catched extends StatefulWidget {
  @override
  @override
  catched_State createState() => catched_State();
}

class catched_State extends State<catched> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text('data'),
          ],
        ),
      ],
    );
  }
}
