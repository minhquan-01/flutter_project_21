// Vị trí lưu: lib/views/products_view.dart
import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import 'product_detail_view.dart'; // Đã thêm dòng gọi trang Chi tiết

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
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(8)),
              child: const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
            ),
            const Spacer(),
            if (MediaQuery.of(context).size.width > 600) ...[
              _buildNavText('Home', false),
              _buildNavText('Products', true),
              _buildNavText('Contact', false),
              _buildNavText('Admin', false),
              const Spacer(),
            ],
            const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            const SizedBox(width: 15),
            const Icon(Icons.person_outline, color: Colors.black87),
            const SizedBox(width: 10),
          ],
        ),
      ),

      body: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Our Motorcycles', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                        const SizedBox(height: 8),
                        Text('Find your perfect ride from our collection', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                              const SizedBox(width: 10),
                              Text('Filter by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            children: _controller.categories.map((cat) {
                              bool isSelected = _controller.selectedCategory == cat;
                              return ChoiceChip(
                                label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
                                selected: isSelected,
                                selectedColor: Colors.red[700],
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
                                onSelected: (bool selected) {
                                  _controller.changeCategory(cat);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                        final displayedProducts = _controller.filteredProducts;

                        if (displayedProducts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text('Không có xe nào trong danh mục này', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: displayedProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(displayedProducts[index]);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 50,
                          runSpacing: 30,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(5)),
                                    child: const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text('Leading motorcycle manufacturer delivering quality, innovation, and performance since 1948.', style: TextStyle(color: Colors.grey, height: 1.5)),
                                ],
                              ),
                            ),
                            _buildFooterColumn('Quick Links', ['All Products', 'Contact Us', 'About Honda', 'Warranty']),
                            _buildFooterColumn('Customer Service', ['FAQ', 'Financing Options', 'Test Ride']),
                            SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Contact Info', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 15),
                                  _buildContactRow(Icons.location_on, '123 Honda Street, District 1, Ho Chi Minh City'),
                                  _buildContactRow(Icons.phone, '1800-123-456'),
                                  _buildContactRow(Icons.email, 'support@honda.com.vn'),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 20),
                        const Text('© 2026 Honda Motor Co., Ltd. All rights reserved.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  // --- CÁC HÀM HỖ TRỢ VẼ GIAO DIỆN ---

  Widget _buildProductCard(ProductModel product) {
    // Đã bọc nút bấm ở đây để lướt sang trang Chi tiết
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(colors: [Colors.grey[300]!, Colors.grey[100]!], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(color: Colors.red));
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.two_wheeler, size: 80, color: Colors.black12),
                        ),
                      ),
                    ),
                    Positioned(top: 15, left: 15, child: _buildTag(product.category, Colors.black87)),
                    Positioned(top: 15, right: 15, child: _buildTag(product.year, Colors.red[700]!)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
                        const SizedBox(height: 8),
                        Text(product.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5)),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text('Colors: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            const SizedBox(width: 5),
                            ...List.generate(product.colors.length, (index) => _buildColorDot(product.colors[index])),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Starting from', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(product.price, style: TextStyle(color: Colors.red[700], fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.red[700], shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        )
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

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 16, height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!, width: 1)),
    );
  }

  Widget _buildNavText(String text, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: isActive ? Colors.red[700] : Colors.grey[600], fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 15)),
          if (isActive) Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 20, color: Colors.red[700]),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(link, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        )),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red[700], size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5))),
        ],
      ),
    );
  }
}