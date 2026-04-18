import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controllers/product_controller.dart';
import '../Models/product_model.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // Khởi tạo controller để lấy danh sách các xe khác
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomHeader(activeTab: 'products'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. NÚT BACK (Quay lại)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
                  label: const Text('Quay lại danh sách', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PHẦN CHI TIẾT SẢN PHẨM (Giữ nguyên giao diện cũ)
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CỘT TRÁI: HÌNH ẢNH
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                        ),
                        padding: const EdgeInsets.all(40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(widget.product.imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.two_wheeler, size: 100, color: Colors.grey)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // CỘT PHẢI: THÔNG TIN
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBadges(),
                          const SizedBox(height: 20),
                          Text(widget.product.name, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                          const SizedBox(height: 5),
                          Text('Phiên bản ${widget.product.year}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                          const SizedBox(height: 25),
                          _buildStockInfo(),
                          const SizedBox(height: 30),
                          const Text('Thông tin chi tiết', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(widget.product.desc, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6)),
                          const SizedBox(height: 40),
                          _buildPriceCard(context, formatter),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),

            // 2. MỤC "BẠN CÓ THỂ THÍCH"
            _buildRelatedProductsSection(),

            const SizedBox(height: 80),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị danh sách các xe liên quan
  Widget _buildRelatedProductsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('BẠN CÓ THỂ THÍCH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
              const SizedBox(height: 40),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  if (_controller.isLoading) return const Center(child: CircularProgressIndicator());

                  // Lọc bỏ xe hiện tại ra khỏi danh sách gợi ý và lấy tối đa 4 xe
                  final relatedItems = _controller.allProducts.where((p) => p.id != widget.product.id).take(4).toList();

                  if (relatedItems.isEmpty) return const SizedBox.shrink();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: relatedItems.length,
                    itemBuilder: (context, index) {
                      final item = relatedItems[index];
                      return _buildSmallProductCard(item);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thẻ xe nhỏ cho mục gợi ý
  Widget _buildSmallProductCard(ProductModel p) {
    return GestureDetector(
      onTap: () {
        // Chuyển hướng đến chính trang này với sản phẩm mới
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductDetailView(product: p)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Icon(Icons.two_wheeler)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text(p.price, style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Các hàm phụ trợ để code gọn gàng hơn
  Widget _buildBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(20)),
      child: Text(widget.product.category == 'Scooter' ? 'Xe tay ga' : (widget.product.category == 'Sport' ? 'Xe thể thao' : 'Xe số'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildStockInfo() {
    return Row(
      children: [
        _infoTag(Icons.inventory_2, 'Còn hàng: ${widget.product.stock} chiếc', Colors.green),
        const SizedBox(width: 15),
        _infoTag(Icons.shopping_cart, 'Đã bán: ${widget.product.sold} chiếc', Colors.blue),
      ],
    );
  }

  Widget _infoTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
      child: Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 5), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildPriceCard(BuildContext context, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giá bán lẻ đề xuất', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          const SizedBox(height: 5),
          Text(widget.product.price, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () => _showCostEstimateDialog(context, widget.product, formatter),
                  child: const Text('Dự toán chi phí', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[100], elevation: 0, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {},
                  child: const Text('Đăng ký Lái thử', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Hàm Dialog dự toán (Giữ nguyên từ code cũ của bạn)
  void _showCostEstimateDialog(BuildContext context, ProductModel product, NumberFormat formatter) {
    int basePrice = int.tryParse(product.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    String selectedRegion = 'Khu vực I (HN/HCM)';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (context, setStateDialog) {
            int registrationFee = selectedRegion == 'Khu vực I (HN/HCM)' ? (basePrice * 0.05).toInt() : (basePrice * 0.02).toInt();
            int licensePlateFee = selectedRegion == 'Khu vực I (HN/HCM)' ? 2000000 : 500000;
            int insuranceFee = 66000;
            int totalCost = basePrice + registrationFee + licensePlateFee + insuranceFee;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Color(0xFFCC0000), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      child: const Center(child: Text('DỰ TOÁN CHI PHÍ LĂN BÁNH', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nơi đăng ký trước bạ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: selectedRegion,
                                  decoration: InputDecoration(filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!))),
                                  items: const [
                                    DropdownMenuItem(value: 'Khu vực I (HN/HCM)', child: Text('Khu vực I (Hà Nội, TP.HCM)', overflow: TextOverflow.ellipsis)),
                                    DropdownMenuItem(value: 'Khu vực II (Các Tỉnh khác)', child: Text('Khu vực II (Các tỉnh khác)', overflow: TextOverflow.ellipsis)),
                                  ],
                                  onChanged: (v) => setStateDialog(() => selectedRegion = v!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                _costRow('Giá xe:', formatter.format(basePrice)),
                                _costRow('Phí trước bạ:', formatter.format(registrationFee)),
                                _costRow('Phí biển số:', formatter.format(licensePlateFee)),
                                _costRow('Bảo hiểm:', formatter.format(insuranceFee)),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('TỔNG CỘNG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(formatter.format(totalCost), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFCC0000))),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng'))],
            );
          }
      ),
    );
  }

  Widget _costRow(String t, String v) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t), Text(v, style: const TextStyle(fontWeight: FontWeight.bold))]));
}