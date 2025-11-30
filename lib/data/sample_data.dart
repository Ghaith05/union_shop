import 'package:union_shop/models/product.dart';

class CollectionItem {
  final String id;
  final String name;
  final List<String> image;

  CollectionItem({required this.id, required this.name, required this.image});
}

final List<CollectionItem> sampleCollections = [
  CollectionItem(
    id: 'c1',
    name: 'New Arrivals',
    image: ['assets/images/collections/new_arrivals.png'],
  ),
  CollectionItem(
    id: 'c2',
    name: 'Best Sellers',
    image: ['assets/images/collections/best_selling.png'],
  ),
  CollectionItem(
    id: 'c3',
    name: 'Sale',
    image: ['assets/images/collections/Sale.png'],
  ),
];

final List<Product> sampleProducts = [
  Product.sample(
    id: 'p1',
    title: 'Union T-Shirt',
    collectionId: 'c1',
    price: 19.99,
    images: ['assets/images/products/union_t-shirt.png'],
    description: 'Comfortable shop tee.',
  ),
  Product.sample(
    id: 'p2',
    title: 'Union Hoodie',
    collectionId: 'c2',
    price: 39.99,
    images: ['assets/images/products/union_hoodie.png'],
    description: 'Warm hoodie.',
  ),
  Product.sample(
    id: 'p3',
    title: 'Sticker Pack',
    collectionId: 'c1',
    price: 4.99,
    images: ['assets/images/products/union_stickers.png'],
    description: 'Sticker set.',
    category: 'Accessories', // NEW
  ),
  // Sale collection items (images to be added by user)
  Product.sample(
    id: 'p4',
    title: 'A5 Notebook',
    collectionId: 'c3',
    price: 6.99,
    salePrice: 4.99,
    onSale: true,
    images: ['assets/images/products/a5_notebook.png'],
    description: 'Classic A5 notebook — lined pages, soft cover.',
    category: 'Accessories', // NEW
  ),
  Product.sample(
    id: 'p5',
    title: 'Union Joggers',
    collectionId: 'c3', // keep in Sale collection
    price: 49.99,
    salePrice: 29.99,
    onSale: true,
    images: ['assets/images/products/union_jogger.png'],
    description: 'Comfortable joggers with embroidered logo.',
    category: 'Clothing', // NEW
  ),
];
