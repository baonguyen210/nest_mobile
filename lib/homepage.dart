// import 'dart:io';
// import 'dart:ui';
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
//   Map<String, Map<String, String>> _userNames = {}; // ✅ Lưu cả name & avatar
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
//     _initializeData(); // Gọi hàm async riêng để dùng `await`
//   }
//
//   Future<void> _initializeData() async {
//     // Delay nhẹ để chờ các widget build xong (optional)
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     // Gọi các hàm load dữ liệu song song
//     await Future.wait([
//       _fetchFamilyData(),
//       _fetchPublicPosts(),
//       _fetchFamilyPosts(),
//       _fetchAllUsers(),
//       _loadUserInfo(),
//       _fetchEventCount(),
//     ]);
//   }
//
//
//
//   void _toggleLike(String postId, String userId) async {
//     try {
//       Dio dio = Dio();
//       String url = "https://platform-family.onrender.com/post/reaction/$postId";
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//
//       if (token == null) {
//         print("🚨 Lỗi: Không tìm thấy AccessToken trong SharedPreferences!");
//         return;
//       }
//
//       Response response = await dio.put(
//         url,
//         data: {"userId": userId},
//         options: Options(headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         print("✅ Like thành công!");
//
//         // ✅ Cập nhật danh sách bài viết
//         setState(() {
//           _posts = _posts.map((post) {
//             if (post["_id"] == postId) {
//               bool isLiked = post["userLike"].contains(userId);
//               if (isLiked) {
//                 post["userLike"].remove(userId);
//               } else {
//                 post["userLike"].add(userId);
//               }
//             }
//             return post;
//           }).toList();
//         });
//
//       } else {
//         print("❌ Lỗi khi like bài viết: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("🚨 Lỗi kết nối API like bài viết: $e");
//     }
//   }
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
//         Map<String, Map<String, String>> userMap = {}; // ✅ Thay đổi: Lưu cả avatar
//
//         for (var user in response.data["data"]) {
//           userMap[user["_id"]] = {
//             "name": user["name"] ?? "Người dùng NEST",
//             "avatar": (user["avatar"] != null && user["avatar"]!.isNotEmpty)
//                 ? user["avatar"]  // ✅ Dùng avatar từ API
//                 : "assets/images/user_avatar.jpg" // ✅ Nếu không có, dùng avatar mặc định
//           };
//         }
//
//         setState(() {
//           _userNames = userMap; // ✅ Gán kiểu đúng
//         });
//
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
//               // Khi nhấn vào SOS, hiển thị modal trượt để kích hoạt
//               GestureDetector(
//                 onTap: () {
//                   _showSOSModal(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     "SOS",
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ),
//               ),
//
//
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
//       Dio dio = Dio();
//       String url = "https://platform-family.onrender.com/post/posts-public";
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         setState(() {
//           _posts = List<Map<String, dynamic>>.from(response.data["data"]);
//         });
//       } else {
//         print("⚠️ API trả về lỗi khi lấy bài viết công khai!");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API bài viết công khai: $e");
//     }
//   }
//
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
//   void _showSOSModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false, // Không cho phép đóng khi nhấn ra ngoài
//       enableDrag: false, // Không cho phép kéo xuống để đóng
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         double dragPosition = 0.0;
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: EdgeInsets.all(16),
//               height: 190, // Chiều cao modal
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Vị trí của bạn sẽ được gửi cho mọi người",
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Stack(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       Positioned(
//                         left: dragPosition,
//                         child: GestureDetector(
//                           onHorizontalDragUpdate: (details) {
//                             setState(() {
//                               dragPosition += details.primaryDelta!;
//                               if (dragPosition < 0) dragPosition = 0;
//                               if (dragPosition > MediaQuery.of(context).size.width - 120) {
//                                 dragPosition = MediaQuery.of(context).size.width - 120;
//                                 _sendSOSAlert(context);
//                                 Navigator.pop(context);
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 100,
//                             height: 50,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                             child: Text(
//                               "SOS",
//                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Trượt sang PHẢI để kích hoạt ngay !",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Text(
//                       "Hủy kích hoạt",
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
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
//                               await Future.delayed(Duration(milliseconds: 300));
//
//                               await Future.wait([
//                                 _fetchPublicPosts(),
//                                 _fetchFamilyPosts(),
//                               ]);
//
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
//
//         // ✅ Cập nhật: Lấy avatar từ _userNames trước, nếu không có thì dùng _familyMembers
//         String authorName = _userNames[authorId] != null ? _userNames[authorId]!["name"] ?? "Người dùng NEST" : _familyMembers[authorId]?["name"] ?? "Người dùng NEST";
//
//         String authorAvatar = _userNames[authorId] != null ? _userNames[authorId]!["avatar"] ?? "assets/images/user_avatar.jpg" : _familyMembers[authorId]?["avatar"] ?? "assets/images/user_avatar.jpg";
//
//
//         // ✅ Xử lý null an toàn
//         String formattedTime = formatTime(post["createdAt"] ?? DateTime.now().toIso8601String());
//         List<dynamic> images = post["images"] ?? [];
//
//         return _buildPost(context, post, authorName, authorAvatar, formattedTime);
//
//       },
//     );
//   }
// }
//
// // Một bài viết
// /// **Hiển thị bài viết**
// Widget _buildPost(BuildContext context, Map<String, dynamic> post, String user, String avatar, String time) {
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
//               backgroundImage: avatar.isNotEmpty
//                   ? NetworkImage(avatar)
//                   : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
//             ),
//             SizedBox(width: 10),
//             Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
//             Spacer(),
//             Text(time, style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//         SizedBox(height: 5),
//         Text(post["content"] ?? ""),
//         SizedBox(height: 5),
//         if (post["images"] != null && post["images"].isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: (post["images"] as List).map((img) {
//               return Builder(
//                 builder: (BuildContext ctx) { // ✅ Sử dụng Builder để có context
//                   return GestureDetector(
//                     onTap: () => _showFullImage(ctx, img), // ✅ Truyền context đúng cách
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           ),
//         SizedBox(height: 5),
//         Row(
//           children: [
//             FutureBuilder<String?>(
//               future: SharedPreferences.getInstance().then((prefs) => prefs.getString('userId')),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Row(
//                     children: [
//                       Icon(Icons.favorite_border, color: Colors.red),
//                       SizedBox(width: 5),
//                       Text(post["userLike"].length.toString()),
//                     ],
//                   );
//                 }
//
//                 String userId = snapshot.data!;
//                 bool isLiked = post["userLike"].contains(userId);
//
//                 return GestureDetector(
//                   onTap: () async {
//                     final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
//                     if (homeScreenState != null) {
//                       homeScreenState._toggleLike(post["_id"], userId);
//                     } else {
//                       print("❌ Không tìm thấy _HomeScreenState!");
//                     }
//                   },
//
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.favorite,
//                         color: post["userLike"].contains(userId) ? Colors.red : Colors.grey,
//                         size: 24,
//                       ),
//                       SizedBox(width: 5),
//                       Text(post["userLike"].length.toString()), // ✅ Hiển thị đúng số lượng like
//                     ],
//                   ),
//                 );
//
//               },
//             ),
//             SizedBox(width: 10),
//             GestureDetector(
//               onTap: () {
//                 final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
//                 if (homeScreenState != null) {
//                   _showCommentsModal(context, post["_id"], homeScreenState._userNames);
//                 } else {
//                   print("❌ Không tìm thấy HomeScreenState!");
//                 }
//               },
//               child: Row(
//                 children: [
//                   Icon(Icons.comment, color: Colors.blue),
//                   SizedBox(width: 5),
//                   Text("Bình luận"),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
//
//
// _showCommentsModal(BuildContext ctx, String postId, Map<String, Map<String, String>> userNames) async {
//   print("📩 Đang mở modal bình luận cho bài viết: $postId");
//
//   List<Map<String, dynamic>> comments = await _fetchComments(postId, userNames); // ✅ Sử dụng biến userNames
//
//   print("📝 Số lượng bình luận lấy được: ${comments.length}");
//
//   TextEditingController _commentController = TextEditingController();
//   String? _parentCommentId;
//   String? _replyingTo;
//
//   showModalBottomSheet(
//     context: ctx,
//     isScrollControlled: true,
//     builder: (ctx) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(ctx).viewInsets.bottom,
//             ),
//             child: Container(
//               padding: EdgeInsets.all(16),
//               height: MediaQuery.of(ctx).size.height * 1,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("Bình luận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Divider(),
//                   Expanded(
//                     child: comments.isNotEmpty
//                         ? ListView.builder(
//                       itemCount: comments.length,
//                       itemBuilder: (context, index) {
//                         var comment = comments[index];
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // ✅ Bình luận chính
//                             ListTile(
//                               leading: CircleAvatar(
//                                 backgroundImage: comment["avatar"].startsWith("http")
//                                     ? NetworkImage(comment["avatar"])
//                                     : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
//                               ),
//                               title: Text(comment["authorName"] ?? "Người dùng"),
//                               subtitle: Text(comment["content"]),
//                               trailing: IconButton(
//                                 icon: Icon(Icons.reply, color: Colors.blue),
//                                 onPressed: () {
//                                   setState(() {
//                                     _parentCommentId = comment["id"];
//                                     _replyingTo = comment["authorName"];
//                                   });
//                                 },
//                               ),
//                             ),
//
//                             // ✅ Hiển thị danh sách reply (nếu có)
//                             if (comment["replies"].isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 40.0),
//                                 child: Column(
//                                   children: comment["replies"].map<Widget>((reply) {
//                                     return ListTile(
//                                       leading: CircleAvatar(
//                                         backgroundImage: reply["avatar"].startsWith("http")
//                                             ? NetworkImage(reply["avatar"])
//                                             : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
//                                       ),
//                                       title: Text(reply["authorName"] ?? "Người dùng"),
//                                       subtitle: Text(reply["content"]),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     )
//                         : Center(
//                       child: Text(
//                         "Chưa có bình luận nào, hãy là người đầu tiên bình luận",
//                         style: TextStyle(color: Colors.grey, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (_replyingTo != null) // ✅ Hiển thị dòng "Đang phản hồi"
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Đang phản hồi $_replyingTo",
//                                 style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _replyingTo = null;
//                                     _parentCommentId = null;
//                                   });
//                                 },
//                                 child: Icon(Icons.close, color: Colors.red, size: 20),
//                               ),
//                             ],
//                           ),
//                         ),
//                       TextField(
//                         controller: _commentController,
//                         decoration: InputDecoration(
//                           hintText: "Nhập bình luận...",
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.send, color: Colors.blue),
//                             onPressed: () async {
//                               await _addCommentAndRefreshUI(postId, _commentController.text, _parentCommentId, () async {
//                                 List<Map<String, dynamic>> updatedComments = await _fetchComments(postId, userNames);
//                                 setState(() {
//                                   comments.clear();
//                                   comments.addAll(updatedComments);
//                                 });
//                               });
//
//                               _commentController.clear();
//                               _parentCommentId = null;
//                               _replyingTo = null; // ✅ Reset khi gửi bình luận
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//
//
//
// Future<List<Map<String, dynamic>>> _fetchComments(String postId, Map<String, Map<String, String>> userNames) async {
//   print("🔍 Gọi API lấy bình luận cho bài viết: $postId");
//   List<Map<String, dynamic>> comments = [];
//
//   try {
//     Dio dio = Dio();
//     String url = "https://platform-family.onrender.com/comment/get-comments-post?postId=$postId";
//     Response response = await dio.get(url);
//
//     print("📡 API Response Status Code: ${response.statusCode}");
//     print("📡 API Response Data: ${response.data}");
//
//     if (response.statusCode == 200 && response.data["ok"] == true) {
//       if (response.data["data"] is List) {
//         comments = [];
//
//         for (var comment in response.data["data"]) {
//           String authorId = comment["author"] ?? "";
//           String authorName = userNames[authorId]?["name"] ?? "Người dùng";
//           String authorAvatar = userNames[authorId]?["avatar"] ?? "assets/images/user_avatar.jpg";
//
//           // ✅ Tạo đối tượng bình luận chính
//           Map<String, dynamic> commentData = {
//             "id": comment["_id"],
//             "authorName": authorName,
//             "avatar": authorAvatar,
//             "content": comment["content"] ?? "",
//             "parentCommentId": comment["parentCommentId"],
//             "replies": []
//           };
//
//           // ✅ Xử lý replies (nếu có)
//           if (comment["replies"] != null && comment["replies"] is List) {
//             for (var reply in comment["replies"]) {
//               String replyAuthorId = reply["author"] ?? "";
//               String replyAuthorName = userNames[replyAuthorId]?["name"] ?? "Người dùng";
//               String replyAuthorAvatar = userNames[replyAuthorId]?["avatar"] ?? "assets/images/user_avatar.jpg";
//
//               commentData["replies"].add({
//                 "id": reply["_id"],
//                 "authorName": replyAuthorName,
//                 "avatar": replyAuthorAvatar,
//                 "content": reply["content"] ?? "",
//                 "parentCommentId": reply["parentCommentId"],
//               });
//             }
//           }
//
//           comments.add(commentData);
//         }
//       }
//     }
//     else {
//       print("⚠️ API trả về lỗi khi lấy bình luận: ${response.data["message"]}");
//     }
//   } catch (e) {
//     print("❌ Lỗi kết nối API lấy bình luận: $e");
//   }
//   return comments;
// }
//
//
//
// Future<void> _addCommentAndRefreshUI(
//     String postId, String content, String? parentCommentId, Function refreshComments) async {
//   if (content.isEmpty) return;
//
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final String? userId = prefs.getString('userId');
//
//     if (userId == null) {
//       print("❌ Không tìm thấy UserID trong SharedPreferences!");
//       return;
//     }
//
//     Dio dio = Dio();
//     String url = "https://platform-family.onrender.com/comment/create";
//
//     Map<String, dynamic> requestData = {
//       "postId": postId,
//       "author": userId,
//       "content": content,
//     };
//
//     if (parentCommentId != null) {
//       requestData["parentCommentId"] = parentCommentId;
//     }
//
//     Response response = await dio.post(url, data: requestData);
//
//     if (response.statusCode == 200) {
//       print("✅ Bình luận thành công!");
//
//       // 🔄 **Gọi lại hàm cập nhật bình luận sau khi gửi API thành công**
//       refreshComments();
//     } else {
//       print("⚠️ Lỗi tạo bình luận: ${response.data}");
//     }
//   } catch (e) {
//     print("🚨 Lỗi kết nối API tạo bình luận: $e");
//   }
// }
//
//
//
//
//
// void _showFullImage(BuildContext context, String imageUrl) {
//   showDialog(
//     context: context,
//     barrierDismissible: true, // ✅ Cho phép đóng khi nhấn ra ngoài
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.transparent, // ✅ Đảm bảo không có viền trắng
//         child: Stack(
//           children: [
//             // ✅ Lớp nền làm mờ
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Hiệu ứng mờ
//               child: Container(
//                 color: Colors.grey.withOpacity(0), // ✅ Nền xám nhẹ với độ trong suốt
//               ),
//             ),
//
//             // ✅ Hiển thị ảnh
//             Center(
//               child: InteractiveViewer(
//                 child: Image.network(imageUrl, fit: BoxFit.contain),
//               ),
//             ),
//
//             // ✅ Nút "X" để đóng
//             Positioned(
//               top: 10,
//               right: 10,
//               child: IconButton(
//                 icon: Icon(Icons.close, color: Colors.white, size: 30),
//                 onPressed: () => Navigator.pop(context), // ✅ Đóng modal
//               ),
//             ),
//           ],
//         ),
//       );
//     },
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
//     if (content.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Vui lòng nhập nội dung bài viết"), backgroundColor: Colors.red),
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
//         print("❌ Lỗi: Không tìm thấy thông tin userId hoặc familyId!");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi: Không tìm thấy thông tin người dùng"), backgroundColor: Colors.red),
//         );
//         return;
//       }
//
//       // ✅ Gọi API lấy danh sách thành viên để kiểm tra quyền admin
//       bool isPrivate = true; // Mặc định là private
//       Dio dio = Dio();
//       String memberUrl = "https://platform-family.onrender.com/family/get-members/$familyId";
//
//       Response memberResponse = await dio.get(memberUrl);
//       if (memberResponse.statusCode == 200 && memberResponse.data["ok"] == true) {
//         String adminId = memberResponse.data["data"]["admin"]["_id"];
//         if (author == adminId) {
//           isPrivate = false; // Nếu userId hiện tại là admin thì isPrivate = false
//         }
//       } else {
//         print("⚠️ Lỗi khi lấy danh sách thành viên: ${memberResponse.data["message"]}");
//       }
//
//       print("🚀 Gửi request tạo bài viết... isPrivate: $isPrivate");
//
//       final response = await dio.post(
//         'https://platform-family.onrender.com/post/create',
//         data: {
//           "author": author,
//           "familyId": familyId,
//           "content": content,
//           "isPrivate": isPrivate, // ✅ Thêm giá trị isPrivate vào API
//         },
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//
//       print("📩 API Response Status Code: ${response.statusCode}");
//       print("📩 API Response Data: ${response.data}");
//
//       if (response.statusCode == 200 && response.data["statusCode"] == 201) {
//         print("✅ Bài viết đã được tạo thành công!");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 10),
//                 Text("Bài viết đã được đăng thành công!"),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//
//         Navigator.pop(context);
//       } else {
//         print("❌ Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi đăng bài: ${response.data["message"] ?? "Không có thông báo lỗi"}"), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       print("🚨 Lỗi kết nối API: $e");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi kết nối: $e"), backgroundColor: Colors.red),
//       );
//     }
//   }
//
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
// Future<void> _sendSOSAlert(BuildContext context) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? senderId = prefs.getString('userId');
//     String? familyId = prefs.getString('familyId');
//     String? userName = prefs.getString('name');
//
//     if (senderId == null || familyId == null || userName == null) {
//       print("❌ Không tìm thấy thông tin UserID, FamilyID hoặc UserName");
//       return;
//     }
//
//     // 🔹 Lấy danh sách thành viên trong gia đình
//     Dio dio = Dio();
//     String url = "https://platform-family.onrender.com/family/get-members/$familyId";
//     Response response = await dio.get(url);
//
//     if (response.statusCode != 200 || response.data["ok"] != true) {
//       print("⚠️ API trả về lỗi khi lấy thành viên gia đình: ${response.data}");
//       return;
//     }
//
//     List<dynamic> members = response.data["data"]["members"];
//     String adminId = response.data["data"]["admin"]["_id"];
//
//     // 🔹 Ép kiểu `_id` về String
//     List<String> recipientIds = [adminId];
//     recipientIds.addAll(
//         members.map((m) => m["_id"].toString()).where((id) => id != senderId)
//     ); // Bỏ qua chính mình
//
//     print("👨‍👩‍👧‍👦 Thành viên nhận SOS: $recipientIds");
//
//     String messageText = "$userName đã gửi tín hiệu SOS, kiểm tra ngay!";
//
//     // 🔹 Gửi tin nhắn SOS cho từng thành viên
//     for (String receiverId in recipientIds) {
//       await _sendSOSMessage(senderId, receiverId, messageText);
//     }
//
//     print("✅ Đã gửi SOS Alert đến tất cả thành viên trong gia đình!");
//
//     // ✅ Hiển thị thông báo thành công
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Tín hiệu SOS đã được gửi thành công!"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//
//   } catch (e) {
//     print("❌ Lỗi khi gửi tín hiệu SOS: $e");
//   }
// }
//
//
//
//
// Future<void> _sendSOSMessage(String senderId, String receiverId, String messageText) async {
//   try {
//     Dio dio = Dio();
//     String url = "https://platform-family.onrender.com/messages";
//
//     Map<String, dynamic> messageData = {
//       "sender": senderId,
//       "receiver": receiverId,
//       "message": messageText,
//     };
//
//     Response response = await dio.post(
//       url,
//       data: messageData,
//       options: Options(headers: {'Content-Type': 'application/json'}),
//     );
//
//     // ✅ Chỉ in log khi thực sự có lỗi
//     if (response.statusCode == 200 && response.data != null && response.data.containsKey("_id")) {
//       print("✅ Đã gửi tin nhắn SOS tới $receiverId!");
//     }
//   } catch (e) {
//     print("❌ Lỗi khi gửi tin nhắn SOS tới $receiverId: $e");
//   }
// }
//
//
//
//
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
import 'dart:ui';

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
  String? _packageName;

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
    _initializeData(); // Gọi hàm async riêng để dùng `await`
  }

  Future<void> _initializeData() async {
    // Delay nhẹ để chờ các widget build xong (optional)
    await Future.delayed(const Duration(milliseconds: 500));

    // Gọi các hàm load dữ liệu song song
    await Future.wait([
      _fetchInstanceInfo(),
      _fetchFamilyData(),
      _fetchPublicPosts(),
      _fetchFamilyPosts(),
      _fetchAllUsers(),
      _loadUserInfo(),
      _fetchEventCount(),
    ]);
  }



  void _toggleLike(String postId, String userId) async {
    try {
      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/post/reaction/$postId";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("🚨 Lỗi: Không tìm thấy AccessToken trong SharedPreferences!");
        return;
      }

      Response response = await dio.put(
        url,
        data: {"userId": userId},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Like thành công!");

        // ✅ Cập nhật danh sách bài viết
        setState(() {
          _posts = _posts.map((post) {
            if (post["_id"] == postId) {
              bool isLiked = post["userLike"].contains(userId);
              if (isLiked) {
                post["userLike"].remove(userId);
              } else {
                post["userLike"].add(userId);
              }
            }
            return post;
          }).toList();
        });

      } else {
        print("❌ Lỗi khi like bài viết: ${response.data["message"]}");
      }
    } catch (e) {
      print("🚨 Lỗi kết nối API like bài viết: $e");
    }
  }

  Future<void> _fetchInstanceInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');
      String? token = prefs.getString('token');

      if (token == null) {
        print("🚨 Lỗi: Không tìm thấy AccessToken trong SharedPreferences!");
        return;
      }

      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/instance";

      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      print("ℹ️ Response from Get Instance API:"); // In toàn bộ response
      print("  Status Code: ${response.statusCode}");
      print("  Data: ${response.data}");

      if (response.statusCode == 200 && response.data["ok"] == true && response.data["data"] is List) {
        List<dynamic> instances = response.data["data"];
        if (familyId != null) {
          for (var instance in instances) {
            if (instance["familyId"] == familyId) {
              setState(() {
                _packageName = instance["packageName"];
              });
              print("✅ Tìm thấy packageName: $_packageName cho familyId: $familyId");
              return; // Thêm return để thoát khỏi hàm sau khi tìm thấy
            }
          }
          print("⚠️ Không tìm thấy familyId: $familyId trong dữ liệu instance trả về.");
        } else {
          print("⚠️ Không tìm thấy familyId trong SharedPreferences để so sánh với dữ liệu instance.");
        }
      } else {
        print("⚠️ API trả về lỗi khi lấy thông tin instance:");
        print("  Status Code: ${response.statusCode}"); // In lại status code để chắc chắn
        print("  Message: ${response.data["message"]}");
        print("  Data: ${response.data}"); // In lại data để xem cấu trúc khi lỗi
      }
    } catch (e) {
      print("❌ Lỗi kết nối API instance: $e");
    }
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
          // Logo Nest và Package Name (bên trái, gần nhau hơn)
          Row(
            mainAxisSize: MainAxisSize.min, // Để Row chỉ chiếm không gian cần thiết
            children: [
              Image.asset('assets/images/logo.png', height: 40),
              if (_packageName != null && _packageName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    _packageName!.split(' ').first, // Lấy phần đầu tiên trước dấu cách
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                  ),
                ),
            ],
          ),

          // Nhóm nút bên phải
          Row(
            children: [
              // Khi nhấn vào SOS, hiển thị modal trượt để kích hoạt
              GestureDetector(
                onTap: () {
                  _showSOSModal(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "SOS",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
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
      Dio dio = Dio();
      String url = "https://platform-family.onrender.com/post/posts-public";
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        setState(() {
          _posts = List<Map<String, dynamic>>.from(response.data["data"]);
        });
      } else {
        print("⚠️ API trả về lỗi khi lấy bài viết công khai!");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API bài viết công khai: $e");
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

  void _showSOSModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Không cho phép đóng khi nhấn ra ngoài
      enableDrag: false, // Không cho phép kéo xuống để đóng
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double dragPosition = 0.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: 190, // Chiều cao modal
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Vị trí của bạn sẽ được gửi cho mọi người",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Positioned(
                        left: dragPosition,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              dragPosition += details.primaryDelta!;
                              if (dragPosition < 0) dragPosition = 0;
                              if (dragPosition > MediaQuery.of(context).size.width - 120) {
                                dragPosition = MediaQuery.of(context).size.width - 120;
                                _sendSOSAlert(context);
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              "SOS",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Trượt sang PHẢI để kích hoạt ngay !",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Hủy kích hoạt",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                              await Future.delayed(Duration(milliseconds: 300));

                              await Future.wait([
                                _fetchPublicPosts(),
                                _fetchFamilyPosts(),
                              ]);

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

        return _buildPost(context, post, authorName, authorAvatar, formattedTime);

      },
    );
  }
}

// Một bài viết
/// **Hiển thị bài viết**
Widget _buildPost(BuildContext context, Map<String, dynamic> post, String user, String avatar, String time) {
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
                  ? NetworkImage(avatar)
                  : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
            ),
            SizedBox(width: 10),
            Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text(time, style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 5),
        Text(post["content"] ?? ""),
        SizedBox(height: 5),
        if (post["images"] != null && post["images"].isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (post["images"] as List).map((img) {
              return Builder(
                builder: (BuildContext ctx) { // ✅ Sử dụng Builder để có context
                  return GestureDetector(
                    onTap: () => _showFullImage(ctx, img), // ✅ Truyền context đúng cách
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        SizedBox(height: 5),
        Row(
          children: [
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then((prefs) => prefs.getString('userId')),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.red),
                      SizedBox(width: 5),
                      Text(post["userLike"].length.toString()),
                    ],
                  );
                }

                String userId = snapshot.data!;
                bool isLiked = post["userLike"].contains(userId);

                return GestureDetector(
                  onTap: () async {
                    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                    if (homeScreenState != null) {
                      homeScreenState._toggleLike(post["_id"], userId);
                    } else {
                      print("❌ Không tìm thấy _HomeScreenState!");
                    }
                  },

                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: post["userLike"].contains(userId) ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(width: 5),
                      Text(post["userLike"].length.toString()), // ✅ Hiển thị đúng số lượng like
                    ],
                  ),
                );

              },
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                if (homeScreenState != null) {
                  _showCommentsModal(context, post["_id"], homeScreenState._userNames);
                } else {
                  print("❌ Không tìm thấy HomeScreenState!");
                }
              },
              child: Row(
                children: [
                  Icon(Icons.comment, color: Colors.blue),
                  SizedBox(width: 5),
                  Text("Bình luận"),
                ],
              ),
            ),

          ],
        ),
      ],
    ),
  );
}



