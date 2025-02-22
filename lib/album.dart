// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AlbumPage extends StatefulWidget {
//   const AlbumPage({Key? key}) : super(key: key);
//
//   @override
//   _AlbumPageState createState() => _AlbumPageState();
// }
//
// class _AlbumPageState extends State<AlbumPage> {
//   List<Map<String, dynamic>> albums = [];
//   List<String> allPhotos = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAlbums();
//   }
//
//   Future<void> _fetchAlbums() async {
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
//         List<Map<String, dynamic>> fetchedAlbums = List<Map<String, dynamic>>.from(response.data['data']);
//         List<String> fetchedPhotos = [];
//
//         for (var album in fetchedAlbums) {
//           fetchedPhotos.addAll(List<String>.from(album['photos']));
//         }
//
//         setState(() {
//           albums = fetchedAlbums;
//           allPhotos = fetchedPhotos;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching albums: $e");
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
//         title: const Text('Album gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.cloud_download),
//             onPressed: () {
//               _fetchAlbums(); // Làm mới danh sách album
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Phần hiển thị danh sách album ở trên
//             Text('Album của gia đình', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 50, // Chiều cao danh sách album
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: albums.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.only(right: 8),
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Center(
//                       child: Text(
//                         albums[index]['title'],
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Phần hiển thị danh sách ảnh của tất cả album
//             Text('Tất cả ảnh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//
//             Expanded(
//               child: allPhotos.isEmpty
//                   ? const Center(child: Text("Chưa có ảnh nào"))
//                   : GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // 3 ảnh trên một hàng
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemCount: allPhotos.length,
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       allPhotos[index],
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<Map<String, dynamic>> albums = [];
  List<String> allPhotos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
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
        List<Map<String, dynamic>> fetchedAlbums = List<Map<String, dynamic>>.from(response.data['data']);
        List<String> fetchedPhotos = [];

        for (var album in fetchedAlbums) {
          fetchedPhotos.addAll(List<String>.from(album['photos']));
        }

        setState(() {
          albums = fetchedAlbums;
          allPhotos = fetchedPhotos;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching albums: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: () {
              _fetchAlbums(); // Làm mới danh sách album
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hiển thị danh sách album ở trên
            Text('Album của gia đình', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 50, // Chiều cao danh sách album
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        albums[index]['title'],
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Phần hiển thị danh sách ảnh của tất cả album
            Text('Tất cả ảnh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: allPhotos.isEmpty
                  ? const Center(child: Text("Chưa có ảnh nào"))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 ảnh trên một hàng
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: allPhotos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      allPhotos[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
