import 'package:flutter/material.dart';
import 'package:nest_mobile/group_management.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
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
              icon: const Icon(Icons.swap_horiz), // Thay đổi biểu tượng thành "Chuyển đổi tài khoản"
              onPressed: () {
                // Thêm chức năng chuyển đổi tài khoản ở đây
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
              // Chuyển đến cài đặt tài khoản
            },
          ),
          const Divider(),

          // Tiêu đề Premium
          ExpansionTile(
            title: Row(
              children: [
                const Text('Đăng ký ', style: TextStyle(fontSize: 16)),
                Text('PREMIUM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            children: [
              // Mô phỏng khoảng trống cho hình ảnh Premium
              Container(
                width: double.infinity,
                height: 300, // Giữ chỗ cho hình ảnh Premium
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Màu nền mô phỏng
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Hình ảnh gói Premium sẽ được thêm vào đây',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

              // Nút đăng ký
              Padding(
                padding: const EdgeInsets.all(16),
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
        ],
      ),
    );
  }
}
