import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Buscar',
      child: const Center(child: Text('Buscador - en desarrollo')),
    );
  }
}
