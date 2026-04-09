// Vị trí lưu: lib/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<String> categories = ['All', 'Scooter', 'Sport', 'Cub'];
  String selectedCategory = 'All';

  bool isLoading = false;

  ProductController() {
    fetchProducts(); 
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Lên mạng quét kho 'products'
      QuerySnapshot snapshot = await _firestore.collection('products').get();

      // 2. Nếu kho trống trơn -> Tự động bơm dữ liệu mẫu
      if (snapshot.docs.isEmpty) {
        await _autoSeedData();
        snapshot = await _firestore.collection('products').get();
      }

      // 3. Dịch toàn bộ dữ liệu tải về thành danh sách xe
      allProducts = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      _applyFilter(); // Chạy bộ lọc

    } catch (e) {
      print("Lỗi kéo dữ liệu: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Hàm chuyển đổi danh mục
  void changeCategory(String category) {
    selectedCategory = category;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedCategory == 'All') {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts.where((p) => p.category == selectedCategory).toList();
    }
    notifyListeners();
  }

  // HÀM BƠM DỮ LIỆU TỰ ĐỘNG (Đã cập nhật link ảnh)
  Future<void> _autoSeedData() async {
    print("Kho trống! Đang tiến hành bơm dữ liệu mẫu lên Firebase...");
    List<ProductModel> mockData = [
      ProductModel(id: '', name: 'Honda Vision 2024', category: 'Scooter', year: '2024', desc: 'Dòng xe tay ga quốc dân với thiết kế thanh lịch, trẻ trung.', price: '31,113,000 VNĐ',
          imageUrl: 'https://cdn.honda.com.vn/motorbike-versions/Image360/December2025/1765585834/0.png', // Ảnh Vision
          colors: [Colors.white, Colors.black87, Colors.red[700]!]),
      ProductModel(id: '', name: 'Honda SH 160i', category: 'Scooter', year: '2024', desc: 'Biểu tượng đẳng cấp với động cơ eSP+ 4 van mạnh mẽ vượt trội.', price: '92,490,000 VNĐ',
          imageUrl: 'https://cdn.honda.com.vn/motorbike-versions/Image360/October2024/1729594648/0.png', // Ảnh SH
          colors: [Colors.black, Colors.grey[300]!, Colors.white]),
      ProductModel(id: '', name: 'Winner X', category: 'Sport', year: '2023', desc: 'Đỉnh cao xe côn tay thể thao với phanh ABS an toàn.', price: '46,160,000 VNĐ',
          imageUrl: 'https://cdn.honda.com.vn/motorbike-versions/Image360/September2025/1757787378/0.png', // Ảnh Winner
          colors: [Colors.red[700]!, Colors.black, Colors.blue[800]!]),
      ProductModel(id: '', name: 'Super Cub C125', category: 'Cub', year: '2023', desc: 'Huyền thoại hồi sinh với thiết kế hoài cổ pha trộn công nghệ hiện đại.', price: '87,390,000 VNĐ',
          imageUrl: 'https://cdn.honda.com.vn/motorbike-versions/July2024/4mvfY4O7TXBSDullbfAZ.png', // Ảnh Cub
          colors: [Colors.blue[300]!, Colors.red[700]!]),
    ];

    for (var product in mockData) {
      await _firestore.collection('products').add(product.toMap());
    }
    print("Bơm dữ liệu hoàn tất!");
  }
}