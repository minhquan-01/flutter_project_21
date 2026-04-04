import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/contact_model.dart';

class ContactController {
  // --- CHỨC NĂNG MỚI THEO YÊU CẦU CỦA THẦY ---

  // 1. Chức năng gọi điện thoại
  Future<void> callPhone(String phoneNumber) async {
    // Sửa định dạng số điện thoại để loại bỏ dấu cách (ví dụ từ "1800-123" thành "1800123")
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Không thể thực hiện cuộc gọi đến $phoneNumber');
    }
  }

  // 2. Chức năng gửi Email
  Future<void> sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Không thể gửi email đến $email');
    }
  }

  // 3. Chức năng mở bản đồ thực tế đến địa điểm trong ảnh Khang gửi
  // Địa chỉ chính xác: HEAD Honda Hanoi showroom, 198 Trần Quang Khải, Lý Thái Tổ, Hoàn Kiếm, Hà Nội
  Future<void> openMap() async {
    // Link bản đồ chính xác cho địa điểm HEAD Honda Hanoi Showroom
    const mapUrl = "https://www.google.com/maps/search/?api=1&query=HEAD+Honda+Hanoi+showroom+198+Trần+Quang+Khải";

    final Uri uri = Uri.parse(mapUrl);
    if (await canLaunchUrl(uri)) {
      // Ép buộc mở trong trình duyệt ngoài hoặc ứng dụng maps của điện thoại
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Không thể mở bản đồ.');
    }
  }

  // --- HÀM GỬI FORM CŨ - CHUYỂN SANG TIẾNG VIỆT ---
  void submitForm(BuildContext context, ContactRequest request) {
    if (request.name.isEmpty || request.message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ tên và lời nhắn của bạn!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Giả lập gửi thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cảm ơn ${request.name}! Yêu cầu của bạn đã được gửi đến Honda.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}