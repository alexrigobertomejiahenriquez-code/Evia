// lib/navigation/app_routes.dart

import 'package:flutter/material.dart';

import 'app_route_names.dart';
import '../screens/home/assistant_screen.dart';
import '../screens/home/placeholder_screen.dart';
import '../features/shopping/presentation/pages/shopping_page.dart';
import '../screens/search/search_screen.dart';
import '../screens/create/create_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/home/home_screen.dart';

class AppRouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    switch (name) {
      case AppRoutes.assistant:
        return MaterialPageRoute(builder: (_) => const AssistantScreen());
      case AppRoutes.shopping:
        return MaterialPageRoute(builder: (_) => const ShoppingPage());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.create:
        return MaterialPageRoute(builder: (_) => const CreateScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.placeholder:
        String title = '';
        if (args is String) {
          title = args;
        } else if (args is Map && args['title'] is String) {
          title = args['title'] as String;
        }
        return MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Ruta no encontrada')),
            body: Center(child: Text('No se encontró la ruta: ${name ?? ''}')),
          ),
        );
    }
  }
}
