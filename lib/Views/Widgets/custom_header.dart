import 'package:flutter/material.dart';
import '../products_view.dart';
// Nếu bạn có file trang chủ (home_view.dart) thì import thêm ở đây nhé!

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String activeTab;

  // Nhận biết xem người dùng đang ở trang nào (mặc định là products)
  const CustomHeader({super.key, this.activeTab = 'products'});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. LOGO HONDA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'HONDA',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),

          // 2. THANH MENU (Trang chủ - Sản phẩm - Liên hệ)
          Row(
            children: [
              _navItem(context, 'Trang chủ', 'home'),
              const SizedBox(width: 40),
              _navItem(context, 'Sản phẩm', 'products'),
              const SizedBox(width: 40),
              _navItem(context, 'Liên hệ', 'contact'),
            ],
          ),

          // 3. ICONS BÊN PHẢI (Giỏ hàng & User)
          Row(
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87), onPressed: () {}),
              const SizedBox(width: 15),
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.black87), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  // Hàm tạo từng nút bấm trên Menu
  Widget _navItem(BuildContext context, String title, String tabId) {
    bool isActive = activeTab == tabId; // Kiểm tra xem có đang ở trang này không

    return InkWell(
      onTap: () {
        if (isActive) return; // Nếu đang ở trang đó rồi thì bấm vào không có tác dụng gì cả

        // Logic chuyển trang
        if (tabId == 'products') {
          // Dùng pushReplacement để chuyển trang mà không bị xếp chồng màn hình lên nhau gây nặng máy
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
        } else if (tabId == 'contact') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Liên hệ đang được hoàn thiện!'), duration: Duration(seconds: 1)));
        } else if (tabId == 'home') {
          // Gắn tạm thông báo nếu chưa code Trang Chủ
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trang chủ đang được hoàn thiện!'), duration: Duration(seconds: 1)));
        }
      },
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFFCC0000) : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          // Cục gạch chân màu đỏ (chỉ hiện khi đang ở trang đó)
          Container(
            height: 2,
            width: 25,
            color: isActive ? const Color(0xFFCC0000) : Colors.transparent,
          )
        ],
      ),
    );
  }
}