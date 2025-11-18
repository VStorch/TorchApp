// lib/routes/routes.dart
import 'package:flutter/material.dart';
import '../pages/promotions_page.dart';
import '../pages/search_service_page.dart';
import '../pages/service_detail_page.dart';
import '../pages/booking_page.dart';
import '../data/pet_shop_services/petshop_service.dart';

class AppRoutes {
  static const String promotions = '/promotions';
  static const String searchService = '/search_service';
  static const String serviceDetail = '/service_detail';
  static const String booking = '/booking';
  static const String petshopDetails = '/petshop_details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case promotions:
        return MaterialPageRoute(builder: (_) => const PromotionsPage());

      case searchService:
        return MaterialPageRoute(builder: (_) => const SearchServicePage());

      case serviceDetail:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final service = args['service'] as PetShopService;
          final couponCode = args['couponCode'] as String?;

          return MaterialPageRoute(
            builder: (_) => ServiceDetailPage(
              service: service,
              preFilledCouponCode: couponCode,
            ),
          );
        }
        return _errorRoute('Argumentos inválidos para ServiceDetailPage');

      case booking:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final service = args['service'] as PetShopService;
          final petShopId = args['petShopId'] as int;
          final couponCode = args['couponCode'] as String?;

          return MaterialPageRoute(
            builder: (_) => BookingPage(
              service: service,
              petShopId: petShopId,
              preFilledCouponCode: couponCode,
            ),
          );
        }
        return _errorRoute('Argumentos inválidos para BookingPage');

      case petshopDetails:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final petShopId = args['petShopId'] as int;
          final couponCode = args['couponCode'] as String?;

          // Esta rota precisa navegar para a página de busca/lista de serviços do pet shop
          // Por enquanto, redireciona para searchService
          return MaterialPageRoute(
            builder: (_) => SearchServicePage(
              petShopId: petShopId,
              preFilledCouponCode: couponCode,
            ),
          );
        }
        return _errorRoute('Argumentos inválidos para PetShop Details');

      default:
        return _errorRoute('Rota não encontrada: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(_).pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}