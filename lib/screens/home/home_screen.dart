import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import 'widgets/home_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)));
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

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$title - Módulo en desarrollo',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
