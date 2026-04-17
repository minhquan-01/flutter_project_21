import 'package:flutter/material.dart';
import '../Controllers/auth_controller.dart';
import 'products_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLogin = true; // Chuyển đổi giữa Đăng nhập và Đăng ký
  bool obscurePass = true; // Ẩn/hiện mật khẩu

  // Các bộ điều khiển nhập liệu
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  // --- HÀM XỬ LÝ KHI BẤM NÚT SUBMIT ---
  void _submit() async {
    // 1. Kiểm tra đầu vào cơ bản
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ Email và Mật khẩu'))
      );
      return;
    }

    // 2. Hiển thị vòng xoay Loading (Chặn người dùng bấm lung tung)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFCC0000))),
    );

    try {
      if (isLogin) {
        // GỌI FIREBASE ĐĂNG NHẬP
        await AuthController.instance.login(emailCtrl.text, passCtrl.text);
      } else {
        // GỌI FIREBASE TẠO TÀI KHOẢN MỚI
        await AuthController.instance.register(emailCtrl.text, passCtrl.text);
      }

      // 3. Nếu thành công: Tắt Loading -> Hiện thông báo -> Chuyển trang
      if (context.mounted) {
        Navigator.pop(context); // Tắt vòng xoay loading

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AuthController.instance.isAdmin ? 'Xin chào Admin!' : (isLogin ? 'Đăng nhập thành công!' : 'Tạo tài khoản thành công!')),
            backgroundColor: Colors.green
        ));

        // Đưa người dùng về trang chủ sản phẩm
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
      }

    } catch (e) {
      // 4. Nếu thất bại: Tắt Loading -> Hiện lỗi màu đỏ
      if (context.mounted) {
        Navigator.pop(context); // Tắt vòng xoay loading

        // Lấy nội dung lỗi đã được dịch ở Controller
        String errorMsg = e.toString().replaceAll('Exception: ', '');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- KHỐI CARD CHÍNH ---
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: Column(
                  children: [
                    // 1. Header Đỏ Honda
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: const BoxDecoration(
                        color: Color(0xFFCC0000),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: const Column(
                        children: [
                          Text('HONDA', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          SizedBox(height: 5),
                          Text('Thương mại điện tử Xe máy', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Thanh chuyển Tab (Login / Register)
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(child: _buildTabButton('Đăng nhập', true)),
                                Expanded(child: _buildTabButton('Đăng ký', false)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 3. Các ô nhập liệu
                          if (!isLogin) ...[
                            _buildLabel('Họ và Tên'),
                            _buildTextField(nameCtrl, 'Nhập họ và tên', Icons.person_outline, false),
                            const SizedBox(height: 20),
                          ],

                          _buildLabel('Địa chỉ Email'),
                          _buildTextField(emailCtrl, 'example@gmail.com', Icons.email_outlined, false),
                          const SizedBox(height: 20),

                          _buildLabel('Mật khẩu'),
                          _buildTextField(passCtrl, '••••••••', Icons.lock_outline, true),
                          const SizedBox(height: 10),

                          if (isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(onPressed: (){}, child: const Text('Quên mật khẩu?', style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold))),
                            ),

                          const SizedBox(height: 20),

                          // 4. Nút bấm chính
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCC0000),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _submit,
                              child: Text(isLogin ? 'Đăng Nhập' : 'Tạo Tài Khoản', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Chuyển đổi nhanh bên dưới
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isLogin ? 'Chưa có tài khoản? ' : 'Đã có tài khoản? ', style: TextStyle(color: Colors.grey[600])),
                                GestureDetector(
                                  onTap: () => setState(() => isLogin = !isLogin),
                                  child: Text(isLogin ? 'Đăng ký ngay' : 'Đăng nhập', style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
              // Quay lại trang chủ
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text('Quay lại Trang chủ', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- TIỆN ÍCH VẼ GIAO DIỆN ---

  Widget _buildTabButton(String title, bool isTabLogin) {
    bool isSelected = isLogin == isTabLogin;
    return GestureDetector(
      onTap: () => setState(() => isLogin = isTabLogin),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : []),
        child: Center(child: Text(title, style: TextStyle(color: isSelected ? const Color(0xFFCC0000) : Colors.grey[600], fontWeight: isSelected ? FontWeight.bold : FontWeight.w500))),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && obscurePass,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
        suffixIcon: isPassword
            ? IconButton(icon: Icon(obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500], size: 20), onPressed: () => setState(() => obscurePass = !obscurePass))
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC0000))),
      ),
    );
  }
}