_showCommentsModal(BuildContext ctx, String postId, Map<String, Map<String, String>> userNames) async {
  print("📩 Đang mở modal bình luận cho bài viết: $postId");

  List<Map<String, dynamic>> comments = await _fetchComments(postId, userNames); // ✅ Sử dụng biến userNames

  print("📝 Số lượng bình luận lấy được: ${comments.length}");

  TextEditingController _commentController = TextEditingController();
  String? _parentCommentId;
  String? _replyingTo;

  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(ctx).size.height * 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Bình luận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),
                  Expanded(
                    child: comments.isNotEmpty
                        ? ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Bình luận chính
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: comment["avatar"].startsWith("http")
                                    ? NetworkImage(comment["avatar"])
                                    : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
                              ),
                              title: Text(comment["authorName"] ?? "Người dùng"),
                              subtitle: Text(comment["content"]),
                              trailing: IconButton(
                                icon: Icon(Icons.reply, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    _parentCommentId = comment["id"];
                                    _replyingTo = comment["authorName"];
                                  });
                                },
                              ),
                            ),

                            // ✅ Hiển thị danh sách reply (nếu có)
                            if (comment["replies"].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Column(
                                  children: comment["replies"].map<Widget>((reply) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: reply["avatar"].startsWith("http")
                                            ? NetworkImage(reply["avatar"])
                                            : AssetImage("assets/images/user_avatar.jpg") as ImageProvider,
                                      ),
                                      title: Text(reply["authorName"] ?? "Người dùng"),
                                      subtitle: Text(reply["content"]),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        "Chưa có bình luận nào, hãy là người đầu tiên bình luận",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_replyingTo != null) // ✅ Hiển thị dòng "Đang phản hồi"
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Đang phản hồi $_replyingTo",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _replyingTo = null;
                                    _parentCommentId = null;
                                  });
                                },
                                child: Icon(Icons.close, color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                        ),
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Nhập bình luận...",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, color: Colors.blue),
                            onPressed: () async {
                              await _addCommentAndRefreshUI(postId, _commentController.text, _parentCommentId, () async {
                                List<Map<String, dynamic>> updatedComments = await _fetchComments(postId, userNames);
                                setState(() {
                                  comments.clear();
                                  comments.addAll(updatedComments);
                                });
                              });

                              _commentController.clear();
                              _parentCommentId = null;
                              _replyingTo = null; // ✅ Reset khi gửi bình luận
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}



