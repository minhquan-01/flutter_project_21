// Vị trí lưu: lib/views/product_detail_view.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int selectedColorIndex = 0; // Biến lưu trạng thái màu xe đang được chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.product.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Nút giỏ hàng trên góc phải
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              // Lát nữa mình sẽ làm trang giỏ hàng sau
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Phần nội dung cuộn được (Ảnh + Thông tin)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Khung chứa ảnh xe bự chà bá
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: Hero( // Hiệu ứng bay ảnh xịn xò
                      tag: widget.product.id,
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2. Thông tin chi tiết
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên và Giá
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(widget.product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(20)),
                              child: Text('2024', style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.product.price, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red[700])),

                        const SizedBox(height: 30),

                        // Mô tả
                        const Text('Mô tả xe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                        const SizedBox(height: 10),
                        Text(widget.product.desc, style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.6)),

                        const SizedBox(height: 30),

                        // Bảng chọn màu
                        const Text('Chọn màu sắc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                        const SizedBox(height: 15),
                        Row(
                          children: List.generate(widget.product.colors.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index; // Cập nhật viền đỏ khi bấm vào màu
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedColorIndex == index ? Colors.red[700]! : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: widget.product.colors[index],
                                  radius: 20,
                                  child: widget.product.colors[index] == Colors.white
                                      ? Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black12)))
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. Thanh công cụ mua hàng dưới cùng (Bottom Bar)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Nút Thêm vào giỏ
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.red[700]!, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        // Hiển thị thông báo nhỏ gọn chớp lên rồi tắt
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Đã thêm xe vào giỏ hàng!'),
                            backgroundColor: Colors.green[700],
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Icon(Icons.add_shopping_cart, color: Colors.red[700]),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Nút Mua ngay
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text('MUA NGAY', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}