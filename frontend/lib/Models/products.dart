// models/product.dart
class Product {
  final String id;
  final String imageCard;
  final String imageDetail;
  final String category;
  final String name;
  final String description;
  final double rating;
  final double price;
  final double? formerPrice;
  final bool isFavorite;
  final String deliveryTime;

  Product({
    required this.id,
    required this.imageCard,
    required this.imageDetail,
    required this.category,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    this.formerPrice,
    this.isFavorite = false,
    this.deliveryTime = "15-20 min",
  });
}