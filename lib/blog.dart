import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  final String _url = 'http://10.0.2.2:3000/mobile/blog';
  // var _data = {
  //   'post': [
  //     {'blogID': 1, 'title': 'Dummy', 'detail': 'Dummy', 'year': 2021},
  //     {'blogID': 2, 'title': 'Dummy2', 'detail': 'Dummy2', 'year': 2021},
  //     {'blogID': 3, 'title': 'Dummy3', 'detail': 'Dummy3', 'year': 2021},
  //   ]
  // };

  //------------- Logout -----------------
  void logout() async {
    // clear the saved token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // return to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  //------------- Get blog data -----------------
  Future<dynamic> getBlog() async {
    // get token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      // connect to server
      http.Response response = await http
          .get(_url, headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        return Future.delayed(Duration(seconds: 1), () {
          // after the delayed time
          return json.decode(response.body);
        });
        // return json.decode(response.body);
      } else {
        throw Exception('Connection error');
      }
    } else {
      print('No token');
      throw Exception('No token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: logout)],
      ),
      body: FutureBuilder(
        future: getBlog(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return Text('OK');
            } else {
              return Text('${snapshot.error}');
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

// ListView.builder(
//         itemCount: _data['post'].length ?? 0,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.edit),
//             title: Text(_data['post'][index]['title']),
//             subtitle: Text(_data['post'][index]['detail']),
//             trailing: Icon(Icons.delete),
//           );
//         },
//       ),
