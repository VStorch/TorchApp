import 'package:flutter/material.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop...',
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

      // Drawer lateral
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFE8CA42),
                ),
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
            ListTile(leading: Icon(Icons.home), title: Text("Tela Inicial")),
            ListTile(leading: Icon(Icons.pets), title: Text("Meus Pets")),
            ListTile(leading: Icon(Icons.business), title: Text("PetShops favoritos")),
            ListTile(leading: Icon(Icons.calendar_month), title: Text("Meus Agendamentos")),
            ListTile(leading: Icon(Icons.local_offer), title: Text("Promoções")),
            ListTile(leading: Icon(Icons.person), title: Text("Meu Perfil")),
            ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
            ListTile(leading: Icon(Icons.logout), title: Text("Sair")),
            ListTile(leading: Icon(Icons.info), title: Text("Sobre")),
          ],
        ),
      ),

      // Corpo da tela com os agendamentos
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAppointmentCard(
              shopName: "Pet shop Realeza",
              address: "Rua Adriano Kormann",
              date: "28 /06 /2025",
              time: "14:00",
              service: "Banho + Tosa",
            ),
            const SizedBox(height: 20),
            _buildAppointmentCard(
              shopName: "Pet shop Realeza",
              address: "Rua Adriano Kormann",
              date: "28 /06 /2025",
              time: "15:00",
              service: "Banho + Tosa",
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar os cartões de agendamento
  Widget _buildAppointmentCard({
    required String shopName,
    required String address,
    required String date,
    required String time,
    required String service,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabeçalho do cartão
          Container(
            width: double.infinity,
            color: const Color(0xFFEBDD6C),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "$shopName\n$address",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Corpo do cartão
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 5),
                    Text(date),
                    const Spacer(),
                    Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text("Serviço: $service"),
                const SizedBox(height: 10),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel, size: 16),
                      label: const Text("Cancelar"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text("Reagendar"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
