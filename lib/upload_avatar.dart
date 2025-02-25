// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:nest_mobile/joinfamily.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UploadAvatarScreen extends StatefulWidget {
//   @override
//   _UploadAvatarScreenState createState() => _UploadAvatarScreenState();
// }
//
// class _UploadAvatarScreenState extends State<UploadAvatarScreen> {
//   XFile? _image;
//   final ImagePicker _picker = ImagePicker();
//   bool isUploading = false; // Trạng thái upload
//   String? uploadedAvatarUrl;
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedFile;
//     });
//   }
//
//   Future<void> _uploadAvatar() async {
//     if (_image == null) return;
//     setState(() {
//       isUploading = true;
//     });
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString("userId");
//     String? token = prefs.getString("token");
//
//     if (userId == null || token == null) {
//       print("⚠️ Không tìm thấy UserID hoặc Token!");
//       return;
//     }
//
//     String uploadUrl = "https://platform-family.onrender.com/upload/multiple";
//     String updateUrl = "https://platform-family.onrender.com/user/update-info/$userId";
//
//     print("🔹 API Upload URL: $uploadUrl");
//     print("🔹 API Update URL: $updateUrl");
//     print("🔹 User ID: $userId");
//     print("🔹 Access Token: $token");
//     print("🔹 Đang gửi ảnh lên server...");
//
//     try {
//       Dio dio = Dio();
//
//       // ✅ Bước 1: Upload ảnh lên server
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(_image!.path, filename: "avatar.jpg"),
//       });
//
//       Response uploadResponse = await dio.post(
//         uploadUrl,
//         data: formData,
//         options: Options(headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "multipart/form-data",
//         }),
//       );
//
//       if (uploadResponse.statusCode == 200 && uploadResponse.data["url"] != null) {
//         uploadedAvatarUrl = uploadResponse.data["url"];
//         print("✅ Ảnh đã được upload thành công: $uploadedAvatarUrl");
//
//         // ✅ Bước 2: Cập nhật avatar vào hồ sơ user
//         Response updateResponse = await dio.put(
//           updateUrl,
//           data: {
//             "avatar": uploadedAvatarUrl,
//           },
//           options: Options(headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "application/json",
//           }),
//         );
//
//         if (updateResponse.statusCode == 200) {
//           print("✅ Cập nhật avatar thành công!");
//
//           // ✅ Lưu avatar vào SharedPreferences
//           await prefs.setString("avatar", uploadedAvatarUrl!);
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Cập nhật avatar thành công!"), backgroundColor: Colors.green),
//           );
//
//           Future.delayed(Duration(seconds: 2), () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()));
//           });
//         } else {
//           print("❌ Lỗi khi cập nhật avatar: ${updateResponse.data}");
//         }
//       } else {
//         print("❌ Lỗi khi upload ảnh: ${uploadResponse.data}");
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi upload avatar: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi khi tải ảnh!"), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() {
//         isUploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(automaticallyImplyLeading: false, title: Text("Cập nhật Avatar")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Chọn ảnh đại diện của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.blueAccent, width: 2),
//                 image: _image != null
//                     ? DecorationImage(image: FileImage(File(_image!.path)), fit: BoxFit.cover)
//                     : uploadedAvatarUrl != null
//                     ? DecorationImage(image: NetworkImage(uploadedAvatarUrl!), fit: BoxFit.cover)
//                     : DecorationImage(image: AssetImage("assets/images/default_avatar.png"), fit: BoxFit.cover),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: Text("Chọn ảnh", style: TextStyle(color: Colors.white, fontSize: 16)),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: _image != null && !isUploading ? _uploadAvatar : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _image != null && !isUploading ? Colors.green : Colors.grey,
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: isUploading
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : Text("Cập nhật", style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//                 SizedBox(width: 10),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
//                     );
//                   },
//                   child: Text("Bỏ qua", style: TextStyle(color: Colors.red, fontSize: 16)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:nest_mobile/joinfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadAvatarScreen extends StatefulWidget {
  @override
  _UploadAvatarScreenState createState() => _UploadAvatarScreenState();
}

class _UploadAvatarScreenState extends State<UploadAvatarScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false; // Trạng thái upload
  String? uploadedAvatarUrl;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _uploadAvatar() async {
    if (_image == null) return;
    setState(() {
      isUploading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    String? token = prefs.getString("token");

    if (userId == null || token == null) {
      print("⚠️ Không tìm thấy UserID hoặc Token!");
      return;
    }

    String uploadUrl = "https://platform-family.onrender.com/upload/multiple";
    String updateUrl = "https://platform-family.onrender.com/user/update-info/$userId";

    try {
      Dio dio = Dio();

      // ✅ Bước 1: Upload ảnh avatar lên server
      print("📤 Đang upload ảnh...");
      FormData formData = FormData.fromMap({
        "images": await MultipartFile.fromFile(_image!.path, filename: "avatar.jpg"),
      });

      Response uploadResponse = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        }),
      );

      print("📤 Response Upload: ${uploadResponse.statusCode}, Data: ${uploadResponse.data}");

      if (uploadResponse.statusCode == 200 && uploadResponse.data["urls"] != null) {
        uploadedAvatarUrl = uploadResponse.data["urls"][0]; // ✅ Lấy URL ảnh đầu tiên

        print("✅ Ảnh đã được upload thành công: $uploadedAvatarUrl");
      } else {
        print("❌ Lỗi khi upload ảnh: ${uploadResponse.data}");
        return;
      }

      // ✅ Bước 2: Cập nhật avatar vào hồ sơ user
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString("name"); // ✅ Lấy name từ SharedPreferences

      if (uploadedAvatarUrl == null || uploadedAvatarUrl!.isEmpty) {
        print("🚨 Lỗi: uploadedAvatarUrl bị null hoặc rỗng!");
        return;
      }

      if (userName == null || userName.isEmpty) {
        print("🚨 Lỗi: userName bị null hoặc rỗng!");
        return;
      }

      print("📤 Gửi request cập nhật avatar...");
      print("🔹 API URL: $updateUrl");
      print("🔹 Token: $token");
      print("🔹 Dữ liệu gửi đi: ${{
        "name": userName,  // ✅ Bổ sung name
        "avatar": uploadedAvatarUrl // ✅ Đảm bảo avatar là String hợp lệ
      }}");

      Response updateResponse = await dio.put(
        updateUrl,
        data: {
          "name": userName, // ✅ Bổ sung name
          "avatar": uploadedAvatarUrl
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (updateResponse.statusCode == 200) {
        print("✅ Cập nhật avatar thành công!");
        await prefs.setString("avatar", uploadedAvatarUrl!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật avatar thành công!"), backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
        );
      } else {
        print("❌ API update-info trả về lỗi: ${updateResponse.statusCode} - ${updateResponse.data}");
      }
    } catch (e) {
      if (e is DioError) {
        print("🚨 DioError: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("🚨 Lỗi không xác định khi upload avatar: $e");
      }
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text("Cập nhật Avatar")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chọn ảnh đại diện của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 2),
                image: _image != null
                    ? DecorationImage(image: FileImage(File(_image!.path)), fit: BoxFit.cover)
                    : uploadedAvatarUrl != null
                    ? DecorationImage(image: NetworkImage(uploadedAvatarUrl!), fit: BoxFit.cover)
                    : DecorationImage(image: AssetImage("assets/images/default_avatar.png"), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Chọn ảnh", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _image != null && !isUploading ? _uploadAvatar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _image != null && !isUploading ? Colors.green : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Cập nhật", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
                    );
                  },
                  child: Text("Bỏ qua", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
