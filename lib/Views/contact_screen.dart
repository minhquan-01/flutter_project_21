import 'package:flutter/material.dart';
import '../Controllers/contact_controller.dart';
import '../Models/contact_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactController _controller = ContactController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  // Dữ liệu cho phần FAQ (Câu hỏi thường gặp)
  final List<Map<String, String>> faqs = [
    {
      "question": "Chính sách bảo hành xe mới như thế nào?",
      "answer": "Tất cả xe máy Honda mới đều được bảo hành chính hãng 3 năm hoặc 30.000km tùy điều kiện nào đến trước. Khách hàng có thể bảo hành tại mọi HEAD trên toàn quốc."
    },
    {
      "question": "Showroom có hỗ trợ mua xe trả góp không?",
      "answer": "Chúng tôi hỗ trợ trả góp qua thẻ tín dụng và các công ty tài chính với lãi suất cực kỳ hấp dẫn chỉ từ 0%. Thủ tục đơn giản, duyệt hồ sơ trong 15 phút."
    },
    {
      "question": "Tôi có thể đặt lịch lái thử xe ở đâu?",
      "answer": "Bạn có thể gọi trực tiếp vào Hotline hoặc điền form liên hệ bên trên, chọn chủ đề 'Đặt lịch lái thử'. Nhân viên CSKH sẽ gọi lại để xác nhận lịch cho bạn."
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: Colors.white,

      // TÍNH NĂNG CSKH MỚI 1: Nút Live Chat nổi góc dưới màn hình
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showChatDialog(context),
        backgroundColor: const Color(0xFFCC0000),
        icon: const Icon(Icons.support_agent, color: Colors.white),
        label: const Text("Chat với CSKH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(isMobile),
            const Padding(
              padding: EdgeInsets.only(top: 60, bottom: 10),
              child: Text("Liên Hệ Với Chúng Tôi", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Color(0xFF0B1629))),
            ),
            const Text("Kết nối với Honda Showroom Hà Nội. Chúng tôi luôn sẵn sàng hỗ trợ bạn!", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 50),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 100),
              child: isMobile
                  ? Column(children: [_buildLeftInfo(), const SizedBox(height: 40), _buildRightForm(context)])
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildLeftInfo()),
                  const SizedBox(width: 40),
                  Expanded(flex: 2, child: _buildRightForm(context)),
                ],
              ),
            ),

            // TÍNH NĂNG CSKH MỚI 2: Khu vực Câu hỏi thường gặp
            _buildFAQSection(isMobile),

            _buildMapSection(),
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  // --- TÍNH NĂNG CSKH MỚI 1: XỬ LÝ KHUNG CHAT (ĐÃ NÂNG CẤP UI) ---
  void _showChatDialog(BuildContext context) {
    final chatController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias, // Bo góc cho cả khung bên ngoài
          child: SizedBox(
            width: 380, // Chiều rộng chuẩn của một khung chat
            height: 480, // Chiều cao mô phỏng màn hình điện thoại
            child: Column(
              children: [
                // 1. HEADER (Thanh tiêu đề màu Đỏ Honda)
                Container(
                  color: const Color(0xFFCC0000),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      const Text("CSKH Trực tuyến", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white), // Nút X để đóng
                      )
                    ],
                  ),
                ),

                // 2. KHU VỰC LỊCH SỬ CHAT (Nền xám nhạt)
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bong bóng chat từ tự động từ hệ thống
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Chào bạn! Honda Showroom có thể giúp gì cho bạn hôm nay?",
                            style: TextStyle(color: Colors.black87, height: 1.5, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. THANH NHẬP TIN NHẮN BÊN DƯỚI (Input Bar)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          decoration: InputDecoration(
                            hintText: "Nhập tin nhắn...",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), // Bo tròn thành dạng viên thuốc
                              borderSide: BorderSide.none, // Bỏ viền tím mặc định
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200, // Nền ô chữ màu xám nhạt
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Nút gửi hình tròn màu đỏ
                      CircleAvatar(
                        backgroundColor: const Color(0xFFCC0000),
                        radius: 24,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 20),
                          onPressed: () {
                            Navigator.pop(context); // Đóng khung chat
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tin nhắn đã được gửi tới tư vấn viên! Chúng tôi sẽ phản hồi trong chốc lát.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TÍNH NĂNG CSKH MỚI 2: KHUNG CÂU HỎI FAQ ---
  Widget _buildFAQSection(bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 100),
      child: Column(
        children: [
          const Text("Câu Hỏi Thường Gặp (FAQ)", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0B1629))),
          const SizedBox(height: 10),
          const Text("Giải đáp nhanh các thắc mắc phổ biến của khách hàng.", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
            ),
            child: ListView.separated(
              shrinkWrap: true, // Quan trọng để không bị lỗi layout
              physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng lẻ
              itemCount: faqs.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
              itemBuilder: (context, index) {
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(faqs[index]["question"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(faqs[index]["answer"]!, style: const TextStyle(color: Colors.grey, height: 1.5)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC HÀM GIAO DIỆN CŨ (GIỮ NGUYÊN) ---
  Widget _buildNavbar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), color: Colors.red, child: const Text("HONDA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
          const Spacer(),
          if (!isMobile) ...[
            const Text("Trang chủ"), const SizedBox(width: 30),
            const Text("Sản phẩm"), const SizedBox(width: 30),
            const Text("Liên hệ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), const SizedBox(width: 30),
            const Text("Quản trị"),
            const SizedBox(width: 40),
          ],
          const Icon(Icons.shopping_cart_outlined), const SizedBox(width: 20),
          const Icon(Icons.person_outline),
          if (isMobile) ...[
            const SizedBox(width: 20),
            const Icon(Icons.menu, size: 28),
          ]
        ],
      ),
    );
  }

  Widget _buildLeftInfo() {
    return Column(
      children: [
        _infoCard(Icons.phone_outlined, "Điện thoại", "Gọi cho chúng tôi 24/7", "1800-123-456", Colors.red, onTap: () => _controller.callPhone("1800-123-456")),
        const SizedBox(height: 20),
        _infoCard(Icons.email_outlined, "Email", "Gửi phản hồi bất cứ lúc nào", "support.hanoi@honda.com.vn", Colors.red, onTap: () => _controller.sendEmail("support.hanoi@honda.com.vn")),
        const SizedBox(height: 20),
        _infoCard(Icons.location_on_outlined, "Địa chỉ", "Ghé thăm Showroom của chúng tôi", "198 Trần Quang Khải, Lý Thái Tổ,\nHoàn Kiếm, Hà Nội, Việt Nam", Colors.red, onTap: () => _controller.openMap()),
        const SizedBox(height: 20),
        _infoCard(Icons.access_time, "Giờ làm việc", "Thứ Hai - Thứ Sáu: 8:00 - 18:00\nThứ Bảy: 8:00 - 17:00", "Chủ Nhật: 9:00 - 16:00", Colors.red),
      ],
    );
  }

  Widget _buildRightForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gửi Lời Nhắn Cho Chúng Tôi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _customField("Họ và tên *", "Nhập tên của bạn", controller: _nameController)),
              const SizedBox(width: 20),
              Expanded(child: _customField("Địa chỉ Email *", "email_cua_ban@example.com", controller: _emailController)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _customField("Số điện thoại", "Ví dụ: +84 912 345 678", controller: _phoneController)),
              const SizedBox(width: 20),
              Expanded(child: _customField("Chủ đề cần tư vấn *", "Chọn chủ đề", isDropdown: true)),
            ],
          ),
          const SizedBox(height: 20),
          _customField("Nội dung tin nhắn *", "Cho chúng tôi biết chúng tôi có thể giúp gì bạn...", maxLines: 4, controller: _messageController),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC0000), shape: const StadiumBorder()),
              onPressed: () {
                final request = ContactRequest(
                  name: _nameController.text, email: _emailController.text, phone: _phoneController.text, subject: 'Hỗ trợ Showroom HN', message: _messageController.text,
                );
                _controller.submitForm(context, request);
              },
              icon: const Icon(Icons.send_outlined, color: Colors.white),
              label: const Text("Gửi Tin Nhắn", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        children: [
          const Text("Bản Đồ Showroom Hà Nội", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0B1629))),
          const SizedBox(height: 5),
          const Text("198 Trần Quang Khải, Lý Thái Tổ, Hoàn Kiếm, Hà Nội", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _controller.openMap(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 400, width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15)],
                image: const DecorationImage(
                  image: AssetImage('assets/map_hanoi_showroom.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.navigation, size: 40, color: Colors.red),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Nhấn vào bản đồ để nhận chỉ đường chi tiết trên Google Maps", style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      color: Colors.black, padding: EdgeInsets.all(isMobile ? 30 : 60),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _footerColumn("HONDA VIỆT NAM", ["Nhà sản xuất xe máy hàng đầu,", "mang đến chất lượng, đổi mới và,", "hiệu suất từ năm 1996."]),
          const SizedBox(height: 40),
          _footerColumn("Liên kết nhanh", ["Về Honda", "Sản phẩm", "Hệ thống Showroom"]),
          const SizedBox(height: 40),
          _footerColumn("Hỗ trợ khách hàng", ["Câu hỏi thường gặp (FAQ)", "Tư vấn tài chính", "Đặt lịch lái thử"]),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _footerColumn("HONDA VIỆT NAM", ["Nhà sản xuất xe máy hàng đầu,", "mang đến chất lượng, đổi mới và,", "hiệu suất từ năm 1996."]),
          _footerColumn("Liên kết nhanh", ["Về Honda", "Sản phẩm", "Hệ thống Showroom"]),
          _footerColumn("Hỗ trợ khách hàng", ["Câu hỏi thường gặp (FAQ)", "Tư vấn tài chính", "Đặt lịch lái thử"]),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(link, style: const TextStyle(color: Colors.grey)))),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String sub, String content, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white)),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(content, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _customField(String label, String hint, {int maxLines = 1, bool isDropdown = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        isDropdown
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(child: DropdownButton(hint: Text(hint), isExpanded: true, items: const [], onChanged: (v) {})),
        )
            : TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300))),
        ),
      ],
    );
  }
}
