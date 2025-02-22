// import 'package:flutter/material.dart';
// import 'game_detail.dart';
//
// class ExplorePage extends StatelessWidget {
//   const ExplorePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Khám phá', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Album lưu trữ
//             _buildAlbumStorage(),
//
//             const SizedBox(height: 20),
//
//             // Trò chơi
//             _buildGameSection(context),
//
//             const SizedBox(height: 20),
//
//             // Theo dõi vị trí người thân
//             _buildLocationTracking(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget hiển thị Album lưu trữ
//   Widget _buildAlbumStorage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Tiêu đề
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Album lưu trữ',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const Text(
//               'Xem tất cả',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 5),
//
//         // Thanh dung lượng
//         Row(
//           children: [
//             const Icon(Icons.storage, color: Colors.green),
//             const SizedBox(width: 8),
//             const Expanded(
//               child: Text('Đã sử dụng 12.91 GB trong tổng số 15 GB'),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 5),
//
//         // Progress bar
//         Container(
//           height: 5,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(3),
//           ),
//           child: FractionallySizedBox(
//             widthFactor: 12.91 / 15, // % dung lượng đã dùng
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.orange,
//                 borderRadius: BorderRadius.circular(3),
//               ),
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         // Danh sách ảnh mẫu (Kích thước nhỏ hơn)
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 6,  // Giảm khoảng cách
//             mainAxisSpacing: 6,  // Giảm khoảng cách
//             childAspectRatio: 1.2, // Tăng tỉ lệ giúp ô nhỏ hơn
//           ),
//           itemCount: 8, // Giữ lại 8 ô trống mẫu
//           itemBuilder: (context, index) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(6), // Viền nhỏ hơn
//               ),
//               child: index == 7
//                   ? const Center(child: Text('+176')) // Hiển thị số ảnh còn lại
//                   : null,
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   // Widget hiển thị danh sách trò chơi
//   Widget _buildGameSection(BuildContext context) {
//     final List<Map<String, dynamic>> games = [
//       {
//         "name": "Trivia Night",
//         "image": "https://medfordbrew.com/wp-content/uploads/2023/09/trivia.jpeg",
//         "description": "Thảo luận nhanh và chọn đáp án chính xác để giành chiến thắng!",
//         "rules": "Người chơi lần lượt trả lời các câu hỏi theo chủ đề. Mỗi câu hỏi có thời gian suy nghĩ là 30 giây. Trả lời đúng được 1 điểm, trả lời sai không bị trừ điểm. Ai có nhiều điểm nhất sau 10 câu hỏi là người chiến thắng.",
//         "suggested_topics": [
//           {
//             "topic": "Động vật",
//             "question": "Con gì có tốc độ chạy nhanh nhất trên mặt đất?",
//             "options": ["A. Ngựa", "B. Báo Gê-pa", "C. Chó sói"],
//             "answer": "B. Báo Gê-pa"
//           },
//           {
//             "topic": "Khoa học",
//             "question": "Nguyên tố nào có ký hiệu hóa học là O?",
//             "options": ["A. Oxy", "B. Vàng", "C. Bạc"],
//             "answer": "A. Oxy"
//           }
//         ]
//       },
//       {
//         "name": "Two Truths and a Lie",
//         "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuYQMIcLYfscNhQ_qWVBlbAn16TVc6_cFKcBDQ9bezjdNBmOhxfmGuX_Xhf9SGnWcSw2w&usqp=CAU",
//         "description": "Mỗi người đưa ra ba câu về bản thân – hai đúng, một sai. Những người khác phải đoán!",
//         "rules": "Mỗi người chia sẻ 3 câu về bản thân: 2 câu đúng, 1 câu sai. Các thành viên khác phải đoán câu nào là sai. Nếu đoán đúng, được 1 điểm. Người đưa ra câu hỏi lừa được nhiều người nhất sẽ chiến thắng.",
//         "suggested_topics": [
//           {
//             "topic": "Sở thích cá nhân",
//             "examples": ["Tôi thích ăn pizza.", "Tôi đã từng leo núi Everest.", "Tôi có một con mèo tên là Miu."],
//             "note": "Người chơi phải đoán xem câu nào là sai."
//           },
//           {
//             "topic": "Trải nghiệm cuộc sống",
//             "examples": ["Tôi đã từng nhảy dù.", "Tôi đã gặp người nổi tiếng.", "Tôi chưa bao giờ đi máy bay."],
//             "note": "Người chơi phải đoán xem câu nào là sai."
//           }
//         ]
//       },
//       {
//         "name": "Charades",
//         "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBfv_kfXwTLmlOJh8au5TQ3AKxi3dB9sL0Tw&s",
//         "description": "Diễn tả một từ hoặc cụm từ mà không nói, để đội của bạn đoán!",
//         "rules": "Một người sẽ diễn tả từ/cụm từ bằng hành động, không được nói. Các thành viên còn lại đoán trong 1 phút. Nếu đoán đúng, đội được 1 điểm. Hết thời gian mà chưa đoán đúng thì không có điểm. Đội nào có nhiều điểm nhất sau 5 lượt chơi sẽ thắng.",
//         "suggested_topics": [
//           {
//             "topic": "Hành động",
//             "examples": ["Đánh răng", "Chạy bộ", "Nhảy múa"]
//           },
//           {
//             "topic": "Nhân vật hoạt hình",
//             "examples": ["Pikachu", "Doraemon", "Elsa"]
//           }
//         ]
//       },
//       {
//         "name": "Scavenger Hunt",
//         "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk87sPeRlrkU-inLxEbah8RsCnl0pbVX9KurNzb3vEffmKiei0uP4OBL2ibeUP-0goC58&usqp=CAU",
//         "description": "Tìm và thu thập các vật phẩm trong danh sách trong thời gian giới hạn!",
//         "rules": "Mỗi đội/cá nhân sẽ có một danh sách đồ vật cần tìm. Ai tìm đủ tất cả các món đồ trong danh sách đầu tiên sẽ chiến thắng. Nếu không ai tìm đủ, người tìm được nhiều món nhất trong 5 phút sẽ thắng.",
//         "suggested_topics": [
//           {
//             "topic": "Đồ vật trong nhà",
//             "examples": ["Một chiếc dép màu xanh", "Một cái muỗng", "Một quyển sách có bìa đỏ"]
//           },
//           {
//             "topic": "Thiên nhiên",
//             "examples": ["Một chiếc lá to", "Một viên đá nhỏ", "Một cành hoa"]
//           }
//         ]
//       }
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.videogame_asset, color: Colors.blue, size: 26),
//             const SizedBox(width: 8),
//             const Text(
//               'Trò chơi',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 10),
//
//         // Danh sách game (Kích thước nhỏ hơn)
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 6,
//             childAspectRatio: 1.2,
//           ),
//           itemCount: games.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 _showGameDetailModal(
//                   context,
//                   games[index]["name"]!,
//                   games[index]["image"]!,
//                   games[index]["description"]!,
//                   games[index]["rules"] ?? "", // Kiểm tra null tránh lỗi
//                   (games[index]["suggested_topics"] as List<dynamic>).cast<Map<String, dynamic>>() ?? [], // Đảm bảo dữ liệu đúng kiểu
//                 );
//               },
//
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Center(
//                   child: Text(
//                     games[index]["name"]!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   void _showGameDetailModal(BuildContext context, String gameName, String gameImage, String gameDescription, String gameRules, List<Map<String, dynamic>> suggestedTopics) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: SingleChildScrollView(  // Để tránh lỗi UI bị tràn khi danh sách dài
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(gameName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                   Divider(),
//
//                   // Ảnh game
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         gameImage,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 10),
//
//                   // Mô tả game
//                   Text(gameDescription, style: TextStyle(fontSize: 14)),
//
//                   SizedBox(height: 15),
//
//                   // Luật chơi
//                   if (gameRules.isNotEmpty) ...[
//                     Text("📜 Luật chơi:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 5),
//                     Text(gameRules, style: TextStyle(fontSize: 14)),
//                     SizedBox(height: 15),
//                   ],
//
//                   // Chủ đề gợi ý
//                   // Chủ đề gợi ý
//                   if (suggestedTopics.isNotEmpty) ...[
//                     Text("📌 Gợi ý chủ đề:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: suggestedTopics.map((topic) {
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("• ${topic['topic']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                               SizedBox(height: 5),
//                               if (topic.containsKey('question')) // Kiểm tra nếu có question
//                                 Text(" ${topic['question']}", style: TextStyle(fontSize: 14)),
//                               if (topic.containsKey('options')) // Kiểm tra nếu có options
//                                 Text(" ${topic['options']?.join(', ')}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//                               if (topic.containsKey('answer')) // Kiểm tra nếu có answer
//                                 Text("✅ Đáp án: ${topic['answer']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
//                               if (topic.containsKey('examples')) // Kiểm tra nếu có examples
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("📝 Ví dụ:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
//                                     SizedBox(height: 5),
//                                     ...topic['examples'].map<Widget>((ex) => Text(" $ex", style: TextStyle(fontSize: 14, color: Colors.grey[700]))).toList(),
//                                   ],
//                                 ),
//                               if (topic.containsKey('note')) // Nếu có ghi chú
//                                 Text("ℹ️ ${topic['note']}", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueGrey)),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ]
//
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//
//   // Widget hiển thị theo dõi vị trí người thân
//   Widget _buildLocationTracking() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.navigation, color: Colors.orange, size: 26),
//             const SizedBox(width: 8),
//             const Text(
//               'Theo dõi vị trí người thân',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
// // Thanh điều hướng dưới
//
// }


import 'package:flutter/material.dart';
import 'package:nest_mobile/album.dart';
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
            _buildAlbumStorage(context),

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
  Widget _buildAlbumStorage(BuildContext context) { // Truyền context
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Album lưu trữ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlbumPage()), // Chuyển đến AlbumPage
                );
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
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
    final List<Map<String, dynamic>> games = [
      {
        "name": "Trivia Night",
        "image": "https://medfordbrew.com/wp-content/uploads/2023/09/trivia.jpeg",
        "description": "Thảo luận nhanh và chọn đáp án chính xác để giành chiến thắng!",
        "rules": "Người chơi lần lượt trả lời các câu hỏi theo chủ đề. Mỗi câu hỏi có thời gian suy nghĩ là 30 giây. Trả lời đúng được 1 điểm, trả lời sai không bị trừ điểm. Ai có nhiều điểm nhất sau 10 câu hỏi là người chiến thắng.",
        "suggested_topics": [
          {
            "topic": "Động vật",
            "question": "Con gì có tốc độ chạy nhanh nhất trên mặt đất?",
            "options": ["A. Ngựa", "B. Báo Gê-pa", "C. Chó sói"],
            "answer": "B. Báo Gê-pa"
          },
          {
            "topic": "Khoa học",
            "question": "Nguyên tố nào có ký hiệu hóa học là O?",
            "options": ["A. Oxy", "B. Vàng", "C. Bạc"],
            "answer": "A. Oxy"
          }
        ]
      },
      {
        "name": "Two Truths and a Lie",
        "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuYQMIcLYfscNhQ_qWVBlbAn16TVc6_cFKcBDQ9bezjdNBmOhxfmGuX_Xhf9SGnWcSw2w&usqp=CAU",
        "description": "Mỗi người đưa ra ba câu về bản thân – hai đúng, một sai. Những người khác phải đoán!",
        "rules": "Mỗi người chia sẻ 3 câu về bản thân: 2 câu đúng, 1 câu sai. Các thành viên khác phải đoán câu nào là sai. Nếu đoán đúng, được 1 điểm. Người đưa ra câu hỏi lừa được nhiều người nhất sẽ chiến thắng.",
        "suggested_topics": [
          {
            "topic": "Sở thích cá nhân",
            "examples": ["Tôi thích ăn pizza.", "Tôi đã từng leo núi Everest.", "Tôi có một con mèo tên là Miu."],
            "note": "Người chơi phải đoán xem câu nào là sai."
          },
          {
            "topic": "Trải nghiệm cuộc sống",
            "examples": ["Tôi đã từng nhảy dù.", "Tôi đã gặp người nổi tiếng.", "Tôi chưa bao giờ đi máy bay."],
            "note": "Người chơi phải đoán xem câu nào là sai."
          }
        ]
      },
      {
        "name": "Charades",
        "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBfv_kfXwTLmlOJh8au5TQ3AKxi3dB9sL0Tw&s",
        "description": "Diễn tả một từ hoặc cụm từ mà không nói, để đội của bạn đoán!",
        "rules": "Một người sẽ diễn tả từ/cụm từ bằng hành động, không được nói. Các thành viên còn lại đoán trong 1 phút. Nếu đoán đúng, đội được 1 điểm. Hết thời gian mà chưa đoán đúng thì không có điểm. Đội nào có nhiều điểm nhất sau 5 lượt chơi sẽ thắng.",
        "suggested_topics": [
          {
            "topic": "Hành động",
            "examples": ["Đánh răng", "Chạy bộ", "Nhảy múa"]
          },
          {
            "topic": "Nhân vật hoạt hình",
            "examples": ["Pikachu", "Doraemon", "Elsa"]
          }
        ]
      },
      {
        "name": "Scavenger Hunt",
        "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk87sPeRlrkU-inLxEbah8RsCnl0pbVX9KurNzb3vEffmKiei0uP4OBL2ibeUP-0goC58&usqp=CAU",
        "description": "Tìm và thu thập các vật phẩm trong danh sách trong thời gian giới hạn!",
        "rules": "Mỗi đội/cá nhân sẽ có một danh sách đồ vật cần tìm. Ai tìm đủ tất cả các món đồ trong danh sách đầu tiên sẽ chiến thắng. Nếu không ai tìm đủ, người tìm được nhiều món nhất trong 5 phút sẽ thắng.",
        "suggested_topics": [
          {
            "topic": "Đồ vật trong nhà",
            "examples": ["Một chiếc dép màu xanh", "Một cái muỗng", "Một quyển sách có bìa đỏ"]
          },
          {
            "topic": "Thiên nhiên",
            "examples": ["Một chiếc lá to", "Một viên đá nhỏ", "Một cành hoa"]
          }
        ]
      }
    ];

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
        // Danh sách game (Kích thước nhỏ hơn)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 game trên một hàng
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1, // Cân đối hình ảnh
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showGameDetailModal(
                  context,
                  games[index]["name"]!,
                  games[index]["image"]!,
                  games[index]["description"]!,
                  games[index]["rules"] ?? "",
                  (games[index]["suggested_topics"] as List<dynamic>).cast<Map<String, dynamic>>() ?? [],
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hình ảnh game
                      Image.network(
                        games[index]["image"]!,
                        fit: BoxFit.cover,
                      ),

                      // Overlay mờ giúp chữ dễ đọc
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                      // Tên game hiển thị trên ảnh
                      Center(
                        child: Text(
                          games[index]["name"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Chữ màu trắng để nổi bật trên ảnh
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showGameDetailModal(BuildContext context, String gameName, String gameImage, String gameDescription, String gameRules, List<Map<String, dynamic>> suggestedTopics) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(  // Để tránh lỗi UI bị tràn khi danh sách dài
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(gameName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(),

                  // Ảnh game
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        gameImage,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Mô tả game
                  Text(gameDescription, style: TextStyle(fontSize: 14)),

                  SizedBox(height: 15),

                  // Luật chơi
                  if (gameRules.isNotEmpty) ...[
                    Text("📜 Luật chơi:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(gameRules, style: TextStyle(fontSize: 14)),
                    SizedBox(height: 15),
                  ],

                  // Chủ đề gợi ý
                  // Chủ đề gợi ý
                  if (suggestedTopics.isNotEmpty) ...[
                    Text("📌 Gợi ý chủ đề:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: suggestedTopics.map((topic) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• ${topic['topic']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              if (topic.containsKey('question')) // Kiểm tra nếu có question
                                Text(" ${topic['question']}", style: TextStyle(fontSize: 14)),
                              if (topic.containsKey('options')) // Kiểm tra nếu có options
                                Text(" ${topic['options']?.join(', ')}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                              if (topic.containsKey('answer')) // Kiểm tra nếu có answer
                                Text("✅ Đáp án: ${topic['answer']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                              if (topic.containsKey('examples')) // Kiểm tra nếu có examples
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("📝 Ví dụ:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                    SizedBox(height: 5),
                                    ...topic['examples'].map<Widget>((ex) => Text(" $ex", style: TextStyle(fontSize: 14, color: Colors.grey[700]))).toList(),
                                  ],
                                ),
                              if (topic.containsKey('note')) // Nếu có ghi chú
                                Text("ℹ️ ${topic['note']}", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ]

                ],
              ),
            ),
          ),
        );
      },
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