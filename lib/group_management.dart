import 'package:flutter/material.dart';

class GroupManagementScreen extends StatelessWidget {
  const GroupManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách thành viên mẫu
    final List<Map<String, dynamic>> members = [
      {'name': 'Ba', 'isLeader': true, 'avatar': 'assets/images/dad.jpg'},
      {'name': 'Mẹ', 'isLeader': false, 'avatar': 'assets/images/mom.jpg'},
      {'name': 'Con', 'isLeader': false, 'avatar': 'assets/images/child.jpg'},
      {'name': 'Ông', 'isLeader': false, 'avatar': 'assets/images/grandpa.jpg'},
      {'name': 'Bà', 'isLeader': false, 'avatar': 'assets/images/grandma.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý nhóm gia đình', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Tiêu đề nhóm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gia đình Thành (${members.length} thành viên)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Danh sách thành viên
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(member['avatar']),
                    radius: 24,
                  ),
                  title: Row(
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (member['isLeader']) // Nếu là trưởng nhóm
                        const Text(
                          '  (Trưởng nhóm)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                    ],
                  ),
                  trailing: !member['isLeader']
                      ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'transfer') {
                        _showConfirmationDialog(context, 'Chuyển quyền trưởng nhóm', '${member['name']} sẽ trở thành trưởng nhóm.');
                      } else if (value == 'remove') {
                        _showConfirmationDialog(context, 'Xóa khỏi nhóm', 'Bạn có chắc muốn xóa ${member['name']} khỏi nhóm?');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'transfer',
                        child: Text('Chuyển quyền trưởng nhóm'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Xóa khỏi nhóm'),
                      ),
                    ],
                  )
                      : null, // Bỏ icon gạch ngang (=) bên cạnh trưởng nhóm
                );
              },
            ),
          ),

          // Nút Mời thành viên & Rời khỏi nhóm (đưa gần vào giữa)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hai button
              children: [
                _simpleButton(context, 'Mời thành viên', Colors.black, () {
                  // Chức năng mời thành viên
                }),
                const SizedBox(width: 30), // Khoảng cách nhỏ giữa hai button
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

  // Hàm tạo nút đơn giản
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

  // Hàm hiển thị hộp thoại xác nhận khi chọn một hành động
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
                // Xử lý chuyển quyền trưởng nhóm hoặc xóa thành viên
              },
              child: const Text('Xác nhận', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
