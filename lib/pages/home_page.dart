import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class HomePage extends StatefulWidget {
  final int? userId;
  final String? userName;

  const HomePage({super.key, this.userId, this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<AnimationController> _pawControllers;
  late List<Animation<double>> _pawAnimations;
  String userName = 'Usuário';

  @override
  void initState() {
    super.initState();
    _initializePawAnimations();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    // Prioridade 1: Se veio pelo construtor
    if (widget.userName != null && widget.userName!.isNotEmpty) {
      if (mounted) {
        setState(() {
          userName = widget.userName!;
        });
      }
      return;
    }

    // Prioridade 2: Busca do SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');

      if (savedName != null && savedName.isNotEmpty && mounted) {
        setState(() {
          userName = savedName;
        });
      }
    } catch (e) {
      print('Erro ao carregar nome: $e');
    }
  }

  void _initializePawAnimations() {
    _pawControllers = List.generate(
      12,
          (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 100)),
        vsync: this,
      ),
    );

    _pawAnimations = _pawControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    for (int i = 0; i < _pawControllers.length; i++) {
      int reversedIndex = _pawControllers.length - 1 - i;
      Future.delayed(Duration(milliseconds: reversedIndex * 150), () {
        if (mounted) {
          _pawControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _pawControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final barHeight = screenHeight * 0.06;

    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(
      type,
      currentUserId: widget.userId,
      currentUserName: widget.userName,
    ))
        .toList();

    return Scaffold(
      drawer: CustomDrawer(menuItems: menuItems),
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFEBDD6C),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.pets, size: screenWidth * 0.08),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Olá, $userName!',
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.08),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              Align(
                alignment: Alignment(0.0, -0.80),
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      'Repetir o último serviço',
                      style: TextStyle(fontSize: isTablet ? 20 : 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ..._buildAnimatedPaws(width, height),
              Align(
                alignment: const Alignment(0, 0.0),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/Gato bugado.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.05, 0.4),
                child: FractionallySizedBox(
                  widthFactor: 0.35,
                  child: Image.asset(
                    'lib/assets/images/torchapp.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBDD6C),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildAnimatedPaws(double width, double height) {
    final pawsData = [
      [0.12, 0.90, 55.0],
      [0.17, 0.74, 45.0],
      [0.25, 0.60, 50.0],
      [0.29, 0.38, 60.0],
      [0.33, 0.17, 50.0],
      [0.42, 0.12, 30.0],
      [0.52, 0.07, 0.0],
      [0.62, 0.15, -10.0],
      [0.71, 0.22, -40.0],
      [0.78, 0.355, -50.0],
      [0.82, 0.50, -55.0],
      [0.88, 0.62, -54.0],
    ];

    return List.generate(pawsData.length, (index) {
      final data = pawsData[index];
      double top = data[0] * height;
      double left = data[1] * width;
      double rotation = data[2];
      double size = width * 0.08;

      return Positioned(
        top: top,
        left: left,
        child: AnimatedBuilder(
          animation: _pawAnimations[index],
          builder: (context, child) {
            final scale = 0.8 + (_pawAnimations[index].value * 0.4);
            final opacity = 0.6 + (_pawAnimations[index].value * 0.4);

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: rotation * (math.pi / 180),
                  child: Image.asset(
                    'lib/assets/images/pata de cachorro.png',
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}