import 'package:flutter/material.dart';

class GameDetailPage extends StatelessWidget {
  const GameDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết trò chơi')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Khám phá',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildAlbumStorage(),
              ],
            ),
          ),

          // Popup chi tiết trò chơi
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: _buildGamePopup(context),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị Album lưu trữ
  Widget _buildAlbumStorage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Album lưu trữ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text('Đã sử dụng 12.91 GB trong tổng số 15 GB'),
        ],
      ),
    );
  }

  // Popup chi tiết trò chơi
  Widget _buildGamePopup(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trivia Night',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Divider(),
          const Text(
            'Chủ đề: \n\nCách chơi\n- Mỗi câu hỏi có thời gian giới hạn 1 phút.\n- Trả lời câu hỏi cùng nhau để dành chiến thắng.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            'Gợi ý chủ đề:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('1. Hỏi: Con gì là loài động vật cao nhất trên Trái Đất?'),
          const Text('   A. Con voi'),
          const Text('   B. Con hươu cao cổ'),
          const Text('   C. Con hổ'),
          const SizedBox(height: 10),
          const Text(
            'Chủ đề: Đời sống',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('2. Hỏi: Vào tháng nào con người sẽ ngủ ít nhất trong năm?'),
          const Text('   A. Tháng 2'),
          const Text('   B. Tháng 7'),
          const Text('   C. Tháng 11'),
        ],
      ),
    );
  }
}
