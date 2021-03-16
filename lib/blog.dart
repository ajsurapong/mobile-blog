import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  //------------- Logout -----------------
  void logout() async {
    // clear the saved token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // return to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: logout)],
      ),
      body: Container(),
    );
  }
}
