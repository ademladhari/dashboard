import 'package:dashboard/screens/Manage_categories.dart';
import 'package:dashboard/screens/home_screen.dart';
import 'package:dashboard/screens/sign_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManageCategories(),
    );
  }
}
