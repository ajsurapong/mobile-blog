import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Add extends StatelessWidget {
  TextEditingController tcTitle = TextEditingController();
  TextEditingController tcDetail = TextEditingController();

  void add() async {
    // connect to server
    // get saved token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = 'http://10.0.2.2:3000/mobile/blog/new';
    http.Response response = await http.post(
      url,
      headers: {'authorization': token},
      body: {'title': tcTitle.text, 'detail': tcDetail.text},
    );

    // response is OK?
    if(response.statusCode == 200) {
      // return to blog page
      Get.offAllNamed('/blog');
    }
    else {
      Get.defaultDialog(title: 'Error', middleText: response.body.toString());
      print(response.body.toString());
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            controller: tcTitle,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: tcDetail,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Detail'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: add,
            child: Text('Save'),
          )
        ]),
      ),
    );
  }
}
