
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final String collectionId;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.collectionId,
  });

  // Simple helper for tests and sample-data initialization
  factory Product.sample({
    required String id,
    required String title,
    required String collectionId,
    double price = 9.99,
    String description = '',
    List<String>? images,
  }) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      images: images ?? const [],
      collectionId: collectionId,
    );
  }
}
