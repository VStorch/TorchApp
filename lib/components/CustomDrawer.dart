import 'package:flutter/material.dart';
import 'MenuItem.dart';
import 'menu_item.dart';

class CustomDrawer extends StatelessWidget {
  final List<MenuItem> menuItems;

  CustomDrawer({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFE8CA42)),
              child: Center(
                child: Text(
                  "Menu",  // Título fixo
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Lista de itens do menu
          ...menuItems.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item.destinationPage),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}