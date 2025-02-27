// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nest_mobile/explore.dart';
// import 'package:nest_mobile/homepage.dart';
// import 'package:nest_mobile/message.dart';
// import 'package:nest_mobile/homepage.dart';
// import 'package:nest_mobile/setting.dart'; // Dùng để định dạng ngày giờ
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CreateSchedulePage extends StatefulWidget {
//   @override
//   _CreateSchedulePageState createState() => _CreateSchedulePageState();
// }
//
// class _CreateSchedulePageState extends State<CreateSchedulePage> {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _noteController = TextEditingController();
//   DateTime? _selectedDate;
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   bool _reminder = false;
//
//   // Chọn ngày
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   // Chọn thời gian bắt đầu và kết thúc
//   Future<void> _selectTime(BuildContext context, bool isStartTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = picked;
//         } else {
//           _endTime = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tạo lịch mới'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // Tên lịch trình
//             _buildTextField(_titleController, 'Tên lịch trình'),
//
//             // Ghi chú thông tin
//             _buildTextField(_noteController, 'Ghi chú thông tin...', maxLines: 1),
//
//             // Chọn ngày
//             _buildDatePicker(),
//
//             // Chọn thời gian bắt đầu & kết thúc
//             Row(
//               children: [
//                 Expanded(child: _buildTimePicker('Bắt đầu', _startTime, true)),
//                 const SizedBox(width: 10),
//                 Expanded(child: _buildTimePicker('Kết thúc', _endTime, false)),
//               ],
//             ),
//
//             // Toggle nhắc nhở
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Nhắc tôi', style: TextStyle(fontSize: 16)),
//                 Switch(
//                   value: _reminder,
//                   onChanged: (value) {
//                     setState(() {
//                       _reminder = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // Nút lưu
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: () {
//                   _createSchedule();
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget text field được đóng khung
//   Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         textAlignVertical: TextAlignVertical.top, // Đẩy nội dung sát lên trên
//         textAlign: TextAlign.start, // Đẩy chữ sát về bên trái
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: label,
//           alignLabelWithHint: true, // Đẩy label sát lên
//           contentPadding: EdgeInsets.zero, // Loại bỏ padding bên trong
//         ),
//       ),
//     );
//   }
//
//
//   // Widget chọn ngày
//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: () => _selectDate(context),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Chọn thời gian',
//               style: const TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const Icon(Icons.calendar_today, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget chọn thời gian bắt đầu/kết thúc
//   Widget _buildTimePicker(String label, TimeOfDay? time, bool isStartTime) {
//     return GestureDetector(
//       onTap: () => _selectTime(context, isStartTime),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               time != null ? time.format(context) : label,
//               style: const TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const Icon(Icons.access_time, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _createSchedule() async {
//     if (_titleController.text.isEmpty || _selectedDate == null || _startTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
//       );
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? familyId = prefs.getString('familyId');  // Lấy từ SharedPreferences
//       final String? createdBy = prefs.getString('userId');   // Lấy từ SharedPreferences
//
//       if (familyId == null || createdBy == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Lỗi: Không tìm thấy thông tin người dùng')),
//         );
//         return;
//       }
//
//       // In ra console các giá trị đầu vào
//       print("========= DEBUG: Thông tin lịch trình =========");
//       print("Tiêu đề: ${_titleController.text}");
//       print("Ghi chú: ${_noteController.text}");
//       print("Ngày: ${_selectedDate!.toIso8601String().split('T')[0]}");
//       print("Giờ bắt đầu: ${_startTime!.hour}:${_startTime!.minute}:00");
//       print("Family ID: $familyId");
//       print("Created By: $createdBy");
//       print("=============================================");
//
//       final dio = Dio();
//       final response = await dio.post(
//         'https://platform-family.onrender.com/scheduler/create',
//         data: {
//           "title": _titleController.text,
//           "description": _noteController.text,
//           "date": "${_selectedDate!.toIso8601String().split('T')[0]} ${_startTime!.hour}:${_startTime!.minute}:00",
//           "familyId": familyId,
//           "createdBy": createdBy
//         },
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//         ),
//       );
//
//       // In response từ API
//       print("========= DEBUG: Response từ API =========");
//       print("Status Code: ${response.statusCode}");
//       print("Response Data: ${response.data}");
//       print("=========================================");
//
//
//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Lịch trình được tạo thành công')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi tạo lịch trình: ${response.data["message"]}')),
//         );
//       }
//     } catch (e) {
//       print("========= DEBUG: Lỗi kết nối =========");
//       print("Error: $e");
//       print("=====================================");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi kết nối: $e')),
//       );
//     }
//   }
//
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:nest_mobile/calendar.dart';
import 'package:nest_mobile/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSchedulePage extends StatefulWidget {
  @override
  _CreateSchedulePageState createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _reminder = false;

  @override
  void initState() {
    super.initState();
    _debugCheckSharedPreferences();
  }

  Future<void> _debugCheckSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print("======== DEBUG: Dữ liệu trong SharedPreferences ========");
    print("familyId: ${prefs.getString('familyId')}");
    print("createdBy: ${prefs.getString('userId')}");
    print("=====================================================");
  }

  // Chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Chọn thời gian bắt đầu và kết thúc
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo lịch mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_titleController, 'Tên lịch trình'),
            _buildTextField(
                _noteController, 'Ghi chú thông tin...', maxLines: 1),
            _buildDatePicker(),
            Row(
              children: [
                Expanded(child: _buildTimePicker('Chọn thời gian', _startTime, true)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nhắc tôi', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _reminder,
                  onChanged: (value) {
                    setState(() {
                      _reminder = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _createSchedule,
                child: const Text(
                    'Lưu', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null ? DateFormat('dd/MM/yyyy').format(
                  _selectedDate!) : 'Chọn ngày',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, bool isStartTime) {
    return GestureDetector(
      onTap: () => _selectTime(context, isStartTime),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time != null ? time.format(context) : label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _createSchedule() async {
    if (_titleController.text.isEmpty || _selectedDate == null ||
        _startTime == null) {
      print("⚠️ Lỗi: Thiếu thông tin nhập vào.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? familyId = prefs.getString('familyId');
      final String? createdBy = prefs.getString('userId');

      print("========= DEBUG: Kiểm tra SharedPreferences =========");
      print("familyId từ SharedPreferences: $familyId");
      print("createdBy từ SharedPreferences: $createdBy");
      print("===================================================");

      if (familyId == null || createdBy == null) {
        print("⚠️ Lỗi: Không tìm thấy `familyId` hoặc `createdBy`.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Lỗi: Không tìm thấy thông tin người dùng')),
        );
        return;
      }

      String formattedDate = "${_selectedDate!.toIso8601String().split(
          'T')[0]} ${_startTime!.hour}:${_startTime!.minute}:00";

      print("========= DEBUG: Thông tin gửi lên API =========");
      print("Tiêu đề: ${_titleController.text}");
      print("Ghi chú: ${_noteController.text}");
      print("Ngày: $formattedDate");
      print("Family ID: $familyId");
      print("Created By: $createdBy");
      print("===================================================");

      final dio = Dio();
      final response = await dio.post(
        'https://platform-family.onrender.com/scheduler/create',
        data: {
          "title": _titleController.text,
          "description": _noteController.text,
          "date": formattedDate,
          "familyId": familyId,
          "createdBy": createdBy
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("========= DEBUG: Response từ API =========");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("=========================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lịch trình đã được tạo thành công!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage(initialIndex: 3)), // Chuyển về Homepage và mở tab "Calendar"
          );
        });
      } else {
        print("❌ Lỗi tạo lịch trình: ${response.data["message"]}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi tạo lịch trình: ${response.data["message"]}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("========= DEBUG: Lỗi kết nối =========");
      print("Error: $e");
      print("=====================================");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e'), backgroundColor: Colors.red),
      );
    }
  }
}