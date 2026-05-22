# 🏍️ Đồ án Chuyên đề 2: Ứng dụng Bán Xe Máy Honda (Flutter & Firebase)

**Honda Motorcycle Sales App** là mã nguồn dự án Đồ án Chuyên đề 2. Mục tiêu của dự án là xây dựng một nền tảng thương mại điện tử thực tế bằng Flutter, chuyên biệt cho mảng bán lẻ và dịch vụ xe máy (mô phỏng đại lý HEAD Honda).

Ứng dụng được thiết kế tối ưu Responsive, hoạt động mượt mà và đồng nhất trên cả môi trường Web (PC) và thiết bị di động (Mobile/Tablet).

---

## 👥 Nhóm phát triển

*   **Nguyễn Văn Quân** - 20224113 (Nhóm trưởng)
*   **Bùi Bảo Khang** - 20224346
*   **Trần Anh Trung** - 20224343

---

## ✨ Danh sách toàn bộ tính năng của hệ thống

Hệ thống được phát triển hoàn thiện với quy mô lớn, tích hợp đầy đủ các luồng nghiệp vụ thực tế, bóc tách thành 2 phân hệ độc lập: **Khách hàng (User App)** và **Quản trị viên (Admin Dashboard)**.

### 👤 1. Phân hệ Khách hàng (User App)

**1.1. Xác thực và Quản lý tài khoản (Authentication & Profile)**
*   **Đăng nhập & Đăng ký:** Xác thực tài khoản người dùng an toàn bằng Email và Mật khẩu (Firebase Auth).
*   **Khôi phục mật khẩu:** Tính năng quên mật khẩu kết nối với API của Google để gửi trực tiếp link đặt lại mật khẩu về hộp thư Email thực của khách hàng.
*   **Quản lý hồ sơ (Profile):** Cập nhật thông tin cá nhân (Tên hiển thị, Số điện thoại).
*   **Ảnh đại diện (Avatar):** Upload và thay đổi ảnh đại diện trực tiếp từ thiết bị (lưu trữ qua ImgBB / Firebase).

**1.2. Giao diện Trang chủ & Điều hướng (Home & Navigation)**
*   **Banner Quảng cáo (Hero Section):** Hiển thị các sự kiện nổi bật với hiệu ứng trượt mượt mà (FadeInUp animations).
*   **Điều hướng thông minh:** Custom Header và Footer động, tự động co giãn và thu gọn thành ngăn kéo (Drawer) khi sử dụng trên Mobile.
*   **Gợi ý sản phẩm:** Tự động đề xuất các dòng "Xe bán chạy" và "Khuyến mãi đặc biệt" ngay trên trang chủ.

**1.3. Khám phá & Chi tiết Sản phẩm (Product Discovery)**
*   **Danh mục sản phẩm:** Phân loại xe theo các phân khúc: Xe tay ga (Scooter), Xe số (Cub), Xe thể thao/Côn tay (Sport).
*   **Card sản phẩm:** Thiết kế lưới (Grid) chống tràn nội dung, hiển thị giá niêm yết, tên xe và hình ảnh thu nhỏ.
*   **Trang chi tiết (Product Detail):** Trình bày thông số kỹ thuật chuyên sâu (Năm sản xuất, Mô tả động cơ, Giá bán lẻ).
*   **Thư viện ảnh động (Multi-image Gallery):** Hỗ trợ xem nhiều góc độ của xe. Khi người dùng nhấp vào ảnh thu nhỏ (thumbnail), ảnh trung tâm cỡ lớn sẽ lập tức cập nhật tương ứng.

**1.4. Đánh giá & Tương tác (Rating & Review)**
*   **Chấm điểm (Rating):** Khách hàng có thể để lại số điểm từ 1 đến 5 sao cho từng mẫu xe.
*   **Bình luận (Review):** Cho phép viết cảm nhận chi tiết.
*   **Đồng bộ dữ liệu:** Hệ thống tự động trích xuất Tên và Ảnh đại diện (Avatar) mới nhất của người dùng từ CSDL để gán vào bình luận.

