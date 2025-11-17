import 'package:flutter/material.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import 'custom_drawer.dart';

class PageScaffold extends StatelessWidget {
  final PageType pageType;
  final Widget body;

  const PageScaffold({
    Key? key,
    required this.pageType,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<MenuItem> allMenuItems = [
      MenuItem.fromType(PageType.home),
      MenuItem.fromType(PageType.myPets),
      MenuItem.fromType(PageType.appointments),
      MenuItem.fromType(PageType.promotions),
      MenuItem.fromType(PageType.profile),
      MenuItem.fromType(PageType.settings),
      MenuItem.fromType(PageType.login),
      MenuItem.fromType(PageType.about),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.pets),
            iconSize: 35,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(menuItems: allMenuItems),
      body: body,
    );
  }
}