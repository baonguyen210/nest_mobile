import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAvatarScreen extends StatefulWidget {
  @override
  _UpdateAvatarScreenState createState() => _UpdateAvatarScreenState();
}

class _UpdateAvatarScreenState extends State<UpdateAvatarScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
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
    String? userName = prefs.getString("name"); // ✅ Lấy name từ SharedPreferences

    if (userId == null || token == null) {
      print("⚠️ Không tìm thấy UserID hoặc Token!");
      return;
    }

    String uploadUrl = "https://platform-family.onrender.com/upload/multiple";
    String updateUrl = "https://platform-family.onrender.com/user/update-info/$userId";

    try {
      Dio dio = Dio();

      // ✅ Bước 1: Upload ảnh lên server
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

      if (uploadResponse.statusCode == 200 && uploadResponse.data["urls"] != null) {
        uploadedAvatarUrl = uploadResponse.data["urls"][0]; // ✅ Lấy URL từ response
        print("✅ Ảnh đã được upload thành công: $uploadedAvatarUrl");

        // 🔹 Kiểm tra lại name
        if (userName == null || userName.isEmpty) {
          userName = "Người dùng";
        }

        // ✅ Bước 2: Cập nhật avatar vào hồ sơ user
        Response updateResponse = await dio.put(
          updateUrl,
          data: {
            "avatar": uploadedAvatarUrl,
            "name": userName, // ✅ Đảm bảo API nhận đủ name
          },
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          }),
        );

        if (updateResponse.statusCode == 200) {
          print("✅ Cập nhật avatar thành công!");

          // ✅ Lưu avatar vào SharedPreferences
          await prefs.setString("avatar", uploadedAvatarUrl!);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cập nhật avatar thành công!"), backgroundColor: Colors.green),
          );

          // ✅ Điều hướng quay lại màn hình cài đặt
          Navigator.pop(context, uploadedAvatarUrl);
        } else {
          print("❌ API update-info trả về lỗi: ${updateResponse.statusCode} - ${updateResponse.data}");
        }
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
      appBar: AppBar(title: Text("Cập nhật ảnh đại diện")),
      body: Center(  // ✅ Đưa toàn bộ nội dung vào giữa
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ Căn giữa theo trục dọc
          children: [
            Text("Chọn ảnh đại diện của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
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
          ],
        ),
      ),
    );
  }
}
