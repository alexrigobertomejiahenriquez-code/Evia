import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import 'search_service.dart';
import 'search_model.dart';
import '../home/assistant_screen.dart';
import '../home/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final MockSearchService _service = MockSearchService();
  List<SearchResult> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    final query = q.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
    });
    final res = await _service.query(query);
    setState(() {
      _results = res;
      _loading = false;
    });
  }

  void _clear() {
    _ctrl.clear();
    setState(() {
      _results = [];
      _loading = false;
    });
  }

  Map<String, List<SearchResult>> _groupByCategory() {
    final Map<String, List<SearchResult>> map = {};
    for (final r in _results) {
      map.putIfAbsent(r.category, () => []).add(r);
    }
    return map;
  }

  void _openResult(SearchResult r) {
    // For known routes, navigate to the real screen when implemented.
    if (r.route == 'assistant') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssistantScreen()));
      return;
    }

    // Otherwise open PlaceholderScreen with title
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceholderScreen(title: r.title)));
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCategory();

    return AppScaffold(
      title: 'Buscar',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _search,
                    decoration: InputDecoration(
                      hintText: 'Buscar en EVIA...',
                      border: const OutlineInputBorder(),
                      suffixIcon: _ctrl.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clear,
                            ),
                    ),
                    onChanged: (v) {
                      setState(() {}); // to update clear button
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : () => _search(_ctrl.text),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildBody(grouped),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Map<String, List<SearchResult>> grouped) {
    if (_ctrl.text.trim().isEmpty && !_loading) {
      return Center(
        child: Text(
          'Escribe algo para buscar en EVIA\n(por ejemplo: Asistente IA, eBook, Proyectos...)',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'Sin resultados',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final categories = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final items = grouped[cat]!;
        return _buildCategorySection(cat, items);
      },
    );
  }

  Widget _buildCategorySection(String category, List<SearchResult> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...items.map((r) => Card(
              child: ListTile(
                title: Text(r.title),
                subtitle: Text(r.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openResult(r),
              ),
            )),
      ],
    );
  }
}
