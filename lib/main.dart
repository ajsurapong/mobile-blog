import 'package:flutter/material.dart';
import 'package:mobile_blog/blog.dart';
import 'package:mobile_blog/login.dart';

void main() {
  runApp(MaterialApp(
    // home: Login(),
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/blog': (context) => Blog(),
    },
  ));
}
