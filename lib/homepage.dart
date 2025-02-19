import 'package:flutter/material.dart';
import 'package:nest_mobile/setting.dart';
import 'message.dart';
import 'explore.dart';
import 'calendar.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Trang chủ (màn hình hiện tại)
    MessageScreen(), // Nhắn tin
    ExplorePage(), // Khám phá
    CalendarPage(), // Lịch trình
    SettingScreen(), // Hồ sơ & Cài đặt
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Màu khi chọn
        unselectedItemColor: Colors.grey, // Màu mặc định
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Nhắn tin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch trình',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}

// -----------------
// HomeScreen
// -----------------
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildEventNotification(),
        _buildShareBox(),
        _buildTabs(),
        Expanded(child: _buildPostList()),
      ],
    );
  }

  // Header với logo, SOS, thông báo, avatar
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Nest (bên trái)
          Image.asset('assets/images/logo.png', height: 40),

          // Nhóm nút bên phải
          Row(
            children: [
              // Nút SOS (màu đỏ, bo tròn, nhỏ gọn)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8), // Làm nút thon hơn
                ),
                child: Text(
                  "SOS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(width: 12),

              // Nút thông báo (màu xám, không có viền)
              Icon(Icons.notifications, color: Colors.grey, size: 30),
              SizedBox(width: 12),

              // Nút chuyển đổi tài khoản (chỉ icon, không viền xanh)
              Icon(Icons.account_circle, color: Colors.blue.shade900, size: 35),
            ],
          ),
        ],
      ),
    );
  }




  // Thông báo sự kiện
  Widget _buildEventNotification() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.event, color: Colors.red),
          SizedBox(width: 5),
          Expanded(
            child: Text("Hôm nay bạn có 2 sự kiện cần theo dõi!", style: TextStyle(fontSize: 14)),
          ),
          Icon(Icons.close, size: 16),
        ],
      ),
    );
  }

  // Hộp chia sẻ bài viết
  Widget _buildShareBox() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Chia sẻ với gia đình ngay tại đây...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.image, color: Colors.green, size: 35,),
          SizedBox(width: 2),
        ],
      ),
    );
  }

  // Tabs giữa "Gia đình" và "Mọi người"
  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Gia đình",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Mọi người",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Danh sách bài viết
  Widget _buildPostList() {
    return ListView(
      children: [
        _buildPost(
          "Ba",
          "Kỷ niệm cuối năm\nNhờ NEST lưu giữ kỷ niệm cả gia đình cùng đi chơi Hội An vui thật vui cùng nhau!",
          "Hội An, 31/12/2024",
          ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
          2,
        ),
        _buildPost(
          "Mẹ",
          "Quá nhanh quá nguy hiểm\nĐi chơi thôi!!!",
          "",
          ["assets/images/photo1.jpg", "assets/images/photo2.jpg"],
          5,
        ),
      ],
    );
  }

  // Một bài viết
  Widget _buildPost(String user, String content, String location, List<String> images, int likes) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/images/user_avatar.png')),
              SizedBox(width: 10),
              Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text("1 giờ trước", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 5),
          Text(content),
          if (location.isNotEmpty) Text("📍 " + location, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Row(
            children: images.map((img) => Expanded(child: Image.asset(img, height: 100))).toList(),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 5),
              Text("$likes"),
              SizedBox(width: 10),
              Icon(Icons.comment),
              Text(" Bình luận"),
            ],
          ),
        ],
      ),
    );
  }
}
