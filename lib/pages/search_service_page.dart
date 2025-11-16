import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import '../data/pet_shop_services/pet_shop_service_service.dart';
import '../data/pet_shop_services/petshop_service.dart';

class SearchServicePage extends StatefulWidget {
  const SearchServicePage({super.key});

  @override
  State<SearchServicePage> createState() => _SearchServicePageState();
}

class _SearchServicePageState extends State<SearchServicePage> {
  final Color yellow = const Color(0xFFF4E04D);
  final TextEditingController _searchController = TextEditingController();

  List<PetShopService> _allServices = [];
  List<PetShopService> _filteredServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final services = await PetShopServiceService.getAllServices();
      setState(() {
        _allServices = services;
        _filteredServices = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar serviços: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _allServices;
      } else {
        _filteredServices = _allServices
            .where((service) =>
            service.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    "Buscar Serviço",
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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadServices,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _filterServices,
                decoration: InputDecoration(
                  hintText: 'Buscar serviço...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      _filterServices('');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: _filteredServices.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchController.text.isEmpty
                            ? Icons.search
                            : Icons.search_off,
                        size: screenHeight * 0.1,
                        color: Colors.black38,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        _searchController.text.isEmpty
                            ? "Nenhum serviço disponível"
                            : "Nenhum serviço encontrado",
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        _searchController.text.isEmpty
                            ? "Arraste para baixo para atualizar"
                            : "Tente buscar por outro termo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = _filteredServices[index];
                    return _buildServiceCard(service, screenWidth, screenHeight);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(PetShopService service, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(screenWidth * 0.04),
        leading: Container(
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            color: yellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pets,
            size: screenHeight * 0.03,
            color: Colors.black87,
          ),
        ),
        title: Text(
          service.name,
          style: TextStyle(
            fontSize: screenHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          service.formattedPrice,
          style: TextStyle(
            fontSize: screenHeight * 0.018,
            color: Colors.black54,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: screenHeight * 0.02),
        onTap: () {
          // Ação ao selecionar o serviço - você pode navegar para detalhes ou agendar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Serviço: ${service.name}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}