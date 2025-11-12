import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E04D),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets,
                          size: MediaQuery.of(context).size.height * 0.04,
                          color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.06).clamp(18.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(menuItems: menuItems),
      backgroundColor: const Color(0xFFFBF8E1),
    );
  }
}