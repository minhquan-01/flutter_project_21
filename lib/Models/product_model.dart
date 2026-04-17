import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String year;
  final String desc;
  final String price;
  final String imageUrl;
  final List<Color> colors;
  final int stock;
  final int sold;

  ProductModel({
    required this.id, required this.name, required this.category,
    required this.year, required this.desc, required this.price,
    required this.imageUrl, required this.colors,
    required this.stock, required this.sold,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<Color> dsMau = [];
    if (data['colors'] != null) {
      for(var colorValue in data['colors']) {
        dsMau.add(Color(colorValue as int));
      }
    }
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Scooter',
      year: data['year'] ?? '2024',
      desc: data['desc'] ?? '',
      price: data['price'] ?? '0 VNĐ',
      imageUrl: data['imageUrl'] ?? '',
      colors: dsMau,
      stock: data['stock'] ?? 0,
      sold: data['sold'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name, 'category': category, 'year': year,
      'desc': desc, 'price': price, 'imageUrl': imageUrl,
      'colors': colors.map((c) => c.value).toList(),
      'stock': stock, 'sold': sold,
    };
  }
}