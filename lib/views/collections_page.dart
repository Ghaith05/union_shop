import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/data/collection_service.dart';
import 'package:union_shop/views/collection_page.dart';

class CollectionsPage extends StatefulWidget {
  static const routeName = '/collections';

  const CollectionsPage({Key? key}) : super(key: key);

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  // Sort state: true = ascending (A → Z), false = descending (Z → A)
  bool _sortAscending = true;
  // Pagination state
  int _pageIndex = 0;
  int _pageSize = 4;
  // Filter state (search box)
  String _filter = '';

  // Fetched collections (populated from service)
  List<CollectionItem> _allCollections = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Load collections from the (tiny) service. Keep this minimal so tests
    // can pump and settle after a microtask if necessary.
    // Seed synchronously from the in-repo sample data so tests that do not
    // pumpAndSettle still see content immediately.
    _allCollections = sampleCollections;
    _loading = false;

    // Also fetch asynchronously to simulate a real service (harmless).
    fetchCollections().then((list) {
      setState(() {
        _allCollections = list;
      });
    }).catchError((e) {
      setState(() {
        _error = e.toString();
      });
    });
  }

  void _openCollection(BuildContext context, CollectionItem collection) {
    // Use a direct push with the typed object (simpler for coursework/tests)
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CollectionPage(collection: collection)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If we're still loading, show a small progress indicator.
    if (_loading) {
      return Scaffold(
        appBar: buildAppBar(context, titleWidget: const Text('Collections')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: buildAppBar(context, titleWidget: const Text('Collections')),
        body: Center(child: Text('Error loading collections: $_error')),
      );
    }

    // Prepare a sorted copy of collections according to state
    // Start from the fetched data, apply filter then sort
    final collectionsToShow = List<CollectionItem>.from(_allCollections)
        .where((c) => c.name.toLowerCase().contains(_filter.toLowerCase()))
        .toList()
      ..sort((a, b) =>
          _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));

    // Pagination calculations (computed after we have collectionsToShow)
    final totalPages =
        (collectionsToShow.length / _pageSize).ceil().clamp(1, 999);
    final clampedPageIndex = _pageIndex.clamp(0, totalPages - 1);
    final start = clampedPageIndex * _pageSize;
    final visible = collectionsToShow.skip(start).take(_pageSize).toList();

    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Collections')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filter + Sort controls (UI-only)
            Row(
              children: [
                // Filter / search box
                Expanded(
                  child: TextField(
                    key: const ValueKey('collections-filter'),
                    decoration: const InputDecoration(
                      labelText: 'Search collections',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() {
                      _filter = v;
                      _pageIndex = 0; // reset page when filtering
                    }),
                  ),
                ),
                const SizedBox(width: 12),

                // Sort dropdown
                const Text('Sort:'),
                const SizedBox(width: 8),
                DropdownButton<bool>(
                  key: const ValueKey('collections-sort'),
                  value: _sortAscending,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Name ↑')),
                    DropdownMenuItem(value: false, child: Text('Name ↓')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _sortAscending = v);
                  },
                ),
                const Spacer(),
                // (Optional) Visual hint of number of collections after filter
                Text('${collectionsToShow.length} collections'),
              ],
            ),
            const SizedBox(height: 12),

            // Grid of collections
            Expanded(
              child: GridView.builder(
                itemCount: visible.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final c = visible[index];
                  return GestureDetector(
                    key: ValueKey('collection-card-${c.id}'),
                    onTap: () => _openCollection(context, c),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // c.image may be a String or a List<String> (first image), handle both.
                          Builder(builder: (context) {
                            String? imgSrc;
                            if (c.image is String) {
                              imgSrc = c.image as String;
                            } else {
                              final list = c.image as List;
                              if (list.isNotEmpty) {
                                imgSrc = list.first as String;
                              }
                            }

                            if (imgSrc == null) {
                              return Container(color: Colors.grey[300]);
                            }

                            return Image.asset(
                              imgSrc,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey[300]),
                            );
                          }),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color.fromRGBO(0, 0, 0, 0.6)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Text(
                              c.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  key: const ValueKey('collections-page-size'),
                  value: _pageSize,
                  items: const [2, 4, 8]
                      .map((s) => DropdownMenuItem(value: s, child: Text('$s')))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _pageSize = v;
                      _pageIndex = 0; // reset page when size changes
                    });
                  },
                ),
                const SizedBox(width: 12),
                TextButton(
                  key: const ValueKey('collections-prev'),
                  onPressed: clampedPageIndex > 0
                      ? () => setState(() => _pageIndex = clampedPageIndex - 1)
                      : null,
                  child: const Text('Prev'),
                ),
                const SizedBox(width: 8),
                Text('Page ${clampedPageIndex + 1} of $totalPages'),
                const SizedBox(width: 8),
                TextButton(
                  key: const ValueKey('collections-next'),
                  onPressed: (clampedPageIndex + 1) < totalPages
                      ? () => setState(() => _pageIndex = clampedPageIndex + 1)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
