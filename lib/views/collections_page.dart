import 'package:flutter/material.dart';
import 'package:union_shop/data/sample_data.dart';

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


