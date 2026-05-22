import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Controllers/product_controller.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  final ProductController _controller = ProductController();
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 850;

    // ĐÃ SỬA LỖI: Bọc Scaffold ở ngoài cùng để cung cấp Material Design
    return Scaffold(
      backgroundColor: Colors.transparent, // Giữ nền trong suốt để tệp với AdminView
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quản lý Đơn hàng', style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A24))),
                  const SizedBox(height: 5),
                  Text('Theo dõi và quản lý các giao dịch thanh toán', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 30),
                  _buildOrdersList(isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(bool isMobile) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            child: const Text('Danh sách Giao dịch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1, color: Colors.black12),

          StreamBuilder<QuerySnapshot>(
            stream: _controller.getAllOrdersAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Padding(padding: EdgeInsets.all(50), child: Center(child: CircularProgressIndicator(color: Color(0xFFCC0000))));
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Padding(padding: EdgeInsets.all(50), child: Center(child: Text('Chưa có giao dịch nào', style: TextStyle(color: Colors.grey))));

              var orders = snapshot.data!.docs;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  var order = orders[index].data() as Map<String, dynamic>;
                  DateTime date = (order['createdAt'] as Timestamp).toDate();
                  String status = order['status'] ?? 'Chờ thanh toán';
                  bool isSuccess = status == 'Đã thanh toán';

                  return ListTile(
                    contentPadding: EdgeInsets.all(isMobile ? 15 : 20),
                    leading: CircleAvatar(
                      backgroundColor: isSuccess ? Colors.green[50] : Colors.orange[50],
                      child: Icon(isSuccess ? Icons.check_circle : Icons.hourglass_top, color: isSuccess ? Colors.green : Colors.orange),
                    ),
                    title: Text('Khách: ${order['userEmail'] ?? 'Ẩn danh'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('Mã đơn: ${orders[index].id}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        Text('Ngày: ${DateFormat('dd/MM/yyyy HH:mm').format(date)}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatter.format(order['totalAmount']), style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(status, style: TextStyle(color: isSuccess ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    onTap: () => _showOrderDetails(context, orders[index].id, order),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, String orderId, Map<String, dynamic> order) {
    List<dynamic> items = order['items'] ?? [];
    int totalAmount = order['totalAmount'] ?? 0;
    DateTime date = (order['createdAt'] as Timestamp).toDate();
    String dateStr = DateFormat('dd/MM/yyyy HH:mm').format(date);
    String userEmail = order['userEmail'] ?? 'Khách vãng lai';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
                children: [
                  const Icon(Icons.receipt_long, color: Color(0xFFCC0000)),
                  const SizedBox(width: 10),
                  const Text('Chi Tiết Đơn Hàng', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mã đơn: $orderId', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('Khách hàng: $userEmail'),
                            const SizedBox(height: 5),
                            Text('Ngày đặt: $dateStr'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(item['imageUrl'] ?? '', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 50, height: 50, color: Colors.grey[300], child: const Icon(Icons.motorcycle))),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'] ?? 'Tên xe', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('SL: ${item['quantity'] ?? 1}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(item['price'] ?? '0 VNĐ', style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(formatter.format(totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFCC0000))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Đóng', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
        );
      }
    );
  }
}