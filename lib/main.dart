import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_links/app_links.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages/reset_password_page.dart';
import 'package:torch_app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // Escutar deep links enquanto o app estiver rodando
    _appLinks.uriLinkStream.listen((uri) {
      print('Deep link recebido globalmente: $uri');
      _handleDeepLink(uri);
    }, onError: (err) {
      print('Erro ao processar deep link: $err');
    });

    // Verificar se o app foi aberto por um deep link
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        print('🔗 Deep link inicial: $uri');
        // Aguardar app estar pronto antes de navegar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _handleDeepLink(uri);
          });
        });
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    final token = uri.queryParameters['token'];
    final email = uri.queryParameters['email'];
    final couponCode = uri.queryParameters['coupon'];
    final petShopId = uri.queryParameters['petshop_id'];

    // ← TRATAMENTO PARA RESET DE SENHA
    if (uri.host == 'reset-password' && token != null && email != null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(
            email: email,
            prefilledCode: token,
          ),
        ),
            (route) => false,
      );
    }
    // ← TRATAMENTO PARA PROMOÇÕES
    else if (uri.host == 'promotions' || uri.path.contains('/promotions')) {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.promotions,
      );
    }
    // ← TRATAMENTO PARA DETALHES DO PETSHOP
    else if (uri.host == 'petshop' && petShopId != null) {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.petshopDetails,
        arguments: {
          'petShopId': int.tryParse(petShopId) ?? 0,
          'couponCode': couponCode,
        },
      );
    }
    // ← TRATAMENTO PARA BUSCA DE SERVIÇOS
    else if (uri.host == 'search' || uri.path.contains('/search')) {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.searchService,
      );
    }
    else {
      print('Deep link não reconhecido: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,

      // ← GERADOR DE ROTAS ADICIONADO
      onGenerateRoute: AppRoutes.generateRoute,

      // Suporte à localização (português Brasil)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      // Página inicial
      home: const LoadingPage(),
    );
  }
}