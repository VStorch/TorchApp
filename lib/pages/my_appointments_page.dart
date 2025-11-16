import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  final Color yellow = const Color(0xFFF4E04D);

  final List<Map<String, String>> appointments = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final barHeight = screenHeight * 0.07;
    final iconSize = barHeight * 0.6;
    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      drawer: CustomDrawer(menuItems: menuItems),

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
                    "Meus Agendamentos",
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

      body: appointments.isEmpty
          ? Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: screenHeight * 0.1,
                color: Colors.black38,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Nenhum agendamento",
                style: TextStyle(
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Seus agendamentos aparecerão aqui",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment, screenWidth, screenHeight);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      Map<String, String> appointment, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.008),
            color: yellow,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: screenHeight * 0.025),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  child: Text(
                    "${appointment['shopName']}\n${appointment['address']}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: screenHeight * 0.02),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      appointment['date']!,
                      style: TextStyle(fontSize: screenHeight * 0.02),
                    ),
                    Spacer(),
                    Text(
                      appointment['time']!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight * 0.02),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Serviço: ${appointment['service']}",
                  style: TextStyle(fontSize: screenHeight * 0.02),
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.cancel, size: screenHeight * 0.02),
                      label: Text("Cancelar", style: TextStyle(fontSize: screenHeight * 0.018)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.refresh, size: screenHeight * 0.02),
                      label: Text("Reagendar", style: TextStyle(fontSize: screenHeight * 0.018)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
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