// import 'dart:ui';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:nest_mobile/album.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'game_detail.dart';
//
// class ExplorePage extends StatefulWidget {
//   const ExplorePage({Key? key}) : super(key: key);
//
//   @override
//   _ExplorePageState createState() => _ExplorePageState();
// }
//
// class _ExplorePageState extends State<ExplorePage> {
//   List<String> photos = [];
//   bool isLoading = true;
//   int totalPhotos = 0;
//   double totalStorageUsed = 0; // Dung lượng đã sử dụng (MB)
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPhotos();
//   }
//
//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // ✅ Cho phép đóng khi nhấn ra ngoài
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent, // ✅ Không có viền trắng
//           child: Stack(
//             children: [
//               // ✅ Lớp nền làm mờ
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Hiệu ứng blur nền sau
//                 child: Container(
//                   color: Colors.grey.withOpacity(0), // ✅ Nền xám nhẹ với độ trong suốt
//                 ),
//               ),
//
//               // ✅ Hiển thị ảnh (có thể zoom)
//               Center(
//                 child: InteractiveViewer(
//                   child: Image.network(imageUrl, fit: BoxFit.contain),
//                 ),
//               ),
//
//               // ✅ Nút "X" để đóng
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.white, size: 30),
//                   onPressed: () => Navigator.pop(context), // ✅ Đóng modal
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// 📌 Lấy ảnh từ API
//   Future<void> _fetchPhotos() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//
//       if (familyId == null) {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       String apiUrl = 'https://platform-family.onrender.com/album/$familyId';
//       Dio dio = Dio();
//       Response response = await dio.get(apiUrl);
//
//       if (response.statusCode == 200 && response.data['ok'] == true) {
//         List<Map<String, dynamic>> albums = List<Map<String, dynamic>>.from(response.data['data']);
//         List<String> fetchedPhotos = [];
//
//         for (var album in albums) {
//           fetchedPhotos.addAll(List<String>.from(album['photos']));
//         }
//
//         setState(() {
//           photos = fetchedPhotos;
//           totalPhotos = fetchedPhotos.length;
//           totalStorageUsed = totalPhotos * 5.0; // Mỗi ảnh 5MB
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching photos: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
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
//             _buildAlbumStorage(context),
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
//   Widget _buildAlbumStorage(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Album lưu trữ',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AlbumPage()), // Chuyển đến AlbumPage
//                 );
//               },
//               child: const Text(
//                 'Xem tất cả',
//                 style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 5),
//
//         // Hiển thị dung lượng đã dùng
//         Row(
//           children: [
//             const Icon(Icons.storage, color: Colors.green),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text('Đã sử dụng ${totalStorageUsed.toStringAsFixed(2)} MB trong tổng số 5 GB'),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 5),
//
//         // Progress bar hiển thị phần trăm dung lượng
//         Container(
//           height: 5,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(3),
//           ),
//           child: FractionallySizedBox(
//             widthFactor: (totalStorageUsed / 15000).clamp(0.0, 1.0), // Tính phần trăm dựa trên 15GB
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
//         // Hiển thị ảnh từ API
//         // Hiển thị ảnh từ API hoặc thông báo nếu không có ảnh
//         isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : photos.isEmpty
//             ? const Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 20),
//             child: Text(
//               "Bạn chưa có album lưu trữ nào.",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//             ),
//           ),
//         )
//             : GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 6,
//             childAspectRatio: 1.2,
//           ),
//           itemCount: photos.length > 7 ? 8 : photos.length,
//           itemBuilder: (context, index) {
//             if (index == 7 && photos.length > 7) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '+${photos.length - 7}',
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               );
//             }
//
//             return GestureDetector(
//               onTap: () => _showFullImage(context, photos[index]), // ✅ Thêm chức năng zoom ảnh
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: Image.network(
//                   photos[index],
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
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
//         // Danh sách game (Kích thước nhỏ hơn)
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4, // 4 game trên một hàng
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 6,
//             childAspectRatio: 1, // Cân đối hình ảnh
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
//                   games[index]["rules"] ?? "",
//                   (games[index]["suggested_topics"] as List<dynamic>).cast<Map<String, dynamic>>() ?? [],
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       // Hình ảnh game
//                       Image.network(
//                         games[index]["image"]!,
//                         fit: BoxFit.cover,
//                       ),
//
//                       // Overlay mờ giúp chữ dễ đọc
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//
//                       // Tên game hiển thị trên ảnh
//                       Center(
//                         child: Text(
//                           games[index]["name"]!,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white, // Chữ màu trắng để nổi bật trên ảnh
//                           ),
//                         ),
//                       ),
//                     ],
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

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nest_mobile/album.dart';
import 'package:nest_mobile/googleMapFlutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_detail.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> photos = [];
  bool isLoading = true;
  int totalPhotos = 0;
  double totalStorageUsed = 0; // Dung lượng đã sử dụng (MB)

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // ✅ Cho phép đóng khi nhấn ra ngoài
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, // ✅ Không có viền trắng
          child: Stack(
            children: [
              // ✅ Lớp nền làm mờ
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Hiệu ứng blur nền sau
                child: Container(
                  color: Colors.grey.withOpacity(0), // ✅ Nền xám nhẹ với độ trong suốt
                ),
              ),

              // ✅ Hiển thị ảnh (có thể zoom)
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

  /// 📌 Lấy ảnh từ API
  Future<void> _fetchPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      String apiUrl = 'https://platform-family.onrender.com/album/$familyId';
      Dio dio = Dio();
      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200 && response.data['ok'] == true) {
        List<Map<String, dynamic>> albums = List<Map<String, dynamic>>.from(response.data['data']);
        List<String> fetchedPhotos = [];

        for (var album in albums) {
          fetchedPhotos.addAll(List<String>.from(album['photos']));
        }

        setState(() {
          photos = fetchedPhotos;
          totalPhotos = fetchedPhotos.length;
          totalStorageUsed = totalPhotos * 5.0; // Mỗi ảnh 5MB
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching photos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
            _buildLocationTracking(context),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị Album lưu trữ
  Widget _buildAlbumStorage(BuildContext context) {
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

        // Hiển thị dung lượng đã dùng
        Row(
          children: [
            const Icon(Icons.storage, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Đã sử dụng ${totalStorageUsed.toStringAsFixed(2)} MB trong tổng số 5 GB'),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Progress bar hiển thị phần trăm dung lượng
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: (totalStorageUsed / 15000).clamp(0.0, 1.0), // Tính phần trăm dựa trên 15GB
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Hiển thị ảnh từ API
        // Hiển thị ảnh từ API hoặc thông báo nếu không có ảnh
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : photos.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Bạn chưa có album lưu trữ nào.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
        )
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.2,
          ),
          itemCount: photos.length > 7 ? 8 : photos.length,
          itemBuilder: (context, index) {
            if (index == 7 && photos.length > 7) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '+${photos.length - 7}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () => _showFullImage(context, photos[index]), // ✅ Thêm chức năng zoom ảnh
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  photos[index],
                  fit: BoxFit.cover,
                ),
              ),
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




  // // Widget hiển thị theo dõi vị trí người thân
  // Widget _buildLocationTracking() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           const Icon(Icons.navigation, color: Colors.orange, size: 26),
  //           const SizedBox(width: 8),
  //           const Text(
  //             'Theo dõi vị trí người thân',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

// Widget hiển thị theo dõi vị trí người thân
  Widget _buildLocationTracking(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoogleMapFlutter()), // Chuyển đến LocationScreen
        );
      },
      child: Column(
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
      ),
    );
  }


}