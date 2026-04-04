import 'package:flutter/material.dart';
import 'Views/contact_screen.dart'; // Đã sửa chữ Views viết hoa giống cây thư mục của bạn

void main() {
  runApp(const HondaEcommerceApp());
}

class HondaEcommerceApp extends StatelessWidget {
  const HondaEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honda Motorbike',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFCC0000),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ContactScreen(),
    );
  }
}