Future<List<Map<String, dynamic>>> _fetchComments(String postId, Map<String, Map<String, String>> userNames) async {
  print("🔍 Gọi API lấy bình luận cho bài viết: $postId");
  List<Map<String, dynamic>> comments = [];

  try {
    Dio dio = Dio();
    String url = "https://platform-family.onrender.com/comment/get-comments-post?postId=$postId";
    Response response = await dio.get(url);

    print("📡 API Response Status Code: ${response.statusCode}");
    print("📡 API Response Data: ${response.data}");

    if (response.statusCode == 200 && response.data["ok"] == true) {
      if (response.data["data"] is List) {
        comments = [];

        for (var comment in response.data["data"]) {
          String authorId = comment["author"] ?? "";
          String authorName = userNames[authorId]?["name"] ?? "Người dùng";
          String authorAvatar = userNames[authorId]?["avatar"] ?? "assets/images/user_avatar.jpg";

          // ✅ Tạo đối tượng bình luận chính
          Map<String, dynamic> commentData = {
            "id": comment["_id"],
            "authorName": authorName,
            "avatar": authorAvatar,
            "content": comment["content"] ?? "",
            "parentCommentId": comment["parentCommentId"],
            "replies": []
          };

          // ✅ Xử lý replies (nếu có)
          if (comment["replies"] != null && comment["replies"] is List) {
            for (var reply in comment["replies"]) {
              String replyAuthorId = reply["author"] ?? "";
              String replyAuthorName = userNames[replyAuthorId]?["name"] ?? "Người dùng";
              String replyAuthorAvatar = userNames[replyAuthorId]?["avatar"] ?? "assets/images/user_avatar.jpg";

              commentData["replies"].add({
                "id": reply["_id"],
                "authorName": replyAuthorName,
                "avatar": replyAuthorAvatar,
                "content": reply["content"] ?? "",
                "parentCommentId": reply["parentCommentId"],
              });
            }
          }

          comments.add(commentData);
        }
      }
    }
    else {
      print("⚠️ API trả về lỗi khi lấy bình luận: ${response.data["message"]}");
    }
  } catch (e) {
    print("❌ Lỗi kết nối API lấy bình luận: $e");
  }
  return comments;
}



