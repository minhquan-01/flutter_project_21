import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthController extends ChangeNotifier {
  static final AuthController instance = AuthController._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  AuthController._internal() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        userData = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        userData = doc.data();
      } else {
        userData = {
          'name': _auth.currentUser?.displayName ?? '',
          'phone': '',
          'avatarUrl': '',
          'email': _auth.currentUser?.email ?? '',
        };
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi lấy thông tin user: $e");
    }
  }

  bool get isLoggedIn => _auth.currentUser != null;
  String get currentUserEmail => _auth.currentUser?.email ?? '';

  bool get isAdmin {
    final email = _auth.currentUser?.email;
    return email == 'admin@honda.com' || email == 'bbk51204@gmail.com';
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  Future<void> register(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      // Tạo document user mới trong Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'name': '',
        'phone': '',
        'avatarUrl': '',
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- CẬP NHẬT THÔNG TIN CÁ NHÂN ---
  Future<void> updateProfile({String? name, String? phone, String? avatarUrl}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

    // Cập nhật local trước (Optimistic UI) để người dùng thấy thay đổi ngay lập tức
    if (userData != null) {
      userData!.addAll(updates);
      notifyListeners();
    }

    await _db.collection('users').doc(uid).set(updates, SetOptions(merge: true));
    
    // Đồng bộ lại với server để đảm bảo dữ liệu chính xác
    await _fetchUserData(uid);
  }

  // --- UPLOAD ẢNH ĐẠI DIỆN ---
  Future<void> uploadAvatar() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb, // Chỉ lấy bytes trên Web để tiết kiệm RAM trên Mobile
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final uid = _auth.currentUser?.uid;
        if (uid == null) return;

        final storageRef = FirebaseStorage.instance.ref().child('avatars').child('$uid.jpg');
        
        // Xử lý upload theo từng nền tảng
        if (kIsWeb) {
          if (file.bytes == null) throw Exception("Không thể đọc dữ liệu ảnh.");
          await storageRef.putData(file.bytes!);
        } else {
          if (file.path == null) throw Exception("Không tìm thấy đường dẫn ảnh.");
          await storageRef.putFile(io.File(file.path!));
        }

        final url = await storageRef.getDownloadURL();
        await updateProfile(avatarUrl: url);
      }
    } catch (e) {
      debugPrint("Lỗi uploadAvatar: $e");
      rethrow;
    }
  }

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
