import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      child: Center(
        child: Text(
          '$title - en desarrollo',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
