class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? salePrice;
  final bool onSale;
  final List<String> images;
  final String collectionId;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.salePrice,
    this.onSale = false,
    required this.images,
    required this.collectionId,
  });

  // Simple helper for tests and sample-data initialization
  factory Product.sample({
    required String id,
    required String title,
    required String collectionId,
    double price = 9.99,
    double? salePrice,
    bool onSale = false,
    String description = '',
    List<String>? images,
  }) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      salePrice: salePrice,
      onSale: onSale,
      images: images ?? const [],
      collectionId: collectionId,
    );
  }
}
