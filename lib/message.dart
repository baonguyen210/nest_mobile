// import 'package:flutter/material.dart';
// import 'package:nest_mobile/chat_screen.dart';
//
// class MessageScreen extends StatelessWidget {
//   const MessageScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nhắn tin', style: TextStyle(fontWeight: FontWeight.bold)),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Thêm chức năng mở màn hình tạo tin nhắn mới
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Thanh tìm kiếm
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//           ),
//
//           // Danh sách tin nhắn
//           Expanded(
//             child: ListView(
//               children: [
//                 chatItem(context, 'Mẹ', 'Ok!', '20:24', 'assets/images/mom.jpg', true, true),
//                 chatItem(context, 'Gia đình Trang', 'Đợi cả nhà đến rồi cùng...', '15:20', 'assets/images/family.jpg', false, true),
//                 chatItem(context, 'Nhóm cả nhà', 'Ông đang đi đón cháu', 'T.4', 'assets/images/group.jpg', false, true),
//                 chatItem(context, 'Ba', 'Chút ba về, ba mang quà...', 'T.4', 'assets/images/dad.jpg', false, true),
//                 chatItem(context, 'Ông ngoại', 'Dạ', 'T.2', 'assets/images/grandpa.jpg', false, true),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // Thanh điều hướng dưới cùng
//     );
//   }
//
//   // Widget tạo từng item trong danh sách tin nhắn
//   Widget chatItem(BuildContext context, String name, String message, String time, String avatar, bool isUnread, bool showDinnerIcon) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: AssetImage(avatar),
//         radius: 24,
//       ),
//       title: Text(
//         name,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(message, overflow: TextOverflow.ellipsis),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(time, style: const TextStyle(color: Colors.grey)),
//           if (showDinnerIcon)
//             const Padding(
//               padding: EdgeInsets.only(left: 8), // Giữ khoảng cách giữa thời gian và icon
//               child: Icon(Icons.restaurant, color: Colors.grey, size: 25), // Icon dĩa ăn cơm
//             ),
//         ],
//       ),
//       onTap: () {
//         // Chuyển sang màn hình chat khi nhấn vào
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ChatScreen(chatTitle: name, avatar: avatar)),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nest_mobile/chat_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> familyMembers = [];

  @override
  void initState() {
    super.initState();
    fetchFamilyMembers();
  }


  Future<void> fetchFamilyMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Kiểm tra toàn bộ dữ liệu trong SharedPreferences
    print("🔍 Kiểm tra SharedPreferences: ${prefs.getKeys()}");

    String? familyId = prefs.getString('FamilyId');
    String? currentUserId = prefs.getString('UserId');  // Kiểm tra key đúng

    if (familyId == null) {
      print("⚠️ Không tìm thấy FamilyId trong SharedPreferences.");
      return;
    }

    if (currentUserId == null) {
      print("❌ Không tìm thấy UserId trong SharedPreferences. Kiểm tra lại luồng đăng nhập!");

      // Thử lấy lại UserId nếu bị mất
      if (prefs.containsKey('userId')) {
        currentUserId = prefs.getString('userId');
        print("🔄 Tìm thấy UserId bằng key 'userId': $currentUserId");
      } else {
        return; // Không có UserId thì không gọi API
      }
    }

    print("🔹 User ID hiện tại: $currentUserId");
    print("📡 Đang gọi API với FamilyId: $familyId");

    final response = await http.get(
      Uri.parse('https://platform-family.onrender.com/family/get-members/$familyId'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("✅ API trả về thành công.");

      if (jsonResponse['data'] != null) {
        final List<dynamic> members = jsonResponse['data']['members'] ?? [];
        final admin = jsonResponse['data']['admin'];

        print("👨‍👩‍👧‍👦 Thành viên từ API trước khi lọc:");
        for (var member in [admin, ...members]) {
          print("➡️ ${member['name']} (ID: ${member['_id']})");
        }

        // Lọc danh sách, chỉ loại bỏ chính mình
        final List<dynamic> filteredMembers = [admin, ...members].where((member) {
          bool isSelf = member['_id'] == currentUserId;
          if (isSelf) {
            print("🚫 Loại bỏ chính mình: ${member['name']} (ID: ${member['_id']})");
          }
          return !isSelf;
        }).toList();

        // 🔹 Nếu danh sách rỗng, giữ lại admin
        if (filteredMembers.isEmpty && admin['_id'] != currentUserId) {
          filteredMembers.add(admin);
        }

        setState(() {
          familyMembers = filteredMembers;
        });

        print("✅ Thành viên sau khi loại bỏ chính mình:");
        for (var member in familyMembers) {
          print("➡️ ${member['name']} (ID: ${member['_id']})");
        }

        print("👨‍👩‍👧‍👦 Số lượng thành viên sau khi lọc: ${familyMembers.length}");
      } else {
        print("⚠️ Không có dữ liệu thành viên từ API.");
      }
    } else {
      print("❌ Lỗi API: ${response.statusCode} - ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhắn tin', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: familyMembers.length,
              itemBuilder: (context, index) {
                final member = familyMembers[index];

                return chatItem(
                  context,
                  member['name'] ?? 'Không tên',
                  'Nhấn để trò chuyện',
                  '',
                  member['avatar'] != null && member['avatar'].isNotEmpty
                      ? member['avatar']
                      : 'assets/images/default_avatar.png',
                  member['_id'], // Truyền đúng receiverId từ danh sách thành viên
                  false,
                  false,
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

  // Widget tạo từng item trong danh sách tin nhắn
Widget chatItem(BuildContext context, String name, String message, String time, String avatar, String receiverId, bool isUnread, bool showDinnerIcon) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: (avatar.isNotEmpty && avatar.startsWith('http'))
          ? NetworkImage(avatar) as ImageProvider
          : const AssetImage('assets/images/default_avatar.png'),
      radius: 24,
    ),
    title: Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(message, overflow: TextOverflow.ellipsis),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatTitle: name,
            avatar: avatar.startsWith('http') ? avatar : '',
            receiverId: receiverId,
          ),
        ),
      );
    },
  );
}
