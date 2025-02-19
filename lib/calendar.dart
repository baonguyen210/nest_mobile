import 'package:flutter/material.dart';
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
            rowHeight: 38,
            // Giảm chiều cao hàng
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(fontSize: 16), // Giảm font nếu cần
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // Giữ danh sách gọn hơn
              children: [
                _buildEventTile("07:30", "Nin học thể dục"),
                _buildEventTile("16:00", "Mẹ và Bà đi siêu thị"),
                _buildEventTile("19:00 - 20:00", "Sushi học thêm Toán"),
                _buildEventTile("29/05", "Sinh nhật Ông ngoại"),
              ],
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
              const Icon(Icons.calendar_today, color: Colors.purple, size: 18),
          title: Text(
            event,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: const Icon(Icons.more_vert, size: 18),
        ),
      ),
    );
  }
}
