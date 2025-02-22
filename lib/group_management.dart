import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  List<Map<String, dynamic>> _members = [];

  @override
  void initState() {
    super.initState();
    _fetchFamilyMembers();
  }

  Future<void> _fetchFamilyMembers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId');

      if (familyId == null) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String url = "https://platform-family.onrender.com/family/get-members/$familyId";
      Dio dio = Dio();
      Response response = await dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = response.data;

        if (responseData["data"] is Map<String, dynamic>) {
          List<Map<String, dynamic>> membersList = [];

          // Kiểm tra và thêm Admin vào danh sách
          if (responseData["data"].containsKey("admin")) {
            Map<String, dynamic> admin = responseData["data"]["admin"];
            admin["isLeader"] = true; // Đánh dấu Admin là trưởng nhóm
            membersList.add(admin);
          }

          // Thêm danh sách members nhưng bỏ qua admin nếu trùng ID
          if (responseData["data"].containsKey("members")) {
            List<dynamic> rawMembers = responseData["data"]["members"];

            for (var member in rawMembers) {
              // Chỉ thêm vào nếu ID khác Admin (tránh trùng lặp)
              if (membersList.isEmpty || membersList[0]["_id"] != member["_id"]) {
                member["isLeader"] = false; // Các thành viên khác không phải trưởng nhóm
                membersList.add(member);
              }
            }
          }

          // In danh sách thành viên ra console
          print("📢 Danh sách thành viên từ API:");
          for (var member in membersList) {
            print("🧑‍🤝‍🧑 Thành viên: ${member['name']} - Leader: ${member['isLeader']} - Avatar: ${member['avatar']}");
          }

          // Cập nhật danh sách thành viên trong UI
          setState(() {
            _members = membersList;
          });
        } else {
          print("⚠️ Dữ liệu trả về không đúng định dạng: ${responseData["data"]}");
        }
      } else {
        print("⚠️ Lỗi lấy thành viên gia đình: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý nhóm gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gia đình của tôi (${_members.length} thành viên)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _members.isEmpty
                ? const Center(
              child: Text(
                "Không có thành viên nào",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: member['avatar'] != null && member['avatar'].isNotEmpty
                        ? NetworkImage(member['avatar'])
                        : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    radius: 24,
                  ),
                  title: Row(
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (member['isLeader'] == true)
                        const Text(
                          '  (Trưởng nhóm)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                    ],
                  ),
                  trailing: member['isLeader'] == false
                      ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'transfer') {
                        _showConfirmationDialog(context, 'Chuyển quyền trưởng nhóm', '${member['name']} sẽ trở thành trưởng nhóm.');
                      } else if (value == 'remove') {
                        _showConfirmationDialog(context, 'Xóa khỏi nhóm', 'Bạn có chắc muốn xóa ${member['name']} khỏi nhóm?');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'transfer', child: Text('Chuyển quyền trưởng nhóm')),
                      const PopupMenuItem(value: 'remove', child: Text('Xóa khỏi nhóm')),
                    ],
                  )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _simpleButton(context, 'Mời thành viên', Colors.black, () {
                  // Chức năng mời thành viên
                }),
                const SizedBox(width: 30),
                _simpleButton(context, 'Rời khỏi nhóm', Colors.red, () {
                  _showConfirmationDialog(context, 'Rời khỏi nhóm', 'Bạn có chắc muốn rời khỏi nhóm gia đình này?');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _simpleButton(BuildContext context, String text, Color textColor, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Xác nhận', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
