// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'create_schedule.dart';
//
// class CalendarPage extends StatefulWidget {
//   const CalendarPage({Key? key}) : super(key: key);
//
//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   DateTime _selectedDay = DateTime.now();
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   List<Map<String, dynamic>> _schedules = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchScheduler();
//   }
//
//   Future<void> _fetchScheduler() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? familyId = prefs.getString('familyId'); // Lấy familyId từ SharedPreferences
//
//       if (familyId == null) {
//         print("⚠️ Không tìm thấy familyId trong SharedPreferences");
//         return;
//       }
//
//       String url = "https://platform-family.onrender.com/scheduler/$familyId";
//       Dio dio = Dio();
//       Response response = await dio.get(url);
//
//       if (response.statusCode == 200 && response.data["ok"] == true) {
//         setState(() {
//           _schedules = List<Map<String, dynamic>>.from(response.data["data"]);
//         });
//       } else {
//         print("⚠️ Lỗi lấy lịch trình: ${response.data["message"]}");
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Lịch trình',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: Column(
//         children: [
//           // Calendar Widget
//           TableCalendar(
//             firstDay: DateTime.utc(2023, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _selectedDay,
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//               });
//             },
//             onFormatChanged: (format) {
//               setState(() {
//                 _calendarFormat = format;
//               });
//             },
//             rowHeight: 38,
//             // Giảm chiều cao hàng
//             calendarStyle: const CalendarStyle(
//               todayDecoration: BoxDecoration(
//                 color: Colors.purple,
//                 shape: BoxShape.circle,
//               ),
//               selectedDecoration: BoxDecoration(
//                 color: Colors.deepPurple,
//                 shape: BoxShape.circle,
//               ),
//               defaultTextStyle: TextStyle(fontSize: 16), // Giảm font nếu cần
//             ),
//             headerStyle: const HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//             ),
//           ),
//
//           // Nút "Tạo lịch mới" đặt lên trên danh sách sự kiện
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CreateSchedulePage()),
//                     );
//                   },
//                   child: const Text('Tạo lịch mới',
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//
//           // Danh sách sự kiện
//           // Danh sách sự kiện
//           Expanded(
//             child: _schedules.isEmpty
//                 ? Center(
//               child: Text(
//                 "Bạn chưa có lịch trình mới nào.",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               itemCount: _schedules.length, // Sử dụng danh sách từ API
//               itemBuilder: (context, index) {
//                 final schedule = _schedules[index]; // Lấy từng lịch trình
//                 return _buildEventTile(
//                   schedule["date"].toString().substring(0, 10), // Hiển thị ngày (cắt chuỗi)
//                   schedule["title"], // Tiêu đề lịch trình
//                 );
//               },
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEventTile(String time, String event) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       // Giảm khoảng cách giữa các mục
//       child: SizedBox(
//         height: 50, // Điều chỉnh độ cao của từng item để giảm khoảng cách
//         child: ListTile(
//           dense: true,
//           // Làm cho ListTile gọn hơn
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//           // Giảm padding
//           visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//           // Giảm khoảng cách giữa các ListTile
//           leading:
//               const Icon(Icons.calendar_today, color: Colors.purple, size: 25),
//           title: Text(
//             event,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             time,
//             style: const TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//           // trailing: const Icon(Icons.more_vert, size: 20),
//         ),
//       ),
//     );
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'create_schedule.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchScheduler();
  }

  Future<void> _fetchScheduler() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? familyId = prefs.getString('familyId'); // Lấy familyId từ SharedPreferences

      if (familyId == null) {
        print("⚠️ Không tìm thấy familyId trong SharedPreferences");
        return;
      }

      String url = "https://platform-family.onrender.com/scheduler/$familyId";
      Dio dio = Dio();
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data["ok"] == true) {
        setState(() {
          _schedules = List<Map<String, dynamic>>.from(response.data["data"]);
        });
      } else {
        print("⚠️ Lỗi lấy lịch trình: ${response.data["message"]}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lịch trình',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            rowHeight: 38, // Giảm chiều cao hàng
            eventLoader: (day) {
              return _schedules.where((event) {
                DateTime eventDate = DateTime.parse(event["date"]).toLocal();
                return isSameDay(eventDate, day);
              }).toList();
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(fontSize: 16),
              markersAlignment: Alignment.bottomCenter, // Căn giữa dấu chấm
              markersMaxCount: 1, // Giới hạn 1 dấu chấm
              markerDecoration: BoxDecoration(
                color: Colors.red, // Màu dấu chấm
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),


          // Nút "Tạo lịch mới" đặt lên trên danh sách sự kiện
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateSchedulePage()),
                    );
                  },
                  child: const Text('Tạo lịch mới',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // Danh sách sự kiện
          // Danh sách sự kiện
          Expanded(
            child: _schedules.isEmpty
                ? Center(
              child: Text(
                "Bạn chưa có lịch trình mới nào.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _schedules.length, // Sử dụng danh sách từ API
              itemBuilder: (context, index) {
                final schedule = _schedules[index]; // Lấy từng lịch trình
                return _buildEventTile(
                  schedule["date"].toString().substring(0, 10), // Hiển thị ngày (cắt chuỗi)
                  schedule["title"], // Tiêu đề lịch trình
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildEventTile(String time, String event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      // Giảm khoảng cách giữa các mục
      child: SizedBox(
        height: 50, // Điều chỉnh độ cao của từng item để giảm khoảng cách
        child: ListTile(
          dense: true,
          // Làm cho ListTile gọn hơn
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          // Giảm padding
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          // Giảm khoảng cách giữa các ListTile
          leading:
          const Icon(Icons.calendar_today, color: Colors.purple, size: 25),
          title: Text(
            event,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          // trailing: const Icon(Icons.more_vert, size: 20),
        ),
      ),
    );
  }
}
