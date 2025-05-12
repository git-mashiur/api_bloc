import 'package:equatable/equatable.dart';
import '../../category/model/category_model.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: CategoryModel.fromJson(json['category']),
      images: List<String>.from(json['images']),
      creationAt: DateTime.parse(json['creationAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object> get props => [id, title, slug, price, description, category, images, creationAt, updatedAt];
}