**1.5. Giỏ hàng & Thanh toán điện tử (Shopping Cart & Checkout)**
*   **Quản lý giỏ hàng:** Thêm, xóa sản phẩm, điều chỉnh số lượng mua.
*   **Tính toán thời gian thực:** Cập nhật tự động tổng số tiền hóa đơn dựa trên số lượng.
*   **Mã giảm giá (Coupon/Voucher):** Cho phép nhập mã khuyến mãi để giảm trừ trực tiếp vào tổng hóa đơn.
*   **Phương thức thanh toán linh hoạt:**
    *   Thanh toán tiền mặt khi nhận xe tại đại lý (COD).
    *   **Thanh toán điện tử MoMo:** Tích hợp trực tiếp API MoMo Sandbox. Khởi tạo giao dịch bằng mã QR, xử lý đối chiếu bảo mật thông qua thuật toán mã hóa **HMAC SHA256**. Nhận callback trả về kết quả thanh toán (Thành công / Thất bại).

**1.6. Dịch vụ Khách hàng & Dashboard (Customer Services)**
*   **Đặt lịch lái thử (Test Drive):** Biểu mẫu đăng ký chọn dòng xe, ngày giờ và thông tin liên lạc gửi thẳng tới đại lý.
*   **Theo dõi đơn hàng (Order History):** Bảng điều khiển riêng cho khách hàng để xem các đơn hàng đã đặt, theo dõi trạng thái vận chuyển (Chờ xác nhận, Đang xử lý, Đã thanh toán, Hoàn thành).
*   **Lịch bảo dưỡng (Maintenance):** Quản lý các lịch hẹn bảo dưỡng định kỳ với HEAD.
*   **Liên hệ & Tin tức:** Trang biểu mẫu gửi thắc mắc (Contact) và cập nhật tin tức (News).
*   **Chatbox:** Tích hợp nút bong bóng chat (Floating action button) hỗ trợ kết nối nhanh với bộ phận CSKH.

---

### 👑 2. Phân hệ Quản trị (Admin Dashboard)

**2.1. Phân quyền & Bảo mật (Role-based Access)**
*   Hệ thống định tuyến (Routing) tự động nhận diện tài khoản có phân quyền "Admin" để mở khóa chức năng và hiển thị thanh Menu "Trang Quản Trị". Chặn truy cập trái phép.

**2.2. Bảng Điều Khiển Tổng Quan (Analytics Dashboard)**
*   Thống kê trực quan các chỉ số kinh doanh cốt lõi: 
    *   Tổng doanh thu toàn hệ thống.
    *   Số lượng đơn hàng đang có.
    *   Tổng số lượng xe đã bán ra.
    *   Quy mô tổng số lượng khách hàng đã đăng ký.

**2.3. Quản lý Kho Xe (Product Management - CRUD)**
*   **Nghiệp vụ cơ bản:** Thêm mới, Sửa thông số (Giá, Kho, Mô tả), Xóa sản phẩm.
*   **Tối ưu hóa tài nguyên ảnh (ImgBB API Integration):** Phát triển tính năng tải lên đa ảnh (Multi-upload) thông qua API của máy chủ ImgBB. Thay vì tiêu tốn dung lượng Firebase Storage, hệ thống sẽ đẩy ảnh thẳng lên ImgBB, sau đó lấy URL trả về để lưu vào CSDL, tiết kiệm băng thông và tối ưu hóa chi phí vận hành nền tảng đám mây.

**2.4. Quản lý Đơn hàng & Tồn kho (Order Management)**
*   **Kiểm duyệt đơn:** Hiển thị danh sách toàn bộ đơn hàng của khách. Admin có quyền cập nhật trạng thái.
*   **Đồng bộ Tồn kho tự động:** Hệ thống kích hoạt trigger tính toán: Khi một đơn hàng chuyển sang trạng thái "Thành công", số lượng xe tương ứng sẽ tự động bị trừ khỏi tổng Tồn kho của cơ sở dữ liệu.

