import 'package:flutter/material.dart';
// import '../products_view.dart'; // Mở comment này khi bạn muốn nối link chuyển trang

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String activeTab; // Biến này để biết bạn đang ở trang nào mà gạch chân đỏ trang đó

  const CustomHeader({super.key, required this.activeTab});

  // Flutter bắt buộc phải có dòng này để biết chiều cao của thanh AppBar
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 20,
      toolbarHeight: 70,
      title: Row(
        children: [
          // 1. Logo HONDA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(8)),
            child: const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1)),
          ),
          const Spacer(),

          // 2. Các nút Menu (Chỉ hiện trên màn hình máy tính/tablet)
          if (MediaQuery.of(context).size.width > 700) ...[
            _buildNavText(context, 'Trang chủ', 'home'),
            _buildNavText(context, 'Sản phẩm', 'products'),
            _buildNavText(context, 'Liên hệ', 'contact'),
            const Spacer(),
          ],

          // 3. Icon Giỏ hàng và Tài khoản
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87), onPressed: () {}),
          const SizedBox(width: 10),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.black87), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // Hàm vẽ chữ cho Menu
  Widget _buildNavText(BuildContext context, String text, String tabId) {
    bool isActive = activeTab == tabId; // Kiểm tra xem tab này có đang mở không
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          // Xử lý chuyển trang ở đây (VD: nếu bấm 'home' thì Navigator sang HomeView)
          // Tạm thời chưa có các trang khác nên để trống
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                text,
                style: TextStyle(
                    color: isActive ? const Color(0xFFCC0000) : Colors.grey[600],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15
                )
            ),
            // Thanh gạch ngang màu đỏ báo hiệu đang ở trang này
            if (isActive)
              Container(margin: const EdgeInsets.only(top: 5), height: 2, width: 25, color: const Color(0xFFCC0000)),
          ],
        ),
      ),
    );
  }
}