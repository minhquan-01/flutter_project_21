import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 850;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tổng quan hệ thống', style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A24))),
          const SizedBox(height: 5),
          Text('Chào mừng Admin, đây là số liệu thống kê trực tiếp từ máy chủ', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 30),

          // 1. DÃY THẺ THỐNG KÊ
          LayoutBuilder(
            builder: (context, constraints) {
              double spacing = 15;
              double cardWidth = isMobile
                  ? (constraints.maxWidth - spacing) / 2
                  : (constraints.maxWidth - (spacing * 3)) / 4;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _buildStatCard('Tổng Xe', 'products', Icons.two_wheeler, Colors.blue, cardWidth, isMobile),
                  _buildStatCard('Đơn hàng', 'orders', Icons.receipt_long, Colors.orange, cardWidth, isMobile),
                  _buildStatCard('Khách hàng', 'users', Icons.people_outline, Colors.purple, cardWidth, isMobile),
                  _buildStatCard('Lái thử', 'test_drives', Icons.calendar_today, Colors.green, cardWidth, isMobile),
                ],
              );
            },
          ),

          const SizedBox(height: 40),

          // 2. KHU VỰC BIỂU ĐỒ MÔ PHỎNG & HOẠT ĐỘNG
          isMobile
              ? Column(
                  children: [
                    _buildDashboardBox('Tỷ lệ danh mục xe (Real-time)', _buildDynamicPieChart()),
                    const SizedBox(height: 20),
                    _buildDashboardBox('Thống kê Tồn Kho & Đã Bán (Top 5)', _buildInventoryBarChart()),
                    const SizedBox(height: 20),
                    _buildDashboardBox('Hoạt động gần đây', _buildActivities()),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildDashboardBox('Tỷ lệ danh mục xe trong hệ thống (Real-time)', _buildDynamicPieChart())),
                        const SizedBox(width: 30),
                        Expanded(flex: 2, child: _buildDashboardBox('Hoạt động hệ thống', _buildActivities())),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildDashboardBox('Thống kê Tồn Kho & Đã Bán (Top 5 Sản Phẩm)', _buildInventoryBarChart()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String collection, IconData icon, Color color, double width, bool isMobile) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        String count = snapshot.hasData ? snapshot.data!.docs.length.toString() : '...';
        return Container(
          width: width,
          padding: EdgeInsets.all(isMobile ? 15 : 25),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: isMobile ? 18 : 24, child: Icon(icon, color: color, size: isMobile ? 20 : 24)),
              SizedBox(height: isMobile ? 10 : 20),
              Text(count, style: TextStyle(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(title, style: TextStyle(color: Colors.grey, fontSize: isMobile ? 12 : 14)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardBox(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          child,
        ],
      ),
    );
  }

  // BIỂU ĐỒ TRÒN SỬ DỤNG FL_CHART
  Widget _buildDynamicPieChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
        
        final docs = snapshot.data!.docs;
        int tayGa = 0; int xeSo = 0; int theThao = 0; int khac = 0;
        
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final cat = data['category']?.toString().toLowerCase() ?? '';
          if (cat.contains('scooter') || cat.contains('tay ga')) tayGa++;
          else if (cat.contains('cub') || cat.contains('xe số')) xeSo++;
          else if (cat.contains('sport') || cat.contains('thể thao') || cat.contains('côn')) theThao++;
          else khac++;
        }
        
        int total = docs.length;
        if (total == 0) return const SizedBox(height: 250, child: Center(child: Text("Chưa có sản phẩm nào")));

        return SizedBox(
          height: 250,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      if (tayGa > 0) PieChartSectionData(color: const Color(0xFFE53935), value: tayGa.toDouble(), title: '${(tayGa/total*100).toStringAsFixed(0)}%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (xeSo > 0) PieChartSectionData(color: const Color(0xFF1E88E5), value: xeSo.toDouble(), title: '${(xeSo/total*100).toStringAsFixed(0)}%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (theThao > 0) PieChartSectionData(color: const Color(0xFFFB8C00), value: theThao.toDouble(), title: '${(theThao/total*100).toStringAsFixed(0)}%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (khac > 0) PieChartSectionData(color: const Color(0xFF757575), value: khac.toDouble(), title: '${(khac/total*100).toStringAsFixed(0)}%', radius: 50, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIndicator(const Color(0xFFE53935), 'Tay ga ($tayGa)'),
                    const SizedBox(height: 12),
                    _buildIndicator(const Color(0xFF1E88E5), 'Xe số ($xeSo)'),
                    const SizedBox(height: 12),
                    _buildIndicator(const Color(0xFFFB8C00), 'Thể thao ($theThao)'),
                    if (khac > 0) ...[
                      const SizedBox(height: 12),
                      _buildIndicator(const Color(0xFF757575), 'Khác ($khac)'),
                    ]
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF424242))),
      ],
    );
  }

  // BIỂU ĐỒ CỘT - THỐNG KÊ TỒN KHO & ĐÃ BÁN (TOP 5)
  Widget _buildInventoryBarChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
        
        var docs = snapshot.data!.docs;
        if (docs.isEmpty) return const SizedBox(height: 300, child: Center(child: Text("Chưa có sản phẩm nào")));

        // Lấy top 5 sản phẩm bán chạy nhất
        docs.sort((a, b) {
          int soldA = (a.data() as Map<String, dynamic>)['sold'] ?? 0;
          int soldB = (b.data() as Map<String, dynamic>)['sold'] ?? 0;
          return soldB.compareTo(soldA);
        });
        
        final top5 = docs.take(5).toList();
        List<BarChartGroupData> barGroups = [];
        double maxY = 0;

        for (int i = 0; i < top5.length; i++) {
          final data = top5[i].data() as Map<String, dynamic>;
          double stock = (data['stock'] ?? 0).toDouble();
          double sold = (data['sold'] ?? 0).toDouble();
          if (stock > maxY) maxY = stock;
          if (sold > maxY) maxY = sold;

          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: sold, color: Colors.blue, width: 16, borderRadius: BorderRadius.circular(4)),
                BarChartRodData(toY: stock, color: Colors.green, width: 16, borderRadius: BorderRadius.circular(4)),
              ],
            )
          );
        }

        // Tăng maxY thêm chút để biểu đồ không bị sát nóc
        maxY = maxY + (maxY * 0.2);
        if (maxY == 0) maxY = 10;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildIndicator(Colors.blue, 'Đã bán'),
                const SizedBox(width: 20),
                _buildIndicator(Colors.green, 'Tồn kho'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= top5.length) return const SizedBox();
                          final name = (top5[value.toInt()].data() as Map<String, dynamic>)['name'] ?? '';
                          // Lấy chữ đầu tiên hoặc cắt ngắn
                          String shortName = name.length > 10 ? '${name.substring(0, 10)}...' : name;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(shortName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5 > 0 ? maxY / 5 : 1,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivities() => Column(
    children: [
      _buildActivityItem('Khách hàng mới vừa tạo tài khoản trên hệ thống.'),
      _buildActivityItem('Một đơn hàng lái thử xe SH 160i vừa được duyệt.'),
      _buildActivityItem('Hệ thống báo cáo tồn kho Vision đang ở mức thấp.'),
      _buildActivityItem('Thanh toán MoMo thành công cho đơn hàng #HD098.'),
    ],
  );

  Widget _buildActivityItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 5), child: Icon(Icons.circle, size: 8, color: Color(0xFFCC0000))),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.5))),
        ],
      ),
    );
  }
}
