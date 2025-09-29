import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class CustomDrawer extends StatelessWidget {
  final List<MenuItem> menuItems;

  const CustomDrawer({required this.menuItems, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFEBDD6C),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFE8CA42)),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ...menuItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.destinationPage),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}