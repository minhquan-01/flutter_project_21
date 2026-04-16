import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A0A), // Nền đen
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
      child: Column(
        children: [
          Wrap(
            spacing: 50,
            runSpacing: 40,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(8)),
                      child: const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Nhà sản xuất xe máy hàng đầu mang đến chất lượng, sự đổi mới và hiệu suất từ năm 1948.', style: TextStyle(color: Colors.white54, height: 1.6, fontSize: 14)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        _buildSocialIcon(Icons.camera_alt_outlined),
                        _buildSocialIcon(Icons.flutter_dash),
                        _buildSocialIcon(Icons.play_circle_outline),
                      ],
                    )
                  ],
                ),
              ),
              _buildFooterColumn('Liên kết nhanh', ['Tất cả sản phẩm', 'Liên hệ', 'Về Honda', 'Bảo hành', 'Trung tâm dịch vụ']),
              _buildFooterColumn('Chăm sóc khách hàng', ['Câu hỏi thường gặp', 'Hỗ trợ trả góp', 'Lái thử', 'Sách hướng dẫn', 'Phụ tùng & Phụ kiện']),
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin liên hệ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildContactRow(Icons.location_on_outlined, '123 Đường Honda, Quận 1, TP. Hồ Chí Minh'),
                    _buildContactRow(Icons.phone_outlined, '1800-123-456'),
                    _buildContactRow(Icons.email_outlined, 'support@honda.com.vn'),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          const Text('© 2024 Honda Motor Co., Ltd. Tất cả quyền được bảo lưu.', style: TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  // --- HÀM HỖ TRỢ VẼ FOOTER NẰM GỌN TRONG NÀY ---
  Widget _buildFooterColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(link, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        )),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFCC0000), size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Icon(icon, color: Colors.white54, size: 22),
    );
  }
}