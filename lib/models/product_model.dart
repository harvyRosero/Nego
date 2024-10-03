import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  final String id;
  final String name;
  final String description;
  final double price;
  final double promo;
  final String category;
  final String ownerId;
  final String createdAt;
  final String updatedAt;
  final String estado;
  final String tipo;
  final int stock;
  final int sold;
  final double rating;
  final List<String> tags;
  final String imageUrl;
  final DocumentReference reference;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.promo,
    required this.category,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.estado,
    required this.tipo,
    required this.stock,
    required this.sold,
    required this.rating,
    required this.tags,
    required this.imageUrl,
    required this.reference,
  });

  factory ProductData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductData(
      name: data['name'] as String,
      id: data['id'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      promo: (data['promo'] as num).toDouble(),
      category: data['category'] as String,
      ownerId: data['ownerId'] as String,
      createdAt: data['createdAt'] as String,
      updatedAt: data['updatedAt'] as String,
      estado: data['estado'] as String,
      tipo: data['tipo'] as String,
      stock: data['stock'] as int,
      sold: data['sold'] as int,
      rating: (data['rating'] as num).toDouble(),
      tags: List<String>.from(data['tags'] as List),
      imageUrl: data['imageUrl'] as String,
      reference: doc.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'promo': promo,
      'category': category,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'estado': estado,
      'tipo': tipo,
      'stock': stock,
      'sold': sold,
      'rating': rating,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }
}
