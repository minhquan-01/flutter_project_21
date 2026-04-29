# Kết quả triển khai Hệ thống đặt lịch Bảo dưỡng

Tôi đã hoàn thành việc xây dựng tính năng lên lịch bảo dưỡng từ Admin và hiển thị cho User.

## Các thay đổi chính

### 1. Cập nhật Model và Luồng dữ liệu
- **Model Contact**: Thêm trường `userId` để khi User gửi yêu cầu liên hệ, Admin sẽ biết chính xác User nào đang cần hỗ trợ để lên lịch tương ứng.
- **Maintenance Controller**: Tạo mới [maintenance_controller.dart](file:///C:/CD2/flutter_project_21-main/lib/Controllers/maintenance_controller.dart) để quản lý việc lưu và tải dữ liệu bảo dưỡng từ Firestore.

### 2. Giao diện Admin ([contact_admin_view.dart](file:///C:/CD2/flutter_project_21-main/lib/Views/contact_admin_view.dart))
- Thêm nút **"Lên lịch bảo dưỡng"** cho các tin nhắn có chủ đề "Bảo dưỡng / Sửa chữa".
- Khi Admin nhấn nút, một hộp thoại hiện ra cho phép:
  - Nhập tên xe / biển số.
  - Chọn ngày bảo dưỡng từ lịch.
  - Nhập nội dung chi tiết (ví dụ: "Thay dầu, kiểm tra định kỳ").

### 3. Giao diện User ([customer_dashboard_view.dart](file:///C:/CD2/flutter_project_21-main/lib/Views/customer_dashboard_view.dart))
- Mục **"Lịch Bảo Dưỡng"** hiện đã lấy dữ liệu thật từ Firestore.
- Hiển thị đầy đủ thông tin: Tên xe, Ngày hẹn, Nội dung bảo dưỡng.
- Thêm tính năng **đếm ngược ngày**: Hệ thống tự động tính toán và hiển thị "Còn x ngày" hoặc "Đã quá hạn" với màu sắc cảnh báo tương ứng (Xanh/Cam/Đỏ).

## Quy trình kiểm tra
1. **User**: Vào trang "Liên hệ", chọn chủ đề "Bảo dưỡng / Sửa chữa" và gửi yêu cầu.
2. **Admin**: Vào mục "Tin nhắn liên hệ", mở tin nhắn vừa nhận, nhấn nút "Lên lịch bảo dưỡng", nhập thông tin và lưu lại.
3. **User**: Quay lại "Bảng điều khiển", kiểm tra mục "Lịch Bảo Dưỡng" để thấy lịch hẹn mới nhất đã xuất hiện.
