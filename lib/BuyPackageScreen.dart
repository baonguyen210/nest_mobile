// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BuyPackageScreen extends StatefulWidget {
//   const BuyPackageScreen({Key? key}) : super(key: key);
//
//   @override
//   State<BuyPackageScreen> createState() => _BuyPackageScreenState();
// }
//
// class _BuyPackageScreenState extends State<BuyPackageScreen> {
//   List<dynamic> packages = [];
//   String? selectedPackageId;
//   Dio dio = Dio();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPackages();
//     _loadUserAndFamilyId();
//   }
//
//   Future<void> _fetchPackages() async {
//     var url = Uri.parse('https://platform-family.onrender.com/package/get-all');
//     var response = await dio.get(url.toString());
//     if (response.statusCode == 200) {
//       setState(() {
//         packages = response.data['data'];
//       });
//     }
//   }
//
//   Future<void> _loadUserAndFamilyId() async {
//     final prefs = await SharedPreferences.getInstance();
//     var userId = prefs.getString('userId');
//     var familyId = prefs.getString('familyId');
//
//     print('User ID: $userId');
//     print('Family ID: $familyId');
//   }
//
//   Future<void> _saveFamilyId(String newFamilyId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('familyId', newFamilyId);
//     print('Family ID updated: $newFamilyId');
//   }
//
//
//   Future<void> _registerPackage(String packageId) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');
//     String? familyId = prefs.getString('familyId');
//     String urlBill = 's.com';
//
//     var url = 'https://platform-family.onrender.com/instance/register-service';
//
//     var data = {
//       'userId': userId,
//       'packageId': packageId,
//       'familyId': familyId,
//       'urlBill': urlBill
//     };
//
//     try {
//       var response = await dio.post(url, data: data);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('Package registered successfully!');
//         print('Response: ${response.data}');
//         // Check if new familyId is available and save it
//         if (response.data['data'] != null && response.data['data']['familyId'] != null) {
//           _saveFamilyId(response.data['data']['familyId']);
//         }
//       } else {
//         print('Failed to register package. Status code: ${response.statusCode}. Response: ${response.data}');
//       }
//     } on DioError catch (e) {
//       print('DioError: ${e.response?.data}');
//       print('Status Code: ${e.response?.statusCode}');
//       print('Error sending request!');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Buy Package'),
//       ),
//       body: ListView.builder(
//         itemCount: packages.length,
//         itemBuilder: (context, index) {
//           var package = packages[index];
//           return ListTile(
//             title: Text(package['name']),
//             subtitle: Text('Price: ${package['price']} - Members: ${package['maxMembers']} - Storage: ${package['storage']}'),
//             trailing: Radio<String>(
//               value: package['_id'],
//               groupValue: selectedPackageId,
//               onChanged: (value) {
//                 setState(() {
//                   selectedPackageId = value;
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: selectedPackageId != null ? () => _registerPackage(selectedPackageId!) : null,
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyPackageScreen extends StatefulWidget {
  const BuyPackageScreen({Key? key}) : super(key: key);

  @override
  State<BuyPackageScreen> createState() => _BuyPackageScreenState();
}

class _BuyPackageScreenState extends State<BuyPackageScreen> {
  List<dynamic> packages = [];
  String? selectedPackageId;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchPackages();
    _loadUserAndFamilyId();
  }

  Future<void> _fetchPackages() async {
    var url = Uri.parse('https://platform-family.onrender.com/package/get-all');
    var response = await dio.get(url.toString());
    if (response.statusCode == 200) {
      setState(() {
        packages = List.from(response.data['data']);
      });
    } else {
      print('Failed to fetch packages: ${response.statusCode}');
    }

  }

  Future<void> _loadUserAndFamilyId() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    var familyId = prefs.getString('familyId');

    print('User ID: $userId');
    print('Family ID: $familyId');
  }

  Future<void> _saveFamilyId(String newFamilyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('familyId', newFamilyId);
    print('Family ID updated: $newFamilyId');
  }


  Future<void> _registerPackage(String packageId) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? familyId = prefs.getString('familyId');
    String urlBill = 's.com';

    var url = 'https://platform-family.onrender.com/instance/register-service';

    var data = {
      'userId': userId,
      'packageId': packageId,
      'familyId': familyId,
      'urlBill': urlBill
    };

    try {
      var response = await dio.post(url, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Package registered successfully!');
        print('Response: ${response.data}');
        // Check if new familyId is available and save it
        if (response.data['data'] != null && response.data['data']['familyId'] != null) {
          _saveFamilyId(response.data['data']['familyId']);
        }
      } else {
        print('Failed to register package. Status code: ${response.statusCode}. Response: ${response.data}');
      }
    } on DioError catch (e) {
      print('DioError: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      print('Error sending request!');
    }
  }

  Widget _buildQRCodeArea(String price, String packageName, String email) {
    // Dummy QR code widget, replace with your actual QR code widget
    Widget qrCodeWidget = Image.asset(
      'assets/images/QR.jpg',
      width: 170,
      height: 170,
    );
    return Column(
      children: [
        Text('THÔNG TIN CHUYỂN KHOẢN',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        qrCodeWidget, // Your actual QR code widget here
        SizedBox(height: 10),
        Text('Số tiền: $price VND'),
        Text('Nội dung: [Email đăng ký] $packageName'),
        SizedBox(height: 30),
      ],
    );
  }

  void _showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đợi xác nhận từ NEST nhé, gói có thể sử dụng ngay từ bây giờ!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _confirmationButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: selectedPackageId != null ? () async {
            await _registerPackage(selectedPackageId!);
            _showConfirmationSnackbar();
          } : null,
          child: const Text(
            'Đã xác nhận chuyển khoản',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Package'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: packages.length,
              itemExtent: 60, // Đặt chiều cao cố định cho mỗi mục, điều chỉnh giá trị này để phù hợp
              itemBuilder: (context, index) {
                var package = packages[index];
                return ListTile(
                  title: Text(package['name']),
                  subtitle: Text('Price: ${package['price']} - Members: ${package['maxMembers']} - Storage: ${package['storage']}'),
                  trailing: Radio<String>(
                    value: package['_id'],
                    groupValue: selectedPackageId,
                    onChanged: (value) {
                      setState(() {
                        selectedPackageId = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          selectedPackageId != null ? _buildQRCodeArea(packages.firstWhere((p) => p['_id'] == selectedPackageId)['price'].toString(), packages.firstWhere((p) => p['_id'] == selectedPackageId)['name'].toString(), "your_email@example.com") : SizedBox.shrink(),
          _confirmationButton(),
        ],
      ),
    );
  }

}
