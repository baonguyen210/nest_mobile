// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:nest_mobile/setting.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'message.dart';
// import 'explore.dart';
// import 'calendar.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
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
//   int _selectedTab = 0; // 0: Mọi người, 1: Gia đình ✅
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
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> _posts = [];
//   Map<String, Map<String, String>> _familyMembers = {}; // Lưu ID -> name, avatar
//   Map<String, String> _userNames = {}; // Lưu ID -> name từ API Get all User
//   String _userName = "Người dùng";
//   String _avatarUrl = "assets/images/user_avatar.jpg";
//   String _familyCode = "Đang tải..."; // Mặc định khi chưa có mã
//   int _eventCount = 0;
//
//   String formatTime(String createdAt) {
//     DateTime postTime = DateTime.parse(createdAt).toLocal();
//     DateTime now = DateTime.now();
//     Duration difference = now.difference(postTime);
//
//     if (difference.inSeconds < 60) {
//       return "Vừa xong";
//     } else if (difference.inMinutes < 60) {
//       return "${difference.inMinutes} phút trước";
//     } else if (difference.inHours < 24) {
//       return "${difference.inHours} giờ trước";
//     } else {
//       return DateFormat('dd/MM HH:mm').format(postTime);
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchFamilyData();
//     _loadUserInfo();
//     _fetchEventCount();
//     _fetchFamilyPosts(); // ✅ Đảm bảo luôn tải mã gia đình và bài viết khi mở Trang chủ
//     _fetchPublicPosts();
//     _fetchAllUsers(); // ✅ Gọi API lấy danh sách user
//   }
//
//
//
//   Future<void> _fetchAllUsers() async {
//     try {
//       Dio dio = Dio();
//       String url = "https://platform-family.onrender.com/user/get-all";
//
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         Map<String, String> userMap = {};
//
//         for (var user in response.data["data"]) {
//           userMap[user["_id"]] = user["name"] ?? "Người dùng NEST";
//         }
//
//         setState(() {
//           _userNames = userMap;
//         });
//
//         print("✅ Đã tải danh sách user thành công!");
//       } else {
//         print("⚠️ API trả về lỗi khi lấy danh sách user: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API Get all User: $e");
//     }
//   }
//
//   /// **Lấy name & avatar từ SharedPreferences**
//   Future<void> _loadUserInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userName = prefs.getString('name') ?? "Người dùng";
//       _avatarUrl = prefs.getString('avatar') ?? "assets/images/user_avatar.jpg";
//     });
//   }
//
//   Future<void> _fetchFamilyCode() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//
//       if (familyId == null || familyId.isEmpty) {
//         print("⚠️ Không tìm thấy familyId trong SharedPreferences");
//         return;
//       }
//
//       String url = "https://platform-family.onrender.com/family/get-codeNumber/$familyId";
//       Dio dio = Dio();
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         setState(() {
//           _familyCode = response.data["data"];
//         });
//       } else {
//         print("⚠️ API trả về lỗi khi lấy mã gia đình: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API lấy mã gia đình: $e");
//     }
//   }
//
//   /// **Gọi API lấy bài viết**
//   Future<void> _fetchFamilyPosts() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//
//       if (familyId == null || familyId.isEmpty) {
//         print("⚠️ Không tìm thấy familyId trong SharedPreferences");
//         return;
//       }
//
//       String postUrl = "https://platform-family.onrender.com/post/posts-family?familyId=$familyId";
//       String codeUrl = "https://platform-family.onrender.com/family/get-codeNumber/$familyId";
//
//       Dio dio = Dio();
//
//       // ✅ Gọi API song song để lấy bài viết và mã gia đình
//       final responses = await Future.wait([
//         dio.get(postUrl),
//         dio.get(codeUrl),
//       ]);
//
//       setState(() {
//         // ✅ Cập nhật danh sách bài viết
//         Response postResponse = responses[0];
//         if (postResponse.statusCode == 200 && postResponse.data["ok"] == true) {
//           _posts = List<Map<String, dynamic>>.from(postResponse.data["data"]);
//           _posts.sort((a, b) {
//             DateTime timeA = DateTime.parse(a["createdAt"]);
//             DateTime timeB = DateTime.parse(b["createdAt"]);
//             return timeB.compareTo(timeA);
//           });
//         } else {
//           print("⚠️ API trả về lỗi khi lấy bài viết: ${postResponse.data["message"]}");
//         }
//
//         // ✅ Cập nhật mã gia đình
//         Response codeResponse = responses[1];
//         if (codeResponse.statusCode == 200 && codeResponse.data["ok"] == true) {
//           _familyCode = codeResponse.data["data"];
//         } else {
//           print("⚠️ API trả về lỗi khi lấy mã gia đình: ${codeResponse.data["message"]}");
//         }
//       });
//     } catch (e) {
//       print("❌ Lỗi kết nối API: $e");
//     }
//   }
//
//
//
//   Future<void> _fetchEventCount() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//
//       if (familyId == null || familyId.isEmpty) {
//         print("⚠️ Không tìm thấy familyId trong SharedPreferences");
//         return;
//       }
//
//       String url = "https://platform-family.onrender.com/scheduler/$familyId";
//       Dio dio = Dio();
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         setState(() {
//           _eventCount = response.data["data"].length;
//         });
//       } else {
//         print("⚠️ API trả về lỗi khi lấy sự kiện: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API sự kiện: $e");
//     }
//   }
//
//
//
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
//               Row(
//                 children: [
//                   Icon(Icons.notifications, color: Colors.grey, size: 30),
//                   SizedBox(width: 12),
//                   GestureDetector(
//                     onTap: () => _showFamilySelectionModal(context),
//                     child: Icon(Icons.account_circle, color: Colors.blue.shade900, size: 35),
//                   ),
//                 ],
//               )
//
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
//   // Thông báo sự kiện (Ẩn nếu không có sự kiện nào)
//   Widget _buildEventNotification() {
//     if (_eventCount == 0) return SizedBox(); // ✅ Không hiển thị nếu không có sự kiện
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(10),
//       color: Colors.grey[200],
//       child: Row(
//         children: [
//           Icon(Icons.event, color: Colors.red),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "Bạn có $_eventCount sự kiện cần theo dõi!",
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   // Hộp chia sẻ bài viết
//   /// **Ô chia sẻ bài viết với avatar của người dùng**
//   Widget _buildShareBox(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(10),
//           color: Colors.white,
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: _avatarUrl.startsWith("http")
//                     ? NetworkImage(_avatarUrl)
//                     : AssetImage(_avatarUrl) as ImageProvider,
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _showCreatePostModal(context, _avatarUrl, _userName),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "Chia sẻ với gia đình ngay tại đây...",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10),
//               GestureDetector(
//                 onTap: () async {
//                   List<File> selectedImages = await _pickImagesFromDevice();
//                   _showCreatePostModal(context, _avatarUrl, _userName, selectedImages);
//                 },
//                 child: Icon(Icons.image, color: Colors.green, size: 35),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           "Mã gia đình của bạn: $_familyCode",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//         ),
//         SizedBox(height: 0),
//       ],
//     );
//   }
//
//
//   Future<List<File>> _pickImagesFromDevice() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? pickedFiles = await picker.pickMultiImage();
//
//     if (pickedFiles != null) {
//       return pickedFiles.map((file) => File(file.path)).toList();
//     }
//     return [];
//   }
//
//
//
//   // Tabs giữa "Gia đình" và "Mọi người"
//   int _selectedTab = 0; // 0: Mọi người, 1: Gia đình ✅
//
//   Widget _buildTabs() {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedTab = 0;
//                 _fetchPublicPosts(); // ✅ Load bài viết public khi nhấn tab Mọi người
//               });
//             },
//             child: Container(
//               color: _selectedTab == 0 ? Colors.blue : Colors.grey[300],
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 "Mọi người",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: _selectedTab == 0 ? Colors.white : Colors.black54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedTab = 1;
//                 _fetchFamilyPosts(); // ✅ Load bài viết gia đình khi nhấn tab Gia đình
//               });
//             },
//             child: Container(
//               color: _selectedTab == 1 ? Colors.blue : Colors.grey[300],
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 "Gia đình",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: _selectedTab == 1 ? Colors.white : Colors.black54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   Future<void> _fetchPublicPosts() async {
//     try {
//       await Future.delayed(Duration(seconds: 1)); // ✅ Delay 1 giây trước khi gọi API
//
//       Dio dio = Dio();
//       String url = "https://platform-family.onrender.com/post/posts-public";
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         setState(() {
//           _posts = List<Map<String, dynamic>>.from(response.data["data"]);
//
//           // ✅ Sắp xếp bài viết theo thời gian giảm dần (Mới nhất lên trước)
//           _posts.sort((a, b) {
//             DateTime timeA = DateTime.parse(a["createdAt"]);
//             DateTime timeB = DateTime.parse(b["createdAt"]);
//             return timeB.compareTo(timeA); // Mới nhất trước
//           });
//         });
//
//       } else {
//         print("⚠️ Lỗi khi lấy bài viết public: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API bài viết public: $e");
//     }
//   }
//
//
//
//
//   /// **Gọi API lấy danh sách thành viên & bài viết**
//   Future<void> _fetchFamilyData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//
//       if (familyId == null || familyId.isEmpty) {
//         print("⚠️ Không tìm thấy familyId trong SharedPreferences");
//         return;
//       }
//
//       String memberUrl = "https://platform-family.onrender.com/family/get-members/$familyId";
//       String postUrl = "https://platform-family.onrender.com/post/posts-family?familyId=$familyId";
//       Dio dio = Dio();
//
//       // Gọi API lấy danh sách thành viên
//       Response memberResponse = await dio.get(memberUrl);
//       if (memberResponse.statusCode == 200 && memberResponse.data["ok"] == true) {
//         Map<String, Map<String, String>> memberMap = {};
//
//         // Lưu thông tin admin
//         var admin = memberResponse.data["data"]["admin"];
//         memberMap[admin["_id"]] = {
//           "name": admin["name"],
//           "avatar": admin["avatar"] ?? "assets/images/user_avatar.jpg"
//         };
//
//         // Lưu thông tin các thành viên
//         List<dynamic> members = memberResponse.data["data"]["members"];
//         for (var member in members) {
//           memberMap[member["_id"]] = {
//             "name": member["name"],
//             "avatar": member["avatar"] ?? "assets/images/user_avatar.jpg"
//           };
//         }
//
//         setState(() {
//           _familyMembers = memberMap;
//         });
//       } else {
//         print("⚠️ Lỗi khi lấy danh sách thành viên: ${memberResponse.data["message"]}");
//       }
//
//       // Gọi API lấy bài viết
//       Response postResponse = await dio.get(postUrl);
//       if (postResponse.statusCode == 200 && postResponse.data["ok"] == true) {
//         if (postResponse.data["data"] is List) {
//           setState(() {
//             _posts = List<Map<String, dynamic>>.from(postResponse.data["data"]);
//           });
//         } else {
//           print("⚠️ API bài viết trả về dữ liệu không đúng định dạng");
//         }
//       } else {
//         print("⚠️ Lỗi lấy bài viết: ${postResponse.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API: $e");
//     }
//   }
//
//   void _showFamilySelectionModal(BuildContext context) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//
//       if (token == null) {
//         print("⚠️ Không tìm thấy accessToken!");
//         return;
//       }
//
//       Dio dio = Dio();
//       String url = "https://platform-family.onrender.com/family/get-family-user";
//       Response response = await dio.get(
//         url,
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         List<dynamic> families = response.data["data"];
//
//         showModalBottomSheet(
//           context: context,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           builder: (context) {
//             return Container(
//               padding: EdgeInsets.all(16),
//               height: MediaQuery.of(context).size.height * 0.5, // ✅ Chiều cao vừa phải
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Chọn nhóm gia đình",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: families.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           margin: EdgeInsets.symmetric(vertical: 5),
//                           child: ListTile(
//                             leading: Icon(Icons.family_restroom, color: Colors.blue),
//                             title: Text(
//                               families[index]["name"],
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                             onTap: () async {
//                               await prefs.setString('familyId', families[index]["_id"]);
//                               Navigator.pop(context);
//
//                               setState(() {
//                                 _familyCode = "Đang tải...";
//                               });
//
//                               _fetchFamilyPosts(); // ✅ Tải bài viết trong gia đình
//                               _fetchPublicPosts(); // ✅ Tải bài viết công khai
//                             },
//
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//
//       } else {
//         print("⚠️ API trả về lỗi khi lấy danh sách nhóm gia đình!");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API nhóm gia đình: $e");
//     }
//   }
//
//
//
//   // Danh sách bài viết
//   Widget _buildPostList() {
//     if (_posts.isEmpty) {
//       return const Center(
//         child: Text(
//           "Không có bài viết nào",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: _posts.length,
//       itemBuilder: (context, index) {
//         final post = _posts[index];
//         String authorId = post["author"] ?? "unknown";
//         String authorName = _userNames[authorId] ?? _familyMembers[authorId]?["name"] ?? "Người dùng NEST";
//         String authorAvatar = _familyMembers[authorId]?["avatar"] ?? "assets/images/user_avatar.jpg";
//
//         // ✅ Xử lý null an toàn
//         String formattedTime = formatTime(post["createdAt"] ?? DateTime.now().toIso8601String());
//         List<dynamic> images = post["images"] ?? [];
//
//         return _buildPost(authorName, post["content"] ?? "", authorAvatar, images, formattedTime);
//       },
//     );
//   }
// }
//
// // Một bài viết
// /// **Hiển thị bài viết**
// Widget _buildPost(String user, String content, String avatar, List<dynamic> images, String time) {
//   return Container(
//     padding: EdgeInsets.all(10),
//     margin: EdgeInsets.only(bottom: 10),
//     color: Colors.white,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: avatar.startsWith("http") ? NetworkImage(avatar) : AssetImage(avatar) as ImageProvider,
//             ),
//             SizedBox(width: 10),
//             Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
//             Spacer(),
//             Text(time, style: TextStyle(color: Colors.grey)), // ✅ Hiển thị thời gian đúng cách
//           ],
//         ),
//         SizedBox(height: 5),
//         Text(content),
//         SizedBox(height: 5),
//
//         // ✅ Kiểm tra danh sách ảnh trước khi hiển thị
//         if (images.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: images
//                 .map((img) => ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
//             ))
//                 .toList(),
//           ),
//
//         SizedBox(height: 5),
//         Row(
//           children: [
//             Icon(Icons.favorite, color: Colors.red),
//             SizedBox(width: 5),
//             Text("0"),
//             SizedBox(width: 10),
//             Icon(Icons.comment),
//             Text(" Bình luận"),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
//
//
// void _showCreatePostModal(BuildContext context, String avatarUrl, String userName, [List<File>? initialImages]) {
//   TextEditingController _postController = TextEditingController();
//   List<File> _selectedImages = initialImages ?? []; // ✅ Nhận danh sách ảnh khi mở modal
//
//
//
//   Future<void> _pickImages() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? pickedFiles = await picker.pickMultiImage();
//
//     if (pickedFiles != null) {
//       _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
//     }
//   }
//
//   Future<List<String>> _uploadImages(List<File> images) async {
//     List<String> uploadedUrls = [];
//     if (images.isEmpty) return uploadedUrls;
//
//     try {
//       Dio dio = Dio();
//       FormData formData = FormData.fromMap({
//         "images": images.map((image) => MultipartFile.fromFileSync(image.path)).toList(),
//       });
//
//       Response response = await dio.post(
//         "https://platform-family.onrender.com/upload/multiple",
//         data: formData,
//         options: Options(headers: {'Content-Type': 'multipart/form-data'}),
//       );
//
//       if (response.statusCode == 200 && response.data["urls"] != null) {
//         uploadedUrls = List<String>.from(response.data["urls"]);
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi tải ảnh: $e");
//     }
//
//     return uploadedUrls;
//   }
//
//   Future<void> _createPost(String content) async {
//     if (content.trim().isEmpty && _selectedImages.isEmpty) { // ✅ Kiểm tra bài viết có nội dung hoặc ảnh
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Vui lòng nhập ít nhất 1 ký tự hoặc chọn ảnh!"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? author = prefs.getString('userId');
//       final String? familyId = prefs.getString('familyId');
//
//       if (author == null || familyId == null || familyId.isEmpty) {
//         print("❌ Lỗi: Không tìm thấy userId hoặc familyId!");
//         return;
//       }
//
//       List<String> uploadedImageUrls = await _uploadImages(_selectedImages);
//
//       Dio dio = Dio();
//       final response = await dio.post(
//         'https://platform-family.onrender.com/post/create',
//         data: {
//           "author": author,
//           "familyId": familyId,
//           "content": content,
//           "images": uploadedImageUrls,
//         },
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//
//       if (response.statusCode == 200 && response.data["statusCode"] == 201) {
//         print("✅ Bài viết đã được tạo thành công!");
//
//         // ✅ Hiển thị thông báo "Đăng bài thành công"
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Đăng bài thành công!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         Navigator.pop(context);
//       } else {
//         print("❌ Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}");
//       }
//     } catch (e) {
//       print("🚨 Lỗi kết nối API: $e");
//     }
//   }
//
//
//
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Tạo bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
//                   ],
//                 ),
//                 Divider(),
//
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: avatarUrl.startsWith("http")
//                           ? NetworkImage(avatarUrl)
//                           : AssetImage(avatarUrl) as ImageProvider,
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 10),
//
//                 TextField(
//                   controller: _postController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: "Bạn đang nghĩ gì, $userName?",
//                     border: InputBorder.none,
//                   ),
//                   onChanged: (text) {
//                     setState(() {}); // Cập nhật lại UI để enable/disable nút "Đăng"
//                   },
//                 ),
//
//
//                 SizedBox(height: 10),
//
//                 Wrap(
//                   spacing: 5,
//                   runSpacing: 5,
//                   children: _selectedImages
//                       .map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover))
//                       .toList(),
//                 ),
//
//                 SizedBox(height: 10),
//
//                 Row(
//                   children: [
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.image),
//                       label: Text("Thêm ảnh"),
//                       onPressed: () async {
//                         await _pickImages();
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 10),
//
//                 ElevatedButton(
//                   onPressed: _postController.text.trim().isEmpty
//                       ? null
//                       : () async {
//                     await _createPost(_postController.text);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _postController.text.trim().isEmpty ? Colors.grey : Colors.blue,
//                     minimumSize: Size(double.infinity, 40),
//                   ),
//                   child: Text("Đăng", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
//     },
//   );
// }
//
// Future<void> _createPost(String content, BuildContext context) async {
//   if (content.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Vui lòng nhập nội dung bài viết"), backgroundColor: Colors.red),
//     );
//     return;
//   }
//
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final String? author = prefs.getString('userId');
//     final String? familyId = prefs.getString('familyId');
//
//     if (author == null || familyId == null || familyId.isEmpty) {
//       print("❌ Lỗi: Không tìm thấy thông tin userId hoặc familyId!");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi: Không tìm thấy thông tin người dùng"), backgroundColor: Colors.red),
//       );
//       return;
//     }
//
//     final dio = Dio();
//     print("🚀 Gửi request tạo bài viết...");
//
//     final response = await dio.post(
//       'https://platform-family.onrender.com/post/create',
//       data: {
//         "author": author,
//         "familyId": familyId,
//         "content": content,
//       },
//       options: Options(headers: {'Content-Type': 'application/json'}),
//     );
//
//     print("📩 API Response Status Code: ${response.statusCode}");
//     print("📩 API Response Data: ${response.data}");
//
//     if (response.statusCode == 200 && response.data["statusCode"] == 201) {
//       print("✅ Bài viết đã được tạo thành công!");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.white), // Icon thành công
//               SizedBox(width: 10),
//               Text("Bài viết đã được đăng thành công!"),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating, // Hiển thị dạng popup nổi
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bo góc
//         ),
//       );
//
//
//       Navigator.pop(context);
//     } else {
//       print("❌ Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}"), backgroundColor: Colors.red),
//       );
//     }
//   } catch (e) {
//     print("🚨 Lỗi kết nối API: $e");
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Lỗi kết nối: $e"), backgroundColor: Colors.red),
//     );
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nest_mobile/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message.dart';
import 'explore.dart';
import 'calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class Homepage extends StatefulWidget {
  final int initialIndex;
  Homepage({this.initialIndex = 0}); // Mặc định là 0 (trang chủ)

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  int _selectedTab = 0; // 0: Mọi người, 1: Gia đình ✅

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
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _posts = [];
  Map<String, Map<String, String>> _familyMembers = {}; // Lưu ID -> name, avatar
  Map<String, Map<String, String>> _userNames = {}; // ✅ Lưu cả name & avatar
  String _userName = "Người dùng";
  String _avatarUrl = "assets/images/user_avatar.jpg";
  String _familyCode = "Đang tải..."; // Mặc định khi chưa có mã
  int _eventCount = 0;

  String formatTime(String createdAt) {
    DateTime postTime = DateTime.parse(createdAt).toLocal();
    DateTime now = DateTime.now();
    Duration difference = now.difference(postTime);

    if (difference.inSeconds < 60) {
      return "Vừa xong";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else {
      return DateFormat('dd/MM HH:mm').format(postTime);
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchPublicPosts();
    _fetchFamilyPosts(); // ✅ Đảm bảo luôn tải mã gia đình và bài viết khi mở Trang chủ
    _fetchAllUsers(); // ✅ Gọi API lấy danh sách user
    _loadUserInfo();
    _fetchEventCount();
    _fetchFamilyData();
  }



  Future<void> _fetchAllUsers() async {
    try {
      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/user/get-all";

      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        Map<String, Map<String, String>> userMap = {}; // ✅ Thay đổi: Lưu cả avatar

        for (var user in response.data["data"]) {
          userMap[user["_id"]] = {
            "name": user["name"] ?? "Người dùng NEST",
            "avatar": (user["avatar"] != null && user["avatar"]!.isNotEmpty)
                ? user["avatar"]  // ✅ Dùng avatar từ API
                : "assets/images/user_avatar.jpg" // ✅ Nếu không có, dùng avatar mặc định
          };
        }

        setState(() {
          _userNames = userMap; // ✅ Gán kiểu đúng
        });


        print("✅ Đã tải danh sách user thành công!");
      } else {
        print("⚠️ API trả về lỗi khi lấy danh sách user: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API Get all User: $e");
    }
  }


  /// **Lấy name & avatar từ SharedPreferences**
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? "Người dùng";
      _avatarUrl = prefs.getString('avatar') ?? "assets/images/user_avatar.jpg";
    });
  }

  Future<void> _fetchFamilyCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null || familyId.isEmpty) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String url = "https://platform-family.onrender.com/family/get-codeNumber/$familyId";
      Dio dio = Dio();
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        setState(() {
          _familyCode = response.data["data"];
        });
      } else {
        print("⚠️ API trả về lỗi khi lấy mã gia đình: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API lấy mã gia đình: $e");
    }
  }

  /// **Gọi API lấy bài viết**
  Future<void> _fetchFamilyPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null || familyId.isEmpty) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String postUrl = "https://platform-family.onrender.com/post/posts-family?familyId=$familyId";
      String codeUrl = "https://platform-family.onrender.com/family/get-codeNumber/$familyId";

      Dio dio = Dio();

      // ✅ Gọi API song song để lấy bài viết và mã gia đình
      final responses = await Future.wait([
        dio.get(postUrl),
        dio.get(codeUrl),
      ]);

      setState(() {
        // ✅ Cập nhật danh sách bài viết
        Response postResponse = responses[0];
        if (postResponse.statusCode == 200 && postResponse.data["ok"] == true) {
          _posts = List<Map<String, dynamic>>.from(postResponse.data["data"]);
          _posts.sort((a, b) {
            DateTime timeA = DateTime.parse(a["createdAt"]);
            DateTime timeB = DateTime.parse(b["createdAt"]);
            return timeB.compareTo(timeA);
          });
        } else {
          print("⚠️ API trả về lỗi khi lấy bài viết: ${postResponse.data["message"]}");
        }

        // ✅ Cập nhật mã gia đình
        Response codeResponse = responses[1];
        if (codeResponse.statusCode == 200 && codeResponse.data["ok"] == true) {
          _familyCode = codeResponse.data["data"];
        } else {
          print("⚠️ API trả về lỗi khi lấy mã gia đình: ${codeResponse.data["message"]}");
        }
      });
    } catch (e) {
      print("❌ Lỗi kết nối API: $e");
    }
  }



  Future<void> _fetchEventCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null || familyId.isEmpty) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String url = "https://platform-family.onrender.com/scheduler/$familyId";
      Dio dio = Dio();
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        setState(() {
          _eventCount = response.data["data"].length;
        });
      } else {
        print("⚠️ API trả về lỗi khi lấy sự kiện: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API sự kiện: $e");
    }
  }



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

              // Nút chuyển đổi tài khoản (chỉ icon, không viền xanh)
              Row(
                children: [
                  Icon(Icons.notifications, color: Colors.grey, size: 30),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showFamilySelectionModal(context),
                    child: Icon(Icons.account_circle, color: Colors.blue.shade900, size: 35),
                  ),
                ],
              )

            ],
          ),
        ],
      ),
    );
  }




  // Thông báo sự kiện
  // Thông báo sự kiện (Ẩn nếu không có sự kiện nào)
  Widget _buildEventNotification() {
    if (_eventCount == 0) return SizedBox(); // ✅ Không hiển thị nếu không có sự kiện

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.event, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Bạn có $_eventCount sự kiện cần theo dõi!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }


  // Hộp chia sẻ bài viết
  /// **Ô chia sẻ bài viết với avatar của người dùng**
  Widget _buildShareBox(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: _avatarUrl.startsWith("http")
                    ? NetworkImage(_avatarUrl)
                    : AssetImage(_avatarUrl) as ImageProvider,
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCreatePostModal(context, _avatarUrl, _userName),
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
              GestureDetector(
                onTap: () async {
                  List<File> selectedImages = await _pickImagesFromDevice();
                  _showCreatePostModal(context, _avatarUrl, _userName, selectedImages);
                },
                child: Icon(Icons.image, color: Colors.green, size: 35),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Mã gia đình của bạn: $_familyCode",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 0),
      ],
    );
  }


  Future<List<File>> _pickImagesFromDevice() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      return pickedFiles.map((file) => File(file.path)).toList();
    }
    return [];
  }



  // Tabs giữa "Gia đình" và "Mọi người"
  int _selectedTab = 0; // 0: Mọi người, 1: Gia đình ✅

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = 0;
                _fetchPublicPosts(); // ✅ Load bài viết public khi nhấn tab Mọi người
              });
            },
            child: Container(
              color: _selectedTab == 0 ? Colors.blue : Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Mọi người",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedTab == 0 ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = 1;
                _fetchFamilyPosts(); // ✅ Load bài viết gia đình khi nhấn tab Gia đình
              });
            },
            child: Container(
              color: _selectedTab == 1 ? Colors.blue : Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Gia đình",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedTab == 1 ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _fetchPublicPosts() async {
    try {
      await Future.delayed(Duration(seconds: 1)); // ✅ Delay 1 giây trước khi gọi API

      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/post/posts-public";
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        setState(() {
          _posts = List<Map<String, dynamic>>.from(response.data["data"]);

          // ✅ Sắp xếp bài viết theo thời gian giảm dần (Mới nhất lên trước)
          _posts.sort((a, b) {
            DateTime timeA = DateTime.parse(a["createdAt"]);
            DateTime timeB = DateTime.parse(b["createdAt"]);
            return timeB.compareTo(timeA); // Mới nhất trước
          });
        });

      } else {
        print("⚠️ Lỗi khi lấy bài viết public: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API bài viết public: $e");
    }
  }




  /// **Gọi API lấy danh sách thành viên & bài viết**
  Future<void> _fetchFamilyData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null || familyId.isEmpty) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String memberUrl = "https://platform-family.onrender.com/family/get-members/$familyId";
      String postUrl = "https://platform-family.onrender.com/post/posts-family?familyId=$familyId";
      Dio dio = Dio();

      // Gọi API lấy danh sách thành viên
      Response memberResponse = await dio.get(memberUrl);
      if (memberResponse.statusCode == 200 && memberResponse.data["ok"] == true) {
        Map<String, Map<String, String>> memberMap = {};

        // Lưu thông tin admin
        var admin = memberResponse.data["data"]["admin"];
        memberMap[admin["_id"]] = {
          "name": admin["name"],
          "avatar": admin["avatar"] ?? "assets/images/user_avatar.jpg"
        };

        // Lưu thông tin các thành viên
        List<dynamic> members = memberResponse.data["data"]["members"];
        for (var member in members) {
          memberMap[member["_id"]] = {
            "name": member["name"],
            "avatar": member["avatar"] ?? "assets/images/user_avatar.jpg"
          };
        }

        setState(() {
          _familyMembers = memberMap;
        });
      } else {
        print("⚠️ Lỗi khi lấy danh sách thành viên: ${memberResponse.data["message"]}");
      }

      // Gọi API lấy bài viết
      Response postResponse = await dio.get(postUrl);
      if (postResponse.statusCode == 200 && postResponse.data["ok"] == true) {
        if (postResponse.data["data"] is List) {
          setState(() {
            _posts = List<Map<String, dynamic>>.from(postResponse.data["data"]);
          });
        } else {
          print("⚠️ API bài viết trả về dữ liệu không đúng định dạng");
        }
      } else {
        print("⚠️ Lỗi lấy bài viết: ${postResponse.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API: $e");
    }
  }

  void _showFamilySelectionModal(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("⚠️ Không tìm thấy accessToken!");
        return;
      }

      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/family/get-family-user";
      Response response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data["ok"] == true) {
        List<dynamic> families = response.data["data"];

        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.5, // ✅ Chiều cao vừa phải
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Chọn nhóm gia đình",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: families.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Icon(Icons.family_restroom, color: Colors.blue),
                            title: Text(
                              families[index]["name"],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              await prefs.setString('familyId', families[index]["_id"]);
                              Navigator.pop(context);

                              setState(() {
                                _familyCode = "Đang tải...";
                              });
                              _fetchPublicPosts(); // ✅ Tải bài viết công khai
                              _fetchFamilyPosts(); // ✅ Tải bài viết trong gia đình

                            },

                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );

      } else {
        print("⚠️ API trả về lỗi khi lấy danh sách nhóm gia đình!");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API nhóm gia đình: $e");
    }
  }



  // Danh sách bài viết
  Widget _buildPostList() {
    if (_posts.isEmpty) {
      return const Center(
        child: Text(
          "Không có bài viết nào",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        String authorId = post["author"] ?? "unknown";

        // ✅ Cập nhật: Lấy avatar từ _userNames trước, nếu không có thì dùng _familyMembers
        String authorName = _userNames[authorId] != null ? _userNames[authorId]!["name"] ?? "Người dùng NEST" : _familyMembers[authorId]?["name"] ?? "Người dùng NEST";

        String authorAvatar = _userNames[authorId] != null ? _userNames[authorId]!["avatar"] ?? "assets/images/user_avatar.jpg" : _familyMembers[authorId]?["avatar"] ?? "assets/images/user_avatar.jpg";


        // ✅ Xử lý null an toàn
        String formattedTime = formatTime(post["createdAt"] ?? DateTime.now().toIso8601String());
        List<dynamic> images = post["images"] ?? [];

        return _buildPost(authorName, post["content"] ?? "", authorAvatar, images, formattedTime);
      },
    );
  }
}

