// Vị trí lưu: lib/views/auth_view.dart
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'products_view.dart'; // Import trang sản phẩm để chuyển tới sau khi login

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool isLoginMode = true; // Biến để chuyển đổi giữa Đăng nhập / Đăng ký

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _submit() async {
    String email = _emailCtrl.text.trim();
    String password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đủ thông tin!')));
      return;
    }

    bool success = false;
    if (isLoginMode) {
      success = await _authController.login(email, password);
    } else {
      success = await _authController.register(email, password);
    }

    if (success) {
      // Đăng nhập thành công -> Bay thẳng vào Showroom
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductsView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: ListenableBuilder(
                  listenable: _authController,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Icon(Icons.two_wheeler, size: 60, color: Colors.red[700]),
                        const SizedBox(height: 10),
                        Text(
                          isLoginMode ? 'XIN CHÀO!' : 'TẠO TÀI KHOẢN',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 30),

                        // Nhập Email
                        TextField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            labelText: 'Email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nhập Password
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Mật khẩu',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Cảnh báo lỗi
                        if (_authController.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(_authController.errorMessage, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),

                        // Nút Submit
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _authController.isLoading ? null : _submit,
                            child: _authController.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(isLoginMode ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ', style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nút chuyển đổi
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLoginMode = !isLoginMode;
                              _authController.errorMessage = '';
                            });
                          },
                          child: Text(
                            isLoginMode ? 'Chưa có tài khoản? Đăng ký ngay' : 'Đã có tài khoản? Đăng nhập',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        )
                      ],
                    );
                  }
              ),
            ),
          ),
        ),
      ),
    );
  }
}