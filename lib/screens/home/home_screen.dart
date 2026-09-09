// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../features/home/widgets/home_tile.dart';
import '../../navigation/app_route_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlaceholder(BuildContext context, String title) {
    // Si es Asistente IA, abrir la pantalla real del asistente.
    if (title == 'Asistente IA') {
      Navigator.of(context).pushNamed(AppRoutes.assistant);
      return;
    }

    // Si es Compras, abrir el ShoppingPage
    if (title == '🛒 Compras' || title == 'Compras') {
      Navigator.of(context).pushNamed(AppRoutes.shopping);
      return;
    }

    Navigator.of(context).pushNamed(AppRoutes.placeholder, arguments: title);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.smart_toy, 'title': 'Asistente IA'},
      {'icon': Icons.book, 'title': 'eBook'},
      {'icon': Icons.folder, 'title': 'Proyectos'},
      {'icon': Icons.map, 'title': 'Planos'},
      {'icon': Icons.request_quote, 'title': 'Cotizar'},
      {'icon': Icons.calendar_month, 'title': 'Agenda'},
      {'icon': Icons.insert_drive_file, 'title': 'Documentos'},
      {'icon': Icons.build, 'title': 'Herramientas'},
      {'icon': Icons.shopping_cart, 'title': '🛒 Compras'},
    ];

    return AppScaffold(
      title: 'Inicio',
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final it = items[index];
            return HomeTile(
              icon: it['icon'] as IconData,
              title: it['title'] as String,
              onTap: () => _openPlaceholder(context, it['title'] as String),
            );
          },
        ),
      ),
    );
  }
}
