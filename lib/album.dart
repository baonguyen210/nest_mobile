// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AlbumPage extends StatefulWidget {
//   const AlbumPage({Key? key}) : super(key: key);
//
//   @override
//   _AlbumPageState createState() => _AlbumPageState();
// }
//
//
// class _AlbumPageState extends State<AlbumPage> {
//   List<Map<String, dynamic>> albums = [];
//   List<String> allPhotos = [];
//   List<String> filteredPhotos = [];
//   String? selectedAlbumId;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAlbums();
//   }
//
//   void _showCreateAlbumDialog() {
//     TextEditingController titleController = TextEditingController();
//     TextEditingController descriptionController = TextEditingController();
//     List<File> newPhotos = [];
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: const Text("Tạo Album Mới"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: "Tên Album"),
//                 ),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(labelText: "Mô tả"),
//                 ),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 5,
//                   children: newPhotos
//                       .map((file) => Image.file(file, width: 50, height: 50))
//                       .toList(),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     List<File> selectedFiles = await _pickImages();
//                     setState(() {
//                       newPhotos.addAll(selectedFiles);
//                     });
//                   },
//                   child: const Text("Chọn Ảnh"),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Hủy"),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   if (titleController.text.isNotEmpty && newPhotos.isNotEmpty) {
//                     List<String> uploadedUrls = await _uploadImages(newPhotos);
//                     await _createAlbum(titleController.text, descriptionController.text, uploadedUrls);
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text("Tạo"),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }
//
//   Future<List<String>> _uploadImages(List<File> images) async {
//     List<String> uploadedUrls = [];
//     if (images.isEmpty) return uploadedUrls;
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//
//       if (token == null) {
//         print("⚠️ Không tìm thấy token!");
//         return [];
//       }
//
//       Dio dio = Dio();
//       FormData formData = FormData.fromMap({
//         "images": images.map((image) => MultipartFile.fromFileSync(image.path)).toList(),
//       });
//
//       Response response = await dio.post(
//         "https://platform-family.onrender.com/upload/multiple",
//         data: formData,
//         options: Options(headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "multipart/form-data",
//         }),
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
//
//
//   Future<List<File>> _pickImages() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? pickedFiles = await picker.pickMultiImage();
//
//     if (pickedFiles != null) {
//       return pickedFiles.map((file) => File(file.path)).toList();
//     }
//     return [];
//   }
//
//   Future<void> _createAlbum(String title, String description, List<String> photos) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId');
//       String? token = prefs.getString('token');
//
//       if (familyId == null || token == null) {
//         print("⚠️ Không tìm thấy familyId hoặc token");
//         return;
//       }
//
//       Dio dio = Dio();
//       String apiUrl = "https://platform-family.onrender.com/album/create";
//
//       Response response = await dio.post(apiUrl,
//         data: {
//           "title": title,
//           "description": description,
//           "photos": photos,
//           "familyId": familyId
//         },
//         options: Options(headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         }),
//       );
//
//       if (response.statusCode == 201 && response.data["ok"] == true) {
//         print("✅ Album tạo thành công!");
//         _fetchAlbums(); // Reload danh sách album sau khi tạo
//       } else {
//         print("❌ Lỗi tạo album: ${response.data['message']}");  // ✅ Đã sửa lỗi
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi gọi API tạo album: $e");
//     }
//   }
//
//
//   /// 📌 Lấy danh sách album từ API
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
//         List<Map<String, dynamic>> fetchedAlbums =
//         List<Map<String, dynamic>>.from(response.data['data']);
//         List<String> fetchedPhotos = [];
//
//         for (var album in fetchedAlbums) {
//           fetchedPhotos.addAll(List<String>.from(album['photos']));
//         }
//
//         setState(() {
//           albums = fetchedAlbums;
//           allPhotos = fetchedPhotos;
//           filteredPhotos = fetchedPhotos;
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
//   /// 📌 Lọc ảnh theo album được chọn
//   void _filterPhotosByAlbum(String albumId) {
//     setState(() {
//       selectedAlbumId = albumId;
//       filteredPhotos = albums
//           .firstWhere((album) => album["_id"] == albumId)["photos"]
//           .cast<String>();
//     });
//   }
//
//   /// 📌 Reset về toàn bộ ảnh
//   void _resetToAllPhotos() {
//     setState(() {
//       selectedAlbumId = null;
//       filteredPhotos = allPhotos;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Album gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add), // 🆕 Nút thêm album
//             onPressed: () => _showCreateAlbumDialog(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.cloud_download),
//             onPressed: _fetchAlbums,
//           ),
//         ],
//       ),
//
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 📌 Danh sách album
//             Text('Album của gia đình', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: albums.length,
//                 itemBuilder: (context, index) {
//                   bool isSelected = albums[index]["_id"] == selectedAlbumId;
//                   return GestureDetector(
//                     onTap: () {
//                       if (isSelected) {
//                         _resetToAllPhotos();
//                       } else {
//                         _filterPhotosByAlbum(albums[index]["_id"]);
//                       }
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.blue : Colors.blueAccent.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                         child: Text(
//                           albums[index]['title'],
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: isSelected ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // 📌 Hiển thị danh sách ảnh
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   selectedAlbumId == null ? 'Tất cả ảnh' : 'Ảnh trong album',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 if (selectedAlbumId != null)
//                   TextButton(
//                     onPressed: _resetToAllPhotos,
//                     child: const Text("Xem tất cả", style: TextStyle(color: Colors.blue)),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 10),
//
//             Expanded(
//               child: filteredPhotos.isEmpty
//                   ? const Center(child: Text("Chưa có ảnh nào"))
//                   : GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemCount: filteredPhotos.length,
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       filteredPhotos[index],
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


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}


