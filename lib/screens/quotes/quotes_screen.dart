import 'package:flutter/material.dart';

import '../../models/quote.dart';
import '../../services/quotes/quote_calculator.dart';
import '../../services/quotes/quote_repository.dart';
import '../../services/quotes/quote_repository_local.dart';
import '../../widgets/common/app_scaffold.dart';
import 'quote_form_screen.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  late final QuoteRepository _repository;
  List<Quote> _quotes = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _repository = QuoteRepositoryLocal();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() => _loading = true);
    try {
      final quotes = await _repository.getQuotes();
      setState(() => _quotes = quotes);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openForm({Quote? quote}) async {
    final result = await Navigator.of(context).push<Quote>(
      MaterialPageRoute(builder: (_) => QuoteFormScreen(quote: quote)),
    );
    if (result != null) {
      await _repository.saveQuote(result);
      await _loadQuotes();
    }
  }

  Future<void> _duplicateQuote(Quote quote) async {
    final duplicated = quote.copyWith(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: '${quote.title} (copia)',
      date: DateTime.now(),
    );
    await _repository.saveQuote(duplicated);
    await _loadQuotes();
  }

  Future<void> _deleteQuote(Quote quote) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cotización'),
        content: Text('¿Deseas eliminar "${quote.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirmed == true) {
      await _repository.deleteQuote(quote.id);
      await _loadQuotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Cotizaciones',
      actions: [
        IconButton(
          tooltip: 'Nueva cotización',
          onPressed: () => _openForm(),
          icon: const Icon(Icons.add),
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _quotes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadQuotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) => _buildQuoteCard(_quotes[index]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.request_quote, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('Sin cotizaciones guardadas', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Crear cotización'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    final totals = QuoteCalculator.calculate(quote);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: ListTile(
        onTap: () => _openForm(quote: quote),
        title: Text(quote.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${quote.client}'),
            Text('Fecha: ${_formatDate(quote.date)}'),
            Text('Total: ${_currency(totals.total)}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _openForm(quote: quote);
            } else if (value == 'duplicate') {
              _duplicateQuote(quote);
            } else if (value == 'delete') {
              _deleteQuote(quote);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(value: 'duplicate', child: Text('Duplicar')),
            PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';
}