**2.5. Quản lý Tương tác & Khách hàng**
*   **Quản lý Khách hàng (Users):** Xem danh sách tài khoản người dùng, thông tin liên hệ.
*   **Quản lý Đăng ký Lái thử (Test Drives):** Xem xét lịch hẹn, thông tin khách hàng muốn trải nghiệm xe.
*   **Quản lý Liên hệ (Contacts):** Xử lý các biểu mẫu thắc mắc, phản hồi chất lượng dịch vụ từ mục Contact.

---

## 💻 Kiến trúc & Công nghệ nền tảng

*   **Frontend (Giao diện):** Ngôn ngữ `Dart` kết hợp framework `Flutter SDK`.
*   **State Management:** Sử dụng gói `Provider` để quản lý trạng thái luồng dữ liệu (Giỏ hàng, Thông tin User) liên tục giữa các màn hình mà không bị đứt gãy.
*   **Backend & Database:** 
    *   Triển khai trên nền tảng `Firebase` (Authentication, Cloud Firestore). 
    *   Sử dụng NoSQL với khả năng đồng bộ dữ liệu Real-time.
*   **Tích hợp APIs:**
    *   Cổng thanh toán điện tử **MoMo API**.
    *   Lưu trữ hình ảnh **ImgBB API**.
*   **Bảo mật Biến môi trường:** Triển khai thư viện `flutter_dotenv` để cô lập các mã khóa bí mật (API Keys) trong file `.env`. File này được bảo vệ bởi `.gitignore` nhằm ngăn chặn nguy cơ lộ lọt dữ liệu lên mã nguồn mở.

---

## 🚀 Hướng dẫn Thiết lập & Chạy dự án cục bộ

Vui lòng thực hiện các bước sau để cấu hình và chạy dự án trên môi trường máy tính cá nhân:

**1. Tải mã nguồn**
```bash
git clone https://github.com/minhquan-01/flutter_project_21.git
cd flutter_project_21
```

**2. Cài đặt các gói phụ thuộc (Dependencies)**
```bash
flutter pub get
```

**3. Cấu hình file Biến môi trường (.env)**
Do yêu cầu bảo mật, file `.env` đã được loại bỏ khỏi kho lưu trữ. Vui lòng tạo một file mới có tên là `.env` (nằm ở thư mục gốc của dự án, ngang hàng với `pubspec.yaml`), sau đó khai báo các giá trị sau:
```env
# API Key của MoMo Sandbox (Sử dụng để tạo giao dịch thanh toán)
MOMO_PARTNER_CODE=nhap_partner_code_cua_ban
MOMO_ACCESS_KEY=nhap_access_key_cua_ban
MOMO_SECRET_KEY=nhap_secret_key_cua_ban

# API Key của ImgBB (Sử dụng cho tính năng tải ảnh của Admin)
IMGBB_API_KEY=nhap_api_key_imgbb_cua_ban
```
*(Lưu ý: Nếu không khai báo khóa API của MoMo, tính năng thanh toán sẽ báo lỗi kết nối, tuy nhiên các luồng chức năng khác của ứng dụng vẫn sẽ hoạt động bình thường).*

**4. Khởi chạy Ứng dụng (Môi trường Web)**
Dự án có gọi các APIs ngoại vi. Khi chạy debug trên nền tảng Web, trình duyệt có thể chặn kết nối do chính sách CORS. Vui lòng chạy lệnh sau để tạm vô hiệu hóa bảo mật chéo của trình duyệt (khuyên dùng trình duyệt Chrome):
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

---

## 📂 Tổ chức Cấu trúc Thư mục
Dự án được phân chia theo kiến trúc MVC thu gọn, bóc tách rõ ràng Logic và Giao diện:
```text
lib/
 ┣ Controllers/     # Tầng nghiệp vụ (Business Logic): ProductController, AuthController, MoMoController.
 ┣ Models/          # Định nghĩa cấu trúc đối tượng dữ liệu: ProductModel, ReviewModel.
 ┣ Views/           # Tầng giao diện người dùng (UI): HomeView, AdminView, CartView.
 ┃ ┣ Widgets/       # Các khối Component tái sử dụng: CustomHeader, CustomFooter, ProductCard.
 ┣ main.dart        # Tệp tin khởi chạy ứng dụng, thiết lập biến môi trường và khởi tạo Firebase.
```
