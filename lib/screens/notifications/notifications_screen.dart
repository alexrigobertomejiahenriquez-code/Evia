import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Avisos',
      child: const Center(child: Text('Avisos y recordatorios - en desarrollo')),
    );
  }
}
