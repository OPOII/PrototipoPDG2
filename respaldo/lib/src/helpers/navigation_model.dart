import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItem = [
  NavigationModel(title: "Settings", icon: Icons.settings),
  NavigationModel(title: "Profile", icon: Icons.person),
  NavigationModel(title: "Dashboard", icon: Icons.insert_chart),
  NavigationModel(title: "Dashboard", icon: Icons.insert_chart),
];
