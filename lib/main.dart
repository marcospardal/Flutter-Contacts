import 'package:flutter/material.dart';

//screens
import 'package:contacts/ui/home_page.dart';

void main() {
  runApp(new MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.pink[800],
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[800]),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[800])),
          hintStyle: TextStyle(color: Colors.pink[800])),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
