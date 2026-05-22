import 'package:flutter/material.dart';
import '../../Controllers/auth_controller.dart';
import '../auth_view.dart';
import '../admin_view.dart';
import '../products_view.dart';
import '../home_view.dart';
import '../contact_view.dart';
import '../customer_dashboard_view.dart';
import '../news_view.dart';
import '../cart_view.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String activeTab;

  const CustomHeader({super.key, required this.activeTab});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  // Drawer cho mobile
  static Widget buildDrawer(BuildContext context, String activeTab) {
    return ListenableBuilder(
      listenable: AuthController.instance,
      builder: (context, _) {
        final auth = AuthController.instance;
        return Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
          ),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFCC0000)),
                margin: EdgeInsets.zero,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
                      if (auth.isLoggedIn)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(auth.currentUserEmail, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(context, Icons.home_outlined, 'Trang chủ', 'home', activeTab),
                    _buildDrawerItem(context, Icons.motorcycle_outlined, 'Sản phẩm', 'products', activeTab),
                    _buildDrawerItem(context, Icons.contact_support_outlined, 'Liên hệ', 'contact', activeTab),
                    _buildDrawerItem(context, Icons.newspaper_outlined, 'Tin tức', 'news', activeTab),

                    if (auth.isLoggedIn && !auth.isAdmin)
                      _buildDrawerItem(context, Icons.dashboard_outlined, 'Bảng điều khiển', 'dashboard', activeTab),

                    if (auth.isAdmin)
                      _buildDrawerItem(context, Icons.admin_panel_settings_outlined, 'Quản trị', 'admin', activeTab),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.person_outline, color: auth.isLoggedIn ? const Color(0xFFCC0000) : Colors.black87),
                title: Text(auth.isLoggedIn ? 'Đăng xuất' : 'Đăng nhập', style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  if (auth.isLoggedIn) {
                    auth.logout();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthView()));
                  }
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String tabId, String activeTab) {
    bool isActive = activeTab == tabId;
    return ListTile(
      leading: Icon(icon, color: isActive ? const Color(0xFFCC0000) : Colors.black87),
      title: Text(title, style: TextStyle(color: isActive ? const Color(0xFFCC0000) : Colors.black87, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      selected: isActive,
      onTap: () {
        Navigator.pop(context);
        if (isActive) return;

        if (tabId == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminView()));
        } else if (tabId == 'contact') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContactScreen()));
        } else if (tabId == 'dashboard') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboardView()));
        } else if (tabId == 'news') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NewsView()));
        } else if (tabId == 'products') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 1200;

    return ListenableBuilder(
        listenable: AuthController.instance,
        builder: (context, _) {
          final auth = AuthController.instance;

          return AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            leading: !isDesktop ? Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87),
                onPressed: () {
                  if (Scaffold.of(ctx).hasDrawer) {
                    Scaffold.of(ctx).openDrawer();
                  } else {
                    // Mở menu dạng Drawer trượt từ mép trái màn hình
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Menu',
                      barrierColor: Colors.black54,
                      transitionDuration: const Duration(milliseconds: 250),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 300,
                            height: double.infinity,
                            child: buildDrawer(context, activeTab),
                          ),
                        );
                      },
                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        );
                      },
                    );
                  }
                },
              ),
            ) : null,
            titleSpacing: isDesktop ? 40 : 15,

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFCC0000), borderRadius: BorderRadius.circular(8)),
                    child: const Text('HONDA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                  ),
                ),

                if (isDesktop)
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildNavText(context, 'Trang chủ', 'home'),
                            _buildNavText(context, 'Sản phẩm', 'products'),
                            _buildNavText(context, 'Liên hệ', 'contact'),
                            _buildNavText(context, 'Tin tức', 'news'),

                            if (auth.isLoggedIn && !auth.isAdmin)
                              _buildNavText(context, 'Bảng điều khiển', 'dashboard'),

                            if (auth.isAdmin)
                              _buildNavText(context, 'Quản trị (Admin)', 'admin'),
                          ],
                        ),
                      ),
                    ),
                  ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView())),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 5),
                      IconButton(
                        icon: Icon(
                            Icons.person_outline,
                            color: auth.isLoggedIn ? const Color(0xFFCC0000) : Colors.black87
                        ),
                        onPressed: () {
                          if (auth.isLoggedIn) {
                            if (auth.isAdmin) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminView()));
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboardView()));
                            }
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthView()));
                          }
                        },
                      ),
                      if (auth.isLoggedIn)
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.black87),
                          onPressed: () {
                            auth.logout();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
                          },
                        ),
                    ],
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildNavText(BuildContext context, String text, String tabId) {
    bool isActive = activeTab == tabId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InkWell(
        onTap: () {
          if (isActive) return;
          if (tabId == 'admin') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminView()));
          else if (tabId == 'contact') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContactScreen()));
          else if (tabId == 'dashboard') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboardView()));
          else if (tabId == 'news') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NewsView()));
          else if (tabId == 'products') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductsView()));
          else Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(color: isActive ? const Color(0xFFCC0000) : Colors.grey[800], fontWeight: isActive ? FontWeight.bold : FontWeight.w500, fontSize: 15)),
            if (isActive) Container(margin: const EdgeInsets.only(top: 5), height: 2, width: 25, color: const Color(0xFFCC0000)),
          ],
        ),
      ),
    );
  }
}