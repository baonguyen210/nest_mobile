// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'homepage.dart';
//
// class ShowFamilyCodeScreen extends StatelessWidget {
//   final String familyCode;
//
//   ShowFamilyCodeScreen({required this.familyCode});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mã Gia Đình")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Mã gia đình của bạn:", style: TextStyle(fontSize: 18)),
//             Text(familyCode, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
//               },
//               child: Text("Tiếp tục"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import để sử dụng Clipboard
import 'homepage.dart';

class ShowFamilyCodeScreen extends StatelessWidget {
  final String familyCode;

  ShowFamilyCodeScreen({required this.familyCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mã gia đình của bạn:", style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),

            // ✅ Mã gia đình có thể nhấn để sao chép
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: familyCode)); // Sao chép vào Clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Sao chép Mã gia đình thành công!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 1.5),
                ),
                child: Text(
                  familyCode,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Hãy lưu mã này và gửi đến các thành viên để mọi người cùng tham gia nhé",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center, // ✅ Đảm bảo text được căn giữa
              ),
            ),
            SizedBox(height: 20),


            // ✅ Button "Tiếp tục" giống với button trong màn hình "Đặt tên Gia đình"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  "Tiếp tục",
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
