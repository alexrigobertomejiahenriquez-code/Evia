import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../models/quote.dart';
import '../../services/projects/project_service.dart';
import '../../services/quotes/quote_calculator.dart';
import '../../widgets/common/app_scaffold.dart';

class QuoteFormScreen extends StatefulWidget {
  final Quote? quote;

  const QuoteFormScreen({super.key, this.quote});

  @override
  State<QuoteFormScreen> createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _clientCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _laborCtrl;
  late final TextEditingController _otherCostsCtrl;
  late final TextEditingController _discountCtrl;
  late final TextEditingController _taxCtrl;
  late final TextEditingController _budgetCtrl;

  late final ProjectService _projectService;

  DateTime _date = DateTime.now();
  List<QuoteItem> _items = [];
  List<Project> _projects = [];
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    final quote = widget.quote;

    _titleCtrl = TextEditingController(text: quote?.title ?? '');
    _clientCtrl = TextEditingController(text: quote?.client ?? '');
    _descriptionCtrl =
        TextEditingController(text: quote?.workDescription ?? '');
    _laborCtrl = TextEditingController(text: _toInput(quote?.laborCost ?? 0));
    _otherCostsCtrl =
        TextEditingController(text: _toInput(quote?.otherCosts ?? 0));
    _discountCtrl = TextEditingController(text: _toInput(quote?.discount ?? 0));
    _taxCtrl = TextEditingController(text: _toInput(quote?.taxPercent ?? 0));
    _budgetCtrl = TextEditingController(
        text:
            quote?.targetBudget == null ? '' : _toInput(quote!.targetBudget!));

    _date = quote?.date ?? DateTime.now();
    _items = List<QuoteItem>.from(quote?.items ?? const []);
    _selectedProjectId = quote?.projectId;

    for (final controller in [
      _titleCtrl,
      _clientCtrl,
      _descriptionCtrl,
      _laborCtrl,
      _otherCostsCtrl,
      _discountCtrl,
      _taxCtrl,
      _budgetCtrl
    ]) {
      controller.addListener(_onInputChanged);
    }

