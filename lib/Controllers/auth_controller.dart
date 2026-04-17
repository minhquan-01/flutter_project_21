import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Nạp thư viện Firebase Auth

class AuthController extends ChangeNotifier {
  static final AuthController instance = AuthController._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthController._internal() {
    // Luôn lắng nghe: Hễ có ai đăng nhập hoặc đăng xuất là báo cho toàn app biết
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  // Lấy trạng thái đăng nhập trực tiếp từ Firebase
  bool get isLoggedIn => _auth.currentUser != null;
  String get currentUserEmail => _auth.currentUser?.email ?? '';

  // KIỂM TRA PHÂN QUYỀN: Chỉ 2 email này mới có nút Admin
  bool get isAdmin {
    final email = _auth.currentUser?.email;
    return email == 'admin@honda.com' || email == 'bbk51204@gmail.com';
  }

  // --- 1. HÀM ĐĂNG NHẬP THẬT ---
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code)); // Bắt lỗi để báo ra màn hình
    }
  }

  // --- 2. HÀM ĐĂNG KÝ THẬT ---
  Future<void> register(String email, String password) async {
    try {
      // Hàm này sẽ tự động tạo tài khoản trên Firebase và lưu lại
      await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  // --- 3. HÀM ĐĂNG XUẤT ---
  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- Tiện ích dịch lỗi Firebase sang Tiếng Việt ---
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found': return 'Không tìm thấy tài khoản này!';
      case 'wrong-password': return 'Sai mật khẩu!';
      case 'email-already-in-use': return 'Email này đã có người đăng ký!';
      case 'weak-password': return 'Mật khẩu quá yếu (Cần ít nhất 6 ký tự)!';
      case 'invalid-email': return 'Định dạng email không hợp lệ!';
      case 'invalid-credential': return 'Sai email hoặc mật khẩu!';
      default: return 'Đã xảy ra lỗi, vui lòng thử lại!';
    }
  }
}