// Một bài viết
/// **Hiển thị bài viết**
Widget _buildPost(String user, String content, String avatar, List<dynamic> images, String time) {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(bottom: 10),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: avatar.isNotEmpty
                  ? NetworkImage(avatar) // ✅ Sử dụng avatar từ API nếu có
                  : AssetImage("assets/images/user_avatar.jpg") as ImageProvider, // ✅ Nếu không có, dùng avatar mặc định
            ),
            SizedBox(width: 10),
            Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text(time, style: TextStyle(color: Colors.grey)), // ✅ Hiển thị thời gian đúng cách
          ],
        ),
        SizedBox(height: 5),
        Text(content),
        SizedBox(height: 5),

        // ✅ Kiểm tra danh sách ảnh trước khi hiển thị
        if (images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: images
                .map((img) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
            ))
                .toList(),
          ),

        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 5),
            Text("0"),
            SizedBox(width: 10),
            Icon(Icons.comment),
            Text(" Bình luận"),
          ],
        ),
      ],
    ),
  );
}



void _showCreatePostModal(BuildContext context, String avatarUrl, String userName, [List<File>? initialImages]) {
  TextEditingController _postController = TextEditingController();
  List<File> _selectedImages = initialImages ?? []; // ✅ Nhận danh sách ảnh khi mở modal



  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> uploadedUrls = [];
    if (images.isEmpty) return uploadedUrls;

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "images": images.map((image) => MultipartFile.fromFileSync(image.path)).toList(),
      });

      Response response = await dio.post(
        "https://platform-family.onrender.com/upload/multiple",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 && response.data["urls"] != null) {
        uploadedUrls = List<String>.from(response.data["urls"]);
      }
    } catch (e) {
      print("🚨 Lỗi khi tải ảnh: $e");
    }

    return uploadedUrls;
  }

  Future<void> _createPost(String content) async {
    if (content.trim().isEmpty && _selectedImages.isEmpty) { // ✅ Kiểm tra bài viết có nội dung hoặc ảnh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập ít nhất 1 ký tự hoặc chọn ảnh!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? author = prefs.getString('userId');
      final String? familyId = prefs.getString('familyId');

      if (author == null || familyId == null || familyId.isEmpty) {
        print("❌ Lỗi: Không tìm thấy userId hoặc familyId!");
        return;
      }

      List<String> uploadedImageUrls = await _uploadImages(_selectedImages);

      Dio dio = Dio();
      final response = await dio.post(
        'https://platform-family.onrender.com/post/create',
        data: {
          "author": author,
          "familyId": familyId,
          "content": content,
          "images": uploadedImageUrls,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data["statusCode"] == 201) {
        print("✅ Bài viết đã được tạo thành công!");

        // ✅ Hiển thị thông báo "Đăng bài thành công"
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng bài thành công!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        print("❌ Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}");
      }
    } catch (e) {
      print("🚨 Lỗi kết nối API: $e");
    }
  }




  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tạo bài viết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                Divider(),

                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: avatarUrl.startsWith("http")
                          ? NetworkImage(avatarUrl)
                          : AssetImage(avatarUrl) as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),

                TextField(
                  controller: _postController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Bạn đang nghĩ gì, $userName?",
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {}); // Cập nhật lại UI để enable/disable nút "Đăng"
                  },
                ),


                SizedBox(height: 10),

                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _selectedImages
                      .map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover))
                      .toList(),
                ),

                SizedBox(height: 10),

                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.image),
                      label: Text("Thêm ảnh"),
                      onPressed: () async {
                        await _pickImages();
                        setState(() {});
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: _postController.text.trim().isEmpty
                      ? null
                      : () async {
                    await _createPost(_postController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _postController.text.trim().isEmpty ? Colors.grey : Colors.blue,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text("Đăng", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      });
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
    final String? author = prefs.getString('userId');
    final String? familyId = prefs.getString('familyId');

    if (author == null || familyId == null || familyId.isEmpty) {
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
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    print("📩 API Response Status Code: ${response.statusCode}");
    print("📩 API Response Data: ${response.data}");

    if (response.statusCode == 200 && response.data["statusCode"] == 201) {
      print("✅ Bài viết đã được tạo thành công!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white), // Icon thành công
              SizedBox(width: 10),
              Text("Bài viết đã được đăng thành công!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating, // Hiển thị dạng popup nổi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bo góc
        ),
      );


      Navigator.pop(context);
    } else {
      print("❌ Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}"), backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    print("🚨 Lỗi kết nối API: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi kết nối: $e"), backgroundColor: Colors.red),
    );
  }
}