import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Year extends StatefulWidget {
  @override
  _YearState createState() => _YearState();
}

class _YearState extends State<Year> {
  List<dynamic> years;

  @override
  void initState() {
    super.initState();
    years = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select year'),
      ),
      body: ListView.builder(
        itemCount: years == null ? 0 : years.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${years[index]['year']}'),
            onTap: () {
              Get.back(result: years[index]['year']);
              // Navigator.pop(context, years[index]['year']);
            },
          );
        },
      ),
    );
  }
}
