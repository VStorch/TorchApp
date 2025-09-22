import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget destinationPage;

  MenuItem({required this.title, required this.icon, required this.destinationPage});
}