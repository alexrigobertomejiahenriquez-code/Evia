import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../navigation/app_route_names.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Crear',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.request_quote,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Genera cotizaciones profesionales con totales automáticos.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.quotes),
                icon: const Icon(Icons.add_chart),
                label: const Text('Nueva cotización'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
