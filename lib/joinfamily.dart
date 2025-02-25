// import 'package:flutter/material.dart';
// import 'package:nest_mobile/homepage.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'choose_family.dart'; // Trang mới để hiển thị gia đình có sẵn
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WelcomeScreen(),
//     );
//   }
// }
//
// class WelcomeScreen extends StatefulWidget {
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   TextEditingController _nameController = TextEditingController();
//   String? userId;
//   String? userName;
//   String? token;
//   bool isLoading = true; // Trạng thái load dữ liệu
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _initialize();
//   }
//
//   Future<void> _initialize() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString("userId");
//     userName = prefs.getString("name");
//     token = prefs.getString("token");
//
//     if (userName != null && userName!.isNotEmpty) {
//       print("✅ Người dùng đã có tên: $userName. Bỏ qua nhập tên.");
//       _checkExistingFamily();
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _checkExistingFamily() async {
//     if (token == null) {
//       print("⚠️ Không có token, yêu cầu đăng nhập lại.");
//       return;
//     }
//
//     try {
//       var dio = Dio();
//       Response response = await dio.get(
//         'https://platform-family.onrender.com/family/get-family-user',
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//
//       if (response.statusCode == 200 && response.data['data'].isNotEmpty) {
//         print("✅ Người dùng đã có gia đình, chuyển đến `ChooseFamily.dart`.");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ChooseFamilyScreen(families: response.data['data'])),
//         );
//       } else {
//         print("❌ Người dùng chưa có gia đình.");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
//         );
//       }
//     } catch (e) {
//       print("🚨 Lỗi kiểm tra gia đình: $e");
//     }
//   }
//
//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString("userId");
//     });
//     print("🔹 User ID đã load: $userId");
//   }
//
//   Future<void> _updateUserName() async {
//     if (_nameController.text.isEmpty || userId == null) {
//       print("⚠️ Lỗi: userId hoặc tên trống!");
//       print("🔹 userId: $userId");
//       print("🔹 name: ${_nameController.text}");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Vui lòng nhập tên trước khi tiếp tục!")),
//       );
//       return;
//     }
//
//     String apiUrl = 'https://platform-family.onrender.com/user/update-info/$userId';
//
//     // ✅ Đảm bảo đúng thứ tự: "avatar" trước "name"
//     Map<String, dynamic> requestData = {
//       "avatar": "", // Avatar trống
//       "name": _nameController.text.trim(),
//     };
//
//     print("🌐 Gửi request đến API: $apiUrl");
//     print("📌 Dữ liệu gửi đi (chuẩn JSON): ${jsonEncode(requestData)}");
//
//     try {
//       var dio = Dio();
//       Response response = await dio.put( // ✅ Sử dụng PUT thay vì POST
//         apiUrl,
//         data: requestData,
//       );
//
//       print("📌 Phản hồi API khi cập nhật tên: ${response.statusCode}");
//       print("📌 Dữ liệu trả về: ${response.data}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Lưu tên vào SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('name', _nameController.text.trim());
//
//         print("💾 Đã lưu tên vào SharedPreferences: ${_nameController.text}");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Cập nhật tên thành công!"), backgroundColor: Colors.green),
//         );
//
//         Future.delayed(Duration(seconds: 1), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
//           );
//         });
//       }
//       else {
//         print("❌ API trả về lỗi: ${response.statusCode} - ${response.data}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Cập nhật thất bại. Vui lòng thử lại!"), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi cập nhật tên: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng!"), backgroundColor: Colors.red),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/family.png', height: 350),
//             SizedBox(height: 50),
//             Text(
//               'Chúc mừng, bạn đã là thành viên của',
//               style: TextStyle(fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               'Đại Gia Đình NEST.',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 hintText: "Nhập tên của bạn",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _updateUserName,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text("Tiếp tục",
//                     style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ThamGiaGiaDinh extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image.asset('assets/images/AE.png', height: 100),
//             // SizedBox(height: 20),
//             SizedBox(height: 40),
//             Text(
//                 'Xin chào! Bây giờ, bạn có thể tham gia hoặc tạo gia đình của bạn',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center),
//             SizedBox(height: 20),
//             Image.asset('assets/images/s.png', height: 320),
//             // SizedBox(height: 0),
//             Text('Lưu giữ kỷ niệm cùng nhau!',
//                 style: TextStyle(color: Colors.red)),
//             SizedBox(height: 50),
//             Text('Gia đình bạn chỉ được tiếp cận với nhau qua mã.',
//                 textAlign: TextAlign.center),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity, // Đảm bảo button rộng hết cỡ
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => NhapMaScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   'Tiếp tục',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NhapMaScreen extends StatefulWidget {
//   @override
//   _NhapMaScreenState createState() => _NhapMaScreenState();
// }
//
// class _NhapMaScreenState extends State<NhapMaScreen> {
//   List<TextEditingController> controllers =
//   List.generate(8, (index) => TextEditingController());
//   List<FocusNode> focusNodes = List.generate(8, (index) => FocusNode());
//
//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }
//
//   Widget buildCodeBox(int index) {
//     return Container(
//       width: 38, // Giảm từ 45 xuống 38
//       height: 50, // Giảm từ 60 xuống 50
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: controllers[index].text.isEmpty && index == firstEmptyIndex()
//             ? Colors.yellow
//             : Colors.grey[300],
//         borderRadius: BorderRadius.circular(6), // Giảm góc bo tròn một chút
//       ),
//       child: TextField(
//           controller: controllers[index],
//           focusNode: focusNodes[index],
//           textAlign: TextAlign.center,
//           maxLength: 1,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Giảm font size
//           keyboardType: TextInputType.text,
//           textCapitalization: TextCapitalization.characters,
//           textInputAction: index < 7 ? TextInputAction.next : TextInputAction.done,
//           decoration: InputDecoration(
//             counterText: "",
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             controllers[index].value = controllers[index].value.copyWith(
//               text: value.toUpperCase(),
//               selection: TextSelection.collapsed(offset: value.length),
//             );
//
//             if (value.isNotEmpty && index < 7) {
//               FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//             } else if (value.isEmpty && index > 0) {
//               FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//             }
//
//             setState(() {});
//           }
//       ),
//     );
//   }
//
//
//
//   int firstEmptyIndex() {
//     for (int i = 0; i < controllers.length; i++) {
//       if (controllers[i].text.isEmpty) return i;
//     }
//     return controllers.length;
//   }
//
//
//   Future<void> joinFamily() async {
//     String codeNumber = controllers.map((c) => c.text).join().trim();
//     print("🚀 Đang gửi mã lời mời: '$codeNumber'");
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");
//
//       var dio = Dio();
//       Response response = await dio.post(
//         'https://platform-family.onrender.com/family/join-family',
//         data: {"codeNumber": codeNumber},
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         String familyId = response.data["data"]["familyId"];
//         await prefs.setString('familyId', familyId);
//         print("✅ Family ID đã được lưu: $familyId");
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Homepage()),
//         );
//       } else {
//         print("❌ Mã không hợp lệ hoặc lỗi!");
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi tham gia gia đình: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Bạn muốn tham gia Gia đình?\nNhập mã lời mời của bạn',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 8,
//                     (index) => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: SizedBox(
//                     height: 60,
//                     child: buildCodeBox(index),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Gợi ý: Bạn có thể hỏi người tạo Gia đình để biết mã lời mời nhé!',
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: controllers.every((c) => c.text.isNotEmpty)
//                     ? joinFamily
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: controllers.every((c) => c.text.isNotEmpty)
//                       ? Colors.blue
//                       : Colors.grey[300],
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   'Gửi',
//                   style: TextStyle(
//                     color: controllers.every((c) => c.text.isNotEmpty)
//                         ? Colors.white
//                         : Colors.grey,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 180),
//             Text(
//               'HOẶC',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             SizedBox(height: 3),
//             Text('Bạn chưa có NHÓM?'),
//             SizedBox(height: 3),
//             Text('Hãy tạo ngay bên dưới !'),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TaoNhomScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   'Tạo vòng tròn mới',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TaoNhomScreen extends StatefulWidget {
//   @override
//   _TaoNhomScreenState createState() => _TaoNhomScreenState();
// }
//
// class _TaoNhomScreenState extends State<TaoNhomScreen> {
//   TextEditingController _controller = TextEditingController();
//   String? userId; // ID user động
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserId(); // Gọi hàm lấy userId khi mở màn hình
//   }
//
//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString("userId"); // Lấy ID từ SharedPreferences
//     });
//     print("User ID đã load: $userId");
//   }
//
//   Future<void> createFamily() async {
//     print("🚀 Hàm createFamily() được gọi!");
//
//     if (_controller.text.isEmpty || userId == null) {
//       print("⚠️ Thiếu dữ liệu: Tên gia đình: ${_controller.text}, UserID: $userId");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin trước khi tạo gia đình!")),
//       );
//       return;
//     }
//
//     try {
//       var dio = Dio();
//       Response response = await dio.post(
//         'https://platform-family.onrender.com/family/create',
//         data: {
//           "name": _controller.text,
//           "admin": userId,
//           "members": [userId]
//         },
//       );
//
//       print("📌 Phản hồi API khi tạo gia đình: ${response.data}");
//
//       if ((response.statusCode == 200 || response.statusCode == 201) && response.data['ok'] == true) {
//         String familyId = response.data["data"]["_id"]; // Lấy familyId từ API
//
//         print("✅ Gia đình đã được tạo thành công với familyId: $familyId");
//
//         // Lưu familyId vào SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('familyId', familyId);
//
//         print("💾 familyId đã được lưu vào SharedPreferences");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Gia đình đã được tạo thành công!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         // Điều hướng về trang chủ sau khi tạo gia đình thành công
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Homepage()),
//           );
//         });
//       } else {
//         print("❌ Tạo gia đình thất bại: ${response.data}");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Tạo gia đình thất bại. Vui lòng thử lại!"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       print("🚨 Lỗi khi tạo gia đình: $e");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng!"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Text('Đặt tên Gia đình của bạn',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             TextField(
//               controller: _controller,
//               onChanged: (value) {
//                 setState(() {}); // Cập nhật trạng thái khi nhập tên
//               },
//               decoration: InputDecoration(
//                 hintText: '|',
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
//                 border: InputBorder.none,
//               ),
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             Text('Bạn có thể thay đổi tên Gia đình trong cài đặt.',
//                 textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
//             SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _controller.text.isNotEmpty != null
//                     ? () {
//                   print("🟢 Nút 'Tiếp tục' được bấm!");
//                   createFamily();
//                 }
//                     : null, // Disable nếu chưa nhập tên gia đình hoặc chưa chọn vai trò
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _controller.text.isNotEmpty != null
//                       ? Colors.blue
//                       : Colors.grey[300],
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   'Tiếp tục',
//                   style: TextStyle(
//                     color: _controller.text.isNotEmpty != null
//                         ? Colors.white
//                         : Colors.grey,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:nest_mobile/homepage.dart';
import 'package:dio/dio.dart';
import 'package:nest_mobile/show_family_code.dart';
import 'package:nest_mobile/upload_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'choose_family.dart'; // Trang mới để hiển thị gia đình có sẵn


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController _nameController = TextEditingController();
  String? userId;
  bool isButtonEnabled = false; // Thêm biến này vào trong class _TaoNhomScreenState
  String? userName;
  String? token;
  bool isLoading = true; // Trạng thái load dữ liệu

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    userName = prefs.getString("name");
    token = prefs.getString("token");

    if (userName != null && userName!.isNotEmpty) {
      print("✅ Người dùng đã có tên: $userName. Bỏ qua nhập tên.");
      _checkExistingFamily();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkExistingFamily() async {
    if (token == null) {
      print("⚠️ Không có token, yêu cầu đăng nhập lại.");
      return;
    }

    try {
      var dio = Dio();
      Response response = await dio.get(
        'https://platform-family.onrender.com/family/get-family-user',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['data'].isNotEmpty) {
        print("✅ Người dùng đã có gia đình, chuyển đến `ChooseFamily.dart`.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChooseFamilyScreen(families: response.data['data'])),
        );
      } else {
        print("❌ Người dùng chưa có gia đình.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
        );
      }
    } catch (e) {
      print("🚨 Lỗi kiểm tra gia đình: $e");
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
    print("🔹 User ID đã load: $userId");
  }

  Future<void> _updateUserName() async {
    if (_nameController.text.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập tên trước khi tiếp tục!"), backgroundColor: Colors.red),
      );
      return;
    }

    String apiUrl = 'https://platform-family.onrender.com/user/update-info/$userId';
    Map<String, dynamic> requestData = {
      "avatar": "", // Avatar trống
      "name": _nameController.text.trim(),
    };

    try {
      var dio = Dio();
      Response response = await dio.put(apiUrl, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _nameController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật tên thành công!"), backgroundColor: Colors.green),
        );

        Future.delayed(Duration(seconds: 1), () {
          // ✅ Kiểm tra avatar trước khi điều hướng
          if (response.data['data']['avatar'] == "") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UploadAvatarScreen()), // ✅ Chuyển đến Upload Avatar
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật thất bại. Vui lòng thử lại!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể kết nối đến máy chủ!"), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/family.png', height: 350),
            SizedBox(height: 50),
            Text(
              'Chúc mừng, bạn đã là thành viên của',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              'Đại Gia Đình NEST.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Nhập tên của bạn",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateUserName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Tiếp tục",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThamGiaGiaDinh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('assets/images/AE.png', height: 100),
            // SizedBox(height: 20),
            SizedBox(height: 40),
            Text(
                'Xin chào! Bây giờ, bạn có thể tham gia hoặc tạo gia đình của bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            Image.asset('assets/images/s.png', height: 320),
            // SizedBox(height: 0),
            Text('Lưu giữ kỷ niệm cùng nhau!',
                style: TextStyle(color: Colors.red)),
            SizedBox(height: 50),
            Text('Gia đình bạn chỉ được tiếp cận với nhau qua mã.',
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Đảm bảo button rộng hết cỡ
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NhapMaScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NhapMaScreen extends StatefulWidget {
  @override
  _NhapMaScreenState createState() => _NhapMaScreenState();
}

class _NhapMaScreenState extends State<NhapMaScreen> {
  List<TextEditingController> controllers =
  List.generate(8, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(8, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Widget buildCodeBox(int index) {
    return Container(
      width: 38, // Giảm từ 45 xuống 38
      height: 50, // Giảm từ 60 xuống 50
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: controllers[index].text.isEmpty && index == firstEmptyIndex()
            ? Colors.yellow
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(6), // Giảm góc bo tròn một chút
      ),
      child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          maxLength: 1,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Giảm font size
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          textInputAction: index < 7 ? TextInputAction.next : TextInputAction.done,
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            controllers[index].value = controllers[index].value.copyWith(
              text: value.toUpperCase(),
              selection: TextSelection.collapsed(offset: value.length),
            );

            if (value.isNotEmpty && index < 7) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }

            setState(() {});
          }
      ),
    );
  }



  int firstEmptyIndex() {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) return i;
    }
    return controllers.length;
  }


  Future<void> joinFamily() async {
    String codeNumber = controllers.map((c) => c.text).join().trim();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var dio = Dio();
      Response response = await dio.post(
        'https://platform-family.onrender.com/family/join-family',
        data: {"codeNumber": codeNumber},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        String familyId = response.data["data"]["familyId"];
        await prefs.setString('familyId', familyId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tham gia gia đình thành công!"), backgroundColor: Colors.green),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mã không hợp lệ hoặc lỗi!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể kết nối đến máy chủ!"), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Bạn muốn tham gia Gia đình?\nNhập mã lời mời của bạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                8,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    height: 60,
                    child: buildCodeBox(index),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Gợi ý: Bạn có thể hỏi người tạo Gia đình để biết mã lời mời nhé!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controllers.every((c) => c.text.isNotEmpty)
                    ? joinFamily
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controllers.every((c) => c.text.isNotEmpty)
                      ? Colors.blue
                      : Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Gửi',
                  style: TextStyle(
                    color: controllers.every((c) => c.text.isNotEmpty)
                        ? Colors.white
                        : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 180),
            Text(
              'HOẶC',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 3),
            Text('Bạn chưa có NHÓM?'),
            SizedBox(height: 3),
            Text('Hãy tạo ngay bên dưới !'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaoNhomScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Tạo vòng tròn mới',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaoNhomScreen extends StatefulWidget {
  @override
  _TaoNhomScreenState createState() => _TaoNhomScreenState();
}

class _TaoNhomScreenState extends State<TaoNhomScreen> {
  TextEditingController _controller = TextEditingController();
  String? userId; // ID user động
  bool isButtonEnabled = false; // ✅ Thêm biến này vào đây

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Gọi hàm lấy userId khi mở màn hình
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId"); // Lấy ID từ SharedPreferences
    });
    print("User ID đã load: $userId");
  }

  Future<void> createFamily() async {
    print("🚀 Hàm createFamily() được gọi!");

    if (_controller.text.isEmpty || userId == null) {
      print("⚠️ Thiếu dữ liệu: Tên gia đình: ${_controller.text}, UserID: $userId");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập Tên Gia Đình của bạn!")),
      );
      return;
    }

    try {
      var dio = Dio();
      Response response = await dio.post(
        'https://platform-family.onrender.com/family/create',
        data: {
          "name": _controller.text,
          "admin": userId,
          "members": [userId]
        },
      );

      print("📌 Phản hồi API khi tạo gia đình: ${response.data}");

      if ((response.statusCode == 200 || response.statusCode == 201) && response.data['ok'] == true) {
        String familyId = response.data["data"]["_id"] ?? ""; // Kiểm tra null
        String familyCode = response.data["data"]["codeNumber"]?.toString() ?? "UNKNOWN"; // ✅ Fix lỗi Null

        print("✅ Gia đình đã được tạo thành công với familyId: $familyId");
        print("✅ Mã gia đình: $familyCode");

        // Lưu familyId vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('familyId', familyId);

        print("💾 familyId đã được lưu vào SharedPreferences");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gia đình đã được tạo thành công!"),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Điều hướng về trang ShowFamilyCodeScreen với familyCode
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowFamilyCodeScreen(familyCode: familyCode),
            ),
          );
        });
      } else {
        print("❌ Tạo gia đình thất bại: ${response.data}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tạo gia đình thất bại. Vui lòng thử lại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("🚨 Lỗi khi tạo gia đình: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('Đặt tên Gia đình của bạn',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  isButtonEnabled = value.trim().isNotEmpty; // ✅ Kiểm tra rỗng và cập nhật state
                });
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên gia đình...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),



            SizedBox(height: 10),
            Text('Bạn có thể thay đổi tên Gia đình trong cài đặt.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                  print("🟢 Nút 'Tiếp tục' được bấm!");
                  createFamily();
                }
                    : null, // ✅ Disable nếu chưa nhập tên
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(
                    color: isButtonEnabled ? Colors.white : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

}