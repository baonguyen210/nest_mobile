import 'package:flutter/material.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final String chatTitle;
  final String avatar;

  const PhotoGalleryScreen({super.key, required this.chatTitle, required this.avatar});

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
            Text(chatTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Ảnh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '11 ảnh, 1 video',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Hiển thị lưới ảnh và video
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 ảnh mỗi hàng
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12, // Số lượng ảnh và video
              itemBuilder: (context, index) {
                if (index == 1) {
                  // Ảnh có biểu tượng video
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/photo_${index + 1}.jpg', fit: BoxFit.cover),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                      ),
                    ],
                  );
                }
                return Image.asset('assets/images/photo_${index + 1}.jpg', fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }
}
