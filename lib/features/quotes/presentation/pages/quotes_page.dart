import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../widgets/common/app_scaffold.dart';
import '../../data/quote_repository_local.dart';
import '../../domain/models/quote_draft.dart';
import '../../domain/models/quote_line_item.dart';
import '../../domain/repositories/quote_repository.dart';

class QuotesPage extends StatefulWidget {
  final QuoteRepository? repository;

  const QuotesPage({super.key, this.repository});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  static const _categories = [
    'Producto',
    'Material',
    'Servicio',
    'Mano de obra',
  ];

  late final QuoteRepository _repository;
  final _titleController = TextEditingController();
  final _customerController = TextEditingController();
  final _notesController = TextEditingController();
  final _discountController = TextEditingController();
  final _budgetController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1');
  final _itemPriceController = TextEditingController();

  String _selectedCategory = _categories.first;
  List<QuoteLineItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? QuoteRepositoryLocal();
    _loadDraft();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customerController.dispose();
    _notesController.dispose();
    _discountController.dispose();
    _budgetController.dispose();
    _itemDescriptionController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadDraft() async {
    final draft = await _repository.getDraft();
    if (!mounted) return;

    setState(() {
      _titleController.text = draft.title;
      _customerController.text = draft.customerName;
      _notesController.text = draft.notes;
      _discountController.text = _displayNumber(draft.discountPercent);
      _budgetController.text =
          draft.targetBudget == 0 ? '' : _displayNumber(draft.targetBudget);
      _items = List<QuoteLineItem>.from(draft.items);
      _loading = false;
    });
  }

  QuoteDraft get _currentDraft {
    final discount = _parseNumber(_discountController.text).clamp(0, 100);
    final budget = _parseNumber(_budgetController.text);

    return QuoteDraft(
      title: _titleController.text.trim().isEmpty
          ? 'Cotización general'
          : _titleController.text.trim(),
      customerName: _customerController.text.trim(),
      notes: _notesController.text.trim(),
      discountPercent: discount.toDouble(),
      targetBudget: budget < 0 ? 0 : budget,
      items: List<QuoteLineItem>.unmodifiable(_items),
    );
  }

  Future<void> _persistDraft() {
    return _repository.saveDraft(_currentDraft);
  }

  double _parseNumber(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;
  }

  String _displayNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';

