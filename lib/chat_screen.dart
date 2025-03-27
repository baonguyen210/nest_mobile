// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:nest_mobile/photo_gallery_screen.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String chatTitle;
//   final String avatar;
//   final String receiverId;
//
//   const ChatScreen({super.key, required this.chatTitle, required this.avatar, required this.receiverId});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController(); // 🟢 Khai báo đúng chỗ
//   List<Map<String, dynamic>> messages = [];
//   IO.Socket? socket;
//   String? currentUserId;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }
//
//   // Khởi tạo Socket.io và lấy tin nhắn từ API
//   void _initializeChat() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     currentUserId = prefs.getString('userId'); // Đổi từ 'UserId' thành 'userId'
//
//     if (currentUserId == null) {
//       print("❌ Không tìm thấy 'userId' trong SharedPreferences.");
//       return;
//     }
//
//     print("🔹 User ID hiện tại: $currentUserId");
//     _fetchMessages();
//
//     if (socket == null) {
//       print("⚠️ Socket chưa được khởi tạo, thử khởi tạo...");
//       _initializeSocket();
//     }
//   }
//
//
//
//   // Lấy tin nhắn từ API
//   Future<void> _fetchMessages() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // In ra toàn bộ dữ liệu trong SharedPreferences để kiểm tra
//     print("🔍 Kiểm tra dữ liệu trong SharedPreferences:");
//     for (String key in prefs.getKeys()) {
//       print("   ✅ Key: $key => Value: ${prefs.getString(key)}");
//     }
//
//     // Lấy `userId` từ SharedPreferences
//     currentUserId = prefs.getString('userId'); // Sửa từ 'UserId' thành 'userId'
//
//     if (currentUserId == null) {
//       print("⚠️ Không tìm thấy 'userId' trong SharedPreferences.");
//       return;
//     }
//
//     final apiUrl = 'https://platform-family.onrender.com/messages/$currentUserId/${widget.receiverId}';
//     print("📡 Đang gọi API lấy tin nhắn giữa:");
//     print("   🔹 Người gửi: $currentUserId");
//     print("   🔹 Người nhận: ${widget.receiverId}");
//     print("   🔹 API URL: $apiUrl");
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       print("🔹 Phản hồi API tin nhắn: ${response.statusCode}");
//       print("📩 Nội dung phản hồi: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//
//         if (jsonResponse.isEmpty) {
//           print("⚠️ API không trả về tin nhắn nào giữa hai người dùng.");
//         } else {
//           print("✅ Danh sách tin nhắn:");
//           for (var msg in jsonResponse) {
//             print("💬 Tin nhắn: '${msg['message']}' (từ ${msg['sender']} đến ${msg['receiver']}) lúc ${msg['createdAt']}");
//           }
//         }
//
//         setState(() {
//           messages = jsonResponse.map((msg) => {
//             'sender': msg['sender'],
//             'message': msg['message'],
//             'createdAt': msg['createdAt'],
//           }).toList();
//         });
//       } else {
//         print("❌ Lỗi API tin nhắn: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("❌ Lỗi khi gọi API tin nhắn: $e");
//     }
//   }
//
//
//   void _initializeSocket() {
//     if (socket != null && socket!.connected) {
//       print("✅ Socket đã kết nối trước đó, không cần khởi tạo lại.");
//       return;
//     }
//
//     print("🔌 Đang kết nối đến socket.io server...");
//     socket = IO.io('https://platform-family.onrender.com', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//       'reconnection': true,  // 🔄 Bật tự động reconnect
//       'reconnectionAttempts': 5, // 🚀 Thử reconnect 5 lần
//       'reconnectionDelay': 2000, // ⏳ Delay 2 giây mỗi lần thử lại
//     });
//
//     socket!.connect();
//
//     socket!.onConnect((_) {
//       print("✅ Đã kết nối với socket.io server");
//       socket!.emit('join', currentUserId);
//     });
//
//     socket!.onDisconnect((_) {
//       print("❌ Mất kết nối với socket.io server.");
//       Future.delayed(Duration(seconds: 3), () {
//         print("🔄 Thử kết nối lại socket...");
//         socket!.connect();
//       });
//     });
//
//     socket!.on('receiveMessage', (data) {
//       print("📩 Tin nhắn mới nhận từ socket: $data");
//
//       if (data['sender'] != currentUserId) {
//         setState(() {
//           messages.add({
//             'sender': data['sender'],
//             'message': data['message'],
//             'createdAt': data['createdAt'],
//           });
//         });
//         print("✅ UI đã được cập nhật với tin nhắn mới.");
//         _scrollToBottom(); // 🔥 Tự động cuộn xuống cuối
//       }
//     });
//   }
//
//
//
//
//
//
//   // Gửi tin nhắn qua API & Socket.io
//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
//
//     final messageText = _messageController.text.trim();
//     _messageController.clear();
//
//     final messageData = {
//       "sender": currentUserId,
//       "receiver": widget.receiverId,
//       "message": messageText,
//     };
//
//     setState(() {
//       messages.add({
//         'sender': currentUserId,
//         'message': messageText,
//         'createdAt': DateTime.now().toIso8601String(),
//       });
//     });
//
//     _scrollToBottom(); // 🔥 Cuộn xuống dưới khi gửi tin nhắn
//
//     socket!.emit('send_message', messageData);
//
//     try {
//       await http.post(
//         Uri.parse("https://platform-family.onrender.com/messages"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(messageData),
//       );
//     } catch (e) {
//       print("❌ Lỗi khi gửi tin nhắn qua API: $e");
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.avatar.isNotEmpty
//                   ? NetworkImage(widget.avatar) as ImageProvider
//                   : const AssetImage('assets/images/default_avatar.png'),
//               radius: 20,
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.chatTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const Text(
//                   'Đang hoạt động 🔵',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(icon: const Icon(Icons.location_on), onPressed: () {}),
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PhotoGalleryScreen(chatTitle: widget.chatTitle, avatar: widget.avatar)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController, // 🟢 Thêm controller
//               padding: const EdgeInsets.all(16),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return chatBubble(
//                   message['message'],
//                   message['sender'] == currentUserId,
//                   message['sender'] != currentUserId ? widget.avatar : '',
//                 );
//               },
//             ),
//           ),
//
//
//           // Thanh nhập tin nhắn
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Gửi tin nhắn...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget tin nhắn (chat bubble)
//   Widget chatBubble(String message, bool isSender, String avatar) {
//     final isDinnerMessage = message.contains("đang đợi bạn xuống ăn cơm");
//     final isSOSMessage = message.contains("đã gửi tín hiệu SOS"); // ✅ Check tin nhắn SOS
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!isSender && avatar.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: CircleAvatar(
//               backgroundImage: avatar.isNotEmpty
//                   ? NetworkImage(avatar) as ImageProvider
//                   : const AssetImage('assets/images/default_avatar.png'),
//               radius: 20,
//             ),
//           ),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           padding: const EdgeInsets.all(12),
//           constraints: const BoxConstraints(maxWidth: 250),
//           decoration: BoxDecoration(
//             color: isSOSMessage
//                 ? Colors.red // ✅ Màu nền đỏ cho SOS
//                 : isDinnerMessage
//                 ? Colors.yellow.shade400
//                 : (isSender ? Colors.blue : Colors.grey[200]),
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(12),
//               topRight: const Radius.circular(12),
//               bottomLeft: isSender ? const Radius.circular(12) : Radius.zero,
//               bottomRight: isSender ? Radius.zero : const Radius.circular(12),
//             ),
//           ),
//           child: Text(
//             message,
//             style: TextStyle(
//               color: isSOSMessage
//                   ? Colors.white // ✅ Chữ trắng cho SOS
//                   : isDinnerMessage
//                   ? Colors.black
//                   : (isSender ? Colors.white : Colors.black),
//               fontStyle: FontStyle.normal, // ✅ Không nghiêng
//               fontWeight: isSOSMessage || isDinnerMessage ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:nest_mobile/photo_gallery_screen.dart';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String avatar;
  final String receiverId;

  const ChatScreen({super.key, required this.chatTitle, required this.avatar, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 🟢 Khai báo đúng chỗ
  List<Map<String, dynamic>> messages = [];
  IO.Socket? socket;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  // Khởi tạo Socket.io và lấy tin nhắn từ API
  void _initializeChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId'); // Đổi từ 'UserId' thành 'userId'

    if (currentUserId == null) {
      print("❌ Không tìm thấy 'userId' trong SharedPreferences.");
      return;
    }

    print("🔹 User ID hiện tại: $currentUserId");
    _fetchMessages();

    if (socket == null) {
      print("⚠️ Socket chưa được khởi tạo, thử khởi tạo...");
      _initializeSocket();
    }
  }



  // Lấy tin nhắn từ API
  Future<void> _fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // In ra toàn bộ dữ liệu trong SharedPreferences để kiểm tra
    print("🔍 Kiểm tra dữ liệu trong SharedPreferences:");
    for (String key in prefs.getKeys()) {
      print("   ✅ Key: $key => Value: ${prefs.getString(key)}");
    }

    // Lấy `userId` từ SharedPreferences
    currentUserId = prefs.getString('userId'); // Sửa từ 'UserId' thành 'userId'

    if (currentUserId == null) {
      print("⚠️ Không tìm thấy 'userId' trong SharedPreferences.");
      return;
    }

    final apiUrl = 'https://platform-family.onrender.com/messages/$currentUserId/${widget.receiverId}';
    print("📡 Đang gọi API lấy tin nhắn giữa:");
    print("   🔹 Người gửi: $currentUserId");
    print("   🔹 Người nhận: ${widget.receiverId}");
    print("   🔹 API URL: $apiUrl");

    try {
      final response = await http.get(Uri.parse(apiUrl));

      print("🔹 Phản hồi API tin nhắn: ${response.statusCode}");
      print("📩 Nội dung phản hồi: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          print("⚠️ API không trả về tin nhắn nào giữa hai người dùng.");
        } else {
          print("✅ Danh sách tin nhắn:");
          for (var msg in jsonResponse) {
            print("💬 Tin nhắn: '${msg['message']}' (từ ${msg['sender']} đến ${msg['receiver']}) lúc ${msg['createdAt']}");
          }
        }

        setState(() {
          messages = jsonResponse.map((msg) => {
            'sender': msg['sender'],
            'message': msg['message'],
            'createdAt': msg['createdAt'],
          }).toList().reversed.toList(); // ✅ Đảo ngược thứ tự
        });


        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 100), () {
            _scrollToBottom();
          });
        });


      } else {
        print("❌ Lỗi API tin nhắn: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API tin nhắn: $e");
    }
  }


  void _initializeSocket() {
    if (socket != null && socket!.connected) {
      print("✅ Socket đã kết nối trước đó, không cần khởi tạo lại.");
      return;
    }

    print("🔌 Đang kết nối đến socket.io server...");
    socket = IO.io('https://platform-family.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,  // 🔄 Bật tự động reconnect
      'reconnectionAttempts': 5, // 🚀 Thử reconnect 5 lần
      'reconnectionDelay': 2000, // ⏳ Delay 2 giây mỗi lần thử lại
    });

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Đã kết nối với socket.io server");
      socket!.emit('join', currentUserId);
    });

    socket!.onDisconnect((_) {
      print("❌ Mất kết nối với socket.io server.");
      Future.delayed(Duration(seconds: 3), () {
        print("🔄 Thử kết nối lại socket...");
        socket!.connect();
      });
    });

    socket!.on('receiveMessage', (data) {
      print("📩 Tin nhắn mới nhận từ socket: $data");

      if (data['sender'] != currentUserId) {
        setState(() {
          messages.insert(0, {
            'sender': data['sender'],
            'message': data['message'],
            'createdAt': data['createdAt'],
          });
        });


        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });


      }
    });
  }






  // Gửi tin nhắn qua API & Socket.io
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    final messageData = {
      "sender": currentUserId,
      "receiver": widget.receiverId,
      "message": messageText,
    };

    setState(() {
      messages.insert(0, {
        'sender': currentUserId,
        'message': messageText,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // đảm bảo sau render mới cuộn
    });




    socket!.emit('send_message', messageData);

    try {
      await http.post(
        Uri.parse("https://platform-family.onrender.com/messages"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(messageData),
      );
    } catch (e) {
      print("❌ Lỗi khi gửi tin nhắn qua API: $e");
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // ✅ Trong reverse mode, jumpTo(0) là nhảy tới cuối danh sách (tin mới nhất)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.avatar.isNotEmpty
                  ? NetworkImage(widget.avatar) as ImageProvider
                  : const AssetImage('assets/images/default_avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                  'Đang hoạt động 🔵',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.location_on), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhotoGalleryScreen(chatTitle: widget.chatTitle, avatar: widget.avatar)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // ✅ Tin nhắn mới nhất ở dưới cùng
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return chatBubble(
                  message['message'],
                  message['sender'] == currentUserId,
                  message['sender'] != currentUserId ? widget.avatar : '',
                );
              },
            ),
          ),



          // Thanh nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Gửi tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget tin nhắn (chat bubble)
  Widget chatBubble(String message, bool isSender, String avatar) {
    final isDinnerMessage = message.contains("đang đợi bạn xuống ăn cơm");
    final isSOSMessage = message.contains("đã gửi tín hiệu SOS"); // ✅ Check tin nhắn SOS

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender && avatar.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: avatar.isNotEmpty
                  ? NetworkImage(avatar) as ImageProvider
                  : const AssetImage('assets/images/default_avatar.png'),
              radius: 20,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: isSOSMessage
                ? Colors.red // ✅ Màu nền đỏ cho SOS
                : isDinnerMessage
                ? Colors.yellow.shade400
                : (isSender ? Colors.blue : Colors.grey[200]),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isSender ? const Radius.circular(12) : Radius.zero,
              bottomRight: isSender ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isSOSMessage
                  ? Colors.white // ✅ Chữ trắng cho SOS
                  : isDinnerMessage
                  ? Colors.black
                  : (isSender ? Colors.white : Colors.black),
              fontStyle: FontStyle.normal, // ✅ Không nghiêng
              fontWeight: isSOSMessage || isDinnerMessage ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}