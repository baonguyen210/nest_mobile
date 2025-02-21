// import 'package:flutter/material.dart';
// import 'package:nest_mobile/setting.dart';
// import 'message.dart';
// import 'explore.dart';
// import 'calendar.dart';
//
//
// class Homepage extends StatefulWidget {
//   final int initialIndex;
//   Homepage({this.initialIndex = 0}); // Mặc định là 0 (trang chủ)
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeScreen(), // Trang chủ (màn hình hiện tại)
//     MessageScreen(), // Nhắn tin
//     ExplorePage(), // Khám phá
//     CalendarPage(), // Lịch trình
//     SettingScreen(), // Hồ sơ & Cài đặt
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex; // Lấy tab đã chọn
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue, // Màu khi chọn
//         unselectedItemColor: Colors.grey, // Màu mặc định
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Trang chủ',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message),
//             label: 'Nhắn tin',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Khám phá',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Lịch trình',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Hồ sơ',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -----------------
// // HomeScreen
// // -----------------
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildHeader(context),
//         _buildEventNotification(),
//         _buildTabs(),
//         _buildShareBox(context),
//         Expanded(child: _buildPostList()),
//       ],
//     );
//   }
//
//   // Header với logo, SOS, thông báo, avatar
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Logo Nest (bên trái)
//           Image.asset('assets/images/logo.png', height: 40),
//
//           // Nhóm nút bên phải
//           Row(
//             children: [
//               // Nút SOS (màu đỏ, bo tròn, nhỏ gọn)
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(8), // Làm nút thon hơn
//                 ),
//                 child: Text(
//                   "SOS",
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//               SizedBox(width: 12),
//
//               // Nút thông báo (màu xám, không có viền)
//               Icon(Icons.notifications, color: Colors.grey, size: 30),
//               SizedBox(width: 12),
//
//               // Nút chuyển đổi tài khoản (chỉ icon, không viền xanh)
//               Icon(Icons.account_circle, color: Colors.blue.shade900, size: 35),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   // Thông báo sự kiện
//   Widget _buildEventNotification() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(10),
//       color: Colors.grey[200],
//       child: Row(
//         children: [
//           Icon(Icons.event, color: Colors.red),
//           SizedBox(width: 5),
//           Expanded(
//             child: Text("Hôm nay bạn có 2 sự kiện cần theo dõi!", style: TextStyle(fontSize: 14)),
//           ),
//           Icon(Icons.close, size: 16),
//         ],
//       ),
//     );
//   }
//
//   // Hộp chia sẻ bài viết
//   Widget _buildShareBox(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       color: Colors.white,
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/images/user_avatar.png'),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _showCreatePostModal(context), // Gọi popup khi nhấn vào
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   "Chia sẻ với gia đình ngay tại đây...",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Icon(Icons.image, color: Colors.green, size: 35),
//           SizedBox(width: 2),
//         ],
//       ),
//     );
//   }
//
//
//   // Tabs giữa "Gia đình" và "Mọi người"
//   Widget _buildTabs() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             color: Colors.blue,
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               "Gia đình",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(
//             color: Colors.grey[300],
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               "Mọi người",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Danh sách bài viết
//   Widget _buildPostList() {
//     return ListView(
//       children: [
//         _buildPost(
//           "Ba",
//           "Kỷ niệm cuối năm\nNhờ NEST lưu giữ kỷ niệm cả gia đình cùng đi chơi Hội An vui thật vui cùng nhau!",
//           "Hội An, 31/12/2024",
//           ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
//           2,
//         ),
//         _buildPost(
//           "Mẹ",
//           "Quá nhanh quá nguy hiểm\nĐi chơi thôi!!!",
//           "",
//           ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
//           5,
//         ),
//       ],
//     );
//   }
//
//   // Một bài viết
//   Widget _buildPost(String user, String content, String location, List<String> images, int likes) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.only(bottom: 10),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(backgroundImage: AssetImage('assets/images/user_avatar.png')),
//               SizedBox(width: 10),
//               Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
//               Spacer(),
//               Text("1 giờ trước", style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//           SizedBox(height: 5),
//           Text(content),
//           if (location.isNotEmpty) Text("📍 " + location, style: TextStyle(color: Colors.grey)),
//           SizedBox(height: 5),
//           Row(
//             children: images.map((img) => Expanded(child: Image.asset(img, height: 100))).toList(),
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Icon(Icons.favorite, color: Colors.red),
//               SizedBox(width: 5),
//               Text("$likes"),
//               SizedBox(width: 10),
//               Icon(Icons.comment),
//               Text(" Bình luận"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showCreatePostModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Để popup hiện full màn hình khi cần
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên khi bàn phím xuất hiện
//           ),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Thanh tiêu đề
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Tạo bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 Divider(),
//
//                 // Thông tin người đăng
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: AssetImage('assets/images/user_avatar.png'),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Thành Đạt", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.lock, size: 14),
//                               SizedBox(width: 5),
//                               Text("Gia đình", style: TextStyle(fontSize: 12)),
//                               Icon(Icons.arrow_drop_down, size: 14),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 10),
//
//                 // Ô nhập nội dung bài viết
//                 TextField(
//                   maxLines: 10,
//                   decoration: InputDecoration(
//                     hintText: "Đạt ơi, bạn đang nghĩ gì thế?",
//                     border: InputBorder.none,
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//
//                 // Nút Đăng (disable nếu chưa nhập nội dung)
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Đóng popup khi đăng bài
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Bài viết đã được đăng!"), backgroundColor: Colors.green),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     minimumSize: Size(double.infinity, 40), // Nút full width
//                   ),
//                   child: Text("Đăng", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nest_mobile/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message.dart';
import 'explore.dart';
import 'calendar.dart';


class Homepage extends StatefulWidget {
  final int initialIndex;
  Homepage({this.initialIndex = 0}); // Mặc định là 0 (trang chủ)

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Trang chủ (màn hình hiện tại)
    MessageScreen(), // Nhắn tin
    ExplorePage(), // Khám phá
    CalendarPage(), // Lịch trình
    SettingScreen(), // Hồ sơ & Cài đặt
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Lấy tab đã chọn
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Màu khi chọn
        unselectedItemColor: Colors.grey, // Màu mặc định
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Nhắn tin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch trình',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}

// -----------------
// HomeScreen
// -----------------
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildEventNotification(),
        _buildTabs(),
        _buildShareBox(context),
        Expanded(child: _buildPostList()),
      ],
    );
  }

  // Header với logo, SOS, thông báo, avatar
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Nest (bên trái)
          Image.asset('assets/images/logo.png', height: 40),

          // Nhóm nút bên phải
          Row(
            children: [
              // Nút SOS (màu đỏ, bo tròn, nhỏ gọn)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8), // Làm nút thon hơn
                ),
                child: Text(
                  "SOS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(width: 12),

              // Nút thông báo (màu xám, không có viền)
              Icon(Icons.notifications, color: Colors.grey, size: 30),
              SizedBox(width: 12),

              // Nút chuyển đổi tài khoản (chỉ icon, không viền xanh)
              Icon(Icons.account_circle, color: Colors.blue.shade900, size: 35),
            ],
          ),
        ],
      ),
    );
  }




  // Thông báo sự kiện
  Widget _buildEventNotification() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.event, color: Colors.red),
          SizedBox(width: 5),
          Expanded(
            child: Text("Hôm nay bạn có 2 sự kiện cần theo dõi!", style: TextStyle(fontSize: 14)),
          ),
          Icon(Icons.close, size: 16),
        ],
      ),
    );
  }

  // Hộp chia sẻ bài viết
  Widget _buildShareBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/Facebook.png'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => _showCreatePostModal(context), // Gọi popup khi nhấn vào
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Chia sẻ với gia đình ngay tại đây...",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.image, color: Colors.green, size: 35),
          SizedBox(width: 2),
        ],
      ),
    );
  }


  // Tabs giữa "Gia đình" và "Mọi người"
  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Gia đình",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Mọi người",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Danh sách bài viết
  Widget _buildPostList() {
    return ListView(
      children: [
        _buildPost(
          "Ba",
          "Kỷ niệm cuối năm\nNhờ NEST lưu giữ kỷ niệm cả gia đình cùng đi chơi Hội An vui thật vui cùng nhau!",
          "Hội An, 31/12/2024",
          ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
          2,
        ),
        _buildPost(
          "Mẹ",
          "Quá nhanh quá nguy hiểm\nĐi chơi thôi!!!",
          "",
          ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
          5,
        ),
      ],
    );
  }

  // Một bài viết
  Widget _buildPost(String user, String content, String location, List<String> images, int likes) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/images/Facebook.png')),
              SizedBox(width: 10),
              Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text("1 giờ trước", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 5),
          Text(content),
          if (location.isNotEmpty) Text("📍 " + location, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Row(
            children: images.map((img) => Expanded(child: Image.asset(img, height: 100))).toList(),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 5),
              Text("$likes"),
              SizedBox(width: 10),
              Icon(Icons.comment),
              Text(" Bình luận"),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    TextEditingController _postController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Hiển thị full màn hình nếu cần
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên khi bàn phím xuất hiện
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh tiêu đề
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tạo bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),

                // Thông tin người đăng
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Facebook.png'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Thành Đạt", style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock, size: 14),
                              SizedBox(width: 5),
                              Text("Gia đình", style: TextStyle(fontSize: 12)),
                              Icon(Icons.arrow_drop_down, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Ô nhập nội dung bài viết
                TextField(
                  controller: _postController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Đạt ơi, bạn đang nghĩ gì thế?",
                    border: InputBorder.none,
                  ),
                ),

                SizedBox(height: 10),

                // Nút Đăng (gọi API khi nhấn)
                ElevatedButton(
                  onPressed: () async {
                    await _createPost(_postController.text, context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text("Đăng", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createPost(String content, BuildContext context) async {
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập nội dung bài viết"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? author = prefs.getString('userId');  // Lấy từ SharedPreferences
      final String? familyId = prefs.getString('familyId');  // Lấy từ SharedPreferences

      print("===== DEBUG: Kiểm tra dữ liệu SharedPreferences =====");
      print("User ID (author): $author");
      print("Family ID (familyId): $familyId");
      print("Nội dung bài viết: $content");
      print("====================================================");

      if (author == null || familyId == null) {
        print("❌ Lỗi: Không tìm thấy thông tin userId hoặc familyId!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: Không tìm thấy thông tin người dùng"), backgroundColor: Colors.red),
        );
        return;
      }

      final dio = Dio();
      print("🚀 Gửi request tạo bài viết...");

      final response = await dio.post(
        'https://platform-family.onrender.com/post/create',
        data: {
          "author": author,
          "familyId": familyId,
          "content": content,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("📩 API Response Status Code: ${response.statusCode}");
      print("📩 API Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data["statusCode"] == 201) {
        print("✅ Bài viết đã được tạo thành công!");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bài viết đã được đăng!"), backgroundColor: Colors.green),
        );

        Navigator.pop(context); // Đóng popup sau khi đăng bài thành công
      } else {
        print("❌ Lỗi đăng bài: ${response.data["message"]}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi đăng bài: ${response.data["message"]}"), backgroundColor: Colors.red),
        );
      }

    } catch (e) {
      print("🚨 Lỗi kết nối API: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: $e"), backgroundColor: Colors.red),
      );
    }
  }


}