Future<void> _addCommentAndRefreshUI(
    String postId, String content, String? parentCommentId, Function refreshComments) async {
  if (content.isEmpty) return;

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    if (userId == null) {
      print("❌ Không tìm thấy UserID trong SharedPreferences!");
      return;
    }

    Dio dio = Dio();
    String url = "https://platform-family.onrender.com/comment/create";

    Map<String, dynamic> requestData = {
      "postId": postId,
      "author": userId,
      "content": content,
    };

    if (parentCommentId != null) {
      requestData["parentCommentId"] = parentCommentId;
    }

    Response response = await dio.post(url, data: requestData);

    if (response.statusCode == 200) {
      print("✅ Bình luận thành công!");

      // 🔄 **Gọi lại hàm cập nhật bình luận sau khi gửi API thành công**
      refreshComments();
    } else {
      print("⚠️ Lỗi tạo bình luận: ${response.data}");
    }
  } catch (e) {
    print("🚨 Lỗi kết nối API tạo bình luận: $e");
  }
}





void _showFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true, // ✅ Cho phép đóng khi nhấn ra ngoài
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // ✅ Đảm bảo không có viền trắng
        child: Stack(
          children: [
            // ✅ Lớp nền làm mờ
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Hiệu ứng mờ
              child: Container(
                color: Colors.grey.withOpacity(0), // ✅ Nền xám nhẹ với độ trong suốt
              ),
            ),

            // ✅ Hiển thị ảnh
            Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),

            // ✅ Nút "X" để đóng
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context), // ✅ Đóng modal
              ),
            ),
          ],
        ),
      );
    },
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

      // ✅ Gọi API lấy danh sách thành viên để kiểm tra quyền admin
      bool isPrivate = true; // Mặc định là private
      Dio dio = Dio();
      String memberUrl = "https://platform-family.onrender.com/family/get-members/$familyId";

      Response memberResponse = await dio.get(memberUrl);
      if (memberResponse.statusCode == 200 && memberResponse.data["ok"] == true) {
        String adminId = memberResponse.data["data"]["admin"]["_id"];
        if (author == adminId) {
          isPrivate = false; // Nếu userId hiện tại là admin thì isPrivate = false
        }
      } else {
        print("⚠️ Lỗi khi lấy danh sách thành viên: ${memberResponse.data["message"]}");
      }

      print("🚀 Gửi request tạo bài viết... isPrivate: $isPrivate");

      final response = await dio.post(
        'https://platform-family.onrender.com/post/create',
        data: {
          "author": author,
          "familyId": familyId,
          "content": content,
          "isPrivate": isPrivate, // ✅ Thêm giá trị isPrivate vào API
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
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Bài viết đã được đăng thành công!"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

Future<void> _sendSOSAlert(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? senderId = prefs.getString('userId');
    String? familyId = prefs.getString('familyId');
    String? userName = prefs.getString('name');

    if (senderId == null || familyId == null || userName == null) {
      print("❌ Không tìm thấy thông tin UserID, FamilyID hoặc UserName");
      return;
    }

    // 🔹 Lấy danh sách thành viên trong gia đình
    Dio dio = Dio();
    String url = "https://platform-family.onrender.com/family/get-members/$familyId";
    Response response = await dio.get(url);

    if (response.statusCode != 200 || response.data["ok"] != true) {
      print("⚠️ API trả về lỗi khi lấy thành viên gia đình: ${response.data}");
      return;
    }

    List<dynamic> members = response.data["data"]["members"];
    String adminId = response.data["data"]["admin"]["_id"];

    // 🔹 Ép kiểu `_id` về String
    List<String> recipientIds = [adminId];
    recipientIds.addAll(
        members.map((m) => m["_id"].toString()).where((id) => id != senderId)
    ); // Bỏ qua chính mình

    print("👨‍👩‍👧‍👦 Thành viên nhận SOS: $recipientIds");

    String messageText = "$userName đã gửi tín hiệu SOS, kiểm tra ngay!";

    // 🔹 Gửi tin nhắn SOS cho từng thành viên
    for (String receiverId in recipientIds) {
      await _sendSOSMessage(senderId, receiverId, messageText);
    }

    print("✅ Đã gửi SOS Alert đến tất cả thành viên trong gia đình!");

    // ✅ Hiển thị thông báo thành công
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tín hiệu SOS đã được gửi thành công!"),
          backgroundColor: Colors.red,
        ),
      );
    }

  } catch (e) {
    print("❌ Lỗi khi gửi tín hiệu SOS: $e");
  }
}




Future<void> _sendSOSMessage(String senderId, String receiverId, String messageText) async {
  try {
    Dio dio = Dio();
    String url = "https://platform-family.onrender.com/messages";

    Map<String, dynamic> messageData = {
      "sender": senderId,
      "receiver": receiverId,
      "message": messageText,
    };

    Response response = await dio.post(
      url,
      data: messageData,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    // ✅ Chỉ in log khi thực sự có lỗi
    if (response.statusCode == 200 && response.data != null && response.data.containsKey("_id")) {
      print("✅ Đã gửi tin nhắn SOS tới $receiverId!");
    }
  } catch (e) {
    print("❌ Lỗi khi gửi tin nhắn SOS tới $receiverId: $e");
  }
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