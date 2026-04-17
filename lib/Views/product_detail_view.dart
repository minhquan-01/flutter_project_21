import 'package:flutter/material.dart';
import '../Models/product_model.dart';
import '../Controllers/product_controller.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Nút Chat góc dưới
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCC0000),
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),

      // HEADER
      appBar: const CustomHeader(activeTab: 'products'),

      // NỘI DUNG CHÍNH
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nút Quay lại
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.grey[700], size: 20),
                        const SizedBox(width: 8),
                        Text('Quay lại danh sách', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Phần 1: Ảnh (Trái) & Thông tin chính (Phải)
                  isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildImageGallery()),
                      const SizedBox(width: 50),
                      Expanded(flex: 5, child: _buildMainInfo()),
                    ],
                  )
                      : Column(
                    children: [
                      _buildImageGallery(),
                      const SizedBox(height: 30),
                      _buildMainInfo(),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // Phần 2: Sản phẩm đề xuất (Đã xóa các khối thông số thừa)
                  const Text('Có thể bạn cũng thích', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                  const SizedBox(height: 30),
                  _buildRelatedProducts(isDesktop),
                ],
              ),
            ),

            // FOOTER
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  // --- 1. Khối hiển thị hình ảnh ---
  Widget _buildImageGallery() {
    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: widget.product.id,
          child: Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Center(child: Icon(Icons.two_wheeler, size: 100, color: Colors.black12))
          ),
        ),
      ),
    );
  }

  // --- 2. Khối hiển thị thông tin sản phẩm ---
  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tem danh mục
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(20)),
          child: Text(
              widget.product.category == 'Scooter' ? 'Xe tay ga' : (widget.product.category == 'Sport' ? 'Xe thể thao' : 'Xe số'),
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
          ),
        ),
        const SizedBox(height: 15),

        // Tên và Đời xe
        Text(widget.product.name, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
        const SizedBox(height: 5),
        Text('Phiên bản ${widget.product.year}', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        const SizedBox(height: 20),

        // Thống kê Kho & Đã bán (Lấy từ Firebase)
        Row(
          children: [
            _buildStatBadge(Icons.inventory_2_outlined, 'Còn hàng:', '${widget.product.stock} chiếc', Colors.green),
            const SizedBox(width: 15),
            _buildStatBadge(Icons.shopping_cart_checkout, 'Đã bán:', '${widget.product.sold} chiếc', Colors.blue),
          ],
        ),
        const SizedBox(height: 25),

        // Mô tả chi tiết (Admin nhập tay)
        const Text('Thông tin chi tiết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(widget.product.desc, style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6)),
        const SizedBox(height: 30),

        // Khối Giá bán và Nút Mua
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giá bán lẻ đề xuất', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              const SizedBox(height: 8),
              Text(widget.product.price, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCC0000),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào giỏ hàng!')));
                      },
                      child: const Text('Mua Ngay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      onPressed: () {},
                      child: const Text('Đăng ký Lái thử', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // --- Tiện ích vẽ nhãn thống kê (Kho / Đã bán) ---
  Widget _buildStatBadge(IconData icon, String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color[50], borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color[700]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color[700], fontSize: 13)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: color[900], fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- 3. Khối Sản phẩm liên quan ---
  Widget _buildRelatedProducts(bool isDesktop) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) return const Center(child: CircularProgressIndicator());

        // Lấy ngẫu nhiên 3 xe khác với xe hiện tại
        var related = _controller.allProducts.where((p) => p.id != widget.product.id).take(3).toList();
        if (related.isEmpty) return const SizedBox();

        return GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: isDesktop ? 1.0 : 1.2
          ),
          itemCount: related.length,
          itemBuilder: (context, index) {
            final p = related[index];
            return GestureDetector(
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductDetailView(product: p))),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: Container(width: double.infinity, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(p.imageUrl, fit: BoxFit.cover)))),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 10),
                            Text(p.price, style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}