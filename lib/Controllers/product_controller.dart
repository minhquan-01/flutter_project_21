import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/product_model.dart';
import '../Models/review_model.dart';

class ProductController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = false;

  String selectedCategory = 'All';
  String searchQuery = '';
  List<String> categories = ['All', 'Scooter', 'Sport', 'Cub'];

  ProductController() { fetchProducts(); }

  // Lọc danh sách xe
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _db.collection('products').get();
      allProducts = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      _applyFilters();
    } catch (e) {
      debugPrint("Lỗi Firestore: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String cat) {
    selectedCategory = cat;
    _applyFilters();
  }

  void searchProduct(String query) {
    searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    filteredProducts = allProducts.where((p) {
      bool matchCategory = selectedCategory == 'All' || p.category == selectedCategory;
      bool matchSearch = searchQuery.isEmpty || p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
    notifyListeners();
  }

  // ==========================================
  // Xử lý giỏ hàng
  // ==========================================

  Future<void> addToCart(ProductModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Vui lòng đăng nhập để mua hàng!');
    }

    try {
      // ĐỌC REAL-TIME KIỂM TRA TỒN KHO
      final productDoc = await _db.collection('products').doc(product.id).get();
      if (!productDoc.exists) throw Exception('Sản phẩm không tồn tại!');
      int realStock = (productDoc.data() as Map<String, dynamic>?)?['stock'] ?? 0;

      final docRef = _db.collection('carts').doc(user.uid).collection('items').doc(product.id);
      final doc = await docRef.get();

      if (doc.exists) {
        int currentQuantity = doc.data()?['quantity'] ?? 1;
        if (currentQuantity + 1 > realStock) {
          throw Exception('Số lượng trong giỏ đã đạt giới hạn tồn kho ($realStock chiếc)');
        }
        await docRef.update({'quantity': currentQuantity + 1});
      } else {
        if (realStock < 1) {
          throw Exception('Sản phẩm hiện đã hết hàng!');
        }
        await docRef.set({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'quantity': 1,
          'addedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow; // Bắn thẳng lỗi ra UI để hiện thông báo chính xác
    }
  }

  Stream<QuerySnapshot> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;
    return _db.collection('carts').doc(user?.uid).collection('items').orderBy('addedAt', descending: true).snapshots();
  }

  Future<void> removeFromCart(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('carts').doc(user.uid).collection('items').doc(productId).delete();
    }
  }

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshots = await _db.collection('carts').doc(user.uid).collection('items').get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  // ==========================================
  // Xử lý đơn hàng và cập nhật tồn kho
  // ==========================================

  // Tạo đơn hàng mới
  Future<String> createOrder(List<QueryDocumentSnapshot> cartItems, int totalAmount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Vui lòng đăng nhập!');

    final orderData = {
      'userId': user.uid,
      'userEmail': user.email,
      'items': cartItems.map((doc) => doc.data() as Map<String, dynamic>).toList(),
      'totalAmount': totalAmount,
      'status': 'Chờ thanh toán',
      'createdAt': Timestamp.now(),
    };

    final docRef = await _db.collection('orders').add(orderData);
    return docRef.id;
  }

  // Lấy lịch sử đơn hàng của User đang đăng nhập
  Stream<QuerySnapshot> getUserOrders() {
    final user = FirebaseAuth.instance.currentUser;
    return _db.collection('orders')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();
  }

  // Đặt lịch bảo dưỡng
  Stream<QuerySnapshot> getMaintenanceSchedule() {
    final user = FirebaseAuth.instance.currentUser;
    return _db.collection('maintenance')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();
  }

  // Lấy TOÀN BỘ đơn hàng cho Admin
  Stream<QuerySnapshot> getAllOrdersAdmin() {
    return _db.collection('orders').orderBy('createdAt', descending: true).snapshots();
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('orders').doc(orderId).update({'status': newStatus});
  }

  // TRỪ SỐ LƯỢNG TRONG KHO (Dùng giao dịch Transaction để an toàn)
  Future<void> updateProductStock(String productId, int quantityPurchased) async {
    try {
      DocumentReference productRef = _db.collection('products').doc(productId);
      await _db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(productRef);
        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>?;
        if (data == null) return;

        int currentStock = data.containsKey('stock') ? (data['stock'] as num).toInt() : 0;
        int currentSold = data.containsKey('sold') ? (data['sold'] as num).toInt() : 0;

        // Trừ kho (không để âm) và cộng số lượng đã bán
        int newStock = currentStock - quantityPurchased;
        if (newStock < 0) newStock = 0;
        
        transaction.update(productRef, {
          'stock': newStock,
          'sold': currentSold + quantityPurchased
        });
      });
    } catch (e) {
      debugPrint("Lỗi cập nhật kho: $e");
    }
  }

  // Thêm sửa xóa xe (Admin)
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

  // Xử lý mã giảm giá
  Future<Map<String, dynamic>?> applyCoupon(String code) async {
    try {
      final snapshot = await _db.collection('coupons')
          .where('code', isEqualTo: code.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Mã giảm giá không tồn tại!');
      }

      final data = snapshot.docs.first.data();
      // Vì hiện tại chỉ có loại Mua xe, nên không cần check type phức tạp
      return data;
    } catch (e) {
      rethrow;
    }
  }
  // ==========================================
  // RATING & REVIEWS
  // ==========================================

  Future<void> addReview(String productId, double rating, String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Vui lòng đăng nhập để đánh giá!');

    // 1. Kiểm tra xem người dùng đã mua sản phẩm này chưa
    final userOrders = await _db.collection('orders').where('userId', isEqualTo: user.uid).get();
    bool hasBought = false;
    for (var doc in userOrders.docs) {
      List items = doc.data()['items'] ?? [];
      if (items.any((item) => item['id'] == productId)) {
        hasBought = true;
        break;
      }
    }
    if (!hasBought) throw Exception('Bạn cần mua sản phẩm này trước khi có thể viết đánh giá!');

    // 2. Lấy thông tin người dùng từ Firestore (để lấy tên và avatar chính xác nhất)
    String userName = user.email?.split('@').first ?? 'Khách';
    String userAvatar = '';
    
    final userDoc = await _db.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      if (data['name'] != null && data['name'].toString().isNotEmpty) {
        userName = data['name'];
      }
      if (data['avatarUrl'] != null && data['avatarUrl'].toString().isNotEmpty) {
        userAvatar = data['avatarUrl'];
      }
    }

    // 3. Thêm đánh giá
    final reviewRef = _db.collection('products').doc(productId).collection('reviews').doc();
    final productRef = _db.collection('products').doc(productId);

    await _db.runTransaction((transaction) async {
      final productDoc = await transaction.get(productRef);
      if (!productDoc.exists) throw Exception('Sản phẩm không tồn tại!');

      int currentCount = productDoc.data()?['reviewCount'] ?? 0;
      double currentRating = (productDoc.data()?['rating'] ?? 0.0).toDouble();

      double newRating = ((currentRating * currentCount) + rating) / (currentCount + 1);
      
      transaction.set(reviewRef, {
        'userId': user.uid,
        'userName': userName,
        'userAvatar': userAvatar,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(productRef, {
        'rating': newRating,
        'reviewCount': currentCount + 1,
      });
    });

    await fetchProducts(); // Tải lại để cập nhật rating mới
  }

  Future<List<ReviewModel>> getReviews(String productId) async {
    final snapshot = await _db.collection('products').doc(productId).collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
  }
}
