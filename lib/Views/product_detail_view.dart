import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controllers/product_controller.dart';
import '../Models/product_model.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';
import 'Widgets/chat_box.dart';
import '../Models/review_model.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductController _controller = ProductController();
  Future<List<ReviewModel>>? _reviewsFuture;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _controller.getReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      floatingActionButton: const ChatBox(),
      appBar: const CustomHeader(activeTab: 'products'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 20 : 40, 30, isMobile ? 20 : 40, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
                  label: const Text('Quay lại', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                child: isMobile
                    ? Column(
                  children: [
                    _buildImageArea(),
                    const SizedBox(height: 30),
                    _buildInfoArea(context, formatter, isMobile),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildImageArea()),
                    const SizedBox(width: 50),
                    Expanded(flex: 1, child: _buildInfoArea(context, formatter, isMobile)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            _buildReviewsSection(isMobile),
            const SizedBox(height: 100),
            _buildRelatedProductsSection(isMobile),
            const SizedBox(height: 80),
            CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    List<String> images = widget.product.imageUrls.isNotEmpty ? widget.product.imageUrls : [widget.product.imageUrl];
    String currentImage = images[_selectedImageIndex];

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)]),
          padding: const EdgeInsets.all(40),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(currentImage, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.two_wheeler, size: 100, color: Colors.grey))
            ),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedImageIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImageIndex = index),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? const Color(0xFFCC0000) : Colors.transparent, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(images[index], fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
      ],
    );
  }

  Widget _buildInfoArea(BuildContext context, NumberFormat formatter, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBadges(),
        const SizedBox(height: 20),
        Text(widget.product.name, style: TextStyle(fontSize: isMobile ? 32 : 42, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A24), height: 1.2)),
        const SizedBox(height: 8),
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                if (index < widget.product.rating.floor()) return const Icon(Icons.star, color: Colors.orange, size: 20);
                if (index < widget.product.rating) return const Icon(Icons.star_half, color: Colors.orange, size: 20);
                return const Icon(Icons.star_border, color: Colors.orange, size: 20);
              }),
            ),
            const SizedBox(width: 8),
            Text('${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} đánh giá)', style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text('Phiên bản ${widget.product.year}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        const SizedBox(height: 25),
        _buildStockInfo(isMobile),
        const SizedBox(height: 35),
        const Text('Thông tin chi tiết', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(widget.product.desc, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6)),
        const SizedBox(height: 40),

        // Thẻ bao bọc Giá bán và Nút bấm
        Container(
          padding: EdgeInsets.all(isMobile ? 20 : 30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giá bán lẻ đề xuất', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              const SizedBox(height: 5),
              Text(widget.product.price, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              isMobile
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBuyBtn(context),
                  const SizedBox(height: 15),
                  _buildTestDriveBtn(context),
                ],
              )
                  : Row(
                children: [
                  Expanded(child: _buildBuyBtn(context)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTestDriveBtn(context)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Nút mua hàng
  Widget _buildBuyBtn(BuildContext context) => ElevatedButton.icon(
    icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 20),
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    onPressed: () async {
      try {
        await _controller.addToCart(widget.product);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Đã thêm sản phẩm vào giỏ hàng!'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ));
        }
      }
    },
    label: const Text('Mua Hàng', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
  );

  Widget _buildTestDriveBtn(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[100], elevation: 0, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    onPressed: () => _showTestDriveDialog(context, widget.product.name),
    child: const Text('Đăng ký Lái thử', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
  );

  // Dialog đăng ký lái thử
  void _showTestDriveDialog(BuildContext context, String bikeName) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    DateTime? selectedDate;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSTB) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Đăng ký lái thử $bikeName', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFCC0000))),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nhân viên HEAD sẽ gọi xác nhận lịch với bạn.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 20),
                  TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Họ và tên *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 15),
                  TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Số điện thoại *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context, initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)),
                        builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFFCC0000))), child: child!),
                      );
                      if (date != null) setStateSTB(() => selectedDate = date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedDate == null ? 'Chọn ngày *' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}', style: TextStyle(color: selectedDate == null ? Colors.grey[700] : Colors.black, fontSize: 16)),
                          const Icon(Icons.calendar_month, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: isLoading ? null : () => Navigator.pop(ctx), child: const Text('Hủy', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: isLoading ? null : () async {
                if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đủ thông tin!'), backgroundColor: Colors.red));
                  return;
                }
                setStateSTB(() => isLoading = true);
                try {
                  await FirebaseFirestore.instance.collection('test_drives').add({
                    'bikeName': bikeName, 'customerName': nameCtrl.text, 'phone': phoneCtrl.text,
                    'date': selectedDate!.toIso8601String(), 'status': 'Chờ xác nhận', 'createdAt': DateTime.now().toIso8601String(),
                  });
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!'), backgroundColor: Colors.green));
                  }
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
                }
                setStateSTB(() => isLoading = false);
              },
              child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Gửi Đăng Ký', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedProductsSection(bool isMobile) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 60), color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40), child: const Text('BẠN CÓ THỂ THÍCH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
              const SizedBox(height: 40),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  if (_controller.isLoading) return const Center(child: CircularProgressIndicator());
                  final relatedItems = _controller.allProducts.where((p) => p.id != widget.product.id).take(4).toList();
                  if (relatedItems.isEmpty) return const SizedBox.shrink();
                  return GridView.builder(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isMobile ? 2 : 4, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 0.75),
                    itemCount: relatedItems.length,
                    itemBuilder: (context, index) => _buildSmallProductCard(relatedItems[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallProductCard(ProductModel p) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductDetailView(product: p))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Icon(Icons.two_wheeler)))),
            Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 5), Text(p.price, style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 14))]))
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() => Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(20)), child: Text(widget.product.category == 'Scooter' ? 'Xe tay ga' : (widget.product.category == 'Sport' ? 'Xe thể thao' : 'Xe số'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)));

  Widget _buildStockInfo(bool isMobile) => Wrap(spacing: 15, runSpacing: 10, children: [_infoTag(Icons.inventory_2, 'Còn hàng: ${widget.product.stock} chiếc', Colors.green), _infoTag(Icons.shopping_cart, 'Đã bán: ${widget.product.sold} chiếc', Colors.blue)]);

  Widget _infoTag(IconData icon, String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: color), const SizedBox(width: 5), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold))]));

  // Phần đánh giá
  Widget _buildReviewsSection(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    const Text('Đánh Giá Sản Phẩm', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                      label: const Text('Viết đánh giá', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000)),
                      onPressed: () => _showReviewDialog(context),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<ReviewModel>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                  
                  final reviews = snapshot.data ?? [];
                  if (reviews.isEmpty) return const Text('Chưa có đánh giá nào cho sản phẩm này.', style: TextStyle(color: Colors.grey));

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    separatorBuilder: (c, i) => const Divider(height: 40),
                    itemBuilder: (context, index) {
                      final r = reviews[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          r.userAvatar.isNotEmpty
                              ? CircleAvatar(backgroundImage: NetworkImage(r.userAvatar))
                              : CircleAvatar(backgroundColor: Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Row(children: List.generate(5, (i) => Icon(i < r.rating ? Icons.star : Icons.star_border, color: Colors.orange, size: 16))),
                                    const SizedBox(width: 10),
                                    Text(DateFormat('dd/MM/yyyy HH:mm').format(r.createdAt), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(r.comment, style: const TextStyle(fontSize: 15, height: 1.4)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    double selectedRating = 5;
    final commentCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSTB) => AlertDialog(
          title: const Text('Viết Đánh Giá', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bạn cảm thấy thế nào về sản phẩm này?'),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(index < selectedRating ? Icons.star : Icons.star_border, color: Colors.orange, size: 36),
                      onPressed: () => setStateSTB(() => selectedRating = index + 1.0),
                    );
                  }),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: commentCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Chia sẻ trải nghiệm của bạn...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: isLoading ? null : () => Navigator.pop(ctx), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000)),
              onPressed: isLoading ? null : () async {
                if (commentCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập bình luận!'), backgroundColor: Colors.red));
                  return;
                }
                setStateSTB(() => isLoading = true);
                try {
                  await _controller.addReview(widget.product.id, selectedRating, commentCtrl.text.trim());
                  setState(() {
                    _reviewsFuture = _controller.getReviews(widget.product.id); // Reload
                  });
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!'), backgroundColor: Colors.green));
                  }
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red));
                }
                setStateSTB(() => isLoading = false);
              },
              child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Gửi Đánh Giá', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}