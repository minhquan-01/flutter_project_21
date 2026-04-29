import 'package:flutter/material.dart';
import 'Widgets/custom_header.dart';
import 'Widgets/custom_footer.dart';

class NewsDetailView extends StatelessWidget {
  final Map<String, dynamic> newsItem;

  const NewsDetailView({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    double paddingX = isMobile ? 20 : 60;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(activeTab: 'news'),
      drawer: CustomHeader.buildDrawer(context, 'news'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Ảnh
            Container(
              width: double.infinity,
              height: isMobile ? 300 : 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(newsItem['img'] ?? 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?q=80&w=2070'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: 40),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFCC0000)),
                        label: const Text('Quay lại Tin tức', style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      
                      // Category & Date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(5)),
                            child: Text(newsItem['category'] ?? 'Tin tức', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 15),
                          Text(newsItem['date'] ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 25),
                      
                      // Title
                      Text(
                        newsItem['title'] ?? '',
                        style: TextStyle(fontSize: isMobile ? 28 : 42, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),
                      
                      // Content (Excerpt as content for now)
                      Text(
                        newsItem['excerpt'] ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.6, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Honda Việt Nam luôn nỗ lực mang đến những trải nghiệm tốt nhất cho khách hàng thông qua việc liên tục cập nhật công nghệ và thiết kế. Mẫu xe này không chỉ là một phương tiện di chuyển mà còn là biểu tượng của phong cách và hiệu suất đỉnh cao.\n\nChúng tôi tin rằng với những cải tiến vượt bậc, dòng sản phẩm này sẽ tiếp tục dẫn đầu thị trường và nhận được sự tin yêu từ cộng đồng yêu xe máy trên toàn quốc. Hãy cùng chờ đón và trải nghiệm sự khác biệt!",
                        style: TextStyle(fontSize: 16, height: 1.8, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
