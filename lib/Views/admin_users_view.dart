import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  String _formatDate(Timestamp? ts) {
    if (ts == null) return 'N/A';
    final d = ts.toDate();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 850;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quản lý Khách hàng', style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A24))),
                const SizedBox(height: 5),
                Text('Danh sách tài khoản khách hàng đã đăng ký', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 30),
                _buildUsersTable(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(padding: EdgeInsets.all(60), child: Center(child: CircularProgressIndicator(color: Color(0xFFCC0000))));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('Chưa có khách hàng nào')));
          }

          var docs = snapshot.data!.docs.toList();
          // Sort client-side by createdAt descending
          docs.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final tsA = dataA['createdAt'] as Timestamp?;
            final tsB = dataB['createdAt'] as Timestamp?;
            if (tsA == null && tsB == null) return 0;
            if (tsA == null) return 1;
            if (tsB == null) return -1;
            return tsB.compareTo(tsA);
          });

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    horizontalMargin: 30, headingRowHeight: 60, dataRowMinHeight: 70, dataRowMaxHeight: 70,
                    headingTextStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 13),
                    columns: const [
                      DataColumn(label: Text('Khách hàng')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Số điện thoại')),
                      DataColumn(label: Text('Ngày đăng ký')),
                    ],
                    rows: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['name']?.toString().isNotEmpty == true) ? data['name'] : 'Chưa cập nhật';
                      final email = data['email'] ?? 'Không có';
                      final phone = (data['phone']?.toString().isNotEmpty == true) ? data['phone'] : 'Chưa cập nhật';

                      return DataRow(cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                backgroundImage: (data['avatarUrl'] != null && data['avatarUrl'].toString().isNotEmpty) 
                                    ? NetworkImage(data['avatarUrl']) : null,
                                child: (data['avatarUrl'] == null || data['avatarUrl'].toString().isEmpty) 
                                    ? const Icon(Icons.person, color: Colors.grey) : null,
                              ),
                              const SizedBox(width: 10),
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          )
                        ),
                        DataCell(Text(email)),
                        DataCell(Text(phone)),
                        DataCell(Text(_formatDate(data['createdAt'] as Timestamp?))),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}
