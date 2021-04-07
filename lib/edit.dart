import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController tcTitle = TextEditingController();
  TextEditingController tcDetail = TextEditingController();
  int blogID;

  void edit() async {
    // get user data
    // connect to server
    // get token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = 'http://10.0.2.2:3000/mobile/blog/edit';
    http.Response response = await http.put(
      url,
      headers: {'authorization': token, 'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': tcTitle.text, 'detail': tcDetail.text, 'blogID': blogID}),
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
  void initState() {
    super.initState();
    var post = Get.arguments;
    // print(post);
    tcTitle.text = post['title'];
    tcDetail.text = post['detail'];
    blogID = post['blogID'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit a post'),
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
            onPressed: edit,
            child: Text('Save'),
          )
        ]),
      ),
    );
  }
}