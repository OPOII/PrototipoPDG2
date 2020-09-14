import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItem = [
  NavigationModel(title: "Resumen", icon: Icons.assessment),
  NavigationModel(title: "Info Excel", icon: Icons.insert_drive_file),
  NavigationModel(title: "Buscar Hacienda", icon: Icons.search),
  NavigationModel(title: "Configuración", icon: Icons.settings),
];
