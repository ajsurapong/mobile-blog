import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final TextEditingController tcUsername = TextEditingController();
  final TextEditingController tcPassword = TextEditingController();
  final String _url = 'http://10.0.2.2:3000/mobile/login';

  //------------- Login -----------------
  void login(BuildContext context) async {
    String username = tcUsername.text;
    String password = tcPassword.text;

    http.Response response = await http
        .post(_url, body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      String token = response.body.toString();
      // save token to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      // forward to blog page
      Navigator.pushReplacementNamed(context, '/blog');
    } else {
      print(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tcUsername,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            TextField(
              controller: tcPassword,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
