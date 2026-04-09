import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String errorMessage = '';

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true; // Thành công
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') errorMessage = 'Tài khoản không tồn tại.';
      else if (e.code == 'wrong-password') errorMessage = 'Sai mật khẩu.';
      else errorMessage = 'Lỗi: ${e.message}';
      notifyListeners();
      return false; // Thất bại
    }
  }

  // Hàm Đăng Ký
  Future<bool> register(String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true; // Thành công
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'weak-password') errorMessage = 'Mật khẩu quá yếu (cần ít nhất 6 ký tự).';
      else if (e.code == 'email-already-in-use') errorMessage = 'Email này đã được sử dụng.';
      else errorMessage = 'Lỗi: ${e.message}';
      notifyListeners();
      return false; // Thất bại
    }
  }
}