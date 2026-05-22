import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controllers/product_controller.dart';
import '../Models/product_model.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';
import 'Widgets/chat_box.dart';
import 'products_view.dart';
import 'product_detail_view.dart';
import 'contact_view.dart';
import 'news_view.dart';
import 'cart_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductController _controller = ProductController();
  final NumberFormat _formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomHeader(activeTab: 'home'),
      floatingActionButton: const ChatBox(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(isMobile),
            _buildRedBanner(isMobile),
            _buildFeaturedModels(isMobile),
            _buildWhyChooseUs(isMobile),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  // Phần Hero banner
  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 500 : 650,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1558981403-c5f9899a28bc?q=80&w=2070&auto=format&fit=crop'), // Ảnh motor trên đường núi
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                delay: 100,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: isMobile ? 40 : 65, fontWeight: FontWeight.bold, height: 1.1),
                    children: const [
                      TextSpan(text: 'Sức Mạnh Của Những\n', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Ước Mơ', style: TextStyle(color: Color(0xFFCC0000))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: 300,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    'Khám phá các dòng xe Honda mới nhất. Chất lượng cao cấp, công nghệ đột phá và hiệu năng vượt trội.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: isMobile ? 16 : 18, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: 500,
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Khám phá ngay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContactScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Đăng ký Lái thử', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Banner khuyến mãi
  Widget _buildRedBanner(bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFB30000),
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    FadeInUp(delay: 200, child: _buildBannerItem(Icons.local_offer_outlined, 'Mã Giảm Giá', 'Nhận voucher giảm giá lên đến 5.000.000 VNĐ khi mua các dòng xe chọn lọc!', 'Vào giỏ hàng', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView())))),
                    const SizedBox(height: 20),
                    FadeInUp(delay: 400, child: _buildBannerItem(Icons.newspaper_outlined, 'Tin Tức Nổi Bật', 'Cập nhật những thông tin mới nhất về thị trường xe và các sự kiện hấp dẫn!', 'Xem tin tức', () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NewsView())))),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: FadeInUp(delay: 200, child: _buildBannerItem(Icons.local_offer_outlined, 'Mã Giảm Giá', 'Nhận voucher giảm giá lên đến 5.000.000 VNĐ khi mua các dòng xe chọn lọc!', 'Vào giỏ hàng', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView()))))),
                    const SizedBox(width: 20),
                    Expanded(child: FadeInUp(delay: 400, child: _buildBannerItem(Icons.newspaper_outlined, 'Tin Tức Nổi Bật', 'Cập nhật những thông tin mới nhất về thị trường xe và các sự kiện hấp dẫn!', 'Xem tin tức', () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NewsView()))))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBannerItem(IconData icon, String title, String desc, String btnText, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.5)),
          const SizedBox(height: 20),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(btnText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Xe nổi bật
  Widget _buildFeaturedModels(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              FadeInUp(delay: 100, child: const Text('Sản phẩm Nổi bật', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24)))),
              const SizedBox(height: 10),
              FadeInUp(delay: 200, child: Text('Khám phá những dòng xe bán chạy nhất của chúng tôi', style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
              const SizedBox(height: 50),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  if (_controller.isLoading) return const CircularProgressIndicator(color: Color(0xFFCC0000));
                  
                  // Lọc lấy 4 sản phẩm bán chạy nhất
                  var products = List<ProductModel>.from(_controller.allProducts);
                  products.sort((a, b) => b.sold.compareTo(a.sold));
                  var top4 = products.take(4).toList();

                  if (top4.isEmpty) return const Text('Chưa có sản phẩm nào.');

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isMobile ? 1 : 0.75, // Aspect ratio giống ảnh
                    ),
                    itemCount: top4.length,
                    itemBuilder: (context, index) => FadeInUp(
                      delay: 300 + (index * 100),
                      child: _buildProductCard(top4[index]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              FadeInUp(
                delay: 600,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Xem Tất Cả Sản Phẩm', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    int priceVal = int.tryParse(product.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    String shortPrice = '${(priceVal / 1000000).toStringAsFixed(1)}M VNĐ';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailView(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey[200], child: const Icon(Icons.two_wheeler, size: 80, color: Colors.grey)),
                    ),
                  ),
                  Positioned(
                    top: 15, right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(20)),
                      child: Text(product.year, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text(product.category, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(shortPrice, style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 18)),
                      const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Vì sao chọn Honda
  Widget _buildWhyChooseUs(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 20 : 40),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              FadeInUp(delay: 100, child: const Text('Tại Sao Chọn Honda?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24)))),
              const SizedBox(height: 10),
              FadeInUp(delay: 200, child: Text('Trải nghiệm sự khác biệt từ Honda', style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
              const SizedBox(height: 60),
              isMobile
                  ? Column(
                      children: [
                        _buildFeaturesList(),
                        const SizedBox(height: 40),
                        _buildShowroomImage(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: _buildFeaturesList()),
                        const SizedBox(width: 50),
                        Expanded(flex: 1, child: _buildShowroomImage()),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        FadeInUp(delay: 300, child: _buildFeatureItem(Icons.workspace_premium, 'Chất Lượng Cao Cấp', 'Các mẫu xe máy Honda được chế tạo với độ chính xác cao và vật liệu tốt nhất, đảm bảo độ bền bỉ dài lâu theo thời gian.')),
        const SizedBox(height: 30),
        FadeInUp(delay: 400, child: _buildFeatureItem(Icons.verified_user_outlined, 'Độ Tin Cậy Tuyệt Đối', 'Với hơn 70 năm đổi mới và phát triển, thương hiệu Honda luôn đồng nghĩa với sự uy tín, an toàn và hiệu năng vượt trội.')),
        const SizedBox(height: 30),
        FadeInUp(delay: 500, child: _buildFeatureItem(Icons.sell_outlined, 'Giá Trị Tốt Nhất', 'Tận hưởng khả năng tiết kiệm nhiên liệu, chi phí bảo dưỡng thấp và giá trị bán lại mạnh mẽ với mỗi chiếc xe Honda.')),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A24))),
              const SizedBox(height: 8),
              Text(desc, style: TextStyle(color: Colors.grey[600], height: 1.5)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildShowroomImage() {
    return FadeInUp(
      delay: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          'https://images.unsplash.com/photo-1558980394-4c7c9299fe96?q=80&w=2070&auto=format&fit=crop', // Ảnh showroom (đã sửa link)
          fit: BoxFit.cover,
          height: 400,
          width: double.infinity,
        ),
      ),
    );
  }
}

// Hiệu ứng animation trượt lên
class FadeInUp extends StatefulWidget {
  final Widget child;
  final int delay; // milliseconds

  const FadeInUp({super.key, required this.child, this.delay = 0});

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _offset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
