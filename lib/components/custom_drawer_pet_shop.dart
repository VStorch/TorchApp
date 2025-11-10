import 'package:flutter/material.dart';
import '../models/page_type_pet_shop.dart';
import '../models/menu_item_pet_shop.dart';

class CustomDrawerPetShop extends StatelessWidget {
  final int petShopId;
  final int userId;

  const CustomDrawerPetShop({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Cria todos os itens do menu usando o factory
    final menuItems = PageTypePetShop.values.map((type) {
      return MenuItemPetShop.fromType(
        type,
        petShopId: petShopId,
        userId: userId,
      );
    }).toList();

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
            final isLogout = item.title == 'Sair';

            return ListTile(
              leading: Icon(
                item.icon,
                color: isLogout ? Colors.red : Colors.black,
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  color: isLogout ? Colors.red : Colors.black,
                  fontSize: 16,
                  fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer

                if (isLogout) {
                  // Logout: remove todas as telas anteriores
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => item.destinationPage),
                        (route) => false,
                  );
                } else {
                  // Navegação normal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => item.destinationPage),
                  );
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}