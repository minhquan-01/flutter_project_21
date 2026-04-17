import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/product_model.dart';

class ProductController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = false;

  // Danh mục dùng cho bộ lọc
  List<String> categories = ['All', 'Scooter', 'Sport', 'Cub'];
  String selectedCategory = 'All';

  ProductController() { fetchProducts(); }

  // Lấy dữ liệu từ Firebase
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _db.collection('products').get();
      allProducts = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      filterByCategory(selectedCategory);
    } catch (e) {
      debugPrint("Lỗi Firestore: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  // Hàm lọc xe theo loại
  void filterByCategory(String cat) {
    selectedCategory = cat;
    if (cat == 'All') {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts.where((p) => p.category == cat).toList();
    }
    notifyListeners();
  }

  Future<void> addProduct(ProductModel p) async {
    await _db.collection('products').add(p.toMap());
    await fetchProducts();
  }

  Future<void> updateProduct(ProductModel p) async {
    await _db.collection('products').doc(p.id).update(p.toMap());
    await fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
    await fetchProducts();
  }
}