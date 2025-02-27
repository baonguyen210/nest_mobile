import 'package:flutter/material.dart';
import 'package:nest_mobile/chat_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhắn tin', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Thêm chức năng mở màn hình tạo tin nhắn mới
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
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

          // Danh sách tin nhắn
          Expanded(
            child: ListView(
              children: [
                chatItem(context, 'Mẹ', 'Ok!', '20:24', 'assets/images/mom.jpg', true, true),
                chatItem(context, 'Gia đình Trang', 'Đợi cả nhà đến rồi cùng...', '15:20', 'assets/images/family.jpg', false, true),
                chatItem(context, 'Nhóm cả nhà', 'Ông đang đi đón cháu', 'T.4', 'assets/images/group.jpg', false, true),
                chatItem(context, 'Ba', 'Chút ba về, ba mang quà...', 'T.4', 'assets/images/dad.jpg', false, true),
                chatItem(context, 'Ông ngoại', 'Dạ', 'T.2', 'assets/images/grandpa.jpg', false, true),
              ],
            ),
          ),
        ],
      ),
      // Thanh điều hướng dưới cùng
    );
  }

  // Widget tạo từng item trong danh sách tin nhắn
  Widget chatItem(BuildContext context, String name, String message, String time, String avatar, bool isUnread, bool showDinnerIcon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatar),
        radius: 24,
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey)),
          if (showDinnerIcon)
            const Padding(
              padding: EdgeInsets.only(left: 8), // Giữ khoảng cách giữa thời gian và icon
              child: Icon(Icons.restaurant, color: Colors.grey, size: 25), // Icon dĩa ăn cơm
            ),
        ],
      ),
      onTap: () {
        // Chuyển sang màn hình chat khi nhấn vào
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(chatTitle: name, avatar: avatar)),
        );
      },
    );
  }
}
