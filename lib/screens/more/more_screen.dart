import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Más',
      child: const Center(child: Text('Más opciones - en desarrollo')),
    );
  }
}
