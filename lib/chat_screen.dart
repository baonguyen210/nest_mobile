import 'package:flutter/material.dart';
import 'package:nest_mobile/photo_gallery_screen.dart';

class ChatScreen extends StatelessWidget {
  final String chatTitle;
  final String avatar;

  const ChatScreen({super.key, required this.chatTitle, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                  'Đang hoạt động 🔵', // Hiển thị trạng thái online
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.location_on), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Mở kho ảnh khi nhấn nút 3 chấm
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhotoGalleryScreen(chatTitle: chatTitle, avatar: avatar)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                chatBubble('Con gái của mẹ khỏe không?', false, avatar),
                chatBubble('Dạ khỏe, còn mẹ', true, ''),
                chatBubble('Mẹ khỏe', false, avatar),
                chatBubble('Hẹn con sau nhé', false, avatar),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '24 / 05 / 2024',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                chatBubble('Tối nay con đi chơi với bạn nha mẹ', true, ''),
                chatBubble('Ừm con', false, avatar),
                chatBubble('Nhớ về sớm!', false, avatar),
                chatBubble('Mẹ ơi', true, ''),
                chatBubble('Cho con xiền đi chơi', true, ''),
              ],
            ),
          ),

          // Thanh nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Gửi tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    // Xử lý gửi tin nhắn
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget tin nhắn (chat bubble)
  Widget chatBubble(String message, bool isSender, String avatar) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender && avatar.isNotEmpty) // Nếu là tin nhắn của người kia, hiển thị avatar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 20,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isSender ? const Radius.circular(12) : Radius.zero,
              bottomRight: isSender ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
