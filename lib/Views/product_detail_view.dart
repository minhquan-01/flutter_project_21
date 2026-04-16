import 'package:flutter/material.dart';
import '../Models/product_model.dart';
import '../Controllers/product_controller.dart';
import 'Widgets/custom_header.dart'; // Nút Header gọn gàng
import 'Widgets/custom_footer.dart'; // Nút Footer gọn gàng

class ProductDetailView extends StatefulWidget {
  final ProductModel product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int selectedColorIndex = 0;
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCC0000),
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),

      // HEADER DÙNG CHUNG (Chỉ 1 dòng)
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
                        Text('Quay lại Sản phẩm', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Phần 1: Ảnh (Trái) & Thông tin (Phải)
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

                  const SizedBox(height: 50),

                  // Phần 2: Khối Màu sắc (Trái) & Tính năng/Thông số (Phải)
                  isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildColorSelection()),
                      const SizedBox(width: 40),
                      Expanded(flex: 6, child: Column(
                        children: [
                          _buildKeyFeatures(),
                          const SizedBox(height: 30),
                          _buildTechSpecs(),
                        ],
                      )),
                    ],
                  )
                      : Column(
                    children: [
                      _buildColorSelection(),
                      const SizedBox(height: 30),
                      _buildKeyFeatures(),
                      const SizedBox(height: 30),
                      _buildTechSpecs(),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // Phần 3: Đề xuất
                  const Text('Có thể bạn cũng thích', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                  const SizedBox(height: 30),
                  _buildRelatedProducts(isDesktop),
                ],
              ),
            ),

            // FOOTER DÙNG CHUNG (Chỉ 1 dòng)
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  // --- CÁC KHỐI GIAO DIỆN CON ---

  Widget _buildImageGallery() {
    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: widget.product.id,
          child: Image.network(widget.product.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.two_wheeler, size: 100, color: Colors.black12))),
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(20)),
          child: Text(widget.product.category, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        Text(widget.product.name, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
        const SizedBox(height: 5),
        Text('Phiên bản ${widget.product.year}', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        const SizedBox(height: 25),
        Text(widget.product.desc, style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6)),
        const SizedBox(height: 30),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      onPressed: () {}, child: const Text('Mua Ngay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[100], foregroundColor: Colors.black87, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      onPressed: () {}, child: const Text('Đăng ký Lái thử', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildColorSelection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chọn Màu Sắc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 15, runSpacing: 15,
            children: List.generate(widget.product.colors.length, (index) {
              bool isSelected = selectedColorIndex == index;
              Color color = widget.product.colors[index];
              String colorName = color == Colors.white ? 'Trắng' : (color == Colors.black ? 'Đen Nhám' : 'Đỏ Thể Thao');

              return GestureDetector(
                onTap: () => setState(() => selectedColorIndex = index),
                child: Container(
                  width: 110, padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: isSelected ? const Color(0xFFCC0000) : Colors.grey[300]!, width: isSelected ? 2 : 1), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(height: 50, width: double.infinity, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12))),
                          if (isSelected) const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.check_circle, color: Colors.white, size: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(colorName, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildKeyFeatures() {
    List<String> features = ['Thiết kế thể thao, mạnh mẽ', 'Động cơ DOHC 150cc uy lực', 'Đèn định vị LED hiện đại', 'Mặt đồng hồ LCD kỹ thuật số', 'Hệ thống chống bó cứng phanh ABS'];
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tính năng Nổi bật', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...features.map((f) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [const Icon(Icons.check, color: Color(0xFFCC0000), size: 20), const SizedBox(width: 15), Expanded(child: Text(f, style: TextStyle(fontSize: 15, color: Colors.grey[800])))])))
        ],
      ),
    );
  }

  Widget _buildTechSpecs() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông số Kỹ thuật', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          _buildSpecRow(Icons.speed, 'Động cơ', '4 kỳ, Xi-lanh đơn, DOHC'), const Divider(height: 30),
          _buildSpecRow(Icons.local_gas_station_outlined, 'Công suất tối đa', '11.8 kW / 9,000 vòng/phút'), const Divider(height: 30),
          _buildSpecRow(Icons.aspect_ratio, 'Kích thước (D x R x C)', '2,020 x 725 x 1,035 mm'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFFCC0000))),
        const SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))])
      ],
    );
  }

  Widget _buildRelatedProducts(bool isDesktop) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) return const Center(child: CircularProgressIndicator());
        var related = _controller.allProducts.where((p) => p.id != widget.product.id).take(3).toList();
        if (related.isEmpty) return const SizedBox();

        return GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 3 : 1, crossAxisSpacing: 30, mainAxisSpacing: 30, childAspectRatio: isDesktop ? 1.0 : 1.2),
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
                          children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 10), Text(p.price, style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 18))],
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