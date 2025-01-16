import 'dart:convert';
import 'package:agro/models/selected_product_model.dart';

class MyOrder {
  final String uid;
  final String userName;
  final String gmail;
  final String direccion;
  final String lat;
  final String lng;
  final String ciudad;
  final String celular;
  final String detallesUbicacion;
  final String barrio;
  final String category;
  final String state;
  final String deliveryId;
  final double totalSum;
  final List<SelectedProductData> products;
  final String createdAt;

  MyOrder({
    required this.uid,
    required this.userName,
    required this.gmail,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.ciudad,
    required this.celular,
    required this.detallesUbicacion,
    required this.barrio,
    required this.category,
    required this.state,
    required this.deliveryId,
    required this.totalSum,
    required this.products,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'gmail': gmail,
      'direccion': direccion,
      'lat': lat,
      'lng': lng,
      'ciudad': ciudad,
      'celular': celular,
      'detallesUbicacion': detallesUbicacion,
      'barrio': barrio,
      'category': category,
      'totalSum': totalSum,
      'state': state,
      'deliveryId': deliveryId,
      'products': products.map((product) => product.toMap()).toList(),
      'createdAt': createdAt,
    };
  }

  factory MyOrder.fromMap(Map<String, dynamic> map) {
    return MyOrder(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      gmail: map['gmail'] ?? '',
      direccion: map['direccion'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      ciudad: map['ciudad'] ?? '',
      celular: map['celular'] ?? '',
      detallesUbicacion: map['detallesUbicacion'] ?? '',
      barrio: map['barrio'] ?? '',
      state: map['state'] ?? '',
      category: map['category'] ?? '',
      deliveryId: map['deliveryId'] ?? '',
      totalSum: map['totalSum']?.toDouble() ?? 0.0,
      products: List<SelectedProductData>.from(
          map['products']?.map((x) => SelectedProductData.fromMap(x))),
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyOrder.fromJson(String source) =>
      MyOrder.fromMap(json.decode(source));
}
