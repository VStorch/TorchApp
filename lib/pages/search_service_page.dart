import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import '../data/pet_shop_services/pet_shop_service_service.dart';
import '../data/pet_shop_services/petshop_service.dart';
import '../data/pet_shop/pet_shop_information_service.dart';
import 'service_detail_page.dart';

class SearchServicePage extends StatefulWidget {
  final int? petShopId; // ← NOVO: Filtrar por pet shop específico
  final String? preFilledCouponCode; // ← NOVO: Cupom para passar adiante

  const SearchServicePage({
    super.key,
    this.petShopId,
    this.preFilledCouponCode,
  });

  @override
  State<SearchServicePage> createState() => _SearchServicePageState();
}

class _SearchServicePageState extends State<SearchServicePage> {
  final Color yellow = const Color(0xFFF4E04D);
  final Color bgColor = const Color(0xFFFBF8E1);
  final TextEditingController _searchController = TextEditingController();

  List<PetShopService> _allServices = [];
  List<PetShopService> _filteredServices = [];
  bool _isLoading = true;

  String _selectedCategory = 'Todos';
  String _sortBy = 'name';

  final List<String> _categories = [
    'Todos',
    'Banho',
    'Tosa',
    'Creche',
    'Outro',
  ];

  Map<String, String> _petShopNames = {};
  final PetShopInformationService _petShopService = PetShopInformationService();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final services = await PetShopServiceService.getAllServices();

      // ← NOVO: Filtrar por pet shop se especificado
      final filteredByPetShop = widget.petShopId != null
          ? services.where((s) => s.petShopId == widget.petShopId).toList()
          : services;

      await _loadPetShopNames(filteredByPetShop);

      setState(() {
        _allServices = filteredByPetShop;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar serviços: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadPetShopNames(List<PetShopService> services) async {
    final uniquePetShopIds = services.map((s) => s.petShopId).toSet();

    for (var petShopId in uniquePetShopIds) {
      try {
        final response = await _petShopService.getPetShopInformationById(petShopId);

        Map<String, dynamic>? data;
        if (response.containsKey('data') && response['data'] != null) {
          data = response['data'] as Map<String, dynamic>;
        } else {
          data = response;
        }
      
        if (data['name'] != null) {
          _petShopNames[petShopId.toString()] = data['name'].toString();
        } else {
          _petShopNames[petShopId.toString()] = 'Pet Shop $petShopId';
        }
      } catch (e) {
        print('Erro ao carregar nome do Pet Shop $petShopId: $e');
        _petShopNames[petShopId.toString()] = 'Pet Shop $petShopId';
      }
    }
  }

  void _applyFilters() {
    List<PetShopService> filtered = _allServices;

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((service) =>
          service.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    if (_selectedCategory != 'Todos') {
      filtered = filtered
          .where((service) =>
          service.name.toLowerCase().contains(_selectedCategory.toLowerCase()))
          .toList();
    }

    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    setState(() {
      _filteredServices = filtered;
    });
  }

  Map<String, List<PetShopService>> _groupByPetShop() {
    Map<String, List<PetShopService>> grouped = {};

    for (var service in _filteredServices) {
      String petShopName = _petShopNames[service.petShopId.toString()] ?? 'Pet Shop ${service.petShopId}';

      if (!grouped.containsKey(petShopName)) {
        grouped[petShopName] = [];
      }
      grouped[petShopName]!.add(service);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final menuItems = PageType.values.map((type) => MenuItem.fromType(type)).toList();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: CustomDrawer(menuItems: menuItems),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: yellow,
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
                    widget.petShopId != null ? "Serviços do Pet Shop" : "Buscar Serviço",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.06).clamp(18.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -6,
                  bottom: 0,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.sort, size: screenHeight * 0.03, color: Colors.black),
                    onSelected: (value) {
                      setState(() {
                        _sortBy = value;
                        _applyFilters();
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'name',
                        child: Row(
                          children: [
                            Icon(Icons.sort_by_alpha,
                                color: _sortBy == 'name' ? yellow : Colors.black54),
                            const SizedBox(width: 8),
                            Text('Nome A-Z'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'price_asc',
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward,
                                color: _sortBy == 'price_asc' ? yellow : Colors.black54),
                            const SizedBox(width: 8),
                            Text('Menor Preço'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'price_desc',
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward,
                                color: _sortBy == 'price_desc' ? yellow : Colors.black54),
                            const SizedBox(width: 8),
                            Text('Maior Preço'),
                          ],
                        ),
                      ),
                    ],
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
        child: Column(
          children: [
            // ← NOVO: Mostrar badge de cupom se presente
            if (widget.preFilledCouponCode != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[50]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[700]!, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.confirmation_number,
                        color: Colors.green[700],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cupom Ativo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.preFilledCouponCode!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 32,
                    ),
                  ],
                ),
              ),

            // Campo de busca
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _applyFilters(),
                decoration: InputDecoration(
                  hintText: 'Buscar serviço...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
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
            ),

            // Chips de Categorias
            SizedBox(
              height: screenHeight * 0.06,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _applyFilters();
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: yellow,
                      checkmarkColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.black54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? Colors.black : Colors.black38,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Lista de Serviços Agrupados
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
                  : _buildGroupedServicesList(screenWidth, screenHeight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedServicesList(double screenWidth, double screenHeight) {
    final grouped = _groupByPetShop();
    final petShops = grouped.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: petShops.length,
      itemBuilder: (context, index) {
        final petShopName = petShops[index];
        final services = grouped[petShopName]!;

        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: yellow.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: yellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Icon(
                        Icons.store,
                        size: screenHeight * 0.025,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            petShopName,
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${services.length} serviço${services.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: screenHeight * 0.016,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ...services.map((service) => _buildServiceItem(service, screenWidth, screenHeight)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(PetShopService service, double screenWidth, double screenHeight) {
    return InkWell(
      onTap: () {
        // ← ATUALIZADO: Passa o cupom para a próxima página
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(
              service: service,
              preFilledCouponCode: widget.preFilledCouponCode,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.pets,
                size: screenHeight * 0.025,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    service.formattedPrice,
                    style: TextStyle(
                      fontSize: screenHeight * 0.018,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenHeight * 0.02,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}