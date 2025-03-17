// import 'package:flutter/material.dart';
// import 'package:nest_mobile/joinfamily.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'homepage.dart';
//
// class ChooseFamilyScreen extends StatelessWidget {
//   final List families;
//
//   ChooseFamilyScreen({required this.families});
//
//   Future<void> _saveFamilyId(BuildContext context, String familyId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('familyId', familyId);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Gia đình đã được chọn!"), backgroundColor: Colors.green),
//     );
//
//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Chọn Gia Đình"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: families.length,
//                 itemBuilder: (context, index) {
//                   var family = families[index];
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 8),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blue, width: 1.5),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         family['name'],
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       leading: Icon(Icons.family_restroom, color: Colors.blue),
//                       onTap: () => _saveFamilyId(context, family['_id']),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => NhapMaScreen()));
//               },
//               child: Text("Nhập mã để tham gia gia đình khác", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:nest_mobile/googleMapFlutter.dart';
import 'package:nest_mobile/joinfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class ChooseFamilyScreen extends StatelessWidget {
  final List families;

  ChooseFamilyScreen({required this.families});

  Future<void> _saveFamilyId(BuildContext context, String familyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('FamilyId', familyId); // Đổi thành 'FamilyId' để đồng nhất với `message.dart`

    print("✅ FamilyId đã lưu vào SharedPreferences: $familyId");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gia đình đã được chọn!"), backgroundColor: Colors.green),
    );

    Future.delayed(Duration(seconds: 2), () {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleMapFlutter()));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chọn Gia Đình"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: families.length,
                itemBuilder: (context, index) {
                  var family = families[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        family['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(Icons.family_restroom, color: Colors.blue),
                      onTap: () => _saveFamilyId(context, family['_id']),
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NhapMaScreen()));
              },
              child: Text("Nhập mã để tham gia gia đình khác", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
