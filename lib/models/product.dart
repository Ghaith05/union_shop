class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? salePrice;
  final bool onSale;
  final List<String> images;
  final String collectionId;
  final String? category; // NEWflut

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.salePrice,
    this.onSale = false,
    required this.images,
    required this.collectionId,
    this.category, // NEW
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
    String? category, // NEW
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
      category: category, // NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'onSale': onSale,
      'images': images,
      'collectionId': collectionId,
      'category': category,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      salePrice: json['salePrice'] == null
          ? null
          : (json['salePrice'] as num).toDouble(),
      onSale: json['onSale'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      collectionId: json['collectionId'] as String,
      category: json['category'] as String?,
    );
  }
}
