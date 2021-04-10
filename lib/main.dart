import 'package:flutter/material.dart';
import 'package:mobile_blog/add.dart';
import 'package:mobile_blog/blog.dart';
import 'package:mobile_blog/edit.dart';
import 'package:mobile_blog/login.dart';
import 'package:mobile_blog/year.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  // make sure that everything before runApp() completes
  WidgetsFlutterBinding.ensureInitialized();

  String home = '/login';
  String url = 'http://10.0.2.2:3000/mobile/verify';

  // check token
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String token = prefs.getString('token');
  FlutterSecureStorage storage = FlutterSecureStorage();
  String token = await storage.read(key: 'token');
  if (token != null) {
    http.Response response =
        await http.get(url, headers: {'authorization': token});
    if (response.statusCode == 200) {
      print('token is valid');
      home = '/blog';
    } else {
      print('token is bad');
    }
  } else {
    print('no token');
  }

  runApp(GetMaterialApp(
    // home: Login(),
    initialRoute: home,
    routes: {
      '/login': (context) => Login(),
      '/blog': (context) => Blog(),      
      '/add': (context) => Add(),      
      '/edit': (context) => Edit(),      
      '/year': (context) => Year(),      
    },
  ));
}
