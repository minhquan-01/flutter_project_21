// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:honda_app/main.dart';

void main() {
  testWidgets('Contact screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HondaEcommerceApp());

    // Kiểm tra xem tiêu đề trang liên hệ có hiển thị không
    expect(find.text('Liên hệ với Honda Vietnam'), findsOneWidget);

    // Kiểm tra xem nút "GỬI YÊU CẦU" có tồn tại không
    expect(find.text('GỬI YÊU CẦU'), findsOneWidget);
  });
}
