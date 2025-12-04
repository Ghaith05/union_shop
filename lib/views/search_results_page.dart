import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/services/search_service.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _controller = TextEditingController();
  final _svc = SearchService();
  List<Product> _results = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.trim().isNotEmpty) {
      _controller.text = arg;
      _doSearch(arg);
    }
  }

  void _doSearch(String q) {
    final qTrim = q.trim();
    if (qTrim.isEmpty) {
      // Helpful UX: show all products when query is empty so users see items
      // immediately after opening the search page.
      setState(() => _results = sampleProducts);
      return;
    }

    final res = _svc.search(qTrim);
    setState(() => _results = res);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('search-input'),
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (v) => _doSearch(v),
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const ValueKey('search-button'),
                  onPressed: () => _doSearch(_controller.text),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Icon(Icons.search),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView.separated(
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, idx) {
                        final p = _results[idx];
                        return ListTile(
                          key: ValueKey('search-result-${p.id}'),
                          leading: p.images.isNotEmpty
                              ? Image.asset(p.images.first,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[300],
                                      width: 56,
                                      height: 56))
                              : Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey[300]),
                          title: Text(p.title),
                          subtitle: Text(p.description),
                          trailing: Text(
                              '£${(p.onSale && p.salePrice != null) ? p.salePrice!.toStringAsFixed(2) : p.price.toStringAsFixed(2)}'),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => ProductPage(product: p))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
