import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Crear',
      child: const Center(child: Text('Crear contenido - en desarrollo')),
    );
  }
}