class _AlbumPageState extends State<AlbumPage> {
  List<Map<String, dynamic>> albums = [];
  List<String> allPhotos = [];
  List<String> filteredPhotos = [];
  String? selectedAlbumId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  void _showCreateAlbumDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    List<File> newPhotos = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("Tạo Album", textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nhập tên album
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Tên Album",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nhập mô tả album
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Mô tả Album",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Hiển thị ảnh đã chọn với nền xám đồng đều
                  Wrap(
                    spacing: 8,
                    children: newPhotos.map((file) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Màu xám nền đồng đều
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(file, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Nút chọn ảnh
                  ElevatedButton.icon(
                    onPressed: () async {
                      List<File> selectedFiles = await _pickImages();
                      setState(() {
                        newPhotos.addAll(selectedFiles);
                      });
                    },
                    icon: Icon(Icons.image),
                    label: Text("Thêm ảnh"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && newPhotos.isNotEmpty) {
                    List<String> uploadedUrls = await _uploadImages(newPhotos);
                    await _createAlbum(titleController.text, descriptionController.text, uploadedUrls);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Tạo Album", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }






  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> uploadedUrls = [];
    if (images.isEmpty) return uploadedUrls;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("⚠️ Không tìm thấy token!");
        return [];
      }

      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "images": images.map((image) => MultipartFile.fromFileSync(image.path)).toList(),
      });

      Response response = await dio.post(
        "https://platform-family.onrender.com/upload/multiple",
        data: formData,
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        }),
      );

      if (response.statusCode == 200 && response.data["urls"] != null) {
        uploadedUrls = List<String>.from(response.data["urls"]);
      }
    } catch (e) {
      print("🚨 Lỗi khi tải ảnh: $e");
    }

    return uploadedUrls;
  }



  Future<List<File>> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      return pickedFiles.map((file) => File(file.path)).toList();
    }
    return [];
  }

  Future<void> _createAlbum(String title, String description, List<String> photos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');
      String? token = prefs.getString('token');

      if (familyId == null || token == null) {
        print("⚠️ Không tìm thấy familyId hoặc token");
        return;
      }

      Dio dio = Dio();
      String apiUrl = "https://platform-family.onrender.com/album/create";

      Response response = await dio.post(apiUrl,
        data: {
          "title": title,
          "description": description,
          "photos": photos,
          "familyId": familyId
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 201 && response.data["ok"] == true) {
        print("✅ Album tạo thành công!");
        _fetchAlbums(); // Reload danh sách album sau khi tạo

        // 🎉 Hiển thị thông báo SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Album đã được tạo thành công!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("❌ Lỗi tạo album: ${response.data['message']}");

        // ❌ Hiển thị lỗi nếu có vấn đề
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Lỗi tạo album: ${response.data['message']}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("🚨 Lỗi khi gọi API tạo album: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🚨 Đã xảy ra lỗi, vui lòng thử lại!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  /// 📌 Lấy danh sách album từ API
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
        List<Map<String, dynamic>> fetchedAlbums =
        List<Map<String, dynamic>>.from(response.data['data']);
        List<String> fetchedPhotos = [];

        for (var album in fetchedAlbums) {
          fetchedPhotos.addAll(List<String>.from(album['photos']));
        }

        setState(() {
          albums = fetchedAlbums;
          allPhotos = fetchedPhotos;
          filteredPhotos = fetchedPhotos;
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

  /// 📌 Lọc ảnh theo album được chọn
  void _filterPhotosByAlbum(String albumId) {
    setState(() {
      selectedAlbumId = albumId;
      filteredPhotos = albums
          .firstWhere((album) => album["_id"] == albumId)["photos"]
          .cast<String>();
    });
  }

  /// 📌 Reset về toàn bộ ảnh
  void _resetToAllPhotos() {
    setState(() {
      selectedAlbumId = null;
      filteredPhotos = allPhotos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // 🆕 Nút thêm album
            onPressed: () => _showCreateAlbumDialog(),
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
            // 📌 Danh sách album
            Text('Album của gia đình', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  bool isSelected = albums[index]["_id"] == selectedAlbumId;
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        _resetToAllPhotos();
                      } else {
                        _filterPhotosByAlbum(albums[index]["_id"]);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          albums[index]['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Hiển thị danh sách ảnh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedAlbumId == null ? 'Tất cả ảnh' : 'Ảnh trong album',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (selectedAlbumId != null)
                  TextButton(
                    onPressed: _resetToAllPhotos,
                    child: const Text("Xem tất cả", style: TextStyle(color: Colors.blue)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: filteredPhotos.isEmpty
                  ? const Center(child: Text("Chưa có ảnh nào"))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredPhotos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      filteredPhotos[index],
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
