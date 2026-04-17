import 'package:flutter/material.dart';
import '../Controllers/product_controller.dart';
import '../Models/product_model.dart';
import 'product_detail_view.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductController _controller = ProductController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      // Nút Chat góc phải
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCC0000),
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),

      // HEADER
      appBar: const CustomHeader(activeTab: 'products'),

      // NỘI DUNG CHÍNH
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFCC0000)));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO SECTION (Tiêu đề lớn) - Đã được khôi phục
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 50, 40, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Danh sách Xe máy', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                      const SizedBox(height: 10),
                      Text('Tìm kiếm chiếc xe hoàn hảo từ bộ sưu tập của chúng tôi', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    ],
                  ),
                ),

                // 2. THANH LỌC DANH MỤC (Nằm trong Card trắng đẹp mắt)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                            const SizedBox(width: 10),
                            Text('Lọc theo Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 15,
                          children: _controller.categories.map((cat) {
                            String hienThi = cat == 'All' ? 'Tất cả' : (cat == 'Scooter' ? 'Xe tay ga' : (cat == 'Sport' ? 'Xe thể thao' : 'Xe số'));
                            bool isSelected = _controller.selectedCategory == cat;

                            return ChoiceChip(
                              label: Text(hienThi, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 15)),
                              selected: isSelected,
                              selectedColor: const Color(0xFFCC0000),
                              backgroundColor: Colors.grey[100],
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: const BorderSide(color: Colors.transparent)),
                              onSelected: (_) => _controller.filterByCategory(cat),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 3. LƯỚI HIỂN THỊ SẢN PHẨM (Responsive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1000 ? 3 : (constraints.maxWidth > 700 ? 2 : 1);
                      final displayedProducts = _controller.filteredProducts;

                      if (displayedProducts.isEmpty) {
                        return Center(
                            child: Padding(
                                padding: const EdgeInsets.all(80.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.two_wheeler, size: 80, color: Colors.grey[300]),
                                    const SizedBox(height: 20),
                                    Text('Chưa có xe nào trong danh mục này', style: TextStyle(color: Colors.grey[500], fontSize: 18))
                                  ],
                                )
                            )
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: displayedProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(displayedProducts[index], context);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                // FOOTER
                const CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- THIẾT KẾ CARD SẢN PHẨM (Đã bỏ phần Màu sắc) ---
  Widget _buildProductCard(ProductModel product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailView(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Khối Hình ảnh
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), color: Colors.grey[100]),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.two_wheeler, size: 80, color: Colors.black12))),
                    ),
                  ),
                  // Tem Danh mục
                  Positioned(top: 15, left: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(15)), child: Text(product.category == 'Scooter' ? 'Xe tay ga' : (product.category == 'Sport' ? 'Xe thể thao' : 'Xe số'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))),
                  // Tem Đời xe
                  Positioned(top: 15, right: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(15)), child: Text(product.year, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),

            // Khối Thông tin
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                    const SizedBox(height: 8),
                    Text(product.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5)),

                    // Đoạn hiển thị Row "Màu sắc" đã được gỡ bỏ hoàn toàn

                    const Spacer(),
                    const Divider(color: Colors.black12),
                    const Spacer(),

                    // Khối Giá bán và Nút mũi tên
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Giá từ', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(product.price, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFFCC0000), shape: BoxShape.circle), child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}