import 'package:flutter/material.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/models/product.dart';

class CollectionsPage extends StatelessWidget {
  static const routeName = '/collections';

  const CollectionsPage({Key? key}) : super(key: key);

  void _openCollection(BuildContext context, CollectionItem collection) {
    // Use named route and pass the collection as an argument.
    Navigator.of(context).pushNamed('/collection', arguments: collection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: sampleCollections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final c = sampleCollections[index];
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
                        if (list.isNotEmpty) imgSrc = list.first as String;
                      }

                      if (imgSrc == null) {
                        return Container(color: Colors.grey[300]);
                      }

                      // Use asset images when path does not start with http
                      if (imgSrc.startsWith('http')) {
                        return Image.network(
                          imgSrc,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[300]),
                        );
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CollectionDetailPage extends StatelessWidget {
  static const routeName = '/collection';

  final CollectionItem collection;
  const CollectionDetailPage({Key? key, required this.collection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products =
        sampleProducts.where((p) => p.collectionId == collection.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(collection.name)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: products.isEmpty
            ? const Center(child: Text('No products in this collection.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final Product p = products[i];
                  return ListTile(
                    leading: p.images.isNotEmpty
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: Builder(builder: (_) {
                              final img = p.images.first;
                              if (img.startsWith('http')) {
                                return Image.network(img,
                                    width: 60, height: 60, fit: BoxFit.cover);
                              }
                              return Image.asset(img,
                                  width: 60, height: 60, fit: BoxFit.cover);
                            }),
                          )
                        : null,
                    title: Text(p.title),
                    subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                    onTap: () {
                      // For now push a simple product detail placeholder via named route if available,
                      // otherwise push a temporary page.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: Text(p.title)),
                            body: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (p.images.isNotEmpty)
                                    Builder(builder: (_) {
                                      final img = p.images.first;
                                      if (img.startsWith('http')) {
                                        return Image.network(img,
                                            height: 200, fit: BoxFit.cover);
                                      }
                                      return Image.asset(img,
                                          height: 200, fit: BoxFit.cover);
                                    }),
                                  const SizedBox(height: 12),
                                  Text(p.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 8),
                                  Text('\$${p.price.toStringAsFixed(2)}'),
                                  const SizedBox(height: 12),
                                  Text(p.description),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
