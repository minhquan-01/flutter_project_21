import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Controllers/product_controller.dart';
import '../Controllers/momo_controller.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';
import 'payment_result_view.dart'; // ĐÃ NẠP TRANG XỬ LÝ TỰ ĐỘNG

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final ProductController _controller = ProductController();
  final MoMoController _momoController = MoMoController();
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomHeader(activeTab: ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                      const SizedBox(width: 10),
                      Text('Giỏ hàng của bạn', style: TextStyle(fontSize: isMobile ? 26 : 32, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A24))),
                    ],
                  ),
                  const SizedBox(height: 30),

                  StreamBuilder<QuerySnapshot>(
                    stream: _controller.getCartItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFCC0000)));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyCart();
                      }

                      final items = snapshot.data!.docs;
                      int totalAmount = 0;

                      for (var doc in items) {
                        int price = int.parse(doc['price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
                        int qty = doc['quantity'] ?? 1;
                        totalAmount += (price * qty);
                      }

                      return isMobile
                          ? Column(
                        children: [
                          _buildCartItemList(items),
                          const SizedBox(height: 30),
                          _buildOrderSummary(totalAmount, items),
                        ],
                      )
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: _buildCartItemList(items)),
                          const SizedBox(width: 40),
                          Expanded(flex: 3, child: _buildOrderSummary(totalAmount, items)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text('Giỏ hàng đang trống', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Hãy chọn cho mình chiếc xe ưng ý nhé!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItemList(List<QueryDocumentSnapshot> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          var item = items[index].data() as Map<String, dynamic>;
          int price = int.parse(item['price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(item['imageUrl'], width: 100, height: 70, fit: BoxFit.cover)),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 5),
                      Text('Số lượng: ${item['quantity']}', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatter.format(price * (item['quantity'] as int)), style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => _controller.removeFromCart(items[index].id))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(int total, List<QueryDocumentSnapshot> items) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tổng tiền xe:'), Text(formatter.format(total), style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 15),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Phí vận chuyển:'), Text('Miễn phí', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('TỔNG CỘNG:', style: TextStyle(fontWeight: FontWeight.bold)), Text(formatter.format(total), style: const TextStyle(color: Color(0xFFCC0000), fontSize: 22, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA50064),
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tạo đơn hàng...')));

                  // 1. Tạo đơn hàng với trạng thái "Chờ thanh toán" trên Firebase
                  String firebaseOrderId = await _controller.createOrder(items, total);

                  // 2. Tạo một mã riêng cho MoMo có tiền tố HONDA_
                  String momoOrderId = "HONDA_$firebaseOrderId";

                  // 3. Chuyển sẵn sang trang xử lý trung gian trước khi gọi MoMo
                  if (context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (_) => PaymentResultView(
                            firebaseOrderId: firebaseOrderId, // Để cập nhật Firebase
                            momoOrderId: momoOrderId,         // Để tra cứu trên MoMo
                            items: items
                        )
                    ));
                  }

                  // 4. Mở cổng MoMo (Khách bị đẩy qua trình duyệt lúc này)
                  await _momoController.createTestPayment(total, "Thanh toan don", momoOrderId);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
                }
              },
              label: const Text('THANH TOÁN MOMO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}