// import 'package:flutter/material.dart';
// import 'package:nest_mobile/group_management.dart';
// import 'package:nest_mobile/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SettingScreen extends StatelessWidget {
//   const SettingScreen({super.key});
//
//   Future<void> _logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // Xóa toàn bộ dữ liệu đã lưu trong SharedPreferences
//
//     // Chuyển hướng về màn hình đăng nhập và xóa lịch sử điều hướng
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => AuthScreen()),
//           (Route<dynamic> route) => false, // Xóa toàn bộ các trang trước đó
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thông tin tài khoản
//             ListTile(
//               leading: const CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/user_avatar.jpg'), // Avatar giả lập
//                 radius: 24,
//               ),
//               title: const Text('Con', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               subtitle: const Text('Tài khoản nhỏ', style: TextStyle(color: Colors.grey)),
//               trailing: IconButton(
//                 icon: const Icon(Icons.swap_horiz),
//                 onPressed: () {
//                   // Chuyển đổi tài khoản
//                 },
//               ),
//             ),
//
//             const Divider(),
//
//             // Các tùy chọn cài đặt
//             ListTile(
//               leading: const Icon(Icons.group, color: Colors.red),
//               title: const Text('Quản lý nhóm gia đình'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const GroupManagementScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings, color: Colors.grey),
//               title: const Text('Cài đặt tài khoản'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const GroupManagementScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
//               onTap: () => _logout(context),
//             ),
//             const Divider(),
//
//             // Tiêu đề Premium
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               color: Colors.white, // Đặt màu nền để nổi bật
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Text('Đăng ký ', style: TextStyle(fontSize: 16)),
//                       Text(
//                         'PREMIUM',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15), // Khoảng cách giữa tiêu đề và hình ảnh
//
//                   // Ảnh Premium
//                   Container(
//                     width: double.infinity,
//                     height: 620,
//                     margin: const EdgeInsets.symmetric(horizontal: 0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: Image.asset(
//                       'assets/images/premium.png',
//                       width: double.infinity,
//                       height: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//
//                   // Nút đăng ký
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         ),
//                         onPressed: () {
//                           // Chuyển đến trang thanh toán Premium
//                         },
//                         child: const Text(
//                           'ĐĂNG KÝ',
//                           style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:nest_mobile/group_management.dart';
import 'package:nest_mobile/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _name = "Người dùng"; // Giá trị mặc định
  String _avatar = "assets/images/user_avatar.jpg"; // Ảnh mặc định nếu không có avatar

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "Người dùng";
      _avatar = prefs.getString('avatar') ?? "assets/images/user_avatar.jpg";
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu đã lưu trong SharedPreferences

    // Chuyển hướng về màn hình đăng nhập và xóa lịch sử điều hướng
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
          (Route<dynamic> route) => false, // Xóa toàn bộ các trang trước đó
    );
  }

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
              leading: CircleAvatar(
                backgroundImage: _avatar.startsWith("http")
                    ? NetworkImage(_avatar)
                    : AssetImage(_avatar) as ImageProvider, // Kiểm tra ảnh từ URL hay file cục bộ
                radius: 24,
              ),
              title: Text(_name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              onTap: () => _logout(context),
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
