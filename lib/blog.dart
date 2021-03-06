import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  String _url = 'http://10.0.2.2:3000/mobile/blog';
  var _token;
  var _year;

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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: 'token');

    // return to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  //------------- Get blog data -----------------
  Future<dynamic> getBlog() async {
    // get token
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _token = prefs.getString('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: 'token');

    if (_token != null) {
      // connect to server
      http.Response response = await http
          .get(_url, headers: {HttpHeaders.authorizationHeader: _token});
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

  //------------- Delete a post -----------------
  void deletePost(blogID) {
    // print(blogID);
    // show alert dialog
    Get.defaultDialog(
        title: 'Warning',
        middleText: 'Sure to delete this post?',
        textConfirm: 'Yes',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          // delete the post in DB
          http.Response response = await http.delete('$_url/$blogID',
              headers: {HttpHeaders.authorizationHeader: _token});
          if (response.statusCode == 200) {
            // refresh page
            setState(() {
              // nothing
            });
          } else {
            Get.defaultDialog(
                title: 'Error', middleText: 'Failed to delete data');
          }
        });
  }

  //------------- Create ListView -----------------
  Widget createListView(blog) {
    // print(blog['year']);
    // create dynamic dropdown for selecting years
    // List<DropdownMenuItem<int>> listItem = [];
    // blog['year'].forEach((y) {
    //   listItem.add(DropdownMenuItem(
    //     value: y['year'],
    //     child: Text('${y['year']}'),
    //   ));
    // });
    // // add all years option
    // listItem.insert(0, DropdownMenuItem(value: 0, child: Text('All years')));

    return Column(
      children: [
        // DropdownButton(
        //   value: _year,
        //   items: listItem,
        //   // items: [
        //   //   DropdownMenuItem(
        //   //     value: 2021,
        //   //     child: Text('2021'),
        //   //   ),
        //   //   DropdownMenuItem(
        //   //     value: 2020,
        //   //     child: Text('2020'),
        //   //   ),
        //   // ],
        //   onChanged: (int newYear) {
        //     setState(() {
        //       _year = newYear;
        //       if(newYear == 0) {
        //         // all years
        //         _url = 'http://10.0.2.2:3000/mobile/blog';
        //       }
        //       else {
        //         _url = 'http://10.0.2.2:3000/mobile/blog/$newYear';
        //       }
        //     });
        //   },
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Year'),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                // _year = await Navigator.pushNamed(context, '/year', arguments: blog['year']);
                _year = await Get.toNamed('/year', arguments: blog['year']);
                setState(() {
                  _url = 'http://10.0.2.2:3000/mobile/blog/$_year';
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh_sharp),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _url = 'http://10.0.2.2:3000/mobile/blog';
                });
              },
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: blog != null ? blog['post'].length : 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed('/edit', arguments: blog['post'][index]);
                  },
                ),
                title: Text(blog['post'][index]['title']),
                subtitle: Text(blog['post'][index]['detail']),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deletePost(blog['post'][index]['blogID'])),
              );
            },
          ),
        ),
      ],
    );
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
              // print(snapshot.data);
              return createListView(snapshot.data);
            } else {
              return Text('${snapshot.error}');
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add');
        },
      ),
    );
  }
}
