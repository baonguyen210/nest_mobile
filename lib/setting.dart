import 'package:flutter/material.dart';
import 'package:nest_mobile/group_management.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin tài khoản
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_avatar.jpg'), // Avatar giả lập
                radius: 24,
              ),
              title: const Text('Con', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text('Tài khoản nhỏ', style: TextStyle(color: Colors.grey)),
              trailing: IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () {
                  // Chuyển đổi tài khoản
                },
              ),
            ),

            const Divider(),

            // Các tùy chọn cài đặt
            ListTile(
              leading: const Icon(Icons.group, color: Colors.red),
              title: const Text('Quản lý nhóm gia đình'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupManagementScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Cài đặt tài khoản'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GroupManagementScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
              onTap: () {

              },
            ),
            const Divider(),

            // Tiêu đề Premium
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Colors.white, // Đặt màu nền để nổi bật
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Đăng ký ', style: TextStyle(fontSize: 16)),
                      Text(
                        'PREMIUM',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15), // Khoảng cách giữa tiêu đề và hình ảnh

                  // Ảnh Premium
                  Container(
                    width: double.infinity,
                    height: 620,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/premium.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Nút đăng ký
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // Chuyển đến trang thanh toán Premium
                        },
                        child: const Text(
                          'ĐĂNG KÝ',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
