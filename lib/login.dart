import 'package:flutter/material.dart';
import 'package:nest_mobile/joinfamily.dart';

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
            SizedBox(height: 30),
            Text('Hoặc', style: TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.g_translate, color: Colors.blue)),
                IconButton(onPressed: () {}, icon: Icon(Icons.facebook, color: Colors.blue)),
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
        ),
        TextField(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThamGiaGiaDinh()),
              );
            },
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
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Mật khẩu', suffixIcon: Icon(Icons.visibility)),
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Xác nhận mật khẩu', suffixIcon: Icon(Icons.visibility)),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
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
