import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  var _data = {
    'post': [
      {'blogID': 1, 'title': 'Dummy', 'detail': 'Dummy', 'year': 2021},
      {'blogID': 2, 'title': 'Dummy2', 'detail': 'Dummy2', 'year': 2021},
      {'blogID': 3, 'title': 'Dummy3', 'detail': 'Dummy3', 'year': 2021},
    ]
  };

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
      body: ListView.builder(
        itemCount: _data['post'].length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.edit),
            title: Text(_data['post'][index]['title']),
            subtitle: Text(_data['post'][index]['detail']),
            trailing: Icon(Icons.delete),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