    _projectService = MockProjectService();
    _loadProjects();
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadProjects() async {
    final projects = await _projectService.getAllProjects();
    if (!mounted) return;
    setState(() {
      _projects = projects;
      if (_selectedProjectId != null &&
          !_projects.any((p) => p.id == _selectedProjectId)) {
        _selectedProjectId = null;
      }
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _titleCtrl,
      _clientCtrl,
      _descriptionCtrl,
      _laborCtrl,
      _otherCostsCtrl,
      _discountCtrl,
      _taxCtrl,
      _budgetCtrl
    ]) {
      controller.removeListener(_onInputChanged);
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _addOrEditItem({QuoteItem? item}) async {
    final descriptionCtrl =
        TextEditingController(text: item?.description ?? '');
    final quantityCtrl =
        TextEditingController(text: _toInput(item?.quantity ?? 1));
    final unitCtrl = TextEditingController(text: item?.unit ?? 'und');
    final unitPriceCtrl =
        TextEditingController(text: _toInput(item?.unitPrice ?? 0));

    final result = await showDialog<QuoteItem>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'Nueva línea' : 'Editar línea'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: unitCtrl,
                decoration: const InputDecoration(labelText: 'Unidad'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: unitPriceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Precio unitario'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final description = descriptionCtrl.text.trim();
              final quantity = _parseNumber(quantityCtrl.text);
              final unit = unitCtrl.text.trim();
              final unitPrice = _parseNumber(unitPriceCtrl.text);

              if (description.isEmpty || quantity <= 0 || unitPrice < 0) {
                return;
              }

              final edited = QuoteItem(
                id: item?.id ??
                    DateTime.now().microsecondsSinceEpoch.toString(),
                description: description,
                quantity: quantity,
                unit: unit.isEmpty ? 'und' : unit,
                unitPrice: unitPrice,
              );
              Navigator.pop(ctx, edited);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    descriptionCtrl.dispose();
    quantityCtrl.dispose();
    unitCtrl.dispose();
    unitPriceCtrl.dispose();

    if (result == null) return;

    setState(() {
      final idx = _items.indexWhere((i) => i.id == result.id);
      if (idx >= 0) {
        _items[idx] = result;
      } else {
        _items.add(result);
      }
    });
  }

  void _removeItem(String itemId) {
    setState(() => _items.removeWhere((i) => i.id == itemId));
  }

  void _saveQuote() {
    if (_titleCtrl.text.trim().isEmpty || _clientCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y cliente son obligatorios')),
      );
      return;
    }

    final project = _selectedProject();

    final quote = Quote(
      id: widget.quote?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      client: _clientCtrl.text.trim(),
      date: _date,
      workDescription: _descriptionCtrl.text.trim(),
      items: _items,
      laborCost: _parseNumber(_laborCtrl.text),
      otherCosts: _parseNumber(_otherCostsCtrl.text),
      discount: _parseNumber(_discountCtrl.text),
      taxPercent: _parseNumber(_taxCtrl.text),
      targetBudget: _budgetCtrl.text.trim().isEmpty
          ? null
          : _parseNumber(_budgetCtrl.text),
      projectId: _selectedProjectId,
      projectName: project?.name,
    );

    Navigator.pop(context, quote);
  }

  @override
  Widget build(BuildContext context) {
    final quote = _buildPreviewQuote();
    final totals = QuoteCalculator.calculate(quote);

    return AppScaffold(
      title: widget.quote == null ? 'Nueva cotización' : 'Editar cotización',
      actions: [
        IconButton(
            onPressed: _saveQuote,
            icon: const Icon(Icons.check),
            tooltip: 'Guardar'),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Título / nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _clientCtrl,
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: 'Descripción del trabajo'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Fecha: ${_formatDate(_date)}'),
              trailing: TextButton(
                  onPressed: _selectDate, child: const Text('Seleccionar')),
            ),
            DropdownButtonFormField<String?>(
              initialValue: _selectedProjectId,
              decoration:
                  const InputDecoration(labelText: 'Proyecto (opcional)'),
              items: [
                const DropdownMenuItem<String?>(
                    value: null, child: Text('Sin proyecto')),
                ..._projects.map<DropdownMenuItem<String?>>(
                  (project) => DropdownMenuItem<String?>(
                    value: project.id,
                    child: Text(project.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _selectedProjectId = value),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: Text('Materiales / productos',
                        style: Theme.of(context).textTheme.titleMedium)),
                TextButton.icon(
                  onPressed: () => _addOrEditItem(),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                )
              ],
            ),
            const SizedBox(height: 8),
            if (_items.isEmpty)
              const Text('Sin líneas agregadas')
            else
              ..._items.map((item) => _buildItemCard(item)),
            const SizedBox(height: 20),
            TextField(
              controller: _laborCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Mano de obra'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otherCostsCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Otros costos'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _discountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Descuento'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taxCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Impuesto (%)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Presupuesto objetivo (opcional)'),
            ),
            const SizedBox(height: 20),
            _buildSummaryCard(totals),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveQuote,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cotización'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(QuoteItem item) {
    final lineTotal = QuoteCalculator.fromCents(
      ((item.quantity * 1000).round() *
              QuoteCalculator.toCents(item.unitPrice) /
              1000)
          .round(),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.description),
        subtitle: Text(
            '${item.quantity} ${item.unit} x ${_currency(item.unitPrice)} = ${_currency(lineTotal)}'),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
                onPressed: () => _addOrEditItem(item: item),
                icon: const Icon(Icons.edit),
                tooltip: 'Editar'),
            IconButton(
                onPressed: () => _removeItem(item.id),
                icon: const Icon(Icons.delete),
                tooltip: 'Eliminar'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(QuoteTotals totals) {
    final diff = totals.budgetDifference;
    Color statusColor;
    switch (totals.budgetStatus) {
      case BudgetStatus.withinBudget:
        statusColor = Colors.green;
        break;
      case BudgetStatus.available:
        statusColor = Colors.blue;
        break;
      case BudgetStatus.overBudget:
        statusColor = Colors.red;
        break;
      case BudgetStatus.notSet:
        statusColor = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _summaryLine(
                'Subtotal materiales', _currency(totals.itemsSubtotal)),
            _summaryLine('Mano de obra', _currency(totals.laborCost)),
            _summaryLine('Otros costos', _currency(totals.otherCosts)),
            _summaryLine('Descuento', '-${_currency(totals.discount)}'),
            _summaryLine('Impuesto', _currency(totals.tax)),
            const Divider(),
            _summaryLine('Total', _currency(totals.total), isBold: true),
            const SizedBox(height: 8),
            _summaryLine(
                'Presupuesto objetivo',
                totals.targetBudget == null
                    ? 'No definido'
                    : _currency(totals.targetBudget!)),
            _summaryLine(
                'Diferencia', diff == null ? '—' : _currency(diff.abs())),
            Text(
              'Estado: ${totals.budgetStatusLabel}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryLine(String label, String value, {bool isBold = false}) {
    final style = isBold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }

  Quote _buildPreviewQuote() {
    final project = _selectedProject();
    return Quote(
      id: widget.quote?.id ?? '',
      title: _titleCtrl.text.trim(),
      client: _clientCtrl.text.trim(),
      date: _date,
      workDescription: _descriptionCtrl.text.trim(),
      items: _items,
      laborCost: _parseNumber(_laborCtrl.text),
      otherCosts: _parseNumber(_otherCostsCtrl.text),
      discount: _parseNumber(_discountCtrl.text),
      taxPercent: _parseNumber(_taxCtrl.text),
      targetBudget: _budgetCtrl.text.trim().isEmpty
          ? null
          : _parseNumber(_budgetCtrl.text),
      projectId: _selectedProjectId,
      projectName: project?.name,
    );
  }

  double _parseNumber(String input) {
    final sanitized = input.trim().replaceAll(',', '.');
    final value = double.tryParse(sanitized);
    if (value == null || !value.isFinite) return 0;
    return value;
  }

  String _toInput(double value) {
    if (value == 0) return '0';
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';

  Project? _selectedProject() {
    for (final project in _projects) {
      if (project.id == _selectedProjectId) return project;
    }
    return null;
  }
}
