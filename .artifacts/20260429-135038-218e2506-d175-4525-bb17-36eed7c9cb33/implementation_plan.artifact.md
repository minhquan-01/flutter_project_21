# Hệ thống đặt lịch bảo dưỡng và sửa chữa từ Admin cho User

Cho phép Admin lên lịch bảo dưỡng/sửa chữa dựa trên yêu cầu từ trang liên hệ của User, và hiển thị lịch này trên bảng điều khiển của User.

## User Review Required

> [!IMPORTANT]
> Admin sẽ chọn ngày bảo dưỡng và xe của khách hàng (dựa trên danh sách xe khách đã mua hoặc nhập tay) để tạo lịch.

## Proposed Changes

### [Models]

#### [contact_model.dart](file:///C:/CD2/flutter_project_21-main/lib/Models/contact_model.dart)
- Thêm trường `userId` vào `ContactRequest` để Admin biết tin nhắn này của ai.

### [Controllers]

#### [NEW] [maintenance_controller.dart](file:///C:/CD2/flutter_project_21-main/lib/Controllers/maintenance_controller.dart)
- Quản lý việc tạo lịch bảo dưỡng trong Firestore (collection `maintenance_schedules`).
- Lấy danh sách lịch bảo dưỡng cho User hiện tại.

### [Views]

#### [contact_view.dart](file:///C:/CD2/flutter_project_21-main/lib/Views/contact_view.dart)
- Truyền `userId` của user hiện tại khi gửi form liên hệ.

#### [contact_admin_view.dart](file:///C:/CD2/flutter_project_21-main/lib/Views/contact_admin_view.dart)
- Thêm nút "Lên lịch bảo dưỡng" cho các tin nhắn có chủ đề "Bảo dưỡng / Sửa chữa".
- Hiển thị Dialog để Admin chọn ngày, giờ và mô tả công việc.

#### [customer_dashboard_view.dart](file:///C:/CD2/flutter_project_21-main/lib/Views/customer_dashboard_view.dart)
- Thay đổi phần `_buildMaintenanceSchedule` để lấy dữ liệu thật từ Firestore thay vì dữ liệu mẫu.

## Verification Plan

### Manual Verification
1. Đăng nhập tài khoản User, vào trang Liên hệ, gửi yêu cầu với chủ đề "Bảo dưỡng / Sửa chữa".
2. Đăng nhập tài khoản Admin, vào mục "Tin nhắn liên hệ".
3. Kiểm tra xem nút "Lên lịch" có xuất hiện ở tin nhắn vừa gửi không.
4. Nhấn "Lên lịch", chọn ngày và lưu lại.
5. Quay lại tài khoản User, vào Bảng điều khiển và kiểm tra xem lịch bảo dưỡng đã hiện lên chưa.
