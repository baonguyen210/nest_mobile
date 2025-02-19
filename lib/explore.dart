import 'package:flutter/material.dart';
import 'game_detail.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Khám phá', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album lưu trữ
            _buildAlbumStorage(),

            const SizedBox(height: 20),

            // Trò chơi
            _buildGameSection(context),

            const SizedBox(height: 20),

            // Theo dõi vị trí người thân
            _buildLocationTracking(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị Album lưu trữ
  Widget _buildAlbumStorage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Album lưu trữ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Xem tất cả',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Thanh dung lượng
        Row(
          children: [
            const Icon(Icons.storage, color: Colors.green),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Đã sử dụng 12.91 GB trong tổng số 15 GB'),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Progress bar
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: 12.91 / 15, // % dung lượng đã dùng
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Danh sách ảnh mẫu (Kích thước nhỏ hơn)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 6,  // Giảm khoảng cách
            mainAxisSpacing: 6,  // Giảm khoảng cách
            childAspectRatio: 1.2, // Tăng tỉ lệ giúp ô nhỏ hơn
          ),
          itemCount: 8, // Giữ lại 8 ô trống mẫu
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6), // Viền nhỏ hơn
              ),
              child: index == 7
                  ? const Center(child: Text('+176')) // Hiển thị số ảnh còn lại
                  : null,
            );
          },
        ),
      ],
    );
  }

  // Widget hiển thị danh sách trò chơi
  Widget _buildGameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.videogame_asset, color: Colors.blue, size: 26),
            const SizedBox(width: 8),
            const Text(
              'Trò chơi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Danh sách game (Kích thước nhỏ hơn)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Hiển thị 4 ô trên 1 hàng
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.2,
          ),
          itemCount: 4, // 4 ô trống cho danh sách game
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameDetailPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Widget hiển thị theo dõi vị trí người thân
  Widget _buildLocationTracking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.navigation, color: Colors.orange, size: 26),
            const SizedBox(width: 8),
            const Text(
              'Theo dõi vị trí người thân',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // Thanh điều hướng dưới

}
