import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_mobile/explore.dart';
import 'package:nest_mobile/message.dart';
import 'package:nest_mobile/setting.dart'; // Dùng để định dạng ngày giờ

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
            // Tên lịch trình
            _buildTextField(_titleController, 'Tên lịch trình'),

            // Ghi chú thông tin
            _buildTextField(_noteController, 'Ghi chú thông tin...', maxLines: 3),

            // Chọn ngày
            _buildDatePicker(),

            // Chọn thời gian bắt đầu & kết thúc
            Row(
              children: [
                Expanded(child: _buildTimePicker('Bắt đầu', _startTime, true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTimePicker('Kết thúc', _endTime, false)),
              ],
            ),

            // Toggle nhắc nhở
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

            const SizedBox(height: 10),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 10),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageScreen()),
                  );
                },
                child: const Text('Nhắn tin', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 2),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExplorePage()),
                  );
                },
                child: const Text('Khám phá', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingScreen()),
                  );
                },
                child: const Text('Cài đặt', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget text field được đóng khung
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
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
        textAlignVertical: TextAlignVertical.top, // Đẩy nội dung sát lên trên
        textAlign: TextAlign.start, // Đẩy chữ sát về bên trái
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          alignLabelWithHint: true, // Đẩy label sát lên
          contentPadding: EdgeInsets.zero, // Loại bỏ padding bên trong
        ),
      ),
    );
  }


  // Widget chọn ngày
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
              _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Chọn thời gian',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Widget chọn thời gian bắt đầu/kết thúc
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
}