  Future<void> _addItem() async {
    final description = _itemDescriptionController.text.trim();
    final quantity = _parseNumber(_itemQuantityController.text);
    final unitPrice = _parseNumber(_itemPriceController.text);

    if (description.isEmpty || quantity <= 0 || unitPrice < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa una descripción, cantidad válida y precio.'),
        ),
      );
      return;
    }

    setState(() {
      _items = [
        ..._items,
        QuoteLineItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          category: _selectedCategory,
          description: description,
          quantity: quantity,
          unitPrice: unitPrice,
        ),
      ];
      _itemDescriptionController.clear();
      _itemQuantityController.text = '1';
      _itemPriceController.clear();
    });

    await _persistDraft();
  }

  Future<void> _removeItem(String id) async {
    setState(() {
      _items = _items.where((item) => item.id != id).toList();
    });
    await _persistDraft();
  }

  Future<void> _clearDraft() async {
    await _repository.clearDraft();
    setState(() {
      _titleController.text = 'Cotización general';
      _customerController.clear();
      _notesController.clear();
      _discountController.text = '0';
      _budgetController.clear();
      _itemDescriptionController.clear();
      _itemQuantityController.text = '1';
      _itemPriceController.clear();
      _selectedCategory = _categories.first;
      _items = [];
    });
  }

  String _buildExportText(QuoteDraft draft) {
    final buffer = StringBuffer()
      ..writeln(draft.title)
      ..writeln('Cliente: ${draft.customerName.isEmpty ? 'Sin asignar' : draft.customerName}')
      ..writeln('');

    for (final item in draft.items) {
      buffer.writeln(
        '- ${item.category}: ${item.description} · ${_displayNumber(item.quantity)} x ${_currency(item.unitPrice)} = ${_currency(item.subtotal)}',
      );
    }

    buffer
      ..writeln('')
      ..writeln('Subtotal: ${_currency(draft.subtotal)}')
      ..writeln('Descuento: ${draft.discountPercent.toStringAsFixed(1)}% (${_currency(draft.discountAmount)})')
      ..writeln('Total: ${_currency(draft.total)}');

    if (draft.targetBudget > 0) {
      buffer.writeln('Presupuesto objetivo: ${_currency(draft.targetBudget)}');
      buffer.writeln(
        draft.remainingBudget >= 0
            ? 'Margen disponible: ${_currency(draft.remainingBudget)}'
            : 'Exceso sobre presupuesto: ${_currency(draft.remainingBudget.abs())}',
      );
    }

    if (draft.notes.isNotEmpty) {
      buffer
        ..writeln('')
        ..writeln('Notas:')
        ..writeln(draft.notes);
    }

    return buffer.toString().trim();
  }

  Future<void> _showExportPreview() async {
    final draft = _currentDraft;
    final exportText = _buildExportText(draft);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vista previa de cotización'),
          content: SingleChildScrollView(
            child: SelectableText(exportText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: exportText));
                if (!context.mounted) return;
                Navigator.of(context).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Cotización copiada al portapapeles.'),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = _currentDraft;

    return AppScaffold(
      title: 'Cotizaciones',
      actions: [
        IconButton(
          tooltip: 'Limpiar borrador',
          onPressed: _loading ? null : _clearDraft,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDetailsCard(context),
                const SizedBox(height: 16),
                _buildAddItemCard(context),
                const SizedBox(height: 16),
                _buildItemsCard(context),
                const SizedBox(height: 16),
                _buildSummaryCard(context, draft),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: draft.items.isEmpty ? null : _showExportPreview,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Exportar resumen'),
                ),
              ],
            ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos de la cotización', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. Reforma integral de cocina',
              ),
              onChanged: (_) {
                setState(() {});
                _persistDraft();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customerController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                hintText: 'Nombre del cliente o proyecto',
              ),
              onChanged: (_) => _persistDraft(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notas',
                hintText: 'Alcance, condiciones o detalles importantes',
              ),
              onChanged: (_) => _persistDraft(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar productos, materiales o servicios', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: _categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _itemDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej. Cerámica antideslizante',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemQuantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _itemPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Precio unitario'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Agregar línea'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Partidas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_items.isEmpty)
              Text(
                'Todavía no has agregado líneas a esta cotización.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ..._items.map(
                (item) => ListTile(
                  contentPadding: const EdgeInsets.zero,
                  title: Text(item.description),
                  subtitle: Text(
                    '${item.category} · ${_displayNumber(item.quantity)} x ${_currency(item.unitPrice)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_currency(item.subtotal)),
                      IconButton(
                        tooltip: 'Eliminar línea',
                        onPressed: () => _removeItem(item.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, QuoteDraft draft) {
    final isOverBudget = draft.targetBudget > 0 && draft.remainingBudget < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen y presupuesto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Descuento (%)',
              ),
              onChanged: (_) {
                setState(() {});
                _persistDraft();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Presupuesto objetivo',
              ),
              onChanged: (_) {
                setState(() {});
                _persistDraft();
              },
            ),
            const SizedBox(height: 16),
            _SummaryRow(label: 'Subtotal', value: _currency(draft.subtotal)),
            _SummaryRow(
              label: 'Descuento',
              value: '${draft.discountPercent.toStringAsFixed(1)}% · ${_currency(draft.discountAmount)}',
            ),
            const Divider(),
            _SummaryRow(
              label: 'Total',
              value: _currency(draft.total),
              emphasize: true,
            ),
            if (draft.targetBudget > 0) ...[
              const SizedBox(height: 12),
              _SummaryRow(
                label: isOverBudget ? 'Exceso' : 'Margen disponible',
                value: _currency(draft.remainingBudget.abs()),
                valueColor: isOverBudget ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            value,
            style: style?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
