// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:nest_mobile/homepage.dart';
// import 'package:nest_mobile/joinfamily.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//       home: AuthScreen(),
//     );
//   }
// }
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;
//   String email = "";
//   String password = "";
//   String name = "None";
//
//   Future<void> login() async {
//     try {
//       var dio = Dio();
//       Response response = await dio.post(
//         'https://platform-family.onrender.com/login',
//         data: {
//           "email": email,
//           "password": password
//         },
//       );
//
//       if (response.statusCode == 200 && response.data['ok'] == true) {
//         // Lấy dữ liệu từ response
//         String userId = response.data['data']['_id'];
//         String name = response.data['data']['name'];
//         String avatar = response.data['data']['avatar'];
//         String accessToken = response.data['data']['access_token']; // ✅ Lấy token
//
//         // Lưu thông tin vào SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('userId', userId);
//         await prefs.setString('name', name);
//         await prefs.setString('avatar', avatar);
//         await prefs.setString('token', accessToken); // ✅ Lưu token
//
//         print("User ID đã được lưu: $userId");
//         print("Tên: $name");
//         print("Avatar: $avatar");
//         print("Token lưu: $accessToken");
//
//         // Chuyển hướng sang màn hình tham gia gia đình
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => WelcomeScreen()),
//         );
//       }
//     } catch (e) {
//       print("Đăng nhập thất bại: $e");
//     }
//   }
//
//
//   Future<void> register() async {
//     try {
//       var dio = Dio();
//       Response response = await dio.post(
//         'https://platform-family.onrender.com/register',
//         data: {
//           "name": name,
//           "email": email,
//           "password": password
//         },
//       );
//       print(response.data);
//       if (response.statusCode == 200) {
//         setState(() {
//           isLogin = true;
//         });
//       }
//     } catch (e) {
//       print("Đăng ký thất bại: $e");
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
//             Image.asset('assets/images/AE.png', height: 200, width: 200, fit: BoxFit.contain),
//             SizedBox(height: 0),
//             Text('MXH DÀNH CHO GIA ĐÌNH', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: isLogin ? Colors.white : Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(Colors.transparent),
//                           shadowColor: MaterialStateProperty.all(Colors.transparent),
//                           overlayColor: MaterialStateProperty.all(Colors.transparent),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isLogin = true;
//                           });
//                         },
//                         child: Text('Đăng nhập', style: TextStyle(color: isLogin ? Colors.black : Colors.grey)),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: !isLogin ? Colors.white : Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           setState(() {
//                             isLogin = false;
//                           });
//                         },
//                         child: Text('Đăng ký', style: TextStyle(color: !isLogin ? Colors.black : Colors.grey)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5),
//             isLogin ? buildLoginForm() : buildRegisterForm(),
//             Spacer(),
//             SizedBox(height: 10),
//             Text('Hoặc', style: TextStyle(color: Colors.grey)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(onPressed: () {}, icon: Image.asset('assets/images/Google.png', height: 35, width: 40)),
//                 IconButton(onPressed: () {}, icon: Image.asset('assets/images/Facebook.png', height: 35, width: 40)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildLoginForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(labelText: 'Tài khoản/Email'),
//           onChanged: (value) => setState(() {
//             email = value;
//           }),
//         ),
//         TextField(
//           onChanged: (value) => setState(() {
//             password = value;
//           }),
//           obscureText: true,
//           decoration: InputDecoration(labelText: 'Mật khẩu', suffixIcon: Icon(Icons.visibility)),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Checkbox(value: false, onChanged: (value) {}),
//                 Text('Ghi nhớ tôi')
//               ],
//             ),
//             TextButton(onPressed: () {}, child: Text('Quên mật khẩu?')),
//           ],
//         ),
//         SizedBox(height: 10),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: login,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: Text('Đăng nhập', style: TextStyle(color: Colors.white, fontSize: 16)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildRegisterForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(labelText: 'Tài khoản/Email'),
//           onChanged: (value) => setState(() {
//             email = value;
//           }),
//         ),
//         TextField(
//           obscureText: true,
//           decoration: InputDecoration(labelText: 'Mật khẩu', suffixIcon: Icon(Icons.visibility)),
//           onChanged: (value) => setState(() {
//             password = value;
//           }),
//         ),
//         TextField(
//           obscureText: true,
//           decoration: InputDecoration(labelText: 'Xác nhận mật khẩu', suffixIcon: Icon(Icons.visibility)),
//         ),
//         SizedBox(height: 20),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: register,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: Text('Đăng ký', style: TextStyle(color: Colors.white, fontSize: 16)),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:nest_mobile/homepage.dart';
import 'package:nest_mobile/joinfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  String email = "";
  String password = "";
  String name = "";

  Future<void> login() async {
    try {
      var dio = Dio();
      Response response = await dio.post(
        'https://platform-family.onrender.com/login',
        data: {
          "email": email,
          "password": password
        },
      );

      if (response.statusCode == 200 && response.data['ok'] == true) {
        // Lấy dữ liệu từ response
        String userId = response.data['data']['_id'];
        String name = response.data['data']['name'];
        String avatar = response.data['data']['avatar'];
        String accessToken = response.data['data']['access_token']; // ✅ Lấy token

        // Lưu thông tin vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('name', name);
        await prefs.setString('avatar', avatar);
        await prefs.setString('token', accessToken); // ✅ Lưu token

        print("User ID đã được lưu: $userId");
        print("Tên: $name");
        print("Avatar: $avatar");
        print("Token lưu: $accessToken");

        // Chuyển hướng sang màn hình tham gia gia đình
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      }
    } catch (e) {
      print("Đăng nhập thất bại: $e");
    }
  }


  Future<void> register() async {
    try {
      var dio = Dio();
      Response response = await dio.post(
        'https://platform-family.onrender.com/register',
        data: {
          "name": name,
          "email": email,
          "password": password
        },
      );

      if (response.statusCode == 200 && response.data['ok'] == true) {
        setState(() {
          isLogin = true;
        });

        // ✅ Hiển thị thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng ký tài khoản thành công!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng ký thất bại. Vui lòng thử lại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi kết nối máy chủ! Vui lòng kiểm tra lại."),
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
            Image.asset('assets/images/AE.png', height: 200, width: 200, fit: BoxFit.contain),
            SizedBox(height: 0),
            Text('MXH DÀNH CHO GIA ĐÌNH', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          setState(() {
                            isLogin = true;
                          });
                        },
                        child: Text('Đăng nhập', style: TextStyle(color: isLogin ? Colors.black : Colors.grey)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isLogin ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = false;
                          });
                        },
                        child: Text('Đăng ký', style: TextStyle(color: !isLogin ? Colors.black : Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            isLogin ? buildLoginForm() : buildRegisterForm(),
            Spacer(),
            SizedBox(height: 10),
            Text('Hoặc', style: TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: Image.asset('assets/images/Google.png', height: 35, width: 40)),
                IconButton(onPressed: () {}, icon: Image.asset('assets/images/Facebook.png', height: 35, width: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Tài khoản/Email'),
          onChanged: (value) => setState(() {
            email = value;
          }),
        ),
        TextField(
          onChanged: (value) => setState(() {
            password = value;
          }),
          obscureText: true,
          decoration: InputDecoration(labelText: 'Mật khẩu', suffixIcon: Icon(Icons.visibility)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Text('Ghi nhớ tôi')
              ],
            ),
            TextButton(onPressed: () {}, child: Text('Quên mật khẩu?')),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Đăng nhập', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget buildRegisterForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Tài khoản/Email'),
          onChanged: (value) => setState(() {
            email = value;
          }),
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Mật khẩu', suffixIcon: Icon(Icons.visibility)),
          onChanged: (value) => setState(() {
            password = value;
          }),
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Xác nhận mật khẩu', suffixIcon: Icon(Icons.visibility)),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Đăng ký', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}